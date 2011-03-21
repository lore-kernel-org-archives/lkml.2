Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1CUXy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:54:57 -0400
Received: from kroah.org ([198.145.64.141]:49203 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1CUXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:09 2011
Message-Id: <20110321230709.478565584@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antony Pavlov <antony@niisi.msk.ru>,
        Guillaume LECERF <glecerf@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [03/87] mtd: jedec_probe: initialise make sector erase command variable
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Antony Pavlov <antony@niisi.msk.ru>

commit ceabebb2bd2672f709e4454e16bc6042732e2dfe upstream.

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

This patch adds the missing initialisation.

Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
Acked-by: Guillaume LECERF <glecerf@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/chips/jedec_probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1935,7 +1935,7 @@ static void jedec_reset(u32 base, struct
 }
 
 
-static int cfi_jedec_setup(struct cfi_private *cfi, int index)
+static int cfi_jedec_setup(struct map_info *map, struct cfi_private *cfi, int index)
 {
 	int i,num_erase_regions;
 	uint8_t uaddr;
@@ -1962,6 +1962,7 @@ static int cfi_jedec_setup(struct cfi_pr
 	cfi->cfiq->NumEraseRegions = jedec_table[index].nr_regions;
 	cfi->cfiq->DevSize = jedec_table[index].dev_size;
 	cfi->cfi_mode = CFI_MODE_JEDEC;
+	cfi->sector_erase_cmd = CMD(0x30);
 
 	for (i=0; i<num_erase_regions; i++){
 		cfi->cfiq->EraseRegionInfo[i] = jedec_table[index].regions[i];
@@ -2175,7 +2176,7 @@ static int jedec_probe_chip(struct map_i
 				       "MTD %s(): matched device 0x%x,0x%x unlock_addrs: 0x%.4x 0x%.4x\n",
 				       __func__, cfi->mfr, cfi->id,
 				       cfi->addr_unlock1, cfi->addr_unlock2 );
-				if (!cfi_jedec_setup(cfi, i))
+				if (!cfi_jedec_setup(map, cfi, i))
 					return 0;
 				goto ok_out;
 			}


