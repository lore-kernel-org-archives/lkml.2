Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab1ESSU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:20:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33761 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933951Ab1ESSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:20 -0400
X-Sasl-enc: 9bBYxgtRkYLgdfnG1bZKfPU6tUlslYd5q3E2P0M7vfWI 1305828499
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.687159978@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [25/71] PM: Fix warning in pm_restrict_gfp_mask() during SNAPSHOT_S2RAM ioctl
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 87186475a402391a1ca7d42a675c9b35a18dc348 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/power/suspend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -209,7 +209,6 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -226,7 +225,6 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
@@ -287,7 +285,9 @@ int enter_state(suspend_state_t state)
 		goto Finish;
 
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	pm_restrict_gfp_mask();
 	error = suspend_devices_and_enter(state);
+	pm_restore_gfp_mask();
 
  Finish:
 	pr_debug("PM: Finishing wakeup.\n");


