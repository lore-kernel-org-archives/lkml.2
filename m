Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0KBNuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:50:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0KBNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nEi6XsO5PfZBHzT+NTzjr6YNvl3KKPCRThJRUh0evm7dnuy0k+TZXppJBIO1Z2CtIk
         lBvPfpI8YzMKWbkSBaGt15dA/LZnQiF6QyJnail7C1nSSvcgaS6F7fxq+n3Ck11AVIN9
         Z9ZLzV0Jy1MwxCTEa7nnRxvuu62r30Kuhr9tU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/4] staging: ft1000: Use common return point.
Date: Tue,  2 Nov 2010 14:51:45 +0100
Message-Id: <1288705907-30725-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
References: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 9bb5377..0de4a2e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1121,14 +1121,13 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
     if ( skb == NULL )
     {
         DEBUG ("ft1000_hw: ft1000_start_xmit:skb == NULL!!!\n" );
-        return STATUS_FAILURE;
+	return NETDEV_TX_OK;
     }
 
     if ( pFt1000Dev->status & FT1000_STATUS_CLOSING)
     {
         DEBUG("network driver is closed, return\n");
-        dev_kfree_skb(skb);
-        return STATUS_SUCCESS;
+	goto err;
     }
 
     //DEBUG("ft1000_start_xmit 1:length of packet = %d\n", skb->len);
@@ -1147,28 +1146,24 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
     {
         /* Drop packet is mediastate is down */
         DEBUG("ft1000_hw:ft1000_start_xmit:mediastate is down\n");
-        dev_kfree_skb(skb);
-        return STATUS_SUCCESS;
+	goto err;
     }
 
     if ( (skb->len < ENET_HEADER_SIZE) || (skb->len > ENET_MAX_SIZE) )
     {
         /* Drop packet which has invalid size */
         DEBUG("ft1000_hw:ft1000_start_xmit:invalid ethernet length\n");
-        dev_kfree_skb(skb);
-        return STATUS_SUCCESS;
+	goto err;
     }
 //mbelian
-    if(ft1000_copy_down_pkt (dev, (pdata+ENET_HEADER_SIZE-2), skb->len - ENET_HEADER_SIZE + 2) == STATUS_FAILURE)
-	{
-    	dev_kfree_skb(skb);
-		return STATUS_SUCCESS;
-	}
+	ft1000_copy_down_pkt(dev, (pdata+ENET_HEADER_SIZE-2),
+				skb->len - ENET_HEADER_SIZE + 2);
 
-    dev_kfree_skb(skb);
+err:
+	dev_kfree_skb(skb);
     //DEBUG(" ft1000_start_xmit() exit\n");
 
-    return 0;
+	return NETDEV_TX_OK;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

