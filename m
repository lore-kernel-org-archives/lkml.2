Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0KEDJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:09:05 -0400
Received: from mail.perches.com ([173.55.12.10]:4156 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0KEDJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:02 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 35/49] drivers/staging: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:59 -0700
Message-Id: <7c3178cef2ca93da01274d5e6d9b68eacdc83b6a.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/comedi/drivers.c       |    4 +---
 drivers/staging/rtl8192e/r8192E_core.c |    4 +---
 drivers/staging/udlfb/udlfb.c          |    5 ++---
 drivers/staging/xgifb/XGI_main_26.c    |    3 +--
 drivers/staging/zram/zram_drv.c        |    3 +--
 5 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 4a29ed7..ef24a53 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -470,10 +470,8 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		struct page **pages = NULL;
 
 		async->buf_page_list =
-		    vmalloc(sizeof(struct comedi_buf_page) * n_pages);
+		    vzalloc(sizeof(struct comedi_buf_page) * n_pages);
 		if (async->buf_page_list) {
-			memset(async->buf_page_list, 0,
-			       sizeof(struct comedi_buf_page) * n_pages);
 			pages = vmalloc(sizeof(struct page *) * n_pages);
 		}
 		if (pages) {
diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index a202194..c870014 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -2283,9 +2283,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 				IMR_TXFOVW | IMR_BcnInt | IMR_TBDOK | IMR_TBDER);
 
 	priv->AcmControl = 0;
-	priv->pFirmware = (rt_firmware*)vmalloc(sizeof(rt_firmware));
-	if (priv->pFirmware)
-	memset(priv->pFirmware, 0, sizeof(rt_firmware));
+	priv->pFirmware = vzalloc(sizeof(rt_firmware));
 
 	/* rx related queue */
         skb_queue_head_init(&priv->rx_queue);
diff --git a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
index 5969e84..e228329 100644
--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -1163,14 +1163,13 @@ static int dlfb_realloc_framebuffer(struct dlfb_data *dev, struct fb_info *info)
 		 * But with imperfect damage info we may send pixels over USB
 		 * that were, in fact, unchanged - wasting limited USB bandwidth
 		 */
-		new_back = vmalloc(new_len);
+		new_back = vzalloc(new_len);
 		if (!new_back)
-			dl_info("No shadow/backing buffer allcoated\n");
+			dl_info("No shadow/backing buffer allocated\n");
 		else {
 			if (dev->backing_buffer)
 				vfree(dev->backing_buffer);
 			dev->backing_buffer = new_back;
-			memset(dev->backing_buffer, 0, new_len);
 		}
 	}
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 4f73d09..1ebf1a0 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -2178,8 +2178,7 @@ static int XGIfb_heap_init(void)
 
 #ifndef AGPOFF
 	if (XGIfb_queuemode == AGP_CMD_QUEUE) {
-		agp_info = vmalloc(sizeof(*agp_info));
-		memset((void *)agp_info, 0x00, sizeof(*agp_info));
+		agp_info = vzalloc(sizeof(*agp_info));
 		agp_copy_info(agp_info);
 
 		agp_backend_acquire();
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 8c3c057..43fd608 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -533,7 +533,7 @@ int zram_init_device(struct zram *zram)
 	}
 
 	num_pages = zram->disksize >> PAGE_SHIFT;
-	zram->table = vmalloc(num_pages * sizeof(*zram->table));
+	zram->table = vzalloc(num_pages * sizeof(*zram->table));
 	if (!zram->table) {
 		pr_err("Error allocating zram address table\n");
 		/* To prevent accessing table entries during cleanup */
@@ -541,7 +541,6 @@ int zram_init_device(struct zram *zram)
 		ret = -ENOMEM;
 		goto fail;
 	}
-	memset(zram->table, 0, num_pages * sizeof(*zram->table));
 
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 
-- 
1.7.3.1.g432b3.dirty

