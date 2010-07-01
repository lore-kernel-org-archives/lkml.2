Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0GASKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:10:30 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:59537 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0GASK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:28 -0400
X-MXL-Hash: 4c2cda141c0a2762-46ba49988dce2f1a7a51bac7c6f5188dda4c7f59
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Date: Thu, 1 Jul 2010 13:09:42 -0500
Subject: RE: [PATCH] Staging: dt3155: remove remaining 32-bit and 8-bit
 global	registers
Thread-Topic: [PATCH] Staging: dt3155: remove remaining 32-bit and 8-bit
 global	registers
Thread-Index: AcsUrHpjG+VkkGCnT9+3Ie7OZFCgkwEnAKYg
Message-ID: <0D753D10438DA54287A00B02708426976373859411@AUSP01VMBX24.collaborationhost.net>
References: <201006251419.50433.hartleys@visionengravers.com>
In-Reply-To: <201006251419.50433.hartleys@visionengravers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010062801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=SU9D1YLbFoAA:10 a=yQWWgrYGNuUA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=DD]
X-AnalysisOut: [OyTI_5AAAA:8 a=lTbjQzD5AAAA:8 a=i00gxMtYAAAA:8 a=RBdXBVZR3]
X-AnalysisOut: [qSNG8Uh48cA:9 a=QuFo3ACkfW91sPjLc9AA:7 a=rJ9w0DUN-bOshWaw0]
X-AnalysisOut: [WMhZ4tNfMoA:4 a=CjuIK1q_8ugA:10 a=GznomRg53nMA:10 a=0kPLrQ]
X-AnalysisOut: [dw3YYA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

Any comments on this patch?

Regards,
Hartley

-----Original Message-----
From: devel-bounces@linuxdriverproject.org [mailto:devel-bounces@linuxdriverproject.org] On Behalf Of H Hartley Sweeten
Sent: Friday, June 25, 2010 2:20 PM
To: Linux Kernel
Cc: devel@driverdev.osuosl.org; ss@aao.gov.au; gregkh@suse.de
Subject: [PATCH] Staging: dt3155: remove remaining 32-bit and 8-bit global registers

Remove the remaining global 32-bit and 8-bit i2c registers. Create a
local variable of the correct type where they are needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 6d35a6f..fed7e62 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -140,6 +140,8 @@ static void quick_stop (int minor)
 
   // TODO: scott was here
 #if 1
+  INT_CSR_R int_csr_r;
+
   int_csr_r.reg = readl(dt3155_lbase[minor] + INT_CSR);
   /* disable interrupts */
   int_csr_r.fld.FLD_END_EVE_EN = 0;
@@ -175,6 +177,10 @@ static void dt3155_isr(int irq, void *dev_id, struct pt_regs *regs)
   void __iomem *mmio;
   struct dt3155_status *dts;
   struct dt3155_fbuffer *fb;
+  INT_CSR_R int_csr_r;
+  CSR1_R csr1_r;
+  I2C_EVEN_CSR i2c_even_csr;
+  I2C_ODD_CSR i2c_odd_csr;
 
   /* find out who issued the interrupt */
   for (index = 0; index < ndevices; index++) {
@@ -411,35 +417,30 @@ static void dt3155_init_isr(int minor)
 {
   struct dt3155_status *dts = &dt3155_status[minor];
   struct dt3155_fbuffer *fb = &dts->fbuffer;
-  const u32 stride = dts->config.cols;
   void __iomem *mmio = dt3155_lbase[minor];
+  u32 dma_addr = fb->frame_info[fb->active_buf].addr;
+  const u32 stride = dts->config.cols;
+  CSR1_R csr1_r;
+  INT_CSR_R int_csr_r;
+  I2C_CSR2 i2c_csr2;
 
   switch (dts->state & DT3155_STATE_MODE)
     {
     case DT3155_STATE_FLD:
       {
-	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
-	even_dma_stride_r = 0;
-	odd_dma_stride_r  = 0;
-
-	writel(even_dma_start_r, mmio + EVEN_DMA_START);
-	writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
-	writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
+	writel(dma_addr, mmio + EVEN_DMA_START);
+	writel(0, mmio + EVEN_DMA_STRIDE);
+	writel(0, mmio + ODD_DMA_STRIDE);
 	break;
       }
 
     case DT3155_STATE_FRAME:
     default:
       {
-	even_dma_start_r  = fb->frame_info[fb->active_buf].addr;
-	odd_dma_start_r   =  even_dma_start_r + stride;
-	even_dma_stride_r =  stride;
-	odd_dma_stride_r  =  stride;
-
-	writel(even_dma_start_r, mmio + EVEN_DMA_START);
-	writel(odd_dma_start_r, mmio + ODD_DMA_START);
-	writel(even_dma_stride_r, mmio + EVEN_DMA_STRIDE);
-	writel(odd_dma_stride_r, mmio + ODD_DMA_STRIDE);
+	writel(dma_addr, mmio + EVEN_DMA_START);
+	writel(dma_addr + stride, mmio + ODD_DMA_START);
+	writel(stride, mmio + EVEN_DMA_STRIDE);
+	writel(stride, mmio + ODD_DMA_STRIDE);
 	break;
       }
     }
@@ -694,8 +695,7 @@ static int dt3155_open(struct inode* inode, struct file* filep)
   dt3155_flush(minor);
 
   /* Disable ALL interrupts */
-  int_csr_r.reg = 0;
-  writel(int_csr_r.reg, dt3155_lbase[minor] + INT_CSR);
+  writel(0, dt3155_lbase[minor] + INT_CSR);
 
   init_waitqueue_head(&(dt3155_read_wait_queue[minor]));
 
@@ -1027,12 +1027,11 @@ int init_module(void)
     }
 
   /* Disable ALL interrupts */
-  int_csr_r.reg = 0;
   for( index = 0;  index < ndevices;  index++)
     {
       dts = &dt3155_status[index];
 
-      writel(int_csr_r.reg, dt3155_lbase[index] + INT_CSR);
+      writel(0, dt3155_lbase[index] + INT_CSR);
       if(dts->device_installed)
 	{
 	  /*
diff --git a/drivers/staging/dt3155/dt3155_io.c b/drivers/staging/dt3155/dt3155_io.c
index b2f2f1e..11fac34 100644
--- a/drivers/staging/dt3155/dt3155_io.c
+++ b/drivers/staging/dt3155/dt3155_io.c
@@ -28,25 +28,6 @@
 #include "dt3155_drv.h"
 
 
-/****** local copies of board's 32 bit registers ******/
-u32 even_dma_start_r;	/*  bit 0 should always be 0 */
-u32 odd_dma_start_r;	/*               .. */
-u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
-u32 odd_dma_stride_r;	/*               .. */
-
-CSR1_R			csr1_r;
-INT_CSR_R		int_csr_r;
-
-IIC_CSR1_R		iic_csr1_r;
-IIC_CSR2_R		iic_csr2_r;
-
-
-
-/******** local copies of board's 8 bit I2C registers ******/
-I2C_CSR2 i2c_csr2;
-I2C_EVEN_CSR i2c_even_csr;
-I2C_ODD_CSR i2c_odd_csr;
-
 /*
  * wait_ibsyclr()
  *
@@ -54,6 +35,8 @@ I2C_ODD_CSR i2c_odd_csr;
  */
 static int wait_ibsyclr(void __iomem *mmio)
 {
+	IIC_CSR2_R iic_csr2_r;
+
 	/* wait 100 microseconds */
 	udelay(100L);
 	/* __delay(loops_per_sec/10000); */
@@ -80,8 +63,9 @@ static int wait_ibsyclr(void __iomem *mmio)
  */
 int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal)
 {
-	/* read 32 bit IIC_CSR2 register data into union */
+	IIC_CSR2_R iic_csr2_r;
 
+	/* read 32 bit IIC_CSR2 register data into union */
 	iic_csr2_r.reg = readl(mmio + IIC_CSR2);
 
 	/* for write operation */
@@ -111,6 +95,8 @@ int WriteI2C(void __iomem *mmio, u_short wIregIndex, u8 byVal)
  */
 int ReadI2C(void __iomem *mmio, u_short wIregIndex, u8 *byVal)
 {
+	IIC_CSR1_R iic_csr1_r;
+	IIC_CSR2_R iic_csr2_r;
 	int writestat;	/* status for return */
 
 	/*  read 32 bit IIC_CSR2 register data into union */
diff --git a/drivers/staging/dt3155/dt3155_io.h b/drivers/staging/dt3155/dt3155_io.h
index 730e30a..1c7d4d7 100644
--- a/drivers/staging/dt3155/dt3155_io.h
+++ b/drivers/staging/dt3155/dt3155_io.h
@@ -206,22 +206,6 @@ typedef union dma_upper_lmt_tag   {
 } DMA_UPPER_LMT_R;
 
 
-/*
- * Global declarations of local copies of boards' 32 bit registers
- */
-extern u32 even_dma_start_r;		/*  bit 0 should always be 0 */
-extern u32 odd_dma_start_r;		/*               ..          */
-extern u32 even_dma_stride_r;	/*  bits 0&1 should always be 0 */
-extern u32 odd_dma_stride_r;		/*               ..             */
-
-extern CSR1_R			csr1_r;
-extern INT_CSR_R		int_csr_r;
-
-extern IIC_CSR1_R		iic_csr1_r;
-extern IIC_CSR2_R		iic_csr2_r;
-
-
-
 /***************** 8 bit I2C register globals  ***********/
 #define CSR2		0x010	/* indices of 8-bit I2C mapped reg's*/
 #define EVEN_CSR	0x011
@@ -312,14 +296,6 @@ typedef union i2c_ad_cmd_tag {
 } I2C_AD_CMD;
 
 
-/***** Global declarations of local copies of boards' 8 bit I2C registers ***/
-
-extern I2C_CSR2			i2c_csr2;
-extern I2C_EVEN_CSR		i2c_even_csr;
-extern I2C_ODD_CSR		i2c_odd_csr;
-
-/* Functions for Global use */
-
 /* access 8-bit IIC registers */
 
 extern int ReadI2C(void __iomem *mmio, u_short wIregIndex, u8 *byVal);
_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
