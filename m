Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2GaEvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48901 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748Ab2GaEvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:11 -0400
Message-Id: <20120731044316.272290483@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 31/73] ftrace: Disable function tracing during suspend/resume and
 hibernation, again
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit 443772d408a25af62498793f6f805ce3c559309a upstream.

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/power/hibernate.c |    6 ++++++
 kernel/power/suspend.c   |    3 +++
 2 files changed, 9 insertions(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -367,6 +367,7 @@ int hibernation_snapshot(int platform_mo
 	}
 
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend(PMSG_FREEZE);
 	if (error)
@@ -392,6 +393,7 @@ int hibernation_snapshot(int platform_mo
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
+	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -496,6 +498,7 @@ int hibernation_restore(int platform_mod
 
 	pm_prepare_console();
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -503,6 +506,7 @@ int hibernation_restore(int platform_mod
 		dpm_resume_end(PMSG_RECOVER);
 	}
 	pm_restore_gfp_mask();
+	ftrace_start();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -529,6 +533,7 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
+	ftrace_stop();
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -572,6 +577,7 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
+	ftrace_start();
 	resume_console();
 
  Close:
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -25,6 +25,7 @@
 #include <linux/export.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -220,6 +221,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	ftrace_stop();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -239,6 +241,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	ftrace_start();
 	resume_console();
  Close:
 	if (suspend_ops->end)


