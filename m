Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0ESBkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:40:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:41192 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab0ESBkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:16 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 20/25] kgdb: Add the ability to schedule a breakpoint via a tasklet
Date: Tue, 18 May 2010 20:39:30 -0500
Message-Id: <1274233175-3675-21-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:58.0469 (UTC) FILETIME=[30CD3B50:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kgdb I/O modules require the ability to create a breakpoint
tasklet, such as kgdboc and external modules such as kgdboe.  The
breakpoint tasklet is used as an asynchronous entry point into the
debugger which will have a different function scope than the current
execution path where it might not be safe to have an inline
breakpoint.  This is true of some of the kgdb I/O drivers which share
code with kgdb and rest of the kernel users.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h      |    1 +
 kernel/debug/debug_core.c |   26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 19d1b29..ee007ea 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -271,6 +271,7 @@ extern int kgdb_mem2hex(char *mem, char *buf, int count);
 extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
+extern void kgdb_schedule_breakpoint(void);
 
 extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 375e42f..fff5901 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -114,6 +114,7 @@ EXPORT_SYMBOL_GPL(kgdb_active);
  */
 static atomic_t			passive_cpu_wait[NR_CPUS];
 static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
 struct task_struct		*kgdb_usethread;
@@ -789,6 +790,31 @@ static void kgdb_unregister_callbacks(void)
 	}
 }
 
+/*
+ * There are times a tasklet needs to be used vs a compiled in
+ * break point so as to cause an exception outside a kgdb I/O module,
+ * such as is the case with kgdboe, where calling a breakpoint in the
+ * I/O driver itself would be fatal.
+ */
+static void kgdb_tasklet_bpt(unsigned long ing)
+{
+	kgdb_breakpoint();
+	atomic_set(&kgdb_break_tasklet_var, 0);
+}
+
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+
+void kgdb_schedule_breakpoint(void)
+{
+	if (atomic_read(&kgdb_break_tasklet_var) ||
+		atomic_read(&kgdb_active) != -1 ||
+		atomic_read(&kgdb_setting_breakpoint))
+		return;
+	atomic_inc(&kgdb_break_tasklet_var);
+	tasklet_schedule(&kgdb_tasklet_breakpoint);
+}
+EXPORT_SYMBOL_GPL(kgdb_schedule_breakpoint);
+
 static void kgdb_initial_breakpoint(void)
 {
 	kgdb_break_asap = 0;
-- 
1.6.3.3

