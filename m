Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2JGXaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:30:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab2JGXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:09 -0400
Message-Id: <20121007225840.940894385@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 045/108] sb_edac: Avoid overflow errors at memory size calculation
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit deb09ddaff1435f72dd598d38f9b58354c68a5ec upstream.

Sandy bridge EDAC is calculating the memory size with overflow.
Basically, the size field and the integer calculation is using 32 bits.
More bits are needed, when the DIMM memories have high density.

The net result is that memories are improperly reported there, when
high-density DIMMs are used:

EDAC DEBUG: in drivers/edac/sb_edac.c, line at 591: mc#0: channel 0, dimm 0, -16384 Mb (-4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800
EDAC DEBUG: in drivers/edac/sb_edac.c, line at 591: mc#0: channel 1, dimm 0, -16384 Mb (-4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800

As the number of pages value is handled at the EDAC core as unsigned
ints, the driver shows the 16 GB memories at sysfs interface as 16760832
MB! The fix is simple: calculate the number of pages as unsigned 64-bits
integer.

After the patch, the memory size (16 GB) is properly detected:

EDAC DEBUG: in drivers/edac/sb_edac.c, line at 592: mc#0: channel 0, dimm 0, 16384 Mb (4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800
EDAC DEBUG: in drivers/edac/sb_edac.c, line at 592: mc#0: channel 1, dimm 0, 16384 Mb (4194304 pages) bank: 8, rank: 2, row: 0x10000, col: 0x800

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Debug log function is debugf0(), not edac_dbg()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/edac/sb_edac.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -554,7 +554,8 @@ static int get_dimm_config(const struct
 {
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	struct csrow_info *csr;
-	int i, j, banks, ranks, rows, cols, size, npages;
+	unsigned i, j, banks, ranks, rows, cols, npages;
+	u64 size;
 	int csrow = 0;
 	unsigned long last_page = 0;
 	u32 reg;
@@ -626,10 +627,10 @@ static int get_dimm_config(const struct
 				cols = numcol(mtr);
 
 				/* DDR3 has 8 I/O banks */
-				size = (rows * cols * banks * ranks) >> (20 - 3);
+				size = ((u64)rows * cols * banks * ranks) >> (20 - 3);
 				npages = MiB_TO_PAGES(size);
 
-				debugf0("mc#%d: channel %d, dimm %d, %d Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
+				debugf0("mc#%d: channel %d, dimm %d, %Ld Mb (%d pages) bank: %d, rank: %d, row: %#x, col: %#x\n",
 					pvt->sbridge_dev->mc, i, j,
 					size, npages,
 					banks, ranks, rows, cols);


