Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162205Ab1FAJAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:00:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:44118 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162139Ab1FAIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:56 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:08 2011
Message-Id: <20110601081107.806560787@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:02 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kishore Kadiyala <kishore.kadiyala@ti.com>,
        Vimal Singh <vimal.newwork@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [032/165] mtd: omap: fix subpage ecc issue with prefetch
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2505
Lines: 68

From: Kishore Kadiyala <kishore.kadiyala@ti.com>

commit c5d8c0cae4af7d78823d32fcd1c458ee1a1b5489 upstream.

When reading/writing a subpage (When HW ECC is not available/enabled)
for number of bytes not aligned to 4, the mis-aligned bytes are handled
first (by cpu copy method) before enabling the Prefetch engine to/from
'p'(start of buffer 'buf'). Then it reads/writes rest of the bytes with
the help of Prefetch engine, if available, or again using cpu copy method.
Currently, reading/writing of rest of bytes, is not done correctly since
its trying to read/write again to/from begining of buffer 'buf',
overwriting the mis-aligned bytes.

Read & write using prefetch engine got broken in commit '2c01946c'.
We never hit a scenario of not getting 'gpmc_prefetch_enable' call
success. So, problem did not get caught up.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Vimal Singh <vimal.newwork@gmail.com>
Reported-by: Bryan DE FARIA <bdefaria@adeneo-embedded.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/nand/omap2.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -263,11 +263,10 @@ static void omap_read_buf_pref(struct mt
 	if (ret) {
 		/* PFPW engine is busy, use cpu copy method */
 		if (info->nand.options & NAND_BUSWIDTH_16)
-			omap_read_buf16(mtd, buf, len);
+			omap_read_buf16(mtd, (u_char *)p, len);
 		else
-			omap_read_buf8(mtd, buf, len);
+			omap_read_buf8(mtd, (u_char *)p, len);
 	} else {
-		p = (u32 *) buf;
 		do {
 			r_count = gpmc_read_status(GPMC_PREFETCH_FIFO_CNT);
 			r_count = r_count >> 2;
@@ -293,7 +292,7 @@ static void omap_write_buf_pref(struct m
 						struct omap_nand_info, mtd);
 	uint32_t w_count = 0;
 	int i = 0, ret = 0;
-	u16 *p;
+	u16 *p = (u16 *)buf;
 	unsigned long tim, limit;
 
 	/* take care of subpage writes */
@@ -309,11 +308,10 @@ static void omap_write_buf_pref(struct m
 	if (ret) {
 		/* PFPW engine is busy, use cpu copy method */
 		if (info->nand.options & NAND_BUSWIDTH_16)
-			omap_write_buf16(mtd, buf, len);
+			omap_write_buf16(mtd, (u_char *)p, len);
 		else
-			omap_write_buf8(mtd, buf, len);
+			omap_write_buf8(mtd, (u_char *)p, len);
 	} else {
-		p = (u16 *) buf;
 		while (len) {
 			w_count = gpmc_read_status(GPMC_PREFETCH_FIFO_CNT);
 			w_count = w_count >> 1;


