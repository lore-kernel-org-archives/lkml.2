Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937617Ab0CPJxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:53:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56372 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab0CPJxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:53:01 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L/DVB: mx1-camera: compile fix
Date: Tue, 16 Mar 2010 10:52:52 +0100
Message-Id: <1268733172-17059-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <Pine.LNX.4.64.1003121057090.4385@axis700.grange>
References: <Pine.LNX.4.64.1003121057090.4385@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a regression of

	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h |    4 +++-
 drivers/media/video/mx1_camera.c             |    8 +++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h b/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
index 07be8ad..d25a65f 100644
--- a/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
+++ b/arch/arm/plat-mxc/include/mach/dma-mx1-mx2.h
@@ -31,7 +31,9 @@
 #define DMA_MODE_WRITE		1
 #define DMA_MODE_MASK		1
 
-#define DMA_BASE IO_ADDRESS(DMA_BASE_ADDR)
+#define MX1_DMA_REG(offset)	MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR + offset)
+#define MX1_DMA_CCR(x)		MX1_DMA_REG(0x8c + ((x) << 6))
+#define MX1_DMA_DIMR		MX1_DMA_REG(0x08)
 
 #define IMX_DMA_MEMSIZE_32	(0 << 4)
 #define IMX_DMA_MEMSIZE_8	(1 << 4)
diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index c167cc3..aa81acd 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -48,8 +48,6 @@
 /*
  * CSI registers
  */
-#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
-#define DMA_DIMR	0x08			/* Interrupt mask Register */
 #define CSICR1		0x00			/* CSI Control Register 1 */
 #define CSISR		0x08			/* CSI Status Register */
 #define CSIRXR		0x10			/* CSI RxFIFO Register */
@@ -783,7 +781,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 			       pcdev);
 
 	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
-			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
+			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
 	/* burst length : 16 words = 64 bytes */
 	imx_dma_config_burstlen(pcdev->dma_chan, 0);
 
@@ -797,8 +795,8 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
 	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
 						   &mx1_camera_sof_fiq_start);
 
-	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
-	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
+	regs.ARM_r8 = (long)MX1_DMA_DIMR;
+	regs.ARM_r9 = (long)MX1_DMA_CCR(pcdev->dma_chan);
 	regs.ARM_r10 = (long)pcdev->base + CSICR1;
 	regs.ARM_fp = (long)pcdev->base + CSISR;
 	regs.ARM_sp = 1 << pcdev->dma_chan;
-- 
1.7.0

