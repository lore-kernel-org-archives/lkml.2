Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1EFWcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:32:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56835 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1EFWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:32:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl
Date: Sat, 7 May 2011 00:30:30 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alexandre Felipe Muller de Souza 
	<alexandrefm@mandriva.com.br>
References: <201105070029.44623.rjw@sisk.pl>
In-Reply-To: <201105070029.44623.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105070030.30849.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

A warning is printed by pm_restrict_gfp_mask() while the
SNAPSHOT_S2RAM ioctl is being executed after creating a hibernation
image, because pm_restrict_gfp_mask() has been called once already
before the image creation and suspend_devices_and_enter() calls it
once again.  This happens after commit 452aa6999e6703ffbddd7f6ea124d3
(mm/pm: force GFP_NOIO during suspend/hibernation and resume).

To avoid this issue, move pm_restrict_gfp_mask() and
pm_restore_gfp_mask() from suspend_devices_and_enter() to its caller
in kernel/power/suspend.c.

Reported-by: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/suspend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -210,7 +210,6 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -227,7 +226,6 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
@@ -288,7 +286,9 @@ int enter_state(suspend_state_t state)
 		goto Finish;
 
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
+	pm_restore_gfp_mask();
 
  Finish:
 	pr_debug("PM: Finishing wakeup.\n");

