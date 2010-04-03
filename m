Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab0DCVWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 17:22:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:14499 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab0DCVWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 17:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject;
        b=wKXssVS6XwX4LEKSRrVOcxfCkxRpsHjIlB4/vjdpdoapUXqfNlG4DvTCrHLEKg3QoO
         qzo3VjqkHBWVGk8cYmD7zUhwHKI/o8w4Z5wVKxSISVVb+G75q05rjRBkihqK30oPJ9bC
         JuMv5gXBWaDIXffLwkrmEji3txYFuoQ7vAN4g=
Message-ID: <4bb7b17e.0d67f10a.60fe.ffff9ac6@mx.google.com>
Date: Sat, 03 Apr 2010 14:22:06 -0700 (PDT)
From: leon.woestenberg@gmail.com
To: jarod@wilsonet.com
To: "Naren (Narendra) Sankar" <nsankar@broadcom.com>
To: "hancockrwd@gmail.com" <hancockrwd@gmail.com>
To: "jarod@redhat.com" <jarod@redhat.com>
To: "davilla@4pi.com" <davilla@4pi.com>
To: "abraham.manu@gmail.com" <abraham.manu@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
To: Leon Woestenberg <leon@sidebranch.com>
Subject: [PATCH] staging: crystalhd: Fix for big-endian systems
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original CrystalHD driver assumes a little endian bitfield host.

This patch adds support for big-endian bitfield hosts.

It was tested by verifying the values of all hardware register accesses
on a big-endian host were equal to a little-endian host.

The use of bitfields is discouraged for hardware access, so this needs
to be rewritten to use macro definitions at some point.

Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
--- git.orig/drivers/staging/crystalhd/crystalhd_hw.h	2010-03-21 16:05:52.000000000 +0100
+++ git/drivers/staging/crystalhd/crystalhd_hw.h	2010-04-03 23:05:58.290430827 +0200
@@ -121,6 +121,7 @@
 
 typedef union _intr_mask_reg_ {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 		uint32_t	mask_tx_done:1;
 		uint32_t	mask_tx_err:1;
 		uint32_t	mask_rx_done:1;
@@ -129,6 +130,16 @@
 		uint32_t	mask_pcie_rbusmast_err:1;
 		uint32_t	mask_pcie_rgr_bridge:1;
 		uint32_t	reserved:25;
+#else
+		uint32_t	reserved:25;
+		uint32_t	mask_pcie_rgr_bridge:1;
+		uint32_t	mask_pcie_rbusmast_err:1;
+		uint32_t	mask_pcie_err:1;
+		uint32_t	mask_rx_err:1;
+		uint32_t	mask_rx_done:1;
+		uint32_t	mask_tx_err:1;
+		uint32_t	mask_tx_done:1;
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -137,10 +148,17 @@
 
 typedef union _link_misc_perst_deco_ctrl_ {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD //ok
 		uint32_t	bcm7412_rst:1;		/* 1 -> BCM7412 is held in reset. Reset value 1.*/
 		uint32_t	reserved0:3;		/* Reserved.No Effect*/
 		uint32_t	stop_bcm_7412_clk:1;	/* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
 		uint32_t	reserved1:27;		/* Reseved. No Effect*/
+#else
+		uint32_t	reserved1:27;		/* Reseved. No Effect*/
+		uint32_t	stop_bcm_7412_clk:1;	/* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
+		uint32_t	reserved0:3;		/* Reserved.No Effect*/
+		uint32_t	bcm7412_rst:1;		/* 1 -> BCM7412 is held in reset. Reset value 1.*/
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -149,6 +167,7 @@
 
 typedef union _link_misc_perst_clk_ctrl_ {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 		uint32_t	sel_alt_clk:1;	  /* When set, selects a 6.75MHz clock as the source of core_clk */
 		uint32_t	stop_core_clk:1;  /* When set, stops the branch of core_clk that is not needed for low power operation */
 		uint32_t	pll_pwr_dn:1;	  /* When set, powers down the main PLL. The alternate clock bit should be set
@@ -157,6 +176,16 @@
 		uint32_t	pll_mult:8;	  /* This setting controls the multiplier for the PLL. */
 		uint32_t	pll_div:4;	  /* This setting controls the divider for the PLL. */
 		uint32_t	reserved1:12;	  /* Reserved */
+#else
+		uint32_t	reserved1:12;	  /* Reserved */
+		uint32_t	pll_div:4;	  /* This setting controls the divider for the PLL. */
+		uint32_t	pll_mult:8;	  /* This setting controls the multiplier for the PLL. */
+		uint32_t	reserved0:5;	  /* Reserved */
+		uint32_t	pll_pwr_dn:1;	  /* When set, powers down the main PLL. The alternate clock bit should be set
+						     to select an alternate clock before setting this bit.*/
+		uint32_t	stop_core_clk:1;  /* When set, stops the branch of core_clk that is not needed for low power operation */
+		uint32_t	sel_alt_clk:1;	  /* When set, selects a 6.75MHz clock as the source of core_clk */
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -166,10 +195,17 @@
 
 typedef union _link_misc_perst_decoder_ctrl_ {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 		uint32_t	bcm_7412_rst:1; /* 1 -> BCM7412 is held in reset. Reset value 1.*/
 		uint32_t	res0:3; /* Reserved.No Effect*/
 		uint32_t	stop_7412_clk:1; /* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
 		uint32_t	res1:27; /* Reseved. No Effect */
+#else
+		uint32_t	res1:27; /* Reseved. No Effect */
+		uint32_t	stop_7412_clk:1; /* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
+		uint32_t	res0:3; /* Reserved.No Effect*/
+		uint32_t	bcm_7412_rst:1; /* 1 -> BCM7412 is held in reset. Reset value 1.*/
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -179,9 +215,15 @@
 
 typedef union _desc_low_addr_reg_ {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 		uint32_t	list_valid:1;
 		uint32_t	reserved:4;
 		uint32_t	low_addr:27;
+#else
+		uint32_t	low_addr:27;
+		uint32_t	reserved:4;
+		uint32_t	list_valid:1;
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -189,6 +231,7 @@
 } desc_low_addr_reg;
 
 typedef struct _dma_descriptor_ {	/* 8 32-bit values */
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 	/* 0th u32 */
 	uint32_t sdram_buff_addr:28;	/* bits 0-27:  SDRAM Address */
 	uint32_t res0:4;		/* bits 28-31: Reserved */
@@ -219,7 +262,38 @@
 
 	/* 7th u32 */
 	uint32_t res8;			/* Last 32bits reserved */
+#else
+	/* 0th u32 */
+	uint32_t res0:4;		/* bits 28-31: Reserved */
+	uint32_t sdram_buff_addr:28;	/* bits 0-27:  SDRAM Address */
+
+	/* 1st u32 */
+	uint32_t buff_addr_low;		/* 1 buffer address low */
+	uint32_t buff_addr_high;	/* 2 buffer address high */
 
+	/* 3rd u32 */
+	uint32_t intr_enable:1;		/* 31 - Interrupt After this desc */
+	uint32_t res3:6;		/* 25-30 reserved */
+	uint32_t xfer_size:23;		/* 2-24 = Xfer size in words */
+	uint32_t res2:2;		/* 0-1 - Reserved */
+
+	/* 4th u32 */
+	uint32_t last_rec_indicator:1;	/* 31 bit Last Record Indicator */
+	uint32_t dma_dir:1;		/* 30 bit DMA Direction */
+	uint32_t fill_bytes:2;		/* 28-29 Bits Fill Bytes */
+	uint32_t res4:25;		/* 3 - 27 Reserved bits */
+	uint32_t next_desc_cont:1;	/* 2 - Next desc is in contig memory */
+	uint32_t endian_xlat_align:2;	/* 0-1 Endian Translation */
+
+	/* 5th u32 */
+	uint32_t next_desc_addr_low;	/* 32-bits Next Desc Addr lower */
+
+	/* 6th u32 */
+	uint32_t next_desc_addr_high;	/* 32-bits Next Desc Addr Higher */
+
+	/* 7th u32 */
+	uint32_t res8;			/* Last 32bits reserved */
+#endif
 } dma_descriptor, *pdma_descriptor;
 
 /*
