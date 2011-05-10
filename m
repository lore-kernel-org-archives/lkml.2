Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1EJSUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:20:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60628 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab1EJSUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:20:32 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] um: fix abort
Date: Tue, 10 May 2011 20:18:56 +0200
Message-Id: <1305051538-7191-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305051538-7191-1-git-send-email-richard@nod.at>
References: <1305051538-7191-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

os_dump_core() uses abort() to terminate UML in case of an
fatal error.
glibc's abort() calls raise(SIGABRT) which makes use of tgkill().
tgkill() has no effect within UML's kernel threads because they
are not pthreads. As fallback abort() executes an invalid instruction
to terminate the process. Therefore UML gets killed by SIGSEGV and
leaves a ugly log entry in the host's kernel ring buffer.

To get rid of this we use our own abort routine.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/util.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 6ea7797..42827ca 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -5,6 +5,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <unistd.h>
 #include <errno.h>
 #include <signal.h>
 #include <string.h>
@@ -75,6 +76,26 @@ void setup_hostinfo(char *buf, int len)
 		 host.release, host.version, host.machine);
 }
 
+/*
+ * We cannot use glibc's abort(). It makes use of tgkill() which
+ * has no effect within UML's kernel threads.
+ * After that glibc would execute an invalid instruction to kill
+ * the calling process and UML crashes with SIGSEGV.
+ */
+static inline void __attribute__ ((noreturn)) uml_abort(void)
+{
+	sigset_t sig;
+
+	fflush(NULL);
+
+	if (!sigemptyset(&sig) && !sigaddset(&sig, SIGABRT))
+		sigprocmask(SIG_UNBLOCK, &sig, 0);
+
+	for (;;)
+		if (kill(getpid(), SIGABRT) < 0)
+			exit(127);
+}
+
 void os_dump_core(void)
 {
 	int pid;
@@ -116,5 +137,5 @@ void os_dump_core(void)
 	while ((pid = waitpid(-1, NULL, WNOHANG | __WALL)) > 0)
 		os_kill_ptraced_process(pid, 0);
 
-	abort();
+	uml_abort();
 }
-- 
1.7.4.2

