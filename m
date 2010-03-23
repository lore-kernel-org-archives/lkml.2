Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0CWNnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:43:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64534 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0CWNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:43:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject;
        b=it4F1RkLXDp3ZHJWX0CKcyTeCIR/YPpZEngT7fLlekT/Ax2I8RdKzoBm4e4cFvN7dv
         m3HT2t8/D9+3ASF6fcjRbahjF8m5Dtgmynsx6Mc1lgJkRcbA9jgmZzZr7e97cFFOE/5j
         TTvCsz/8efn2xL8tJM9m7qlJJqZHpJyaudKKA=
Message-ID: <4ba8c564.8109cc0a.6677.4856@mx.google.com>
Date: Tue, 23 Mar 2010 06:43:00 -0700 (PDT)
From: leon.woestenberg@gmail.com
To: jarod@wilsonet.com
To: "Naren (Narendra) Sankar" <nsankar@broadcom.com>
To: "hancockrwd@gmail.com" <hancockrwd@gmail.com>
To: "jarod@redhat.com" <jarod@redhat.com>
To: "davilla@4pi.com" <davilla@4pi.com>
To: "abraham.manu@gmail.com" <abraham.manu@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
To: Leon Woestenberg <leon@sidebranch.com>
Subject: [PATCH] staging: crystalhd: printk register accesses to debug for big-endian systems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CrystalHD device driver assumes a little endian host. In order to verify future work on
endianess-independence, this patch adds printk's to track the register access to the device.

This helps verify bitfield endianess correctness as well as any hard-coded assumptions in
the driver code.

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>



--- git.orig/drivers/staging/crystalhd/crystalhd_misc.c	2010-03-21 16:05:52.000000000 +0100
+++ git/drivers/staging/crystalhd/crystalhd_misc.c	2010-03-23 13:44:45.324121364 +0100
@@ -140,12 +140,14 @@
  */
 uint32_t bc_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 {
+	uint32_t val;
 	if (!adp || (reg_off > adp->pci_mem_len)) {
 		BCMLOG_ERR("dec_rd_reg_off outof range: 0x%08x\n", reg_off);
 		return 0;
 	}
-
-	return readl(adp->addr + reg_off);
+	val = readl(adp->addr + reg_off);
+	printk(KERN_DEBUG "bc_dec_reg_rd(): read(0x%p) = 0x%08x\n", adp->addr + reg_off, val);
+	return val;
 }
 
 /**
@@ -167,6 +169,7 @@
 		BCMLOG_ERR("dec_wr_reg_off outof range: 0x%08x\n", reg_off);
 		return;
 	}
+	printk(KERN_DEBUG "bc_dec_reg_wr(): writel(0x%08x @ 0x%p).\n", val, adp->addr + reg_off);
 	writel(val, adp->addr + reg_off);
 	udelay(8);
 }
@@ -186,11 +189,14 @@
  */
 uint32_t crystalhd_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
 {
+	uint32_t val;
 	if (!adp || (reg_off > adp->pci_i2o_len)) {
-		BCMLOG_ERR("link_rd_reg_off outof range: 0x%08x\n", reg_off);
+		printk(KERN_DEBUG "link_rd_reg_off outof range: 0x%08x\n", reg_off);
 		return 0;
 	}
-	return readl(adp->i2o_addr + reg_off);
+	val = readl(adp->i2o_addr + reg_off);
+	printk(KERN_DEBUG "crystalhd_reg_rd(): read(0x%p) = 0x%08x\n", adp->i2o_addr + reg_off, val);
+	return val;
 }
 
 /**
@@ -213,6 +219,7 @@
 		BCMLOG_ERR("link_wr_reg_off outof range: 0x%08x\n", reg_off);
 		return;
 	}
+	printk(KERN_DEBUG "crystalhd_reg_wr(): writel(0x%08x @ 0x%p).\n", val, adp->i2o_addr + reg_off);
 	writel(val, adp->i2o_addr + reg_off);
 }
 
