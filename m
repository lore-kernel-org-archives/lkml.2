Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2DPOGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:06:18 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8533 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab2DPOGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:06:16 -0400
Subject: [PATCH v2 2/2] IPC: selftest tor new MSG_PEEK_ALL flag for msgrcv()
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, mtk.manpages@gmail.com
Date: Mon, 16 Apr 2012 18:06:13 +0400
Message-ID: <20120416140613.653.89845.stgit@localhost6.localdomain6>
In-Reply-To: <20120416140235.653.36996.stgit@localhost6.localdomain6>
References: <20120416140235.653.36996.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test send two messages, then peek them and check, that they are equal to
original messages. Then it receives messages and check once more to make sure,
that messages are not corrupted or lost after peek operation.

---
 tools/testing/selftests/ipc/Makefile          |   31 +++++
 tools/testing/selftests/ipc/msgque_peek_all.c |  170 +++++++++++++++++++++++++
 2 files changed, 201 insertions(+), 0 deletions(-)
 create mode 100644 tools/testing/selftests/ipc/Makefile
 create mode 100644 tools/testing/selftests/ipc/msgque_peek_all.c

diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
new file mode 100644
index 0000000..10e5051
--- /dev/null
+++ b/tools/testing/selftests/ipc/Makefile
@@ -0,0 +1,31 @@
+ifeq ($(strip $(V)),)
+	E = @echo
+	Q = @
+else
+	E = @\#
+	Q =
+endif
+export E Q
+
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := X86
+	CFLAGS := -DCONFIG_X86_32 -D__i386__
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := X86
+	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+endif
+
+all:
+ifeq ($(ARCH),X86)
+	$(E) "  CC run_test"
+	$(Q) gcc msgque_peek_all.c -o run_test
+else
+	$(E) "Not an x86 target, can't build kcmp selftest"
+endif
+
+clean:
+	$(E) "  CLEAN"
+	$(Q) rm -fr ./run_test
diff --git a/tools/testing/selftests/ipc/msgque_peek_all.c b/tools/testing/selftests/ipc/msgque_peek_all.c
new file mode 100644
index 0000000..5308999
--- /dev/null
+++ b/tools/testing/selftests/ipc/msgque_peek_all.c
@@ -0,0 +1,170 @@
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/sem.h>
+#include <sys/ipc.h>
+#include <sys/msg.h>
+#include <signal.h>
+#include <errno.h>
+
+#define __round_mask(x, y)	((__typeof__(x))((y) - 1))
+#define round_up(x, y)		((((x) - 1) | __round_mask(x, y)) + 1)
+
+#ifndef MSG_PEEK_ALL
+#define MSG_PEEK_ALL		040000
+/* message buffer for msgrcv in case of array calls */
+struct msgbuf_a {
+	long mtype;	/* type of message */
+	int msize;	/* size of message */
+	char mtext[0];	/* message text */
+};
+#endif
+
+const char *test_doc="Tests sysv5 msg queues supporting by checkpointing";
+const char *test_author="Stanislav Kinsbursky <skinsbursky@openvz.org>";
+
+#define MAX_MSG_LENGTH		32
+
+struct my_msg {
+	long mtype;
+	char mtext[MAX_MSG_LENGTH];
+};
+
+struct my_msg messages[] = {
+	{ 1, "Test sysv5 msg" },
+	{ 26538, "Yet another test sysv5 msg"},
+	{ 0, "" }
+};
+
+static int receive_messages(int msgq)
+{
+	int i, ret;
+	struct my_msg msgbuf;
+
+	i = 0;
+	while(messages[i].mtype > 0) {
+		ret = msgrcv(msgq, &msgbuf, MAX_MSG_LENGTH,
+				messages[i].mtype, IPC_NOWAIT);
+		if (ret < 0) {
+			printf("Child: msgrcv failed (%m)\n");
+			return -errno;
+		}
+		if (ret != strlen(messages[i].mtext) + 1) {
+			printf("Received message[%i] size is wrong: %d "
+					"(should be %ld)\n", i,
+					ret, strlen(messages[i].mtext) + 1);
+			return -EINVAL;
+		}
+		if (memcmp(msgbuf.mtext, messages[i].mtext, ret)) {
+			printf("Received message content is wrong\n");
+			return -EINVAL;
+		}
+		i++;
+	}
+	return 0;
+}
+
+static int peek_messages(int msgq)
+{
+	void *msg_array, *ptr;
+	int array_size;
+	struct msqid_ds ds;
+	int id, ret, i;
+
+	ret = msgctl(msgq, IPC_STAT, &ds);
+	if (ret < 0) {
+		printf("Failed to get stats for IPC message queue (%m)\n");
+		return -errno;
+	}
+
+	/*
+	 * Here we allocate memory for struct msgbuf_a twice becase messages in
+	 * array will be aligned by struct msgbuf_a.
+	 */
+	array_size = ds.msg_qnum * sizeof(struct msgbuf_a) * 2 + ds.msg_cbytes;
+	msg_array = malloc(array_size);
+	if (msg_array == 0)
+		return -ENOMEM;
+
+	ret = msgrcv(msgq, msg_array, array_size, 0, IPC_NOWAIT | MSG_PEEK_ALL);
+	if (ret < 0) {
+		printf("Failed to receive IPC messages array (%m)");
+		return -errno;
+	}
+
+	i = 0;
+	ptr = msg_array;
+	while (i < ds.msg_qnum) {
+		struct msgbuf_a *msg = ptr;
+
+		if (msg->mtype != messages[i].mtype) {
+			printf("Peeked message type is wrong: %ld (should be %ld)\n",
+				msg->mtype, messages[i].mtype);
+			return -EINVAL;
+		}
+		if (memcmp(msg->mtext, messages[i].mtext, msg->msize)) {
+			printf("Peeked message content is wrong\n");
+			return -EINVAL;
+		}
+		ptr += round_up(msg->msize + sizeof(struct msgbuf_a), sizeof(struct msgbuf_a));
+		i++;
+	}
+	return 0;
+}
+
+static int send_messages(int msgq)
+{
+	int i = 0;
+
+	while(messages[i].mtype > 0) {
+		if (msgsnd(msgq, &messages[i], strlen(messages[i].mtext) + 1, IPC_NOWAIT) != 0) {
+			printf("Parent: msgsnd[%i] failed (%m)", i);
+			return -errno;
+		};
+		i++;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	key_t key;
+	int msgq, ret;
+
+	key = ftok(argv[0], 822155650);
+	if (key == -1) {
+		printf("Can't make key");
+		return -errno;
+	}
+
+	msgq = msgget(key, IPC_CREAT | IPC_EXCL | 0666);
+	if (msgq == -1) {
+		msgq = msgget(key, 0666);
+		if (msgq == -1) {
+			printf("Can't get queue");
+			return -errno;
+		}
+	}
+
+	ret = send_messages(msgq);
+	if (ret)
+		goto out;
+	ret = peek_messages(msgq);
+	if (ret)
+		goto out;
+	ret = receive_messages(msgq);
+	if (ret)
+		goto out;
+out:
+	if (msgctl(msgq, IPC_RMID, 0)) {
+		printf("Failed to destroy message queue (%m)\n");
+		return -errno;
+	}
+	return ret;
+}

