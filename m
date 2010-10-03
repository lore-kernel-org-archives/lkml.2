Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0JCR6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:58:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40452 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0JCR6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KmlV2E2dLCQyxjlgWkPsTbJrgBUTf1oezL7oD6r7/9vXfqIPsMObszTvqJ2pjL1bhd
         5/+shVGPxFtNE6elgpSKtXjokLHsw8eLF6EvZtgj3blRrLGFz+8OwAqznZe84QPN6bWP
         WL4i8vdcV9++cDSEwH6I1B6zE+2tMqa2+5KBM=
Date: Sun, 3 Oct 2010 21:58:46 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: ft1000: fix error path
Message-ID: <20101003175845.GA24834@albatros>
References: <1285491595-377-1-git-send-email-segooon@gmail.com>
 <20100926131151.GC6134@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100926131151.GC6134@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_ft1000_netdev() calls kfree(netdev) instead of free_netdev(netdev).
It doesn't check kmalloc() return value.
ft1000_read_fifo_reg() doesn't free dr on error and calls kfree(urb)
instead of usb_free_urb(urb).  Also kfree(NULL) is OK.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 51ed0dd..8609add 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1013,6 +1013,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     FT1000_INFO *pInfo = NULL;
     PDPRAM_BLK pdpram_blk;
     int i;
+	struct list_head *cur, *tmp;
 
 	gCardIndex=0; //mbelian
 
@@ -1048,7 +1049,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         }
         else {
             printk(KERN_ERR "ft1000: Invalid device name\n");
-            kfree(netdev);
+	    free_netdev(netdev);
             return STATUS_FAILURE;
         }
     }
@@ -1121,8 +1122,14 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
         for (i=0; i<NUM_OF_FREE_BUFFERS; i++) {
             // Get memory for DPRAM_DATA link list
             pdpram_blk = kmalloc ( sizeof(DPRAM_BLK), GFP_KERNEL );
+	    if (pdpram_blk == NULL)
+		goto err_free;
             // Get a block of memory to store command data
             pdpram_blk->pbuffer = kmalloc ( MAX_CMD_SQSIZE, GFP_KERNEL );
+	    if (pdpram_blk->pbuffer == NULL) {
+		kfree(pdpram_blk);
+		goto err_free;
+	    }
             // link provisioning data
             list_add_tail (&pdpram_blk->list, &freercvpool);
         }
@@ -1131,6 +1138,15 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 
     return STATUS_SUCCESS;
 
+
+err_free:
+	list_for_each_safe(cur, tmp, &pdpram_blk->list) {
+		pdpram_blk = list_entry(cur, DPRAM_BLK, list);
+		list_del(&pdpram_blk->list);
+		kfree(pdpram_blk->pbuffer);
+		kfree(pdpram_blk);
+	}
+	return STATUS_FAILURE;
 }
 
 
@@ -1287,7 +1303,8 @@ static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pip
 
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
