Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1ABO1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:27:50 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58790 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab1ABO1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:27:48 -0500
Date: Sun, 2 Jan 2011 15:27:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/video/carminefb.c: improve error handling
Message-ID: <Pine.LNX.4.64.1101021527220.10933@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code had an error handling goto to the wrong place, a misplaced
release_mem_region, and a duplicated release_mem_region.

The semantic match that finds the double release_mem_region is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2,e3;
position p1,p2,p3;
@@
release_mem_region@p1(e1, e2)@p3;
... when != request_mem_region(e1,e2,e3)
release_mem_region(e1, e2)@p2;

@@
expression e <= r.e1,e3;
expression r.e1,e2;
position r.p1,r.p2,r.p3,p!=r.p1;
@@
*release_mem_region(e1, e2)@p3;
... when != e = e3
*release_mem_region@p(e1, e2)@p2;// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index 6b19136..caaa27d 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -654,7 +654,7 @@ static int __devinit carminefb_probe(struct pci_dev *dev,
 		printk(KERN_ERR "carminefb: Memory bar is only %d bytes, %d "
 				"are required.", carminefb_fix.smem_len,
 				CARMINE_TOTAL_DIPLAY_MEM);
-		goto err_free_reg_mmio;
+		goto err_unmap_vregs;
 	}
 
 	if (!request_mem_region(carminefb_fix.smem_start,
@@ -667,8 +667,6 @@ static int __devinit carminefb_probe(struct pci_dev *dev,
 			carminefb_fix.smem_len);
 	if (!hw->screen_mem) {
 		printk(KERN_ERR "carmine: Can't ioremap smem area.\n");
-		release_mem_region(carminefb_fix.smem_start,
-				carminefb_fix.smem_len);
 		goto err_reg_smem;
 	}
 
@@ -710,7 +708,7 @@ err_deinit_hw:
 err_unmap_screen:
 	iounmap(hw->screen_mem);
 err_reg_smem:
-	release_mem_region(carminefb_fix.mmio_start, carminefb_fix.mmio_len);
+	release_mem_region(carminefb_fix.smem_start, carminefb_fix.smem_len);
 err_unmap_vregs:
 	iounmap(hw->v_regs);
 err_free_reg_mmio:
