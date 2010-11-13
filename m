Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0KMWP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:15:26 -0500
Received: from relay02.digicable.hu ([92.249.128.188]:59918 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0KMWPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:15:23 -0500
Message-ID: <4CDF0DF4.4020405@freemail.hu>
Date: Sat, 13 Nov 2010 23:15:16 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Pete Zaitcev <zaitcev@redhat.com>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH, RFC] usbmon: correct computing of the ISO packets with mmap
References: <4CD8ECE4.1090206@freemail.hu> <20101109075056.59a2e7d8@lembas.zaitcev.lan> <4CD9A96D.1010306@freemail.hu>
In-Reply-To: <4CD9A96D.1010306@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The length of the isochronous packets were not computed correctly in case of memory
mapped operation because the gaps between the isodesc data were not taken into
account. The last data byte can be found at offset+actual_length of the
last ISO description.

This patch fixes the problem described at https://bugzilla.kernel.org/show_bug.cgi?id=22182 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.37-rc1/drivers/usb/mon/mon_bin.c.orig	2010-10-20 22:30:22.000000000 +0200
+++ linux-2.6.37-rc1/drivers/usb/mon/mon_bin.c	2010-11-13 22:29:09.000000000 +0100
@@ -515,6 +515,26 @@ static void mon_bin_event(struct mon_rea
 	}

 	if (rp->mmap_active) {
+		if (usb_endpoint_xfer_isoc(epd) &&
+		    ((usb_urb_dir_in(urb) && ev_type == 'C') ||
+		     (usb_urb_dir_out(urb) && ev_type == 'S'))) {
+			int i;
+
+			/* Search for the last ISO descritor with OK status
+			 * and non-zero length
+			 */
+			length = 0;
+			i = urb->number_of_packets - 1;
+			while (0 <= i &&
+			       (urb->iso_frame_desc[i].status != 0 ||
+			        urb->iso_frame_desc[i].actual_length == 0)) {
+				i--;
+			}
+			if (0 <= i) {
+				length = urb->iso_frame_desc[i].offset +
+					 urb->iso_frame_desc[i].actual_length;
+			}
+		}
 		offset = mon_buff_area_alloc_contiguous(rp,
 						 length + PKT_SIZE + lendesc);
 	} else {

