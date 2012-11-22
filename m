Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab2KVUDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:03:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2KVTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:26 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 24/46] staging: line6: drop midi_mask_receive
Date: Thu, 22 Nov 2012 20:49:03 +0100
Message-Id: <1353613765-18690-25-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The midi_mask_receive sysfs attribute selects the MIDI channels on which
to receive messages.  There is no need to do this at the driver level,
instead the MIDI application endpoints decide which channels to use.
Other drivers don't implement midi_mask_receive so applications cannot
make use of this feature.  Therefore we drop it as part of the effort to
clean up the staging driver.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c |  5 -----
 drivers/staging/line6/midi.c   | 42 ------------------------------------------
 drivers/staging/line6/midi.h   |  5 -----
 3 files changed, 52 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 571f2ce..3c27051 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -424,11 +424,6 @@ static void line6_data_received(struct urb *urb)
 		if (done == 0)
 			break;
 
-		/* MIDI input filter */
-		if (line6_midibuf_skip_message
-		    (mb, line6->line6midi->midi_mask_receive))
-			continue;
-
 		line6->message_length = done;
 #ifdef CONFIG_LINE6_USB_DUMP_MIDI
 		line6_write_hexdump(line6, 'r', line6->buffer_message, done);
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 5040729..f0f3e59 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -319,42 +319,8 @@ static ssize_t midi_set_midi_mask_transmit(struct device *dev,
 	return count;
 }
 
-/*
-	"read" request on "midi_mask_receive" special file.
-*/
-static ssize_t midi_get_midi_mask_receive(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	return sprintf(buf, "%d\n", line6->line6midi->midi_mask_receive);
-}
-
-/*
-	"write" request on "midi_mask" special file.
-*/
-static ssize_t midi_set_midi_mask_receive(struct device *dev,
-					  struct device_attribute *attr,
-					  const char *buf, size_t count)
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
-	line6->line6midi->midi_mask_receive = value;
-	return count;
-}
-
 static DEVICE_ATTR(midi_mask_transmit, S_IWUSR | S_IRUGO,
 		   midi_get_midi_mask_transmit, midi_set_midi_mask_transmit);
-static DEVICE_ATTR(midi_mask_receive, S_IWUSR | S_IRUGO,
-		   midi_get_midi_mask_receive, midi_set_midi_mask_receive);
 
 /* MIDI device destructor */
 static int snd_line6_midi_free(struct snd_device *device)
@@ -362,8 +328,6 @@ static int snd_line6_midi_free(struct snd_device *device)
 	struct snd_line6_midi *line6midi = device->device_data;
 	device_remove_file(line6midi->line6->ifcdev,
 			   &dev_attr_midi_mask_transmit);
-	device_remove_file(line6midi->line6->ifcdev,
-			   &dev_attr_midi_mask_receive);
 	line6_midibuf_destroy(&line6midi->midibuf_in);
 	line6_midibuf_destroy(&line6midi->midibuf_out);
 	return 0;
@@ -410,12 +374,10 @@ int line6_init_midi(struct usb_line6 *line6)
 	case LINE6_DEVID_PODHD300:
 	case LINE6_DEVID_PODHD500:
 		line6midi->midi_mask_transmit = 1;
-		line6midi->midi_mask_receive = 1;
 		break;
 
 	default:
 		line6midi->midi_mask_transmit = 1;
-		line6midi->midi_mask_receive = 4;
 	}
 
 	line6->line6midi = line6midi;
@@ -435,10 +397,6 @@ int line6_init_midi(struct usb_line6 *line6)
 	if (err < 0)
 		return err;
 
-	err = device_create_file(line6->ifcdev, &dev_attr_midi_mask_receive);
-	if (err < 0)
-		return err;
-
 	init_waitqueue_head(&line6midi->send_wait);
 	spin_lock_init(&line6midi->send_urb_lock);
 	spin_lock_init(&line6midi->midi_transmit_lock);
diff --git a/drivers/staging/line6/midi.h b/drivers/staging/line6/midi.h
index 4a9e9f9..cf32d77 100644
--- a/drivers/staging/line6/midi.h
+++ b/drivers/staging/line6/midi.h
@@ -60,11 +60,6 @@ struct snd_line6_midi {
 	unsigned short midi_mask_transmit;
 
 	/**
-		 Bit mask for input MIDI channels.
-	*/
-	unsigned short midi_mask_receive;
-
-	/**
 		 Buffer for incoming MIDI stream.
 	*/
 	struct MidiBuffer midibuf_in;
-- 
1.8.0

