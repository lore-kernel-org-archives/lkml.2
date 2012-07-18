Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab2GRADk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:03:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2GRAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Dillow <dave@thedillows.org>,
        Sri Deevi <srinivasa.deevi@conexant.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 02/37] media: cx231xx: dont DMA to random addresses
Date: Tue, 17 Jul 2012 17:02:39 -0700
Message-Id: <20120717232431.491143399@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dillow <dave@thedillows.org>

commit a7deca6fa79d5c65575532e780f3c93f6bf8ddad upstream.

Commit 7a6f6c29d264cdd2fe0eb3d923217eed5f0ad134 (cx231xx: use
URB_NO_TRANSFER_DMA_MAP) was intended to avoid mapping the DMA buffer
for URB twice. This works for the URBs allocated with usb_alloc_urb(),
as those are allocated from cohernent DMA pools, but the flag was also
added for the VBI and audio URBs, which have a manually allocated area.
This leaves the random trash in the structure after allocation as the
DMA address, corrupting memory and preventing VBI and audio from
working. Letting the USB core map the buffers solves the problem.

Signed-off-by: David Dillow <dave@thedillows.org>
Cc: Sri Deevi <srinivasa.deevi@conexant.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/cx231xx/cx231xx-audio.c |    4 ++--
 drivers/media/video/cx231xx/cx231xx-vbi.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/video/cx231xx/cx231xx-audio.c
+++ b/drivers/media/video/cx231xx/cx231xx-audio.c
@@ -307,7 +307,7 @@ static int cx231xx_init_audio_isoc(struc
 		urb->context = dev;
 		urb->pipe = usb_rcvisocpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = URB_ISO_ASAP;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->interval = 1;
 		urb->complete = cx231xx_audio_isocirq;
@@ -368,7 +368,7 @@ static int cx231xx_init_audio_bulk(struc
 		urb->context = dev;
 		urb->pipe = usb_rcvbulkpipe(dev->udev,
 						dev->adev.end_point_addr);
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = 0;
 		urb->transfer_buffer = dev->adev.transfer_buffer[i];
 		urb->complete = cx231xx_audio_bulkirq;
 		urb->transfer_buffer_length = sb_size;
--- a/drivers/media/video/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/video/cx231xx/cx231xx-vbi.c
@@ -452,7 +452,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx
 			return -ENOMEM;
 		}
 		dev->vbi_mode.bulk_ctl.urb[i] = urb;
-		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
+		urb->transfer_flags = 0;
 
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);


