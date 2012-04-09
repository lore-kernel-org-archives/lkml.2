Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2DIRyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:54:43 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2410 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab2DIRyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:54:41 -0400
Subject: [PATCH 4/4] test: IPC message queue migration test
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Date: Mon, 09 Apr 2012 21:54:19 +0400
Message-ID: <20120409175419.8358.18639.stgit@localhost6.localdomain6>
In-Reply-To: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test is a part of CRIU development test suit.

---
 msgque.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 151 insertions(+), 0 deletions(-)
 create mode 100644 msgque.c

diff --git a/msgque.c b/msgque.c
new file mode 100644
index 0000000..9647e0a
--- /dev/null
+++ b/msgque.c
@@ -0,0 +1,151 @@
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
+#include "zdtmtst.h"
+
+const char *test_doc="Tests sysv5 msg queues supporting by checkpointing";
+const char *test_author="Stanislav Kinsbursky <skinsbursky@openvz.org>";
+
+struct msg1 {
+	long mtype;
+	char mtext[20];
+};
+#define TEST_STRING "Test sysv5 msg"
+#define MSG_TYPE 1
+
+#define ANOTHER_TEST_STRING "Yet another test sysv5 msg"
+#define ANOTHER_MSG_TYPE 26538
+
+static int test_fn(int argc, char **argv)
+{
+	key_t key;
+	int msg, pid;
+	struct msg1 msgbuf;
+	int chret;
+
+	key = ftok(argv[0], 822155650);
+	if (key == -1) {
+		err("Can't make key");
+		exit(1);
+	}
+
+	pid = test_fork();
+	if (pid < 0) {
+		err("Can't fork");
+		exit(1);
+	}
+
+	msg = msgget(key, IPC_CREAT | IPC_EXCL | 0666);
+	if (msg == -1) {
+		msg = msgget(key, 0666);
+		if (msg == -1) {
+			err("Can't get queue");
+			goto err_kill;
+		}
+	}
+
+	if (pid == 0) {
+		/*
+		 * Here is the place where test sleeps and waits for signal.
+		 * This place is used for suspend/restore test.
+		 */
+		test_waitsig();
+
+		if (msgrcv(msg, &msgbuf, sizeof(TEST_STRING), MSG_TYPE, IPC_NOWAIT) == -1) {
+			fail("Child: msgrcv failed (%m)");
+			return -errno;
+		}
+
+		if (strncmp(TEST_STRING, msgbuf.mtext, sizeof(TEST_STRING))) {
+			fail("Child: the source and received strings aren't equal");
+			return -errno;
+		}
+		test_msg("Child: received %s\n", msgbuf.mtext);
+
+		msgbuf.mtype = ANOTHER_MSG_TYPE;
+		memcpy(msgbuf.mtext, ANOTHER_TEST_STRING, sizeof(ANOTHER_TEST_STRING));
+		if (msgsnd(msg, &msgbuf, sizeof(ANOTHER_TEST_STRING), IPC_NOWAIT) != 0) {
+			fail("Child: msgsnd failed (%m)");
+			return -errno;
+		};
+		pass();
+		return 0;
+	} else {
+		msgbuf.mtype = MSG_TYPE;
+		memcpy(msgbuf.mtext, TEST_STRING, sizeof(TEST_STRING));
+		if (msgsnd(msg, &msgbuf, sizeof(TEST_STRING), IPC_NOWAIT) != 0) {
+			fail("Parent: msgsnd failed (%m)");
+			goto err_kill;
+		};
+
+		msgbuf.mtype = ANOTHER_MSG_TYPE;
+		memcpy(msgbuf.mtext, ANOTHER_TEST_STRING, sizeof(ANOTHER_TEST_STRING));
+		if (msgsnd(msg, &msgbuf, sizeof(ANOTHER_TEST_STRING), IPC_NOWAIT) != 0) {
+			fail("child: msgsnd (2) failed (%m)");
+			return -errno;
+		};
+
+		test_daemon();
+		test_waitsig();
+
+		kill(pid, SIGTERM);
+
+		wait(&chret);
+		chret = WEXITSTATUS(chret);
+		if (chret) {
+			fail("Parent: child exited with non-zero code %d (%s)\n",
+			     chret, strerror(chret));
+			goto out;
+		}
+
+		if (msgrcv(msg, &msgbuf, sizeof(ANOTHER_TEST_STRING), ANOTHER_MSG_TYPE, IPC_NOWAIT) == -1) {
+			fail("Parent: msgrcv failed (%m)");
+			goto err;
+		}
+
+		if (strncmp(ANOTHER_TEST_STRING, msgbuf.mtext, sizeof(ANOTHER_TEST_STRING))) {
+			fail("Parent: the source and received strings aren't equal");
+			goto err;
+		}
+		test_msg("Parent: received %s\n", msgbuf.mtext);
+
+		pass();
+	}
+
+out:
+	if (msgctl(msg, IPC_RMID, 0)) {
+		fail("Failed to destroy message queue: %d\n", -errno);
+		return -errno;
+	}
+	return chret;
+
+err_kill:
+	kill(pid, SIGKILL);
+	wait(NULL);
+err:
+	chret = -errno;
+	goto out;
+}
+
+int main(int argc, char **argv)
+{
+#ifdef NEW_IPC_NS
+	test_init_ns(argc, argv, CLONE_NEWIPC, test_fn);
+#else
+	test_init(argc, argv);
+	test_fn();
+#endif
+	return 0;
+}

