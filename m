Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0KNXY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 18:24:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0KNXY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 18:24:27 -0500
Date: Sun, 14 Nov 2010 16:25:02 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH, RFC] usbmon: correct computing of the ISO packets with
 mmap
Message-ID: <20101114162502.6d6318e7@lembas.zaitcev.lan>
In-Reply-To: <4CE0458E.9070900@freemail.hu>
References: <4CD8ECE4.1090206@freemail.hu>
	<20101109075056.59a2e7d8@lembas.zaitcev.lan>
	<4CD9A96D.1010306@freemail.hu>
	<4CDF0DF4.4020405@freemail.hu>
	<20101114124035.6a0c9b80@lembas.zaitcev.lan>
	<4CE0458E.9070900@freemail.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Nov 2010 21:24:46 +0100
Németh Márton <nm127@freemail.hu> wrote:

> Sure, I'm happy as long as I can capture the whole data content of the ISO
> packets.

Great. So, what do you think about the attached? It differs from your
code in one important aspect: output buffer sizes are not adjusted.
Your patch attempts that, but uses actual_length, which is not
defined during submission events. So I skipped that.

-- Pete

diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 44cb37b..15c5e46 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -437,6 +437,28 @@ static unsigned int mon_bin_get_data(const struct mon_reader_bin *rp,
 	return length;
 }
 
+/*
+ * This is the look-ahead pass in case of 'Ci', when actual_length cannot
+ * be used to determine the length of the whole contiguous buffer.
+ */
+static unsigned int mon_bin_collate_isodesc(const struct mon_reader_bin *rp,
+    struct urb *urb, unsigned int ndesc)
+{
+	struct usb_iso_packet_descriptor *fp;
+	unsigned int length;
+
+	length = 0;
+	fp = urb->iso_frame_desc;
+	while (ndesc-- != 0) {
+		if (fp->status == 0 && fp->actual_length != 0) {
+			if (fp->offset + fp->actual_length > length)
+				length = fp->offset + fp->actual_length;
+		}
+		fp++;
+	}
+	return length;
+}
+
 static void mon_bin_get_isodesc(const struct mon_reader_bin *rp,
     unsigned int offset, struct urb *urb, char ev_type, unsigned int ndesc)
 {
@@ -479,6 +501,10 @@ static void mon_bin_event(struct mon_reader_bin *rp, struct urb *urb,
 	/*
 	 * Find the maximum allowable length, then allocate space.
 	 */
+	urb_length = (ev_type == 'S') ?
+	    urb->transfer_buffer_length : urb->actual_length;
+	length = urb_length;
+
 	if (usb_endpoint_xfer_isoc(epd)) {
 		if (urb->number_of_packets < 0) {
 			ndesc = 0;
@@ -487,14 +513,16 @@ static void mon_bin_event(struct mon_reader_bin *rp, struct urb *urb,
 		} else {
 			ndesc = urb->number_of_packets;
 		}
+		if (ev_type == 'C' && usb_urb_dir_in(urb))
+			length = mon_bin_collate_isodesc(rp, urb, ndesc);
 	} else {
 		ndesc = 0;
 	}
 	lendesc = ndesc*sizeof(struct mon_bin_isodesc);
 
-	urb_length = (ev_type == 'S') ?
-	    urb->transfer_buffer_length : urb->actual_length;
-	length = urb_length;
+	/* not an issue unless there's a subtle bug in a HCD somewhere */
+	if (length >= urb->transfer_buffer_length)
+		length = urb->transfer_buffer_length;
 
 	if (length >= rp->b_size/5)
 		length = rp->b_size/5;
