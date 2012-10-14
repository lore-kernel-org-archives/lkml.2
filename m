Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2JNO5C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:57:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46532 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932212Ab2JNOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:29 -0400
Message-Id: <20121014143544.225421762@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Shiyan <shc_work@mail.ru>, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 077/147] mtd: autcpu12-nvram: Fix compile breakage
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <shc_work@mail.ru>

commit d1f55c680e5d021e7066f4461dd678d42af18898 upstream.

Update driver autcpu12-nvram.c so it compiles; map_read32/map_write32
no longer exist in the kernel so the driver is totally broken.
Additionally, map_info name passed to simple_map_init is incorrect.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/maps/autcpu12-nvram.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index e5bfd0e..0598d52 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -43,7 +43,8 @@ struct map_info autcpu12_sram_map = {
 
 static int __init init_autcpu12_sram (void)
 {
-	int err, save0, save1;
+	map_word tmp, save0, save1;
+	int err;
 
 	autcpu12_sram_map.virt = ioremap(0x12000000, SZ_128K);
 	if (!autcpu12_sram_map.virt) {
@@ -51,7 +52,7 @@ static int __init init_autcpu12_sram (void)
 		err = -EIO;
 		goto out;
 	}
-	simple_map_init(&autcpu_sram_map);
+	simple_map_init(&autcpu12_sram_map);
 
 	/*
 	 * Check for 32K/128K
@@ -61,20 +62,22 @@ static int __init init_autcpu12_sram (void)
 	 * Read	and check result on ofs 0x0
 	 * Restore contents
 	 */
-	save0 = map_read32(&autcpu12_sram_map,0);
-	save1 = map_read32(&autcpu12_sram_map,0x10000);
-	map_write32(&autcpu12_sram_map,~save0,0x10000);
+	save0 = map_read(&autcpu12_sram_map, 0);
+	save1 = map_read(&autcpu12_sram_map, 0x10000);
+	tmp.x[0] = ~save0.x[0];
+	map_write(&autcpu12_sram_map, tmp, 0x10000);
 	/* if we find this pattern on 0x0, we have 32K size
 	 * restore contents and exit
 	 */
-	if ( map_read32(&autcpu12_sram_map,0) != save0) {
-		map_write32(&autcpu12_sram_map,save0,0x0);
+	tmp = map_read(&autcpu12_sram_map, 0);
+	if (!map_word_equal(&autcpu12_sram_map, tmp, save0)) {
+		map_write(&autcpu12_sram_map, save0, 0x0);
 		goto map;
 	}
 	/* We have a 128K found, restore 0x10000 and set size
 	 * to 128K
 	 */
-	map_write32(&autcpu12_sram_map,save1,0x10000);
+	map_write(&autcpu12_sram_map, save1, 0x10000);
 	autcpu12_sram_map.size = SZ_128K;
 
 map:


