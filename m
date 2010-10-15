Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0JOJVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:21:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0JOJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w2o40QxdbXBb+fKWsJ0aNpeNhQ2fKDUJTumwp/Zi1KURsrr4Pp8b3fA5uAiacYNHfe
         OXaK7Kspr6pFmYAwbvWMrRFtGzFP/SZ4CmI6ztEV9iD9QIagg+FDCPI1b1W8pamGP81Z
         ER7ty3Uq/6Qu1dkesuFLKRIjuEhrXkHbMl1aU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000: Use specific error return code for reg_ft1000_netdev(). Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
Date: Fri, 15 Oct 2010 09:41:45 +0200
Message-Id: <1287128505-15739-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    6 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    4 +++-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 999abb6..3e1a6bf 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1112,7 +1112,7 @@ err_net:
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf)
+int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf)
 {
     struct net_device *netdev;
     FT1000_INFO *pInfo;
@@ -1133,7 +1133,7 @@ u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
     {
         DEBUG("reg_ft1000_netdev: could not register network device\n");
         free_netdev(netdev);
-        return STATUS_FAILURE;
+	return rc;
     }
 
 
@@ -1162,7 +1162,7 @@ u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
     pInfo->CardReady = 1;
 
 
-   return STATUS_SUCCESS;
+	return 0;
 }
 
 static int ft1000_reset(struct net_device *dev)
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index a2c415e..5fae954 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -191,7 +191,9 @@ static int ft1000_probe(struct usb_interface *interface,
 
 	DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
 
-	reg_ft1000_netdev(ft1000dev, interface);
+	ret = reg_ft1000_netdev(ft1000dev, interface);
+	if (ret)
+		goto err_load;
 
 	pft1000info->NetDevRegDone = 1;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 27ee304..ee54372 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -634,7 +634,7 @@ char *getfw (char *fn, size_t *pimgsz);
 int dsp_reload(struct ft1000_device *ft1000dev);
 u16 init_ft1000_netdev(struct ft1000_device *ft1000dev);
 struct usb_interface;
-u16 reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
+int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf);
 int ft1000_poll(void* dev_id);
 
 void ft1000InitProc(struct net_device *dev);
-- 
1.7.1

