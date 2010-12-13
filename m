Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940Ab0LMJhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:37:03 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:59042 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab0LMJhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=RRvXzknMT9mUO7dEOphpyilIZDODKxS1totiC3dFQ7ja1mF80vHrRpieSbbIAppEWK
         MEhj9xgJslEBiktlJ2QIvJ1LIDDeDahYRggc24vU7rHfH2A5eXpDiXILJP8+adXHvQHY
         6+KlUOvF+zxG15OxOZR95Lb9sZZpgdLjBPuPg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000: Always extract device number from netdev name.
Date: Mon, 13 Dec 2010 10:39:20 +0100
Message-Id: <1292233160-2687-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using gCardIndex as global variable was not correctly used because
for every plugged device was set to 0 in init_ft1000_netdev.

Remove global definition. Use it locally and for every plugged
device extract number from net device name.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   14 +-------------
 1 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 7456787..643a637 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -41,7 +41,6 @@ static int ft1000_chkcard (struct ft1000_device *dev);
 //Jim
 
 static u8 tempbuffer[1600];
-static unsigned long gCardIndex;
 
 #define MAX_RCV_LOOP   100
 
@@ -773,8 +772,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	int i, ret_val;
 	struct list_head *cur, *tmp;
 	char card_nr[2];
-
-	gCardIndex=0; //mbelian
+	unsigned long gCardIndex = 0;
 
     DEBUG("Enter init_ft1000_netdev...\n");
 
@@ -794,9 +792,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 
     dev_alloc_name(netdev, netdev->name);
 
-    //for the first inserted card, decide the card index beginning number, in case there are existing network interfaces
-    if ( gCardIndex == 0 )
-    {
         DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
 
 	if ( strncmp(netdev->name,"eth", 3) == 0) {
@@ -816,13 +811,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 		ret_val = -ENXIO;
 		goto err_net;
         }
-    }
-    else
-    {
-        //not the first inserted card, increase card number by 1
-        pInfo->CardNumber = gCardIndex;
-        /*DEBUG("card number = %d\n", pInfo->CardNumber);*/ //mbelian
-    }
 
     memset(&pInfo->stats, 0, sizeof(struct net_device_stats) );
 
-- 
1.7.1

