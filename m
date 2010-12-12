Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0LLQtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:49:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:45391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab0LLQtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:49:07 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Duncan Sands <duncan.sands@free.fr>, linux-usb@vger.kernel.org
Subject: [PATCH 5/6] speedtch: don't abuse struct delayed_work
Date: Sun, 12 Dec 2010 17:48:18 +0100
Message-Id: <1292172499-21633-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:49:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speedtch directly uses the internal timer and work members of a struct
delayed_work.  Use a separate work item and timer instead.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: linux-usb@vger.kernel.org
---
This is part of a series to remove flush_scheduled_work() usage to
prepare for deprecation of flush_scheduled_work().  Patches in this
series are self contained and mostly straight-forward.

Please feel free to take it into the appropriate tree, or just ack it.
In the latter case, I'll merge the patch through the workqueue tree
during the next merge window.

Thank you.

 drivers/usb/atm/speedtch.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 4716e70..b591906 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -139,7 +139,8 @@ struct speedtch_instance_data {
 
 	struct speedtch_params params; /* set in probe, constant afterwards */
 
-	struct delayed_work status_checker;
+	struct timer_list status_check_timer;
+	struct work_struct status_check_work;
 
 	unsigned char last_status;
 
@@ -498,7 +499,7 @@ static void speedtch_check_status(struct work_struct *work)
 {
 	struct speedtch_instance_data *instance =
 		container_of(work, struct speedtch_instance_data,
-			     status_checker.work);
+			     status_check_work);
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct atm_dev *atm_dev = usbatm->atm_dev;
 	unsigned char *buf = instance->scratch_buffer;
@@ -575,11 +576,11 @@ static void speedtch_status_poll(unsigned long data)
 {
 	struct speedtch_instance_data *instance = (void *)data;
 
-	schedule_delayed_work(&instance->status_checker, 0);
+	schedule_work(&instance->status_check_work);
 
 	/* The following check is racy, but the race is harmless */
 	if (instance->poll_delay < MAX_POLL_DELAY)
-		mod_timer(&instance->status_checker.timer, jiffies + msecs_to_jiffies(instance->poll_delay));
+		mod_timer(&instance->status_check_timer, jiffies + msecs_to_jiffies(instance->poll_delay));
 	else
 		atm_warn(instance->usbatm, "Too many failures - disabling line status polling\n");
 }
@@ -595,7 +596,7 @@ static void speedtch_resubmit_int(unsigned long data)
 	if (int_urb) {
 		ret = usb_submit_urb(int_urb, GFP_ATOMIC);
 		if (!ret)
-			schedule_delayed_work(&instance->status_checker, 0);
+			schedule_work(&instance->status_check_work);
 		else {
 			atm_dbg(instance->usbatm, "%s: usb_submit_urb failed with result %d\n", __func__, ret);
 			mod_timer(&instance->resubmit_timer, jiffies + msecs_to_jiffies(RESUBMIT_DELAY));
@@ -624,7 +625,7 @@ static void speedtch_handle_int(struct urb *int_urb)
 	}
 
 	if ((count == 6) && !memcmp(up_int, instance->int_data, 6)) {
-		del_timer(&instance->status_checker.timer);
+		del_timer(&instance->status_check_timer);
 		atm_info(usbatm, "DSL line goes up\n");
 	} else if ((count == 6) && !memcmp(down_int, instance->int_data, 6)) {
 		atm_info(usbatm, "DSL line goes down\n");
@@ -640,7 +641,7 @@ static void speedtch_handle_int(struct urb *int_urb)
 
 	if ((int_urb = instance->int_urb)) {
 		ret = usb_submit_urb(int_urb, GFP_ATOMIC);
-		schedule_delayed_work(&instance->status_checker, 0);
+		schedule_work(&instance->status_check_work);
 		if (ret < 0) {
 			atm_dbg(usbatm, "%s: usb_submit_urb failed with result %d\n", __func__, ret);
 			goto fail;
@@ -686,7 +687,7 @@ static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_de
 	}
 
 	/* Start status polling */
-	mod_timer(&instance->status_checker.timer, jiffies + msecs_to_jiffies(1000));
+	mod_timer(&instance->status_check_timer, jiffies + msecs_to_jiffies(1000));
 
 	return 0;
 }
@@ -698,7 +699,7 @@ static void speedtch_atm_stop(struct usbatm_data *usbatm, struct atm_dev *atm_de
 
 	atm_dbg(usbatm, "%s entered\n", __func__);
 
-	del_timer_sync(&instance->status_checker.timer);
+	del_timer_sync(&instance->status_check_timer);
 
 	/*
 	 * Since resubmit_timer and int_urb can schedule themselves and
@@ -869,10 +870,10 @@ static int speedtch_bind(struct usbatm_data *usbatm,
 
 	usbatm->flags |= (use_isoc ? UDSL_USE_ISOC : 0);
 
-	INIT_DELAYED_WORK(&instance->status_checker, speedtch_check_status);
+	INIT_WORK(&instance->status_check_work, speedtch_check_status);
 
-	instance->status_checker.timer.function = speedtch_status_poll;
-	instance->status_checker.timer.data = (unsigned long)instance;
+	instance->status_check_timer.function = speedtch_status_poll;
+	instance->status_check_timer.data = (unsigned long)instance;
 	instance->last_status = 0xff;
 	instance->poll_delay = MIN_POLL_DELAY;
 
-- 
1.7.1

