Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2EYIel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:34:41 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:46269 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754768Ab2EYIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:34:37 -0400
Date: Fri, 25 May 2012 10:28:19 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Subject: [PATCH] mtd: dc21285.c: handle nw_gpio_lock correctly
Message-ID: <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nw_gpio_lock is a raw_spinlock_t, therefore raw_spin_lock_irqsave should be
used. it doesn't make a difference, while rlock is the first element of
spinlock_t.

Also the check for machine_is_netwinder() is a double check of
CONFIG_ARCH_NETWINDER.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/mtd/maps/dc21285.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index 080f060..38fbf23 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -38,9 +38,9 @@ static void nw_en_write(void)
 	 * we want to write a bit pattern XXX1 to Xilinx to enable
 	 * the write gate, which will be open for about the next 2ms.
 	 */
-	spin_lock_irqsave(&nw_gpio_lock, flags);
+	raw_spin_lock_irqsave(&nw_gpio_lock, flags);
 	nw_cpld_modify(CPLD_FLASH_WR_ENABLE, CPLD_FLASH_WR_ENABLE);
-	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+	raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 
 	/*
 	 * let the ISA bus to catch on...
@@ -79,8 +79,7 @@ static void dc21285_copy_from(struct map_info *map, void *to, unsigned long from
 
 static void dc21285_write8(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint8_t*)(map->virt + adr) = d.x[0];
@@ -88,8 +87,7 @@ static void dc21285_write8(struct map_info *map, const map_word d, unsigned long
 
 static void dc21285_write16(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint16_t*)(map->virt + adr) = d.x[0];
@@ -97,8 +95,7 @@ static void dc21285_write16(struct map_info *map, const map_word d, unsigned lon
 
 static void dc21285_write32(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*(uint32_t*)(map->virt + adr) = d.x[0];
 }
 
-- 
1.7.5.4

