Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0EOVX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:23:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35479 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465Ab0EOVXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:23:20 -0400
Date: Sat, 15 May 2010 23:23:15 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 33/37] drivers/net/usb: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152322560.21345@ask.diku.dk>
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
 drivers/net/usb/dm9601.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -93,10 +93,9 @@ static int dm_write(struct usbnet *dev, 
 	netdev_dbg(dev->net, "dm_write() reg=0x%02x, length=%d\n", reg, length);
 
 	if (data) {
-		buf = kmalloc(length, GFP_KERNEL);
+		buf = kmemdup(data, length, GFP_KERNEL);
 		if (!buf)
 			goto out;
-		memcpy(buf, data, length);
 	}
 
 	err = usb_control_msg(dev->udev,
