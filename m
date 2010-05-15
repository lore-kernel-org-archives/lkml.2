Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0EOVSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:18:48 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41729 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0EOVSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:18:45 -0400
Date: Sat, 15 May 2010 23:18:40 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Huang Shijie <shijie8@gmail.com>, Kang Yong <kangyong@telegent.com>,
       Zhang Xiaobing <xbzhang@telegent.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 18/37] drivers/media/video/tlg2300: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152318160.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/tlg2300/pd-main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -227,12 +227,11 @@ static int firmware_download(struct usb_
 
 	fwlength = fw->size;
 
-	fwbuf = kzalloc(fwlength, GFP_KERNEL);
+	fwbuf = kmemdup(fw->data, fwlength, GFP_KERNEL);
 	if (!fwbuf) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memcpy(fwbuf, fw->data, fwlength);
 
 	max_packet_size = udev->ep_out[0x1]->desc.wMaxPacketSize;
 	log("\t\t download size : %d", (int)max_packet_size);
