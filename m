Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0LRQcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:32:52 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:62540 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0LRQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lkTiL1lpHYCRd2nY/VYEuNterrIqGgO+m7OW3LCm3/kfyMSdnzdB+8E0OhfnVYx6Hj
         tXpdUnGABvKspRig/2ss7FfdRCK253jrP2CKqh6F/x8iF2xwKrAgRRUwF2A1i9BeI3PQ
         YSmtG8c2Vx6zwJmTgOe7bj+Ej9P5dNAZeKXDE=
Message-ID: <4D0CE22F.7090409@kernel.org>
Date: Sat, 18 Dec 2010 17:32:47 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Duncan Sands <duncan.sands@free.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 5/6] speedtch: don't abuse struct delayed_work
References: <20101216213005.GA5781@kroah.com> <1292172499-21633-6-git-send-email-tj@kernel.org> <1292172499-21633-1-git-send-email-tj@kernel.org> <20101217145117.75a28ae0@absol.kitzblitz>
In-Reply-To: <20101217145117.75a28ae0@absol.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

speedtch directly uses the internal timer and work members of a struct
delayed_work.  Use a separate work item and timer instead.

* Nicolas Kaiser discovered that timer init was missing.  Fixed.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@free.fr>
Cc: linux-usb@vger.kernel.org
Cc: Nicolas Kaiser <nikai@nikai.net>
---
Can you please test this one?  Thanks.

 drivers/usb/atm/speedtch.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: work/drivers/usb/atm/speedtch.c
===================================================================
--- work.orig/drivers/usb/atm/speedtch.c
+++ work/drivers/usb/atm/speedtch.c
@@ -139,7 +139,8 @@ struct speedtch_instance_data {

 	struct speedtch_params params; /* set in probe, constant afterwards */

-	struct delayed_work status_checker;
+	struct timer_list status_check_timer;
+	struct work_struct status_check_work;

 	unsigned char last_status;

@@ -498,7 +499,7 @@ static void speedtch_check_status(struct
 {
 	struct speedtch_instance_data *instance =
 		container_of(work, struct speedtch_instance_data,
-			     status_checker.work);
+			     status_check_work);
 	struct usbatm_data *usbatm = instance->usbatm;
 	struct atm_dev *atm_dev = usbatm->atm_dev;
 	unsigned char *buf = instance->scratch_buffer;
@@ -575,11 +576,11 @@ static void speedtch_status_poll(unsigne
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
@@ -595,7 +596,7 @@ static void speedtch_resubmit_int(unsign
 	if (int_urb) {
 		ret = usb_submit_urb(int_urb, GFP_ATOMIC);
 		if (!ret)
-			schedule_delayed_work(&instance->status_checker, 0);
+			schedule_work(&instance->status_check_work);
 		else {
 			atm_dbg(instance->usbatm, "%s: usb_submit_urb failed with result %d\n", __func__, ret);
 			mod_timer(&instance->resubmit_timer, jiffies + msecs_to_jiffies(RESUBMIT_DELAY));
@@ -624,7 +625,7 @@ static void speedtch_handle_int(struct u
 	}

 	if ((count == 6) && !memcmp(up_int, instance->int_data, 6)) {
-		del_timer(&instance->status_checker.timer);
+		del_timer(&instance->status_check_timer);
 		atm_info(usbatm, "DSL line goes up\n");
 	} else if ((count == 6) && !memcmp(down_int, instance->int_data, 6)) {
 		atm_info(usbatm, "DSL line goes down\n");
@@ -640,7 +641,7 @@ static void speedtch_handle_int(struct u

 	if ((int_urb = instance->int_urb)) {
 		ret = usb_submit_urb(int_urb, GFP_ATOMIC);
-		schedule_delayed_work(&instance->status_checker, 0);
+		schedule_work(&instance->status_check_work);
 		if (ret < 0) {
 			atm_dbg(usbatm, "%s: usb_submit_urb failed with result %d\n", __func__, ret);
 			goto fail;
@@ -686,7 +687,7 @@ static int speedtch_atm_start(struct usb
 	}

 	/* Start status polling */
-	mod_timer(&instance->status_checker.timer, jiffies + msecs_to_jiffies(1000));
+	mod_timer(&instance->status_check_timer, jiffies + msecs_to_jiffies(1000));

 	return 0;
 }
@@ -698,7 +699,7 @@ static void speedtch_atm_stop(struct usb

 	atm_dbg(usbatm, "%s entered\n", __func__);

-	del_timer_sync(&instance->status_checker.timer);
+	del_timer_sync(&instance->status_check_timer);

 	/*
 	 * Since resubmit_timer and int_urb can schedule themselves and
@@ -869,10 +870,11 @@ static int speedtch_bind(struct usbatm_d

 	usbatm->flags |= (use_isoc ? UDSL_USE_ISOC : 0);

-	INIT_DELAYED_WORK(&instance->status_checker, speedtch_check_status);
+	INIT_WORK(&instance->status_check_work, speedtch_check_status);
+	init_timer(&instance->status_check_timer);

-	instance->status_checker.timer.function = speedtch_status_poll;
-	instance->status_checker.timer.data = (unsigned long)instance;
+	instance->status_check_timer.function = speedtch_status_poll;
+	instance->status_check_timer.data = (unsigned long)instance;
 	instance->last_status = 0xff;
 	instance->poll_delay = MIN_POLL_DELAY;

