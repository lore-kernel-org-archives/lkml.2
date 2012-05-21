Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2EUHPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:15:04 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60207 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2EUHPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:15:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: Disable function tracing during suspend/resume and
 hibernation, again
To: rostedt@goodmis.org, rjw@sisk.pl
Cc: mingo@kernel.org, lenb@kernel.org, pavel@ucw.cz, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 21 May 2012 12:27:14 +0530
Message-ID: <20120521065651.4142.36898.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12052106-5564-0000-0000-000002CBB973
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If function tracing is enabled for some of the low-level suspend/resume
functions, it leads to triple fault during resume from suspend, ultimately
ending up in a reboot instead of a resume (or a total refusal to come out
of suspended state, on some machines).

This issue was explained in more detail in commit f42ac38c59e0a03d (ftrace:
disable tracing for suspend to ram). However, the changes made by that commit
got reverted by commit cbe2f5a6e84eebb (tracing: allow tracing of
suspend/resume & hibernation code again). So, unfortunately since things are
not yet robust enough to allow tracing of low-level suspend/resume functions,
suspend/resume is still broken when ftrace is enabled.

So fix this by disabling function tracing during suspend/resume & hibernation.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
---

 kernel/power/hibernate.c |    6 ++++++
 kernel/power/suspend.c   |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..52a1817 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -352,6 +352,7 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
@@ -377,6 +378,7 @@ int hibernation_snapshot(int platform_mode)
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
+	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -479,6 +481,7 @@ int hibernation_restore(int platform_mode)
 
 	pm_prepare_console();
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -486,6 +489,7 @@ int hibernation_restore(int platform_mode)
 		dpm_resume_end(PMSG_RECOVER);
 	}
 	pm_restore_gfp_mask();
+	ftrace_start();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -512,6 +516,7 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
+	ftrace_stop();
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -555,6 +560,7 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
+	ftrace_start();
 	resume_console();
 
  Close:
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 396d262..c8b7446 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -212,6 +213,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 			goto Close;
 	}
 	suspend_console();
+	ftrace_stop();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -231,6 +233,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	ftrace_start();
 	resume_console();
  Close:
 	if (suspend_ops->end)

