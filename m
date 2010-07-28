Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0G1QqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:46:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0G1QqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:46:04 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH] staging:ti dspbridge: avoid possible NULL dereference panic
Date: Wed, 28 Jul 2010 11:50:36 -0500
Message-Id: <1280335836-31801-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dsp_notifications array is received from user,
dspbridge verifies the array has valid pointers
and dsp_notification structures. However, these
structures contain pointers that need to be
checked for valid handles.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 1b0ab4a..da08dfc 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -539,7 +539,7 @@ func_end:
  */
 u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
 {
-	int status = 0, real_status = 0;
+	int status = 0;
 	struct dsp_notification *anotifications[MAX_EVENTS];
 	struct dsp_notification notifications[MAX_EVENTS];
 	u32 index, i;
@@ -554,19 +554,21 @@ u32 mgrwrap_wait_for_bridge_events(union trapped_args *args, void *pr_ctxt)
 	/* get the events */
 	for (i = 0; i < count; i++) {
 		CP_FM_USR(&notifications[i], anotifications[i], status, 1);
-		if (!status) {
-			/* set the array of pointers to kernel structures */
-			anotifications[i] = &notifications[i];
+		if (status || !notifications[i].handle) {
+			status = -EINVAL;
+			break;
 		}
+		/* set the array of pointers to kernel structures */
+		anotifications[i] = &notifications[i];
 	}
 	if (!status) {
-		real_status = mgr_wait_for_bridge_events(anotifications, count,
+		status = mgr_wait_for_bridge_events(anotifications, count,
 							 &index,
 							 args->args_mgr_wait.
 							 utimeout);
 	}
 	CP_TO_USR(args->args_mgr_wait.pu_index, &index, status, 1);
-	return real_status;
+	return status;
 }
 
 /*
-- 
1.5.4.5

