Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079Ab2JKAUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:20:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43603 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932989Ab2JKAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:16:35 -0400
X-Sasl-enc: n9ANFM0e6JP6xfHmFMyHOkWp4NCKSzpC4PkJtJ45pds0 1349914593
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexander Shiyan <shc_work@mail.ru>, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 123/133] mtd: autcpu12-nvram: Fix compile breakage
Date: Thu, 11 Oct 2012 07:52:29 +0900
Message-Id: <20121010224916.686047112@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/maps/autcpu12-nvram.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

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
@@ -51,7 +52,7 @@ static int __init init_autcpu12_sram (vo
 		err = -EIO;
 		goto out;
 	}
-	simple_map_init(&autcpu_sram_map);
+	simple_map_init(&autcpu12_sram_map);
 
 	/*
 	 * Check for 32K/128K
@@ -61,20 +62,22 @@ static int __init init_autcpu12_sram (vo
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


