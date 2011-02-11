Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1BKJyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:54:46 -0500
Received: from t111.niisi.ras.ru ([193.232.173.111]:59086 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1BKJyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:54:44 -0500
From: Antony Pavlov <antony@niisi.msk.ru>
To: dwmw2@infradead.org
Cc: w.sang@pengutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antony@niisi.msk.ru>
Subject: [PATCH] mtd: jedec_probe: initialise make sector erase command variable
Date: Fri, 11 Feb 2011 13:00:37 +0300
Message-Id: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
X-Mailer: git-send-email 1.7.1
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the commit 08968041bef437ec363623cd3218c2b083537ada
 (mtd: cfi_cmdset_0002: make sector erase command variable)
introdused a field sector_erase_cmd. In the same commit initialisation
of cfi->sector_erase_cmd made in cfi_chip_setup()
(file drivers/mtd/chips/cfi_probe.c), so the CFI chip has no problem:

...
        cfi->cfi_mode = CFI_MODE_CFI;
        cfi->sector_erase_cmd = CMD(0x30);
...

But for the JEDEC chips this initialisation is not carried out,
so the JEDEC chips have sector_erase_cmd == 0.

It's not possible symply add the line
        p_cfi->sector_erase_cmd = CMD(0x30);
to the cfi_jedec_setup() function be cause CMD() macros needs
map and cfi variables. So this patch makes necessary changes.

Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
---
 drivers/mtd/chips/jedec_probe.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index d72a5fb..4e1be51 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1935,14 +1935,14 @@ static void jedec_reset(u32 base, struct map_info *map, struct cfi_private *cfi)
 }
 
 
-static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
+static int cfi_jedec_setup(struct map_info *map, struct cfi_private *cfi, int index)
 {
 	int i,num_erase_regions;
 	uint8_t uaddr;
 
-	if (! (jedec_table[index].devtypes & p_cfi->device_type)) {
+	if (!(jedec_table[index].devtypes & cfi->device_type)) {
 		DEBUG(MTD_DEBUG_LEVEL1, "Rejecting potential %s with incompatible %d-bit device type\n",
-		      jedec_table[index].name, 4 * (1<<p_cfi->device_type));
+		      jedec_table[index].name, 4 * (1<<cfi->device_type));
 		return 0;
 	}
 
@@ -1950,27 +1950,28 @@ static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
 
 	num_erase_regions = jedec_table[index].nr_regions;
 
-	p_cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
-	if (!p_cfi->cfiq) {
+	cfi->cfiq = kmalloc(sizeof(struct cfi_ident) + num_erase_regions * 4, GFP_KERNEL);
+	if (!cfi->cfiq) {
 		//xx printk(KERN_WARNING "%s: kmalloc failed for CFI ident structure\n", map->name);
 		return 0;
 	}
 
-	memset(p_cfi->cfiq,0,sizeof(struct cfi_ident));
+	memset(cfi->cfiq, 0, sizeof(struct cfi_ident));
 
-	p_cfi->cfiq->P_ID = jedec_table[index].cmd_set;
-	p_cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
-	p_cfi->cfiq->DevSize = jedec_table[index].dev_size;
-	p_cfi->cfi_mode = CFI_MODE_JEDEC;
+	cfi->cfiq->P_ID = jedec_table[index].cmd_set;
+	cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
+	cfi->cfiq->DevSize = jedec_table[index].dev_size;
+	cfi->cfi_mode = CFI_MODE_JEDEC;
+	cfi->sector_erase_cmd = CMD(0x30);
 
 	for (i=0; i<num_erase_regions; i++){
-		p_cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
+		cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
 	}
-	p_cfi->cmdset_priv = NULL;
+	cfi->cmdset_priv = NULL;
 
 	/* This may be redundant for some cases, but it doesn't hurt */
-	p_cfi->mfr = jedec_table[index].mfr_id;
-	p_cfi->id = jedec_table[index].dev_id;
+	cfi->mfr = jedec_table[index].mfr_id;
+	cfi->id = jedec_table[index].dev_id;
 
 	uaddr = jedec_table[index].uaddr;
 
@@ -1978,8 +1979,8 @@ static int cfi_jedec_setup(struct cfi_private *p_cfi, int index)
 	   our brains explode when we see the datasheets talking about address
 	   lines numbered from A-1 to A18. The CFI table has unlock addresses
 	   in device-words according to the mode the device is connected in */
-	p_cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / p_cfi->device_type;
-	p_cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / p_cfi->device_type;
+	cfi->addr_unlock1 = unlock_addrs[uaddr].addr1 / cfi->device_type;
+	cfi->addr_unlock2 = unlock_addrs[uaddr].addr2 / cfi->device_type;
 
 	return 1;	/* ok */
 }
@@ -2175,7 +2176,7 @@ static int jedec_probe_chip(struct map_info *map, __u32 base,
 				       "MTD %s(): matched device 0x%x,0x%x unlock_addrs: 0x%.4x 0x%.4x\n",
 				       __func__, cfi->mfr, cfi->id,
 				       cfi->addr_unlock1, cfi->addr_unlock2 );
-				if (!cfi_jedec_setup(cfi, i))
+				if (!cfi_jedec_setup(map, cfi, i))
 					return 0;
 				goto ok_out;
 			}
-- 
1.7.1

