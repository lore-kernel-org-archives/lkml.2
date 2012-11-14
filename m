Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2KNHwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:52:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50136 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2KNHu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:50:59 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/6] staging: line6: drop control URB dumping code
Date: Wed, 14 Nov 2012 08:50:41 +0100
Message-Id: <1352879446-23195-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
References: <1352879446-23195-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usbmon feature should be used instead of manually dumping control
URBs.  There are a few advantages to using usbmon:

 * Can be turned on/off at runtime
 * Provides full USB-level traffic
 * tcpdump and wireshark support for powerful analysis
 * No driver-specific code is required

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c | 36 ------------------------------------
 drivers/staging/line6/midi.c   |  3 ---
 2 files changed, 39 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 571f2ce..fda92d1 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -177,22 +177,6 @@ void line6_write_hexdump(struct usb_line6 *line6, char dir,
 }
 #endif
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-/*
-	Dump URB data to syslog.
-*/
-static void line6_dump_urb(struct urb *urb)
-{
-	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
-
-	if (urb->status < 0)
-		return;
-
-	line6_write_hexdump(line6, 'R', (unsigned char *)urb->transfer_buffer,
-			    urb->actual_length);
-}
-#endif
-
 /*
 	Send raw message in pieces of wMaxPacketSize bytes.
 */
@@ -201,10 +185,6 @@ int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
 {
 	int i, done = 0;
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, size);
-#endif
-
 	for (i = 0; i < size; i += line6->max_packet_size) {
 		int partial;
 		const char *frag_buf = buffer + i;
@@ -259,10 +239,6 @@ static int line6_send_raw_message_async_part(struct message *msg,
 			 (char *)msg->buffer + done, bytes,
 			 line6_async_request_sent, msg, line6->interval);
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', (char *)msg->buffer + done, bytes);
-#endif
-
 	msg->done += bytes;
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 
@@ -403,10 +379,6 @@ static void line6_data_received(struct urb *urb)
 	if (urb->status == -ESHUTDOWN)
 		return;
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_dump_urb(urb);
-#endif
-
 	done =
 	    line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
 
@@ -502,10 +474,6 @@ int line6_send_program(struct usb_line6 *line6, u8 value)
 	buffer[0] = LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST;
 	buffer[1] = value;
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, 2);
-#endif
-
 	retval = usb_interrupt_msg(line6->usbdev,
 				   usb_sndintpipe(line6->usbdev,
 						  line6->ep_control_write),
@@ -539,10 +507,6 @@ int line6_transmit_parameter(struct usb_line6 *line6, int param, u8 value)
 	buffer[1] = param;
 	buffer[2] = value;
 
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', buffer, 3);
-#endif
-
 	retval = usb_interrupt_msg(line6->usbdev,
 				   usb_sndintpipe(line6->usbdev,
 						  line6->ep_control_write),
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 5040729..348d425 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -131,9 +131,6 @@ static int send_midi_async(struct usb_line6 *line6, unsigned char *data,
 		dev_err(line6->ifcdev, "Out of memory\n");
 		return -ENOMEM;
 	}
-#ifdef CONFIG_LINE6_USB_DUMP_CTRL
-	line6_write_hexdump(line6, 'S', data, length);
-#endif
 
 	transfer_buffer = kmemdup(data, length, GFP_ATOMIC);
 
-- 
1.8.0

