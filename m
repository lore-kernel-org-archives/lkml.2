Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0DNQUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:20:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58304 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265Ab0DNQUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:20:22 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/3] Add tracing_off_event() calls to BUG() and WARN() paths
Date: Wed, 14 Apr 2010 12:20:15 -0400
Message-Id: <1271262016-18650-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds tracing_off_event() calls, which stop debug tracing,
when a BUG() or WARN() function is called. The stoppage depends on
commandline paramenter tracing_off={bug,warn,none}. The default is
"bug", so only the BUG() paths will stop tracing.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 kernel/panic.c |    4 +++-
 lib/bug.c      |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 13d966b..f0ff321 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -319,7 +319,7 @@ int oops_may_print(void)
  */
 void oops_enter(void)
 {
-	tracing_off();
+	tracing_off_event(TRACE_EVENT_BUG);
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();
@@ -369,6 +369,8 @@ static void warn_slowpath_common(const char *file, int line, void *caller, struc
 {
 	const char *board;
 
+	tracing_off_event(TRACE_EVENT_WARN);
+
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 	board = dmi_get_system_info(DMI_PRODUCT_NAME);
diff --git a/lib/bug.c b/lib/bug.c
index 300e41a..457c1eb 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -154,6 +154,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		warning = (bug->flags & BUGFLAG_WARNING) != 0;
 	}
 
+	tracing_off_event(warning ? TRACE_EVENT_WARN : TRACE_EVENT_BUG);
+
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
 		if (file)
-- 
1.7.0

