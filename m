Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab2HGXOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:14:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40991 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2HGWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:37:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 030/109] ftrace: Disable function tracing during suspend/resume and hibernation, again
Date: Tue,  7 Aug 2012 15:34:49 -0700
Message-Id: <20120807222045.749888021@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |    6 ++++++
 kernel/power/suspend.c   |    3 +++
 2 files changed, 9 insertions(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -352,6 +352,7 @@ int hibernation_snapshot(int platform_mo
 	}
 
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
@@ -377,6 +378,7 @@ int hibernation_snapshot(int platform_mo
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
+	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -479,6 +481,7 @@ int hibernation_restore(int platform_mod
 
 	pm_prepare_console();
 	suspend_console();
+	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -486,6 +489,7 @@ int hibernation_restore(int platform_mod
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
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -24,6 +24,7 @@
 #include <linux/export.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 
 #include "power.h"
@@ -212,6 +213,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	ftrace_stop();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -231,6 +233,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	ftrace_start();
 	resume_console();
  Close:
 	if (suspend_ops->end)


