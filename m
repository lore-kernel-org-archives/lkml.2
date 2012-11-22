Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178Ab2KVTvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab2KVTv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:29 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 26/46] staging: line6: drop midi_postprocess flag
Date: Thu, 22 Nov 2012 20:49:05 +0100
Message-Id: <1353613765-18690-27-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer necessary to trigger on MIDI transmit messages that will
change the state of the device since:

1. We've dropped the midi_postprocess sysfs attr in a previous commit so
   it is not possible to activate this feature anymore.

2. The other sysfs attrs that could inspect the state after a dump
   request have been dropped.

Therefore we can safely remove this dead code.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/midi.c | 22 ----------------------
 drivers/staging/line6/pod.c  | 34 ----------------------------------
 drivers/staging/line6/pod.h  |  7 -------
 3 files changed, 63 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 8261875..53bef97 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -154,28 +154,6 @@ static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
 	}
 
 	++line6->line6midi->num_active_send_urbs;
-
-	switch (line6->usbdev->descriptor.idProduct) {
-	case LINE6_DEVID_BASSPODXT:
-	case LINE6_DEVID_BASSPODXTLIVE:
-	case LINE6_DEVID_BASSPODXTPRO:
-	case LINE6_DEVID_PODXT:
-	case LINE6_DEVID_PODXTLIVE:
-	case LINE6_DEVID_PODXTPRO:
-	case LINE6_DEVID_POCKETPOD:
-		line6_pod_midi_postprocess((struct usb_line6_pod *)line6, data,
-					   length);
-		break;
-
-	case LINE6_DEVID_VARIAX:
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD500:
-		break;
-
-	default:
-		MISSING_CASE;
-	}
-
 	return 0;
 }
 
diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 37b20d7..ddd0e54 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -285,40 +285,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 }
 
 /*
-	Detect some cases that require a channel dump after sending a command to the
-	device. Important notes:
-	*) The actual dump request can not be sent here since we are not allowed to
-	wait for the completion of the first message in this context, and sending
-	the dump request before completion of the previous message leaves the POD
-	in an undefined state. The dump request will be sent when the echoed
-	commands are received.
-	*) This method fails if a param change message is "chopped" after the first
-	byte.
-*/
-void line6_pod_midi_postprocess(struct usb_line6_pod *pod, unsigned char *data,
-				int length)
-{
-	int i;
-
-	if (!pod->midi_postprocess)
-		return;
-
-	for (i = 0; i < length; ++i) {
-		if (data[i] == (LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST)) {
-			line6_invalidate_current(&pod->dumpreq);
-			break;
-		} else
-		    if ((data[i] == (LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST))
-			&& (i < length - 1))
-			if ((data[i + 1] == POD_amp_model_setup)
-			    || (data[i + 1] == POD_effect_setup)) {
-				line6_invalidate_current(&pod->dumpreq);
-				break;
-			}
-	}
-}
-
-/*
 	Transmit PODxt Pro control parameter.
 */
 void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 481cce6..8543bae 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -127,18 +127,11 @@ struct usb_line6_pod {
 		Device ID.
 	*/
 	int device_id;
-
-	/**
-		Flag to enable MIDI postprocessing.
-	*/
-	char midi_postprocess;
 };
 
 extern void line6_pod_disconnect(struct usb_interface *interface);
 extern int line6_pod_init(struct usb_interface *interface,
 			  struct usb_line6_pod *pod);
-extern void line6_pod_midi_postprocess(struct usb_line6_pod *pod,
-				       unsigned char *data, int length);
 extern void line6_pod_process_message(struct usb_line6_pod *pod);
 extern void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
 					 u8 value);
-- 
1.8.0

