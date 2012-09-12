Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2IMA2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:28:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2ILXeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Mack <zonque@gmail.com>,
        "Robert M. Albrecht" <linux@romal.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 077/108] ALSA: snd-usb: fix cross-interface streaming devices
Date: Wed, 12 Sep 2012 16:29:15 -0700
Message-Id: <20120912232458.579694714@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 2e4a263ca80a203ac6109f5932722a716c265395 upstream.

Commit 68e67f40b ("ALSA: snd-usb: move calls to usb_set_interface")
saved us some unnecessary calls to snd_usb_set_interface() but ignored
the fact that there is at least one device out there which operates on
two endpoint in different interfaces simultaniously.

Take care for this by catching the case where data and sync endpoints
are located on different interfaces and calling snd_usb_set_interface()
between the start of the two endpoints.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-by: Robert M. Albrecht <linux@romal.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -236,6 +236,21 @@ static int start_endpoints(struct snd_us
 	    !test_and_set_bit(SUBSTREAM_FLAG_SYNC_EP_STARTED, &subs->flags)) {
 		struct snd_usb_endpoint *ep = subs->sync_endpoint;
 
+		if (subs->data_endpoint->iface != subs->sync_endpoint->iface ||
+		    subs->data_endpoint->alt_idx != subs->sync_endpoint->alt_idx) {
+			err = usb_set_interface(subs->dev,
+						subs->sync_endpoint->iface,
+						subs->sync_endpoint->alt_idx);
+			if (err < 0) {
+				snd_printk(KERN_ERR
+					   "%d:%d:%d: cannot set interface (%d)\n",
+					   subs->dev->devnum,
+					   subs->sync_endpoint->iface,
+					   subs->sync_endpoint->alt_idx, err);
+				return -EIO;
+			}
+		}
+
 		snd_printdd(KERN_DEBUG "Starting sync EP @%p\n", ep);
 
 		ep->sync_slave = subs->data_endpoint;


