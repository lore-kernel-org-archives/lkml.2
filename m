Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab0GSVmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:42:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40072 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966873Ab0GSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:54 -0400
Message-Id: <20100719213853.607589770@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:33 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 15/25] GRU - reorder interrupt processing
References: <20100719213651.362618144@sgi.com>
Content-Disposition: inline; filename=uv_gru_preload_tlb_inval
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Reorder the servicing of CBR completion interrupts & TLB miss interrupts.
There is a small performance gain to service TLB misses first. Completion
interrupts are rare.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:25:40.978392010 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-07-19 10:25:45.626240841 -0500
@@ -7,7 +7,7 @@
  * These misses are reported either via interrupts or user polling of
  * the user CB.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2008-2010 Silicon Graphics, Inc.  All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -559,19 +559,10 @@ static irqreturn_t gru_intr(int chiplet,
 		imap.fault_bits[0], imap.fault_bits[1],
 		dmap.fault_bits[0], dmap.fault_bits[1]);
 
-	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
-		STAT(intr_cbr);
-		cmp = gru->gs_async_wq[cbrnum];
-		if (cmp)
-			complete(cmp);
-		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
-			gru->gs_gid, cbrnum, cmp ? cmp->done : -1);
-	}
-
 	for_each_cbr_in_tfm(cbrnum, imap.fault_bits) {
-		STAT(intr_tfh);
 		tfh = get_tfh_by_index(gru, cbrnum);
 		prefetchw(tfh);	/* Helps on hdw, required for emulator */
+		STAT(intr_tfh);
 
 		/*
 		 * When hardware sets a bit in the faultmap, it implicitly
@@ -596,6 +587,8 @@ static irqreturn_t gru_intr(int chiplet,
 			gts->ustats.interrupts++;
 		gts->ustats.fmm_tlbmiss++;
 		multi = 1;
+		if (!gts->ts_mm)
+			continue;
 		if (!gts->ts_force_cch_reload &&
 					down_read_trylock(&gts->ts_mm->mmap_sem)) {
 			gru_try_dropin(gru, gts, tfh, NULL);
@@ -605,6 +598,15 @@ static irqreturn_t gru_intr(int chiplet,
 			STAT(intr_mm_lock_failed);
 		}
 	}
+	for_each_cbr_in_tfm(cbrnum, dmap.fault_bits) {
+		STAT(intr_cbr);
+		cmp = gru->gs_async_wq[cbrnum];
+		if (cmp)
+			complete(cmp);
+		gru_dbg(grudev, "gid %d, cbr_done %d, done %d\n",
+			gru->gs_gid, cbrnum, cmp ? cmp->done : -1);
+	}
+
 	return IRQ_HANDLED;
 }
 

