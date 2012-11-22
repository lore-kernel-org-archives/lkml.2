Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965208Ab2KVTvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:51:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965107Ab2KVTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:27 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 25/46] staging: line6: drop midi_mask_transmit
Date: Thu, 22 Nov 2012 20:49:04 +0100
Message-Id: <1353613765-18690-26-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The midi_mask_transmit sysfs attribute selects the MIDI channels on
which to transmit messages.  If ALSA wants to transmit a message that
does not match an allowed channel, the message will be dropped.  This
driver feature is not really used and applications don't know how to
take advantage of it.  Therefore we drop it and rely on applications or
MIDI sequencers to select the channels used for communication.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/midi.c | 56 --------------------------------------------
 drivers/staging/line6/midi.h |  5 ----
 2 files changed, 61 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index f0f3e59..8261875 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -72,10 +72,6 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 		if (done == 0)
 			break;
 
-		if (line6_midibuf_skip_message
-		    (mb, line6midi->midi_mask_transmit))
-			continue;
-
 		send_midi_async(line6, chunk, done);
 	}
 
@@ -287,47 +283,10 @@ static int snd_line6_new_midi(struct snd_line6_midi *line6midi)
 	return 0;
 }
 
-/*
-	"read" request on "midi_mask_transmit" special file.
-*/
-static ssize_t midi_get_midi_mask_transmit(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_transmit);
-}
-
-/*
-	"write" request on "midi_mask" special file.
-*/
-static ssize_t midi_set_midi_mask_transmit(struct device *dev,
-					   struct device_attribute *attr,
-					   const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	unsigned short value;
-	int ret;
-
-	ret = kstrtou16(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	line6->line6midi->midi_mask_transmit = value;
-	return count;
-}
-
-static DEVICE_ATTR(midi_mask_transmit, S_IWUSR | S_IRUGO,
-		   midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
-
 /* MIDI device destructor */
 static int snd_line6_midi_free(struct snd_device *device)
 {
 	struct snd_line6_midi *line6midi = device->device_data;
-	device_remove_file(line6midi->line6->ifcdev,
-			   &dev_attr_midi_mask_transmit);
 	line6_midibuf_destroy(&line6midi->midibuf_in);
 	line6_midibuf_destroy(&line6midi->midibuf_out);
 	return 0;
@@ -369,17 +328,6 @@ int line6_init_midi(struct usb_line6 *line6)
 	}
 
 	line6midi->line6 = line6;
-
-	switch (line6->product) {
-	case LINE6_DEVID_PODHD300:
-	case LINE6_DEVID_PODHD500:
-		line6midi->midi_mask_transmit = 1;
-		break;
-
-	default:
-		line6midi->midi_mask_transmit = 1;
-	}
-
 	line6->line6midi = line6midi;
 
 	err = snd_device_new(line6->card, SNDRV_DEV_RAWMIDI, line6midi,
@@ -393,10 +341,6 @@ int line6_init_midi(struct usb_line6 *line6)
 	if (err < 0)
 		return err;
 
-	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_transmit);
-	if (err < 0)
-		return err;
-
 	init_waitqueue_head(&line6midi->send_wait);
 	spin_lock_init(&line6midi->send_urb_lock);
 	spin_lock_init(&line6midi->midi_transmit_lock);
diff --git a/drivers/staging/line6/midi.h b/drivers/staging/line6/midi.h
index cf32d77..19dabd5 100644
--- a/drivers/staging/line6/midi.h
+++ b/drivers/staging/line6/midi.h
@@ -55,11 +55,6 @@ struct snd_line6_midi {
 	wait_queue_head_t send_wait;
 
 	/**
-		 Bit mask for output MIDI channels.
-	*/
-	unsigned short midi_mask_transmit;
-
-	/**
 		 Buffer for incoming MIDI stream.
 	*/
 	struct MidiBuffer midibuf_in;
-- 
1.8.0

