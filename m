Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0EOVR2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:17:28 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46709 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab0EOVRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:17:24 -0400
Date: Sat, 15 May 2010 23:17:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jouni Malinen <jmalinen@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 14/37] drivers/net/wireless/ath/ath9k: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152316580.21345@ask.diku.dk>
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
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -901,12 +901,10 @@ static void ath9k_hif_usb_reboot(struct 
 	void *buf;
 	int ret;
 
-	buf = kmalloc(4, GFP_KERNEL);
+	buf = kmemdup(&reboot_cmd, 4, GFP_KERNEL);
 	if (!buf)
 		return;
 
-	memcpy(buf, &reboot_cmd, 4);
-
 	ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
 			   buf, 4, NULL, HZ);
 	if (ret)
