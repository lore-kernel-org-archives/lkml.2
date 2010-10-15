Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0JOHTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:19:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0JOHTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NGUhj4k9vv8EESAxFKGTrtZZg0sETceRD5q+FwZWTLA1AMq2HoQX0lMqPKxcX1SG6b
         DJciKEfOSQsCSl5DKMo5+PP8ytE6V5Z6KZnZwrbiVfR8FzU3o33ihMCh8by7ej5MWMIV
         KzkFdrQxTednNaY0gmYwcUIeMsrVDPOPztM6Y=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/2] staging:ft1000: Use specific return error codes.
Date: Fri, 15 Oct 2010 08:57:25 +0200
Message-Id: <1287125845-12825-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287125845-12825-1-git-send-email-marek.belisko@gmail.com>
References: <1287125845-12825-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   30 ++++++++++++++----------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 8498538..a218455 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -961,7 +961,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     if (!netdev )
     {
         DEBUG("init_ft1000_netdev: can not allocate network device\n");
-        return STATUS_FAILURE;
+	return -ENOMEM;
     }
 
     //pInfo = (PFT1000_INFO)netdev->priv;
@@ -984,8 +984,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 		ret_val = strict_strtoul(card_nr, 10, &gCardIndex);
 		if (ret_val) {
 			printk(KERN_ERR "Can't parse netdev\n");
-			free_netdev(netdev);
-			return STATUS_FAILURE;
+			goto err_net;
 		}
 
             pInfo->CardNumber = gCardIndex;
@@ -993,8 +992,8 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         }
         else {
             printk(KERN_ERR "ft1000: Invalid device name\n");
-	    free_netdev(netdev);
-            return STATUS_FAILURE;
+		ret_val = -ENXIO;
+		goto err_net;
         }
     }
     else
@@ -1065,21 +1064,24 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
             // Get memory for DPRAM_DATA link list
             pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
-	    if (pdpram_blk == NULL)
-		goto err_free;
+		if (pdpram_blk == NULL) {
+			ret_val = -ENOMEM;
+			goto err_free;
+		}
             // Get a block of memory to store command data
             pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
-	    if (pdpram_blk->pbuffer == NULL) {
-		kfree(pdpram_blk);
-		goto err_free;
-	    }
+		if (pdpram_blk->pbuffer == NULL) {
+			ret_val = -ENOMEM;
+			kfree(pdpram_blk);
+			goto err_free;
+		}
             // link provisioning data
             list_add_tail (&pdpram_blk->list, &freercvpool);
         }
         numofmsgbuf = NUM_OF_FREE_BUFFERS;
 
 
-    return STATUS_SUCCESS;
+	return 0;
 
 
 err_free:
@@ -1089,7 +1091,9 @@ err_free:
 		kfree(pdpram_blk->pbuffer);
 		kfree(pdpram_blk);
 	}
-	return STATUS_FAILURE;
+err_net:
+	free_netdev(netdev);
+	return ret_val;
 }
 
 
-- 
1.7.1

