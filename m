Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2LRVzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:55:13 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53664 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab2LRVzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:55:08 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org, wad@chromium.org,
        pmoore@redhat.com, otubo@linux.vnet.ibm.com
Subject: [PATCH 3/3] samples: Add sample using SECCOMP_RET_INFO
Date: Tue, 18 Dec 2012 16:54:45 -0500
Message-Id: <1355867685-3303-1-git-send-email-coreyb@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121821-5806-0000-0000-00001D26084A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a sample that demonstrates use of the SECCOMP_RET_INFO return value.

Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>
---
 samples/seccomp/Makefile     |  8 ++++++-
 samples/seccomp/bpf-logger.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 samples/seccomp/bpf-logger.c

diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
index bbbd276..ee769bb 100644
--- a/samples/seccomp/Makefile
+++ b/samples/seccomp/Makefile
@@ -1,7 +1,7 @@
 # kbuild trick to avoid linker error. Can be omitted if a module is built.
 obj- := dummy.o
 
-hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct
+hostprogs-$(CONFIG_SECCOMP_FILTER) := bpf-fancy dropper bpf-direct bpf-logger
 
 HOSTCFLAGS_bpf-fancy.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-fancy.o += -idirafter $(objtree)/include
@@ -17,6 +17,10 @@ HOSTCFLAGS_bpf-direct.o += -I$(objtree)/usr/include
 HOSTCFLAGS_bpf-direct.o += -idirafter $(objtree)/include
 bpf-direct-objs := bpf-direct.o
 
+HOSTCFLAGS_bpf-logger.o += -I$(objtree)/usr/include
+HOSTCFLAGS_bpf-logger.o += -idirafter $(objtree)/include
+bpf-logger-objs := bpf-logger.o
+
 # Try to match the kernel target.
 ifndef CONFIG_64BIT
 
@@ -31,9 +35,11 @@ HOSTCFLAGS_bpf-direct.o += $(MFLAG)
 HOSTCFLAGS_dropper.o += $(MFLAG)
 HOSTCFLAGS_bpf-helper.o += $(MFLAG)
 HOSTCFLAGS_bpf-fancy.o += $(MFLAG)
+HOSTCFLAGS_bpf-logger.o += $(MFLAG)
 HOSTLOADLIBES_bpf-direct += $(MFLAG)
 HOSTLOADLIBES_bpf-fancy += $(MFLAG)
 HOSTLOADLIBES_dropper += $(MFLAG)
+HOSTLOADLIBES_bpf-logger += $(MFLAG)
 endif
 
 # Tell kbuild to always build the programs
diff --git a/samples/seccomp/bpf-logger.c b/samples/seccomp/bpf-logger.c
new file mode 100644
index 0000000..4eee0ea
--- /dev/null
+++ b/samples/seccomp/bpf-logger.c
@@ -0,0 +1,52 @@
+/*
+ * System call logger built on seccomp_filter.
+ *
+ * Copyright (c) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ * Copyright (C) IBM Corporation, 2012
+ * Authors: Will Drewry <wad@chromium.org>
+ *          Corey Bryant <coreyb@linux.vnet.ibm.com>
+ *
+ * The code may be used by anyone for any purpose,
+ * and can serve as a starting point for developing
+ * applications using prctl(PR_SET_SECCOMP, 2, ...).
+ *
+ * Prints rate-limited informational kernel messages for
+ * each system call that the process executes.
+ *
+ * Run this one as root as PR_SET_NO_NEW_PRIVS is not called.
+ */
+
+#include <linux/filter.h>
+#include <linux/seccomp.h>
+#include <linux/unistd.h>
+#include <sys/prctl.h>
+#include <unistd.h>
+
+static int install_filter()
+{
+	struct sock_filter filter[] = {
+		BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_INFO),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
+		.filter = filter,
+	};
+	if (prctl(PR_SET_SECCOMP, 2, &prog)) {
+		perror("prctl");
+		return 1;
+	}
+	return 0;
+}
+
+#define payload(_c) (_c), sizeof((_c))
+int main(int argc, char **argv)
+{
+	int fd;
+	char msg[] = "To examine syscalls type: dmesg | grep seccomp\n";
+	if (install_filter())
+		return 1;
+	fd = syscall(__NR_dup, STDOUT_FILENO);
+	syscall(__NR_write, fd, payload(msg));
+	syscall(__NR_close, fd);
+	return 0;
+}
-- 
1.7.11.7

