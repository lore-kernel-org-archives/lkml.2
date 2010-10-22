Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab0JVTUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:20:08 -0400
Received: from kroah.org ([198.145.64.141]:34001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759252Ab0JVS4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:06 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:29 2010
Message-Id: <20101022185229.391234662@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jason77.wang@gmail.com>,
        =?ISO-8859-15?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [023/103] V4L/DVB: gspca - main: Fix a crash of some webcams on ARM arch
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wang <jason77.wang@gmail.com>

commit 882787ff8fdeb0be790547ee9b22b281095e95da upstream.

When plugging some webcams on ARM, the system crashes.
This is because we alloc buffer for an urb through usb_buffer_alloc,
the alloced buffer is already in DMA coherent region, so we should
set the flag of this urb to URB_NO_TRANSFER_DMA_MAP, otherwise when
we submit this urb, the hcd core will handle this address as an
non-DMA address and call dma_map_single/sg to map it. On arm
architecture, dma_map_single a DMA coherent address will be catched
by a BUG_ON().

Signed-off-by: Jason Wang <jason77.wang@gmail.com>
Signed-off-by: Jean-François Moine <moinejf@free.fr>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/gspca/gspca.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -223,6 +223,7 @@ static int alloc_and_submit_int_urb(stru
 		usb_rcvintpipe(dev, ep->bEndpointAddress),
 		buffer, buffer_len,
 		int_irq, (void *)gspca_dev, interval);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	gspca_dev->int_urb = urb;
 	ret = usb_submit_urb(urb, GFP_KERNEL);
 	if (ret < 0) {


