Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0IZJAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:00:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0IZI77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Wks2ZNZSX5wz4L8AmV9tpeVGs2rTLgU77vRMnyzRI3iPdV+1TfiLdwJxwQClD90WeI
         funoOI2k+K1OdYIp4DIJnX6U0LEC2K+LTybMjcJKT4TqkLodiNuwYSDP9FZPSZaY8tgG
         bre4K/YHbM1qHmUZU5ckjcptreDURfBNNVlVg=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ft1000: fix error path
Date: Sun, 26 Sep 2010 12:59:55 +0400
Message-Id: <1285491595-377-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_ft1000_netdev() calls kfree(netdev) instead of free_netdev(netdev).
It doesn't check kmalloc() return value.
ft1000_read_fifo_reg() doesn't free dr on error and calls kfree(urb)
instead of usb_free_urb(urb).  Also kfree(NULL) is OK.
---
 Compile tested.

 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 51ed0dd..3130843 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1048,7 +1048,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         }
         else {
             printk(KERN_ERR "ft1000: Invalid device name\n");
-            kfree(netdev);
+            free_netdev(netdev);
             return STATUS_FAILURE;
         }
     }
@@ -1121,8 +1121,14 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
             // Get memory for DPRAM_DATA link list
             pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
+	    if (pdpram_blk == NULL)
+	        goto err_free;
             // Get a block of memory to store command data
             pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
+	    if (pdpram_blk->pbuffer == NULL) {
+		kfree(pdpram_blk);
+		goto err_free;
+	    }
             // link provisioning data
             list_add_tail (&pdpram_blk->list, &freercvpool);
         }
@@ -1131,6 +1137,13 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 
     return STATUS_SUCCESS;
 
+
+err_free:
+	for (i--; i>=0; i--) {
+		kfree(pdpram_blk->pbuffer);
+		kfree(pdpram_blk);
+	}
+	return STATUS_FAILURE;
 }
 
 
@@ -1287,7 +1300,8 @@ static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pip
 
     if(!urb || !dr)
     {
-        if(urb) kfree(urb);
+	kfree(dr);
+	usb_free_urb(urb);
         spin_unlock(&ft1000dev->device_lock);
         return -ENOMEM;
     }
-- 
1.7.0.4

