Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0JNOye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:54:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0JNOyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qast6FIAIsuYLsOqeLz2dHAU5OyQekSSD8Ol9KA+L7Fvq0DKZI5fiw7iK2VTcPIBF4
         aNEEPgtMl0Qi8yKUxPgO19gZZbgZz9NK2xAN2ertVHBv0O3XmtWzm3IM2WxzzqCj1v+P
         VNh2zYcMrQQZVHAkESoIvKt5zB7SP6OZeYg5Q=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000:Get rid of using atoi.
Date: Thu, 14 Oct 2010 14:14:33 +0200
Message-Id: <1287058473-15285-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   36 +++++++++----------------
 1 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 507a248..8498538 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -55,28 +55,10 @@ static const struct net_device_ops ft1000net_ops = {
 //Jim
 
 static u8 tempbuffer[1600];
-static int gCardIndex;
+static unsigned long gCardIndex;
 
 #define MAX_RCV_LOOP   100
 
-
-static int atoi(const char *s)
-{
-        int k = 0;
-    int cnt;
-
-        k = 0;
-    cnt = 0;
-        while (*s != '\0' && *s >= '0' && *s <= '9') {
-                k = 10 * k + (*s - '0');
-                s++;
-        // Let's put a limit on this while loop to avoid deadlock scenario
-        if (cnt > 100)
-           break;
-        cnt++;
-        }
-        return k;
-}
 /****************************************************************
  *     ft1000_control_complete
  ****************************************************************/
@@ -966,8 +948,9 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     struct net_device *netdev;
     FT1000_INFO *pInfo = NULL;
     PDPRAM_BLK pdpram_blk;
-    int i;
+	int i, ret_val;
 	struct list_head *cur, *tmp;
+	char card_nr[2];
 
 	gCardIndex=0; //mbelian
 
@@ -995,9 +978,16 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     {
         DEBUG("init_ft1000_netdev: network device name is %s\n", netdev->name);
 
-        if ( strncmp(netdev->name,"eth", 3) == 0) {
-            //pInfo->CardNumber = atoi(&netdev->name[3]);
-            gCardIndex = atoi(&netdev->name[3]);
+	if ( strncmp(netdev->name,"eth", 3) == 0) {
+		card_nr[0] = netdev->name[3];
+		card_nr[1] = '\0';
+		ret_val = strict_strtoul(card_nr, 10, &gCardIndex);
+		if (ret_val) {
+			printk(KERN_ERR "Can't parse netdev\n");
+			free_netdev(netdev);
+			return STATUS_FAILURE;
+		}
+
             pInfo->CardNumber = gCardIndex;
             DEBUG("card number = %d\n", pInfo->CardNumber);
         }
-- 
1.7.1

