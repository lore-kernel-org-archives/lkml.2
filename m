Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab2JJXDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:03:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40459 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932675Ab2JJXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:43 -0400
X-Sasl-enc: SyHYn+9iq2JMbH7SWpQIuIqUeHfB26qHvQBmQMwNP8bM 1349910221
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 072/122] ALSA: snd-usb: Add quirks for Playback Designs devices
Date: Thu, 11 Oct 2012 07:53:58 +0900
Message-Id: <20121010225351.076653536@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 2b58fd5b3193fd3af3d15114d95706087d25a7fe upstream.

Playback Designs' USB devices have some hardware limitations on their
USB interface. In particular:

 - They need a 20ms delay after each class compliant request as the
   hardware ACKs the USB packets before the device is actually ready
   for the next command. Sending data immediately will result in buffer
   overflows in the hardware.
 - The devices send bogus feedback data at the start of each stream
   which confuse the feedback format auto-detection.

This patch introduces a new quirks hook that is called after each
control packet and which adds a delay for all devices that match
Playback Designs' USB VID for now.

In addition, it adds a counter to snd_usb_endpoint to drop received
packets on the floor. Another new quirks function that is called once
an endpoint is started initializes that counter for these devices on
their sync endpoint.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: Andreas Koch <andreas@akdesigninc.com>
Supported-by: Demian Martin <demianm_1@yahoo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.h     |    2 ++
 sound/usb/endpoint.c |    8 ++++++++
 sound/usb/helper.c   |    5 +++++
 sound/usb/quirks.c   |   24 ++++++++++++++++++++++++
 sound/usb/quirks.h   |   10 ++++++++++
 5 files changed, 49 insertions(+)

--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -92,6 +92,8 @@ struct snd_usb_endpoint {
 	unsigned char silence_value;
 	unsigned int stride;
 	int iface, alt_idx;
+	int skip_packets;		/* quirks for devices to ignore the first n packets
+					   in a stream */
 
 	spinlock_t lock;
 	struct list_head list;
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -31,6 +31,7 @@
 #include "card.h"
 #include "endpoint.h"
 #include "pcm.h"
+#include "quirks.h"
 
 #define EP_FLAG_ACTIVATED	0
 #define EP_FLAG_RUNNING		1
@@ -170,6 +171,11 @@ static void retire_inbound_urb(struct sn
 {
 	struct urb *urb = urb_ctx->urb;
 
+	if (unlikely(ep->skip_packets > 0)) {
+		ep->skip_packets--;
+		return;
+	}
+
 	if (ep->sync_slave)
 		snd_usb_handle_sync_urb(ep->sync_slave, ep, urb);
 
@@ -828,6 +834,8 @@ int snd_usb_endpoint_start(struct snd_us
 	ep->unlink_mask = 0;
 	ep->phase = 0;
 
+	snd_usb_endpoint_start_quirk(ep);
+
 	/*
 	 * If this endpoint has a data endpoint as implicit feedback source,
 	 * don't start the urbs here. Instead, mark them all as available,
--- a/sound/usb/helper.c
+++ b/sound/usb/helper.c
@@ -21,6 +21,7 @@
 
 #include "usbaudio.h"
 #include "helper.h"
+#include "quirks.h"
 
 /*
  * combine bytes and get an integer value
@@ -97,6 +98,10 @@ int snd_usb_ctl_msg(struct usb_device *d
 		memcpy(data, buf, size);
 		kfree(buf);
 	}
+
+	snd_usb_ctl_msg_quirk(dev, pipe, request, requesttype,
+			      value, index, data, size);
+
 	return err;
 }
 
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -761,3 +761,27 @@ void snd_usb_set_format_quirk(struct snd
 	}
 }
 
+void snd_usb_endpoint_start_quirk(struct snd_usb_endpoint *ep)
+{
+	/*
+	 * "Playback Design" products send bogus feedback data at the start
+	 * of the stream. Ignore them.
+	 */
+	if ((le16_to_cpu(ep->chip->dev->descriptor.idVendor) == 0x23ba) &&
+	    ep->type == SND_USB_ENDPOINT_TYPE_SYNC)
+		ep->skip_packets = 4;
+}
+
+void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
+			   __u8 request, __u8 requesttype, __u16 value,
+			   __u16 index, void *data, __u16 size)
+{
+	/*
+	 * "Playback Design" products need a 20ms delay after each
+	 * class compliant request
+	 */
+	if ((le16_to_cpu(dev->descriptor.idVendor) == 0x23ba) &&
+	    (requesttype & USB_TYPE_MASK) == USB_TYPE_CLASS)
+		mdelay(20);
+}
+
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -1,6 +1,10 @@
 #ifndef __USBAUDIO_QUIRKS_H
 #define __USBAUDIO_QUIRKS_H
 
+struct audioformat;
+struct snd_usb_endpoint;
+struct snd_usb_substream;
+
 int snd_usb_create_quirk(struct snd_usb_audio *chip,
 			 struct usb_interface *iface,
 			 struct usb_driver *driver,
@@ -20,4 +24,10 @@ void snd_usb_set_format_quirk(struct snd
 int snd_usb_is_big_endian_format(struct snd_usb_audio *chip,
 				 struct audioformat *fp);
 
+void snd_usb_endpoint_start_quirk(struct snd_usb_endpoint *ep);
+
+void snd_usb_ctl_msg_quirk(struct usb_device *dev, unsigned int pipe,
+			   __u8 request, __u8 requesttype, __u16 value,
+			   __u16 index, void *data, __u16 size);
+
 #endif /* __USBAUDIO_QUIRKS_H */


