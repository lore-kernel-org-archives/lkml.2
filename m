Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1JLE66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:58:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54060 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1JLE65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:58:57 -0400
MIME-Version: 1.0
Date: Wed, 12 Oct 2011 10:28:56 +0530
Message-ID: <CAA_L+UPmnbe20kyHMKCMabhqggwvChmdZo0P8ENNCGA7xfNUbQ@mail.gmail.com>
Subject: [PATCH 3.1-rc9] edac:i82975x fix 32bit compile and cleanup
From: Arvind R <arvino55@gmail.com>
To: trivial@kernel.org
Cc: linux-edac@vger.kernel.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.1-rc9] edac:i82975x fix 32bit compile and cleanup

the clean up achieves:
  1. fix warning on 32-bit compile
  2. reorder info extraction for clarity
  3. add error-trap diagnostic message
  4. handle ALL modes of memory configurations

Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)
---
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -277,11 +277,9 @@ static void i82975x_get_error_info(struc
 static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		struct i82975x_error_info *info, int handle_errors)
 {
-	int row, multi_chan, chan;
+	int row, chan;
 	unsigned long offst, page;

-	multi_chan = mci->csrows[0].nr_channels - 1;
-
 	if (!(info->errsts2 & 0x0003))
 		return 0;

@@ -294,20 +292,30 @@ static int i82975x_process_error_info(st
 	}

 	page = (unsigned long) info->eap;
-	if (info->xeap & 1)
-		page |= 0x100000000ul;
-	chan = page & 1;
 	page >>= 1;
-	offst = page & ((1 << PAGE_SHIFT) - 1);
-	page >>= PAGE_SHIFT;
+	if (info->xeap & 1)
+		page |= 0x80000000;
+	page >>= (PAGE_SHIFT - 1);
 	row = edac_mc_find_csrow_by_page(mci, page);

+	if (row == -1)	{
+		i82975x_mc_printk(mci, KERN_ERR, "error processing EAP:\n"
+			"\tXEAP=%u\n"
+			"\t EAP=0x%08x\n"
+			"\tPAGE=0x%08x\n",
+			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned int) page);
+		return 0;
+	}
+	chan = (mci->csrows[row].nr_channels == 1) ? 0 : info->eap & 1;
+	offst = info->eap
+			& ((1 << PAGE_SHIFT) -
+				(1 << mci->csrows[row].grain));
+
 	if (info->errsts & 0x0002)
 		edac_mc_handle_ue(mci, page, offst , row, "i82975x UE");
 	else
 		edac_mc_handle_ce(mci, page, offst, info->derrsyn, row,
-				multi_chan ? chan : 0,
-				"i82975x CE");
+				chan, "i82975x CE");

 	return 1;
 }
@@ -410,7 +418,7 @@ static void i82975x_init_csrows(struct m
 		csrow->last_page = cumul_size - 1;
 		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
-		csrow->grain = 1 << 6;	/* I82975X_EAP has 64B resolution */
+		csrow->grain = 1 << 7;	/* 128Byte cache-line resolution */
 		csrow->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
 		csrow->dtype = i82975x_dram_type(mch_window, index);
 		csrow->edac_mode = EDAC_SECDED; /* only supported */
