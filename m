Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2A0OYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:24:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38756 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2A0OYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:24:44 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc: use string library
Date: Fri, 27 Jan 2012 23:24:48 +0900
Message-Id: <1327674295-3700-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use memchr_inv to check if the data contains all 0xFF bytes.
  It is faster than looping for each byte.

- Use memcmp to compare memory areas

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/powermac/nvram.c |   42 ++++++++++++++-----------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
index 54d2271..da18b26 100644
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -279,7 +279,7 @@ static u32 core99_check(u8* datas)
 
 static int sm_erase_bank(int bank)
 {
-	int stat, i;
+	int stat;
 	unsigned long timeout;
 
 	u8 __iomem *base = (u8 __iomem *)nvram_data + core99_bank*NVRAM_SIZE;
@@ -301,11 +301,10 @@ static int sm_erase_bank(int bank)
 	out_8(base, SM_FLASH_CMD_CLEAR_STATUS);
 	out_8(base, SM_FLASH_CMD_RESET);
 
-	for (i=0; i<NVRAM_SIZE; i++)
-		if (base[i] != 0xff) {
-			printk(KERN_ERR "nvram: Sharp/Micron flash erase failed !\n");
-			return -ENXIO;
-		}
+	if (memchr_inv(base, 0xff, NVRAM_SIZE)) {
+		printk(KERN_ERR "nvram: Sharp/Micron flash erase failed !\n");
+		return -ENXIO;
+	}
 	return 0;
 }
 
@@ -336,17 +335,16 @@ static int sm_write_bank(int bank, u8* datas)
 	}
 	out_8(base, SM_FLASH_CMD_CLEAR_STATUS);
 	out_8(base, SM_FLASH_CMD_RESET);
-	for (i=0; i<NVRAM_SIZE; i++)
-		if (base[i] != datas[i]) {
-			printk(KERN_ERR "nvram: Sharp/Micron flash write failed !\n");
-			return -ENXIO;
-		}
+	if (memcmp(base, datas, NVRAM_SIZE)) {
+		printk(KERN_ERR "nvram: Sharp/Micron flash write failed !\n");
+		return -ENXIO;
+	}
 	return 0;
 }
 
 static int amd_erase_bank(int bank)
 {
-	int i, stat = 0;
+	int stat = 0;
 	unsigned long timeout;
 
 	u8 __iomem *base = (u8 __iomem *)nvram_data + core99_bank*NVRAM_SIZE;
@@ -382,12 +380,11 @@ static int amd_erase_bank(int bank)
 	/* Reset */
 	out_8(base, 0xf0);
 	udelay(1);
-	
-	for (i=0; i<NVRAM_SIZE; i++)
-		if (base[i] != 0xff) {
-			printk(KERN_ERR "nvram: AMD flash erase failed !\n");
-			return -ENXIO;
-		}
+
+	if (memchr_inv(base, 0xff, NVRAM_SIZE)) {
+		printk(KERN_ERR "nvram: AMD flash erase failed !\n");
+		return -ENXIO;
+	}
 	return 0;
 }
 
@@ -429,11 +426,10 @@ static int amd_write_bank(int bank, u8* datas)
 	out_8(base, 0xf0);
 	udelay(1);
 
-	for (i=0; i<NVRAM_SIZE; i++)
-		if (base[i] != datas[i]) {
-			printk(KERN_ERR "nvram: AMD flash write failed !\n");
-			return -ENXIO;
-		}
+	if (memcmp(base, datas, NVRAM_SIZE)) {
+		printk(KERN_ERR "nvram: AMD flash write failed !\n");
+		return -ENXIO;
+	}
 	return 0;
 }
 
-- 
1.7.4.4

