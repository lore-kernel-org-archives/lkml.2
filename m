Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1EMNu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:50:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1EMNu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:50:56 -0400
Date: Fri, 13 May 2011 15:50:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Josh Wu <josh.wu@atmel.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lars.haring@atmel.com
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1105130956090.26356@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:dN7zdWEMEHPdgJx65NLeSFw4mlQi9Qtc9u/6N7IknRv
 iZrce/ldcrQCaqJq71zn7BQBv73m1ew67bcS3WnsPtO/8eca+I
 VVvZvWyWF2FtpCcuKGgi13vZuBvWqit/N/KeFkEmKkxgzzrswl
 MH9iqM5RtcfIgD0LVMvfN5EKrDxl6LVU2edUdsPexgJKHgrWPU
 IwaaE6+Qky8PQF/bsWO0vsEJWbNY+AB2GgFHQcHtGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Josh Wu wrote:

> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> base on branch staging/for_v2.6.40
> 
>  arch/arm/mach-at91/include/mach/at91_isi.h |  454 ++++++++++++
>  drivers/media/video/Kconfig                |   10 +
>  drivers/media/video/Makefile               |    1 +
>  drivers/media/video/atmel-isi.c            | 1089 ++++++++++++++++++++++++++++
>  4 files changed, 1554 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-at91/include/mach/at91_isi.h
>  create mode 100644 drivers/media/video/atmel-isi.c
> 
> diff --git a/arch/arm/mach-at91/include/mach/at91_isi.h b/arch/arm/mach-at91/include/mach/at91_isi.h
> new file mode 100644
> index 0000000..3219358
> --- /dev/null
> +++ b/arch/arm/mach-at91/include/mach/at91_isi.h
> @@ -0,0 +1,454 @@
> +/*
> + * Register definitions for the Atmel Image Sensor Interface.

Why do you put ISI register definitions in a header under arch/arm/...? It 
seems only your driver needs them. Then at most put it directly under 
drivers/media/video or even consider inlining all these definitions in the 
driver itself, although, I admit, in such quantities it probably looks 
cleaner in a separate header. But please put it under drivers/... Any 
common stuff, that you will need in your board code to configure the 
driver should go in a header under include/media/.

> + *
> + * Copyright (C) 2011 Atmel Corporation

Consider adding an author with an email address?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef __AT91_ISI_H__
> +#define __AT91_ISI_H__
> +
> +#include <linux/videodev2.h>
> +#include <linux/i2c.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-chip-ident.h>

None of these headers seems to be needed in the header itself. OTOH, you 
do use __raw_readl()/writel(), which need something like linux/io.h. But 
you'll, probably, remove those __raw_* from the header.

> +
> +/* ISI register offsets */
> +#define ISI_CR1					0x0000
> +#define ISI_CR2					0x0004
> +#define ISI_SR					0x0008
> +#define ISI_IER					0x000c
> +#define ISI_IDR					0x0010
> +#define ISI_IMR					0x0014
> +#define ISI_PSIZE				0x0020
> +#define ISI_PDECF				0x0024
> +#define ISI_PPFBD				0x0028
> +#define ISI_CDBA				0x002c
> +#define ISI_Y2R_SET0				0x0030
> +#define ISI_Y2R_SET1				0x0034
> +#define ISI_R2Y_SET0				0x0038
> +#define ISI_R2Y_SET1				0x003c
> +#define ISI_R2Y_SET2				0x0040
> +
> +/* ISI_V2 register offsets */
> +#define ISI_V2_CFG1				0x0000
> +#define ISI_V2_CFG2				0x0004
> +#define ISI_V2_PSIZE				0x0008
> +#define ISI_V2_PDECF				0x000c
> +#define ISI_V2_Y2R_SET0				0x0010
> +#define ISI_V2_Y2R_SET1				0x0014
> +#define ISI_V2_R2Y_SET0				0x0018
> +#define ISI_V2_R2Y_SET1				0x001C
> +#define ISI_V2_R2Y_SET2				0x0020
> +#define ISI_V2_CTRL				0x0024
> +#define ISI_V2_STATUS				0x0028
> +#define ISI_V2_INTEN				0x002C
> +#define ISI_V2_INTDIS				0x0030
> +#define ISI_V2_INTMASK				0x0034
> +#define ISI_V2_DMA_CHER				0x0038
> +#define ISI_V2_DMA_CHDR				0x003C
> +#define ISI_V2_DMA_CHSR				0x0040
> +#define ISI_V2_DMA_P_ADDR			0x0044
> +#define ISI_V2_DMA_P_CTRL			0x0048
> +#define ISI_V2_DMA_P_DSCR			0x004C
> +#define ISI_V2_DMA_C_ADDR			0x0050
> +#define ISI_V2_DMA_C_CTRL			0x0054
> +#define ISI_V2_DMA_C_DSCR			0x0058
> +
> +/* Bitfields in CR1 */
> +#define ISI_RST_OFFSET				0
> +#define ISI_RST_SIZE				1
> +#define ISI_DIS_OFFSET				1
> +#define ISI_DIS_SIZE				1
> +#define ISI_HSYNC_POL_OFFSET			2
> +#define ISI_HSYNC_POL_SIZE			1
> +#define ISI_VSYNC_POL_OFFSET			3
> +#define ISI_VSYNC_POL_SIZE			1
> +#define ISI_PIXCLK_POL_OFFSET			4
> +#define ISI_PIXCLK_POL_SIZE			1
> +#define ISI_EMB_SYNC_OFFSET			6
> +#define ISI_EMB_SYNC_SIZE			1
> +#define ISI_CRC_SYNC_OFFSET			7
> +#define ISI_CRC_SYNC_SIZE			1
> +#define ISI_FRATE_OFFSET			8
> +#define ISI_FRATE_SIZE				3
> +#define ISI_FULL_OFFSET				12
> +#define ISI_FULL_SIZE				1
> +#define ISI_THMASK_OFFSET			13
> +#define ISI_THMASK_SIZE				2
> +#define ISI_CODEC_ON_OFFSET			15
> +#define ISI_CODEC_ON_SIZE			1
> +#define ISI_SLD_OFFSET				16
> +#define ISI_SLD_SIZE				8
> +#define ISI_SFD_OFFSET				24
> +#define ISI_SFD_SIZE				8
> +
> +/* Bitfields in CFG1 */
> +#define ISI_V2_HSYNC_POL_OFFSET			2
> +#define ISI_V2_HSYNC_POL_SIZE			1
> +#define ISI_V2_VSYNC_POL_OFFSET			3
> +#define ISI_V2_VSYNC_POL_SIZE			1
> +#define ISI_V2_PIXCLK_POL_OFFSET		4
> +#define ISI_V2_PIXCLK_POL_SIZE			1
> +#define ISI_V2_EMB_SYNC_OFFSET			6
> +#define ISI_V2_EMB_SYNC_SIZE			1
> +#define ISI_V2_CRC_SYNC_OFFSET			7
> +#define ISI_V2_CRC_SYNC_SIZE			1
> +#define ISI_V2_FRATE_OFFSET			8
> +#define ISI_V2_FRATE_SIZE			3
> +#define ISI_V2_DISCR_OFFSET			11
> +#define ISI_V2_DISCR_SIZE			1
> +#define ISI_V2_FULL_OFFSET			12
> +#define ISI_V2_FULL_SIZE			1
> +#define ISI_V2_THMASK_OFFSET			13
> +#define ISI_V2_THMASK_SIZE			2
> +#define ISI_V2_SLD_OFFSET			16
> +#define ISI_V2_SLD_SIZE				8
> +#define ISI_V2_SFD_OFFSET			24
> +#define ISI_V2_SFD_SIZE				8
> +
> +/* Bitfields in CR2 */
> +#define ISI_IM_VSIZE_OFFSET			0
> +#define ISI_IM_VSIZE_SIZE			11
> +#define ISI_GS_MODE_OFFSET			11
> +#define ISI_GS_MODE_SIZE			1
> +#define ISI_RGB_MODE_OFFSET			12
> +#define ISI_RGB_MODE_SIZE			1
> +#define ISI_GRAYSCALE_OFFSET			13
> +#define ISI_GRAYSCALE_SIZE			1
> +#define ISI_RGB_SWAP_OFFSET			14
> +#define ISI_RGB_SWAP_SIZE			1
> +#define ISI_COL_SPACE_OFFSET			15
> +#define ISI_COL_SPACE_SIZE			1
> +#define ISI_IM_HSIZE_OFFSET			16
> +#define ISI_IM_HSIZE_SIZE			11
> +#define ISI_YCC_SWAP_OFFSET			28
> +#define ISI_YCC_SWAP_SIZE			2
> +#define ISI_RGB_CFG_OFFSET			30
> +#define ISI_RGB_CFG_SIZE			2
> +
> +/* Bitfields in CFG2 */
> +#define ISI_V2_IM_VSIZE_OFFSET			0
> +#define ISI_V2_IM_VSIZE_SIZE			11
> +#define ISI_V2_GS_MODE_OFFSET			11
> +#define ISI_V2_GS_MODE_SIZE			1
> +#define ISI_V2_RGB_MODE_OFFSET			12
> +#define ISI_V2_RGB_MODE_SIZE			1
> +#define ISI_V2_GRAYSCALE_OFFSET			13
> +#define ISI_V2_GRAYSCALE_SIZE			1
> +#define ISI_V2_RGB_SWAP_OFFSET			14
> +#define ISI_V2_RGB_SWAP_SIZE			1
> +#define ISI_V2_COL_SPACE_OFFSET			15
> +#define ISI_V2_COL_SPACE_SIZE			1
> +#define ISI_V2_IM_HSIZE_OFFSET			16
> +#define ISI_V2_IM_HSIZE_SIZE			11
> +#define ISI_V2_YCC_SWAP_OFFSET			28
> +#define ISI_V2_YCC_SWAP_SIZE			2
> +#define ISI_V2_RGB_CFG_OFFSET			30
> +#define ISI_V2_RGB_CFG_SIZE			2
> +
> +/* Bitfields in CTRL */
> +#define ISI_V2_EN_OFFSET			0
> +#define ISI_V2_EN_SIZE				1
> +#define ISI_V2_DIS_OFFSET			1
> +#define ISI_V2_DIS_SIZE				1
> +#define ISI_V2_SRST_OFFSET			2
> +#define ISI_V2_SRST_SIZE			1
> +#define ISI_V2_CDC_OFFSET			8
> +#define ISI_V2_CDC_SIZE				1
> +
> +/* Bitfields in SR/IER/IDR/IMR */
> +#define ISI_SOF_OFFSET				0
> +#define ISI_SOF_SIZE				1
> +#define ISI_SOFTRST_OFFSET			2
> +#define ISI_SOFTRST_SIZE			1
> +#define ISI_CDC_STATUS_OFFSET			3
> +#define ISI_CDC_STATUS_SIZE			1
> +#define ISI_CRC_ERR_OFFSET			4
> +#define ISI_CRC_ERR_SIZE			1
> +#define ISI_FO_C_OVF_OFFSET			5
> +#define ISI_FO_C_OVF_SIZE			1
> +#define ISI_FO_P_OVF_OFFSET			6
> +#define ISI_FO_P_OVF_SIZE			1
> +#define ISI_FO_P_EMP_OFFSET			7
> +#define ISI_FO_P_EMP_SIZE			1
> +#define ISI_FO_C_EMP_OFFSET			8
> +#define ISI_FO_C_EMP_SIZE			1
> +#define ISI_FR_OVR_OFFSET			9
> +#define ISI_FR_OVR_SIZE				1
> +
> +/* Bitfields in SR/IER/IDR/IMR(ISI_V2) */
> +#define ISI_V2_ENABLE_OFFSET			0
> +#define ISI_V2_ENABLE_SIZE			1
> +#define ISI_V2_DIS_DONE_OFFSET			1
> +#define ISI_V2_DIS_DONE_SIZE			1
> +#define ISI_V2_SRST_OFFSET			2
> +#define ISI_V2_SRST_SIZE			1
> +#define ISI_V2_CDC_STATUS_OFFSET		8
> +#define ISI_V2_CDC_STATUS_SIZE			1
> +#define ISI_V2_VSYNC_OFFSET			10
> +#define ISI_V2_VSYNC_SIZE			1
> +#define ISI_V2_PXFR_DONE_OFFSET			16
> +#define ISI_V2_PXFR_DONE_SIZE			1
> +#define ISI_V2_CXFR_DONE_OFFSET			17
> +#define ISI_V2_CXFR_DONE_SIZE			1
> +#define ISI_V2_P_OVR_OFFSET			24
> +#define ISI_V2_P_OVR_SIZE			1
> +#define ISI_V2_C_OVR_OFFSET			25
> +#define ISI_V2_C_OVR_SIZE			1
> +#define ISI_V2_CRC_ERR_OFFSET			26
> +#define ISI_V2_CRC_ERR_SIZE			1
> +#define ISI_V2_FR_OVR_OFFSET			27
> +#define ISI_V2_FR_OVR_SIZE			1
> +
> +/* Bitfields in PSIZE */
> +#define ISI_PREV_VSIZE_OFFSET			0
> +#define ISI_PREV_VSIZE_SIZE			10
> +#define ISI_PREV_HSIZE_OFFSET			16
> +#define ISI_PREV_HSIZE_SIZE			10
> +
> +/* Bitfields in PSIZE(ISI_V2) */
> +#define ISI_V2_PREV_VSIZE_OFFSET		0
> +#define ISI_V2_PREV_VSIZE_SIZE			10
> +#define ISI_V2_PREV_HSIZE_OFFSET		16
> +#define ISI_V2_PREV_HSIZE_SIZE			10
> +
> +/* Bitfields in PCDEF */
> +#define ISI_DEC_FACTOR_OFFSET			0
> +#define ISI_DEC_FACTOR_SIZE			8
> +
> +/* Bitfields in PCDEF */
> +#define ISI_V2_DEC_FACTOR_OFFSET		0
> +#define ISI_V2_DEC_FACTOR_SIZE			8
> +
> +/* Bitfields in PPFBD */
> +#define ISI_PREV_FBD_ADDR_OFFSET		0
> +#define ISI_PREV_FBD_ADDR_SIZE			32
> +
> +/* Bitfields in CDBA */
> +#define ISI_CODEC_DMA_ADDR_OFFSET		0
> +#define ISI_CODEC_DMA_ADDR_SIZE			32
> +
> +/* Bitfields in DMA_C_ADDR */
> +#define ISI_V2_DMA_ADDR_OFFSET			0
> +#define ISI_V2_DMA_ADDR_SIZE			32
> +
> +/* Bitfields in DMA_C_CTRL & in DMA_P_CTRL */
> +#define ISI_V2_DMA_FETCH_OFFSET			0
> +#define ISI_V2_DMA_FETCH_SIZE			1
> +#define ISI_V2_DMA_WB_OFFSET			1
> +#define ISI_V2_DMA_WB_SIZE			1
> +#define ISI_V2_DMA_IEN_OFFSET			2
> +#define ISI_V2_DMA_IEN_SIZE			1
> +#define ISI_V2_DMA_DONE_OFFSET			3
> +#define ISI_V2_DMA_DONE_SIZE			1
> +
> +/* Bitfields in DMA_CHER */
> +#define ISI_V2_DMA_P_CH_EN_OFFSET		0
> +#define ISI_V2_DMA_P_CH_EN_SIZE			1
> +#define ISI_V2_DMA_C_CH_EN_OFFSET		1
> +#define ISI_V2_DMA_C_CH_EN_SIZE			1
> +
> +/* Bitfields in Y2R_SET0 */
> +#define ISI_Y2R_SET0_C3_OFFSET			24
> +#define ISI_Y2R_SET0_C3_SIZE			8
> +
> +/* Bitfields in Y2R_SET0(ISI_V2) */
> +#define ISI_V2_Y2R_SET0_C3_OFFSET		24
> +#define ISI_V2_Y2R_SET0_C3_SIZE			8
> +
> +/* Bitfields in Y2R_SET1 */
> +#define ISI_Y2R_SET1_C4_OFFSET			0
> +#define ISI_Y2R_SET1_C4_SIZE			9
> +#define ISI_YOFF_OFFSET				12
> +#define ISI_YOFF_SIZE				1
> +#define ISI_CROFF_OFFSET			13
> +#define ISI_CROFF_SIZE				1
> +#define ISI_CBOFF_OFFSET			14
> +#define ISI_CBOFF_SIZE				1
> +
> +/* Bitfields in Y2R_SET1(ISI_V2) */
> +#define ISI_V2_Y2R_SET1_C4_OFFSET		0
> +#define ISI_V2_Y2R_SET1_C4_SIZE			9
> +#define ISI_V2_YOFF_OFFSET			12
> +#define ISI_V2_YOFF_SIZE			1
> +#define ISI_V2_CROFF_OFFSET			13
> +#define ISI_V2_CROFF_SIZE			1
> +#define ISI_V2_CBOFF_OFFSET			14
> +#define ISI_V2_CBOFF_SIZE			1
> +
> +/* Bitfields in R2Y_SET0 */
> +#define ISI_C0_OFFSET				0
> +#define ISI_C0_SIZE				8
> +#define ISI_C1_OFFSET				8
> +#define ISI_C1_SIZE				8
> +#define ISI_C2_OFFSET				16
> +#define ISI_C2_SIZE				8
> +#define ISI_ROFF_OFFSET				24
> +#define ISI_ROFF_SIZE				1
> +
> +/* Bitfields in R2Y_SET0(ISI_V2) */
> +#define ISI_V2_C0_OFFSET			0
> +#define ISI_V2_C0_SIZE				8
> +#define ISI_V2_C1_OFFSET			8
> +#define ISI_V2_C1_SIZE				8
> +#define ISI_V2_C2_OFFSET			16
> +#define ISI_V2_C2_SIZE				8
> +#define ISI_V2_ROFF_OFFSET			24
> +#define ISI_V2_ROFF_SIZE			1
> +
> +/* Bitfields in R2Y_SET1 */
> +#define ISI_R2Y_SET1_C3_OFFSET			0
> +#define ISI_R2Y_SET1_C3_SIZE			8
> +#define ISI_R2Y_SET1_C4_OFFSET			8
> +#define ISI_R2Y_SET1_C4_SIZE			8
> +#define ISI_C5_OFFSET				16
> +#define ISI_C5_SIZE				8
> +#define ISI_GOFF_OFFSET				24
> +#define ISI_GOFF_SIZE				1
> +
> +/* Bitfields in R2Y_SET1(ISI_V2) */
> +#define ISI_V2_R2Y_SET1_C3_OFFSET		0
> +#define ISI_V2_R2Y_SET1_C3_SIZE			8
> +#define ISI_V2_R2Y_SET1_C4_OFFSET		8
> +#define ISI_V2_R2Y_SET1_C4_SIZE			8
> +#define ISI_V2_C5_OFFSET			16
> +#define ISI_V2_C5_SIZE				8
> +#define ISI_V2_GOFF_OFFSET			24
> +#define ISI_V2_GOFF_SIZE			1
> +
> +/* Bitfields in R2Y_SET2 */
> +#define ISI_C6_OFFSET				0
> +#define ISI_C6_SIZE				8
> +#define ISI_C7_OFFSET				8
> +#define ISI_C7_SIZE				8
> +#define ISI_C8_OFFSET				16
> +#define ISI_C8_SIZE				8
> +#define ISI_BOFF_OFFSET				24
> +#define ISI_BOFF_SIZE				1
> +
> +/* Bitfields in R2Y_SET2(ISI_V2) */
> +#define ISI_V2_C6_OFFSET			0
> +#define ISI_V2_C6_SIZE				8
> +#define ISI_V2_C7_OFFSET			8
> +#define ISI_V2_C7_SIZE				8
> +#define ISI_V2_C8_OFFSET			16
> +#define ISI_V2_C8_SIZE				8
> +#define ISI_V2_BOFF_OFFSET			24
> +#define ISI_V2_BOFF_SIZE			1
> +
> +/* Constants for FRATE */
> +#define ISI_FRATE_CAPTURE_ALL			0
> +
> +/* Constants for FRATE(ISI_V2) */
> +#define ISI_V2_FRATE_CAPTURE_ALL		0
> +
> +/* Constants for YCC_SWAP */
> +#define ISI_YCC_SWAP_DEFAULT			0
> +#define ISI_YCC_SWAP_MODE_1			1
> +#define ISI_YCC_SWAP_MODE_2			2
> +#define ISI_YCC_SWAP_MODE_3			3
> +
> +/* Constants for YCC_SWAP(ISI_V2) */
> +#define ISI_V2_YCC_SWAP_DEFAULT			0
> +#define ISI_V2_YCC_SWAP_MODE_1			1
> +#define ISI_V2_YCC_SWAP_MODE_2			2
> +#define ISI_V2_YCC_SWAP_MODE_3			3
> +
> +/* Constants for RGB_CFG */
> +#define ISI_RGB_CFG_DEFAULT			0
> +#define ISI_RGB_CFG_MODE_1			1
> +#define ISI_RGB_CFG_MODE_2			2
> +#define ISI_RGB_CFG_MODE_3			3
> +
> +/* Constants for RGB_CFG(ISI_V2) */
> +#define ISI_V2_RGB_CFG_DEFAULT			0
> +#define ISI_V2_RGB_CFG_MODE_1			1
> +#define ISI_V2_RGB_CFG_MODE_2			2
> +#define ISI_V2_RGB_CFG_MODE_3			3
> +

Let's see if we can get rid of these without cluttering the driver too 
much. The idea would be to use full register names in the code and use 
inlines instead of macros, as also others have suggested. In any case all 
these accessors, whether as macros or as inlines can and should fo into 
the driver .c file.

> +/* Bit manipulation macros */
> +#define ISI_BIT(name)					\
> +	(1 << ISI_##name##_OFFSET)

This macro is used quite a lot, but it only uses the *_OFFSET to the 
bitfield.

> +#define ISI_BF(name, value)				\
> +	(((value) & ((1 << ISI_##name##_SIZE) - 1))	\
> +	 << ISI_##name##_OFFSET)
> +#define ISI_BFEXT(name, value)				\
> +	(((value) >> ISI_##name##_OFFSET)		\
> +	 & ((1 << ISI_##name##_SIZE) - 1))

This one is not used at all. Please, remove.

> +#define ISI_BFINS(name, value, old)			\
> +	(((old) & ~(((1 << ISI_##name##_SIZE) - 1)	\
> +		    << ISI_##name##_OFFSET))\
> +	 | ISI_BF(name, value))

This one is only used twice, would be easy to convert.

Ok, put it this way: I will not be the one, who will block this driver just 
because of these macros. It would be nicer to replace them with inlines, 
but this doesn't look like a serious enough issue for me. At least, please, 
move them to the .c file and remove unused ones.

> +
> +/* Register access macros */
> +#define isi_readl(port, reg)				\
> +	__raw_readl((port)->regs + ISI_##reg)
> +#define isi_writel(port, reg, value)			\
> +	__raw_writel((value), (port)->regs + ISI_##reg)

Same for these two: inlines would be nicer, but I won't fight. At least 
move them to the .c.

> +
> +#define ATMEL_V4L2_VID_FLAGS (V4L2_CAP_VIDEO_OUTPUT)

??? What is this macro for? and it is never used. Please, remove.

> +
> +struct atmel_isi;

Seems unneeded.

> +
> +enum atmel_isi_pixfmt {
> +	ATMEL_ISI_PIXFMT_GREY,		/* Greyscale */
> +	ATMEL_ISI_PIXFMT_CbYCrY,
> +	ATMEL_ISI_PIXFMT_CrYCbY,
> +	ATMEL_ISI_PIXFMT_YCbYCr,
> +	ATMEL_ISI_PIXFMT_YCrYCb,
> +	ATMEL_ISI_PIXFMT_RGB24,
> +	ATMEL_ISI_PIXFMT_BGR24,
> +	ATMEL_ISI_PIXFMT_RGB16,
> +	ATMEL_ISI_PIXFMT_BGR16,
> +	ATMEL_ISI_PIXFMT_GRB16,		/* G[2:0] R[4:0]/B[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_GBR16,		/* G[2:0] B[4:0]/R[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_RGB24_REV,
> +	ATMEL_ISI_PIXFMT_BGR24_REV,
> +	ATMEL_ISI_PIXFMT_RGB16_REV,
> +	ATMEL_ISI_PIXFMT_BGR16_REV,
> +	ATMEL_ISI_PIXFMT_GRB16_REV,	/* G[2:0] R[4:0]/B[4:0] G[5:3] */
> +	ATMEL_ISI_PIXFMT_GBR16_REV,	/* G[2:0] B[4:0]/R[4:0] G[5:3] */
> +};

Huh... none of these are used. Please, remove.

> +
> +struct isi_platform_data {
> +	u8 has_emb_sync;
> +	u8 emb_crc_sync;
> +	u8 hsync_act_low;
> +	u8 vsync_act_low;
> +	u8 pclk_act_falling;
> +	u8 isi_full_mode;
> +#define ISI_HSYNC_ACT_LOW	0x01
> +#define ISI_VSYNC_ACT_LOW	0x02
> +#define ISI_PXCLK_ACT_FALLING	0x04
> +#define ISI_EMB_SYNC		0x08
> +#define ISI_CRC_SYNC		0x10
> +#define ISI_FULL		0x20
> +#define ISI_DATAWIDTH_8		0x40
> +#define ISI_DATAWIDTH_10	0x80
> +	u32 flags;
> +	u8 gs_mode;
> +#define ISI_GS_2PIX_PER_WORD	0x00
> +#define ISI_GS_1PIX_PER_WORD	0x01
> +	u8 pixfmt;
> +	u8 sfd;
> +	u8 sld;
> +	u8 thmask;
> +#define ISI_BURST_4_8_16	0x00
> +#define ISI_BURST_8_16		0x01
> +#define ISI_BURST_16		0x02
> +	u8 frate;
> +#define ISI_FRATE_DIV_2		0x01
> +#define ISI_FRATE_DIV_3		0x02
> +#define ISI_FRATE_DIV_4		0x03
> +#define ISI_FRATE_DIV_5		0x04
> +#define ISI_FRATE_DIV_6		0x05
> +#define ISI_FRATE_DIV_7		0x06
> +#define ISI_FRATE_DIV_8		0x07
> +};

This is the only struct, that is needed in your external header, please, 
put it in include/media/atmel-isi.h or similar. And you'll have to 
#include <linux/types.h> in it.

> +
> +#endif /* __AT91_ISI_H__ */
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index d61414e..eae6005 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -80,6 +80,16 @@ menuconfig VIDEO_CAPTURE_DRIVERS
>  	  Some of those devices also supports FM radio.
>  
>  if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
> +config VIDEO_ATMEL_ISI
> +	tristate "ATMEL Image Sensor Interface (ISI) support"
> +	depends on VIDEO_DEV && SOC_CAMERA

Other reviewers asked you to add a dependency on AT91 / AVR32. At the first 
glance your driver doesn't have any arch dependencies, which is good! I.e., 
it should compile on any platform (even if it won't work;)). So, I would 
verify this, just try to compile it in a x86 config. If this is possible - 
please, keep it arch-independent to allow for broad and easy
compile-testing.

But you probably need a couple more depends: HAVE_CLK and, maybe, HAS_DMA?

> +	select VIDEOBUF2_DMA_CONTIG
> +	default n
> +	---help---
> +	  This module makes the ATMEL Image Sensor Interface available
> +	  as a v4l2 device.
> +	  Say Y here to enable selecting the Image Sensor Interface.
> +	  When in doubt, say N.

I would drop the last two lines. The "doubt" statement makes sense for 
generic options, where you can have doubts:) For specific hardware drivers 
you usually know, whether you have them and need drivers for them.

>  
>  config VIDEO_ADV_DEBUG
>  	bool "Enable advanced debug functionality"
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a10e4c3..f734a65 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -166,6 +166,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/

[OT] hm, wow, who has decided to put a generic V4L driver (set) in the 
Makefile together with other soc-camera drivers? It has to be converted now;)

> +obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>  
>  obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
>  
> diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
> new file mode 100644
> index 0000000..33d0b83
> --- /dev/null
> +++ b/drivers/media/video/atmel-isi.c
> @@ -0,0 +1,1089 @@
> +/*
> + * Copyright (c) 2011 Atmel Corporation

Same: Author / email would be nice.

> + *
> + * Based on previous work by Lars Haring and Sedji Gaouaou
> + *
> + * Based on the bttv driver for Bt848 with respective copyright holders
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/completion.h>

completion unused.

> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>

moduleparam unused

> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/version.h>

Maybe unused, if you remove KERNEL_VERSION.

> +#include <linux/kfifo.h>

Probably unused

> +
> +#include <mach/board.h>
> +#include <mach/cpu.h>

Why do you need these two?

> +#include <mach/at91_isi.h>
> +
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/soc_camera.h>
> +#include <media/soc_mediabus.h>
> +
> +#define ATMEL_ISI_VERSION	KERNEL_VERSION(1, 0, 0)

Some suggested removing this. Well, you have to put something into 
cap->version, and other drivers do this. So, I don't mind that much.

> +#define MAX_BUFFER_NUMS		32
> +#define MAX_SUPPORT_WIDTH	2048
> +#define MAX_SUPPORT_HEIGHT	2048
> +
> +static unsigned int vid_limit = 16;

As someone pointed out: only used once, is constant, a macro would do.

> +
> +enum isi_buffer_state {
> +	ISI_BUF_NEEDS_INIT,
> +	ISI_BUF_PREPARED,
> +};

You only verify your buffer state once: in your .buf_prepare(). I think, 
you can just remove these.

> +
> +/* Single frame capturing states */
> +enum {
> +	STATE_IDLE = 0,
> +	STATE_CAPTURE_READY,
> +	STATE_CAPTURE_WAIT_SOF,
> +	STATE_CAPTURE_IN_PROGRESS,
> +	STATE_CAPTURE_DONE,
> +	STATE_CAPTURE_ERROR,
> +};

V4L2 doesn't support still image capture yet, and in your it is just a 
dummy, probably, left over from earlier versions, that implemented it, 
using proprietary ioctl()s. Good, that you removed those, now, please, 
also remove all traces of the still image mode. If these states are only 
needed for it, they should be removed too. They seem to be used for normal 
streaming too, then the comment should be changed.

> +
> +/* Frame buffer descriptor
> + *  Used by the ISI module as a linked list for the DMA controller.
> + */
> +struct fbd {
> +	/* Physical address of the frame buffer */
> +	u32 fb_address;
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)
> +	/* DMA Control Register(only in HISI2) */
> +	u32 dma_ctrl;
> +#endif

As others have pointed out - there's nothing special in these dma_ctrl 
fields, #ifd's should be just removed.

> +	/* Physical address of the next fbd */
> +	u32 next_fbd_address;
> +};
> +
> +#if defined(CONFIG_ARCH_AT91SAM9G45) ||\
> +	defined(CONFIG_ARCH_AT91SAM9X5)

ditto

> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl)
> +{
> +	fb_desc->dma_ctrl = ctrl;
> +}
> +#else
> +static void set_dma_ctrl(struct fbd *fb_desc, u32 ctrl) { }
> +#endif
> +
> +/* Frame buffer data
> + */
> +struct frame_buffer {
> +	struct vb2_buffer vb;
> +	struct fbd fb_desc;
> +	/* Frame number of the frame  */
> +	unsigned long sequence;

This "sequence" seems to be unused. Please, remove.

> +
> +	enum isi_buffer_state dma_desc_status;

This will go, I think.

> +	struct list_head list;
> +};
> +
> +struct atmel_isi {
> +	/* ISI module spin lock. Protects against concurrent access of variables
> +	 * that are shared with the ISR */

multiline comment style.

> +	spinlock_t			lock;
> +	void __iomem			*regs;
> +
> +	/*  If set ISI is in still capture mode */
> +	int				still_capture;

please, remove.

> +	int				sequence;
> +	/* State of the ISI module in capturing mode */
> +	int				state;
> +
> +	/* Capture/streaming wait queue for waiting for SOF */
> +	wait_queue_head_t		capture_wq;
> +
> +	struct v4l2_device		v4l2_dev;

Unneeded. Remove.

> +
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +
> +	struct clk			*pclk;
> +	struct platform_device		*pdev;

Seems unused.

> +	unsigned int			irq;
> +
> +	struct isi_platform_data	*pdata;
> +	unsigned long			platform_flags;
> +
> +	struct list_head		video_buffer_list;
> +	struct frame_buffer		*active;
> +
> +	struct soc_camera_device	*icd;
> +	struct soc_camera_host		soc_host;
> +};
> +
> +static int configure_geometry(struct atmel_isi *isi, u32 width,
> +			u32 height, enum v4l2_mbus_pixelcode code)
> +{
> +	u32 cfg2, cr, ctrl;
> +
> +	cr = 0;

initialisation superfluous.

> +	switch (code) {
> +	/* YUV, including grey */
> +	case V4L2_MBUS_FMT_Y8_1X8:
> +		cr = ISI_BIT(GRAYSCALE);
> +		break;
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 3);
> +		break;
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 2);
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 1);
> +		break;
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		cr = ISI_BF(V2_YCC_SWAP, 0);
> +		break;
> +	/* RGB, TODO */
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ctrl = ISI_BIT(DIS);
> +	isi_writel(isi, V2_CTRL, ctrl);
> +	/* Check if module properly disable */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS_DONE))
> +		cpu_relax();

As others pointed out - busy loops are better with a timeout / a counter.

> +
> +	cfg2 = isi_readl(isi, V2_CFG2);
> +	cfg2 |= cr;
> +	cfg2 = ISI_BFINS(V2_IM_VSIZE, height - 1, cfg2);
> +	cfg2 = ISI_BFINS(V2_IM_HSIZE, width - 1, cfg2);
> +	isi_writel(isi, V2_CFG2, cfg2);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
> +{
> +	if (isi->active) {
> +		struct vb2_buffer *vb = &isi->active->vb;
> +		struct frame_buffer *buf = isi->active;
> +
> +		list_del_init(&buf->list);
> +		do_gettimeofday(&vb->v4l2_buf.timestamp);
> +		vb->v4l2_buf.sequence = isi->sequence++;
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +	}
> +
> +	if (list_empty(&isi->video_buffer_list)) {
> +		isi->active = NULL;
> +	} else {
> +		/* start next dma frame. */
> +		isi->active = list_entry(isi->video_buffer_list.next,
> +					struct frame_buffer, list);
> +		isi_writel(isi, V2_DMA_C_DSCR, (__pa(&(isi->active->fb_desc))));

Ouch... No __pa(), please. Use proper remapping.

> +		isi_writel(isi, V2_DMA_C_CTRL,
> +			ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_DONE));
> +		isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +/* ISI interrupt service routine */
> +static irqreturn_t isi_interrupt(int irq, void *dev_id)
> +{
> +	struct atmel_isi *isi = dev_id;
> +	u32 status, mask, pending;
> +	irqreturn_t ret = IRQ_NONE;
> +
> +	spin_lock(&isi->lock);
> +
> +	status = isi_readl(isi, V2_STATUS);
> +	mask = isi_readl(isi, V2_INTMASK);
> +	pending = status & mask;
> +
> +	if (!isi->still_capture) {
> +		if (pending & (ISI_BIT(V2_VSYNC))) {
> +			switch (isi->state) {
> +			case STATE_IDLE:
> +				isi->state = STATE_CAPTURE_READY;
> +				wake_up_interruptible(&isi->capture_wq);
> +				break;
> +			}
> +		} else if (likely(pending & (ISI_BIT(V2_CXFR_DONE)))) {
> +			ret = atmel_isi_handle_streaming(isi);
> +		}
> +	} else {

This whole case should go - snapshot is not supported.

> +		while (pending) {
> +			if (pending & (ISI_BIT(V2_C_OVR) | ISI_BIT(V2_FR_OVR)))
> +				printk(KERN_ERR "Overrun (status = 0x%x)\n",
> +					status);
> +			else if (pending &
> +				(ISI_BIT(V2_VSYNC) | ISI_BIT(V2_CDC))) {
> +				switch (isi->state) {
> +				case STATE_IDLE:
> +					isi->state = STATE_CAPTURE_READY;
> +					wake_up_interruptible(&isi->capture_wq);
> +					break;
> +				case STATE_CAPTURE_READY:
> +					break;

Just omit this case.

> +				case STATE_CAPTURE_WAIT_SOF:
> +					isi->state = STATE_CAPTURE_IN_PROGRESS;
> +					break;
> +				}
> +			}
> +
> +			if (likely(pending & (ISI_BIT(V2_CXFR_DONE))))
> +				ret = atmel_isi_handle_streaming(isi);
> +
> +			status = isi_readl(isi, V2_STATUS);
> +			mask = isi_readl(isi, V2_INTMASK);
> +			pending = status & mask;
> +			ret = IRQ_HANDLED;
> +		}
> +	}
> +	spin_unlock(&isi->lock);
> +
> +	return ret;
> +}
> +
> +static int atmel_isi_init(struct atmel_isi *isi)
> +{
> +	/*
> +	 * The reset will only succeed if we have a
> +	 * pixel clock from the camera.
> +	 */

And what happens if you don't?

> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_SRST));
> +	isi_writel(isi, V2_INTDIS, ~0UL);
> +
> +	return 0;

It cannot fail, so, make it void.

> +}
> +
> +/* ------------------------------------------------------------------
> +	Videobuf operations
> +   ------------------------------------------------------------------*/
> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +				unsigned int *nplanes, unsigned long sizes[],
> +				void *alloc_ctxs[])
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *dev = ici->priv;
> +	unsigned long size;
> +
> +	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (0 == *nbuffers)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +	if (*nbuffers > MAX_BUFFER_NUMS)
> +		*nbuffers = MAX_BUFFER_NUMS;
> +
> +	while (size * *nbuffers > vid_limit * 1024 * 1024)
> +		(*nbuffers)--;

Please, use a division.

> +
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = dev->alloc_ctx;
> +
> +	dev->sequence = 0;
> +	dev->active = NULL;
> +
> +	dev_dbg(icd->dev.parent, "%s, count=%d, size=%ld\n", __func__,
> +		*nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static int buffer_init(struct vb2_buffer *vb)
> +{
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +
> +	buf->dma_desc_status = ISI_BUF_NEEDS_INIT;
> +	INIT_LIST_HEAD(&buf->list);
> +
> +	return 0;
> +}
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	unsigned long size;
> +	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	size = bytes_per_line * icd->user_height;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(icd->dev.parent, "%s data will not fit into plane (%lu < %lu)\n",
> +				__func__, vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(&buf->vb, 0, size);
> +
> +	if (buf->dma_desc_status == ISI_BUF_NEEDS_INIT) {
> +		buf->dma_desc_status = ISI_BUF_PREPARED;
> +
> +		/* initialize the dma descriptor */
> +		buf->fb_desc.fb_address = vb2_dma_contig_plane_paddr(vb, 0);
> +		buf->fb_desc.next_fbd_address = 0;
> +		set_dma_ctrl(&buf->fb_desc, ISI_BIT(V2_DMA_WB));

This your descriptor: you either have to allocate it yourself in 
.buf_init(), using dma_alloc_coherent(), and free in .buf_cleanup(), 
using dma_free_coherent(), or you could try to calculate .sizeimage on your 
own, adding the size of your descriptor with required alignment, and rely 
on the DMA contiguous buffer allocator to allocate the extra space for you, 
and then just calculate offset to it.

An interesting question is also: have you really tested it with USERPTR? If 
not, maybe it's better to also drop that capability from the driver for now.

> +	}
> +
> +	return 0;
> +}
> +
> +static int buffer_finish(struct vb2_buffer *vb)
> +{
> +	return 0;
> +}

Don't think you need this one.

> +
> +static void buffer_cleanup(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	unsigned long flags = 0;

No need to initialise.

> +
> +	spin_lock_irqsave(&isi->lock, flags);
> +	buf->dma_desc_status = ISI_BUF_NEEDS_INIT;
> +	spin_unlock_irqrestore(&isi->lock, flags);

This seems bogus... Hope, .dma_desc_status will disappear completely.

> +}
> +
> +static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
> +{
> +	u32 ctrl, cfg1;
> +	ctrl = isi_readl(isi, V2_CTRL);
> +	cfg1 = isi_readl(isi, V2_CFG1);
> +	/* Enable irq: cxfr for the codec path, pxfr for the preview path */
> +	isi_writel(isi, V2_INTEN,
> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
> +
> +	/* Enable codec path */
> +	ctrl |= ISI_BIT(V2_CDC);
> +	/* Check if already in a frame */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
> +		cpu_relax();

Again - don't run endlessly, especially under spin_lock_irqsave()...

> +
> +	/* Write the address of the first frame buffer in the C_ADDR reg
> +	* write the address of the first descriptor(link list of buffer)
> +	* in the C_DSCR reg, and enable dma channel.
> +	*/
> +	isi_writel(isi, V2_DMA_C_DSCR, (__pa(&(buffer->fb_desc))));

Use remapping

> +	isi_writel(isi, V2_DMA_C_CTRL,
> +			ISI_BIT(V2_DMA_FETCH) | ISI_BIT(V2_DMA_DONE));
> +	isi_writel(isi, V2_DMA_CHER, ISI_BIT(V2_DMA_C_CH_EN));
> +
> +	/* Enable linked list */
> +	cfg1 |= ISI_BF(V2_FRATE, isi->pdata->frate) | ISI_BIT(V2_DISCR);
> +
> +	/* Enable ISI module*/
> +	ctrl |= ISI_BIT(V2_ENABLE);
> +	isi_writel(isi, V2_CTRL, ctrl);
> +	isi_writel(isi, V2_CFG1, cfg1);
> +}
> +
> +static void buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct frame_buffer *buf = container_of(vb, struct frame_buffer, vb);
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&isi->lock, flags);
> +	list_add_tail(&buf->list, &isi->video_buffer_list);
> +
> +	if (isi->active == NULL) {
> +		isi->active = buf;
> +		start_dma(isi, buf);
> +	}
> +	spin_unlock_irqrestore(&isi->lock, flags);
> +}
> +
> +static int start_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	u32 sr = 0;
> +	int ret;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->state = STATE_IDLE;
> +
> +	/* Clear any pending SOF interrupt */
> +	sr = isi_readl(isi, V2_STATUS);
> +	/* Enable VSYNC interrupt for SOF */
> +	isi_writel(isi, V2_INTEN, ISI_BIT(V2_VSYNC));
> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_EN));
> +
> +	spin_unlock_irq(&isi->lock);
> +	dev_dbg(icd->dev.parent, "isi: waiting for SOF\n");
> +	ret = wait_event_interruptible(isi->capture_wq,
> +				       isi->state != STATE_IDLE);
> +	if (ret)
> +		return ret;
> +
> +	if (isi->state != STATE_CAPTURE_READY)
> +		return -EIO;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->state = STATE_CAPTURE_WAIT_SOF;
> +	isi_writel(isi, V2_INTDIS, ISI_BIT(V2_VSYNC));
> +	spin_unlock_irq(&isi->lock);
> +
> +	return 0;
> +}
> +
> +/* abort streaming and wait for last buffer */
> +static int stop_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	spin_lock_irq(&isi->lock);
> +	isi->still_capture = 0;
> +	isi->active = NULL;
> +
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_CDC))
> +		cpu_relax();

timeout / counter - under spinlock...

> +
> +	/* Disble codec path */
> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) & (~ISI_BIT(V2_CDC)));
> +	/* Disable interrupts */
> +	isi_writel(isi, V2_INTDIS,
> +			ISI_BIT(V2_CXFR_DONE) | ISI_BIT(V2_PXFR_DONE));
> +	/* Disable ISI module*/
> +	isi_writel(isi, V2_CTRL, isi_readl(isi, V2_CTRL) | ISI_BIT(V2_DIS));
> +
> +	/* Release all active buffers */
> +	while (!list_empty(&isi->video_buffer_list)) {

Use some kind of list_for_each(_entry)_safe()?

> +		struct frame_buffer *buf;
> +		buf = list_entry(isi->video_buffer_list.next,
> +				struct frame_buffer, list);
> +		list_del_init(&buf->list);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	spin_unlock_irq(&isi->lock);
> +	return 0;
> +}
> +
> +static struct vb2_ops isi_video_qops = {
> +	.queue_setup		= queue_setup,
> +	.buf_init		= buffer_init,
> +	.buf_prepare		= buffer_prepare,
> +	.buf_finish		= buffer_finish,
> +	.buf_cleanup		= buffer_cleanup,
> +	.buf_queue		= buffer_queue,
> +	.start_streaming	= start_streaming,
> +	.stop_streaming		= stop_streaming,
> +	.wait_prepare		= soc_camera_unlock,
> +	.wait_finish		= soc_camera_lock,
> +};
> +
> +/* ------------------------------------------------------------------
> +	SOC camera operations for the device
> +   ------------------------------------------------------------------*/
> +static int isi_camera_init_videobuf(struct vb2_queue *q,
> +				     struct soc_camera_device *icd)
> +{
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;

I don't think VB2_READ makes sense there.

> +	q->drv_priv = icd;
> +	q->buf_struct_size = sizeof(struct frame_buffer);
> +	q->ops = &isi_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +
> +	return vb2_queue_init(q);
> +}
> +static inline void stride_align(u32 *width)
> +{
> +	if (((*width + 7) &  ~7) < 4096)
> +		*width = (*width + 7) &  ~7;

Use ALIGN(*width, 8). Yes, mx3_camera.c should do the same;) But do you 
actually need 8-byte width alignment?

> +	else
> +		*width = *width &  ~7;
> +}
> +
> +static int isi_camera_set_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	int ret;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> +	if (!xlate) {
> +		dev_warn(icd->dev.parent, "Format %x not found\n",
> +			 pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	stride_align(&pix->width);
> +	dev_dbg(icd->dev.parent, "plan to set format %dx%d\n",
> +			pix->width, pix->height);
> +
> +	mf.width	= pix->width;
> +	mf.height	= pix->height;
> +	mf.field	= pix->field;
> +	mf.colorspace	= pix->colorspace;
> +	mf.code		= xlate->code;
> +
> +	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (mf.code != xlate->code)
> +		return -EINVAL;
> +
> +	ret = configure_geometry(isi, pix->width, pix->height, xlate->code);
> +	if (ret < 0)
> +		return ret;
> +
> +	pix->width		= mf.width;
> +	pix->height		= mf.height;
> +	pix->field		= mf.field;
> +	pix->colorspace		= mf.colorspace;
> +	icd->current_fmt	= xlate;
> +
> +	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
> +						    xlate->host_fmt);
> +	if (pix->bytesperline < 0)
> +		return pix->bytesperline;
> +	pix->sizeimage = pix->height * pix->bytesperline;

.bytesperline and .sizeimage should be calculated automatically as of 
commit b12795e1dd07e0fc3cb1030b4860d0a4e1c17e87 (in next).

> +
> +	dev_dbg(icd->dev.parent, "Finally set format %dx%d, sizeimage = %d\n",
> +		pix->width, pix->height, pix->sizeimage);
> +
> +	return ret;
> +}
> +
> +static int isi_camera_try_fmt(struct soc_camera_device *icd,
> +			      struct v4l2_format *f)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	__u32 pixfmt = pix->pixelformat;
> +	int ret;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (pixfmt && !xlate) {
> +		dev_warn(icd->dev.parent, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
> +	}
> +
> +	/* limit to Atmel ISI hardware capabilities */
> +	if (pix->height > MAX_SUPPORT_HEIGHT)
> +		pix->height = MAX_SUPPORT_HEIGHT;
> +	if (pix->width > MAX_SUPPORT_WIDTH)
> +		pix->width = MAX_SUPPORT_WIDTH;
> +
> +	pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
> +						    xlate->host_fmt);
> +	if (pix->bytesperline < 0)
> +		return pix->bytesperline;
> +	pix->sizeimage = pix->height * pix->bytesperline;

No need for ->bytesperline and ->sizeimage either.

> +
> +	/* limit to sensor capabilities */
> +	mf.width	= pix->width;
> +	mf.height	= pix->height;
> +	mf.field	= pix->field;
> +	mf.colorspace	= pix->colorspace;
> +	mf.code		= xlate->code;
> +
> +	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	pix->width	= mf.width;
> +	pix->height	= mf.height;
> +	pix->colorspace	= mf.colorspace;
> +
> +	switch (mf.field) {
> +	case V4L2_FIELD_ANY:
> +		pix->field = V4L2_FIELD_NONE;
> +		break;
> +	case V4L2_FIELD_NONE:
> +		break;
> +	default:
> +		dev_err(icd->dev.parent, "Field type %d unsupported.\n",
> +			mf.field);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "Packed YUV422 16 bit",
> +		.bits_per_sample	= 8,
> +		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +};
> +
> +/* This will be corrected as we get more formats */
> +static bool isi_camera_packing_supported(const struct soc_mbus_pixelfmt *fmt)
> +{
> +	return	fmt->packing == SOC_MBUS_PACKING_NONE ||
> +		(fmt->bits_per_sample == 8 &&
> +		 fmt->packing == SOC_MBUS_PACKING_2X8_PADHI) ||
> +		(fmt->bits_per_sample > 8 &&
> +		 fmt->packing == SOC_MBUS_PACKING_EXTEND16);
> +}
> +
> +static int test_platform_param(struct atmel_isi *isi,
> +			       unsigned char buswidth, unsigned long *flags)
> +{
> +	/*
> +	 * Platform specified synchronization and pixel clock polarities are
> +	 * only a recommendation and are only used during probing. Atmel ISI
> +	 * camera interface only works in master mode, i.e., uses HSYNC and
> +	 * VSYNC signals from the sensor
> +	 */
> +	*flags = SOCAM_MASTER |
> +		SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_HSYNC_ACTIVE_LOW |
> +		SOCAM_VSYNC_ACTIVE_HIGH |
> +		SOCAM_VSYNC_ACTIVE_LOW |
> +		SOCAM_PCLK_SAMPLE_RISING |
> +		SOCAM_PCLK_SAMPLE_FALLING |
> +		SOCAM_DATA_ACTIVE_HIGH;
> +
> +	/* If requested data width is supported by the platform, use it */
> +	switch (buswidth) {
> +	case 10:
> +		if (!(isi->platform_flags & ISI_DATAWIDTH_10))
> +			return -EINVAL;
> +		*flags |= SOCAM_DATAWIDTH_10;
> +		break;
> +	case 8:
> +		if (!(isi->platform_flags & ISI_DATAWIDTH_8))
> +			return -EINVAL;
> +		*flags |= SOCAM_DATAWIDTH_8;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int isi_camera_try_bus_param(struct soc_camera_device *icd,
> +				    unsigned char buswidth)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long bus_flags, camera_flags;
> +	int ret = test_platform_param(isi, buswidth, &bus_flags);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	camera_flags = icd->ops->query_bus_param(icd);
> +
> +	ret = soc_camera_bus_param_compatible(camera_flags, bus_flags);
> +	if (!ret)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +
> +static int isi_camera_get_formats(struct soc_camera_device *icd,
> +				  unsigned int idx,
> +				  struct soc_camera_format_xlate *xlate)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct device *dev = icd->dev.parent;
> +	int formats = 0, ret;
> +	/* sensor format */
> +	enum v4l2_mbus_pixelcode code;
> +	/* soc camera host format */
> +	const struct soc_mbus_pixelfmt *fmt;
> +
> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
> +	if (ret < 0)
> +		/* No more formats */
> +		return 0;
> +
> +	fmt = soc_mbus_get_fmtdesc(code);
> +	if (!fmt) {
> +		dev_err(icd->dev.parent,
> +			"Invalid format code #%u: %d\n", idx, code);
> +		return 0;
> +	}
> +
> +	/* This also checks support for the requested bits-per-sample */
> +	ret = isi_camera_try_bus_param(icd, fmt->bits_per_sample);
> +	if (ret < 0) {
> +		dev_err(icd->dev.parent,
> +			"Fail to try the bus parameters.\n");
> +		return 0;
> +	}
> +
> +	switch (code) {
> +	case V4L2_MBUS_FMT_UYVY8_2X8:
> +	case V4L2_MBUS_FMT_VYUY8_2X8:
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +	case V4L2_MBUS_FMT_YVYU8_2X8:
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt	= &isi_camera_formats[0];
> +			xlate->code	= code;
> +			xlate++;
> +			dev_dbg(icd->dev.parent, "Providing format %s using code %d\n",
> +				isi_camera_formats[0].name, code);
> +		}
> +		break;
> +	default:
> +		if (!isi_camera_packing_supported(fmt))
> +			return 0;
> +		if (xlate)
> +			dev_dbg(dev,
> +				"Providing format %s in pass-through mode\n",
> +				fmt->name);
> +	}
> +
> +	/* Generic pass-through */
> +	formats++;
> +	if (xlate) {
> +		xlate->host_fmt	= fmt;
> +		xlate->code	= code;
> +		xlate++;
> +	}
> +
> +	return formats;
> +}
> +
> +/* Called with .video_lock held */
> +static int isi_camera_add_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	int ret;
> +
> +	if (isi->icd)
> +		return -EBUSY;
> +
> +	ret = atmel_isi_init(isi);
> +	if (ret)
> +		return ret;
> +
> +	isi->icd = icd;
> +	dev_info(icd->dev.parent, "Atmel ISI Camera driver attached to camera %d\n",
> +		 icd->devnum);
> +	return 0;
> +}
> +/* Called with .video_lock held */
> +static void isi_camera_remove_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +
> +	BUG_ON(icd != isi->icd);
> +
> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_DIS));
> +	/* Check if module disable */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS))
> +		cpu_relax();

Timeout

> +
> +	isi->icd = NULL;
> +
> +	dev_info(icd->dev.parent, "Atmel ISI Camera driver detached from camera %d\n",
> +		 icd->devnum);
> +}
> +
> +static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
> +{
> +	struct soc_camera_device *icd = file->private_data;
> +
> +	return vb2_poll(&icd->vb2_vidq, file, pt);
> +}
> +
> +static int isi_camera_querycap(struct soc_camera_host *ici,
> +			       struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "atmel-isi");
> +	strcpy(cap->card, "Atmel Image Sensor Interface");
> +	cap->version = ATMEL_ISI_VERSION;
> +
> +	cap->capabilities = (V4L2_CAP_VIDEO_CAPTURE
> +			     | V4L2_CAP_READWRITE
> +			     | V4L2_CAP_STREAMING
> +			     );

As someone commented: stay consistent, put '|' at the end of th line. And 
you don't want to mention V4L2_CAP_READWRITE here.

> +	return 0;
> +}
> +
> +static int isi_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct atmel_isi *isi = ici->priv;
> +	unsigned long bus_flags, camera_flags, common_flags;
> +	const struct soc_mbus_pixelfmt *fmt;
> +	int ret;
> +	u32 cfg1, ctrl;
> +
> +	fmt = soc_mbus_get_fmtdesc(icd->current_fmt->code);
> +	if (!fmt)
> +		return -EINVAL;

Hm, there seems to be a problem with this one. soc_mbus_get_fmtdesc() only 
looks for the requested code in the internal mbus_fmt[] array. But it only 
contains formats, for which we know their pass-through formats. E.g., This 
does not work with driver additional formats. Drivers, that implement 
native formats cannot use this function like here int their 
.set_bus_param() methods. See sh_mobile_ceu_camera.c for a correct 
implementation. But the soc_mbus_get_fmtdesc() and its other existing users 
have to be fixed too...

> +
> +	ret = test_platform_param(isi, fmt->bits_per_sample, &bus_flags);
> +	if (ret < 0)
> +		return ret;
> +
> +	camera_flags = icd->ops->query_bus_param(icd);
> +
> +	common_flags = soc_camera_bus_param_compatible(camera_flags, bus_flags);
> +	dev_dbg(icd->dev.parent, "Flags cam: 0x%lx host: 0x%lx common: 0x%lx\n",
> +		camera_flags, bus_flags, common_flags);
> +	if (!common_flags)
> +		return -EINVAL;
> +
> +	/* Make choises, based on platform preferences */
> +	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
> +		if (isi->pdata->hsync_act_low)
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_HSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & SOCAM_VSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & SOCAM_VSYNC_ACTIVE_LOW)) {
> +		if (isi->pdata->vsync_act_low)
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~SOCAM_VSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
> +	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
> +		if (isi->pdata->pclk_act_falling)
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
> +		else
> +			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
> +	}
> +
> +	ret = icd->ops->set_bus_param(icd, common_flags);
> +	if (ret < 0) {
> +		dev_dbg(icd->dev.parent, "camera set_bus_param(%lx) returned %d\n",
> +			common_flags, ret);
> +		return ret;
> +	}
> +
> +	/* set bus param for ISI */
> +	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> +		isi->pdata->pclk_act_falling = 1;
> +	if (common_flags & SOCAM_HSYNC_ACTIVE_LOW)
> +		isi->pdata->hsync_act_low = 1;
> +	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
> +		isi->pdata->vsync_act_low = 1;

This modifies platform data, which is persistent even across module loading 
and unloading. This will break set ups with multiple sensors. You should 
make separate copies of these flags in your driver private data, if you 
have to store them. But in fact, you only use these flags here, so, you 
don't have to save them at all.

> +
> +	cfg1 = ISI_BF(V2_EMB_SYNC, (isi->pdata->has_emb_sync))
> +		| ISI_BF(V2_HSYNC_POL, isi->pdata->hsync_act_low)
> +		| ISI_BF(V2_VSYNC_POL, isi->pdata->vsync_act_low)
> +		| ISI_BF(V2_PIXCLK_POL, isi->pdata->pclk_act_falling)
> +		| ISI_BF(V2_FULL, isi->pdata->isi_full_mode);
> +
> +	ctrl = ISI_BIT(DIS);
> +	isi_writel(isi, V2_CFG1, cfg1);
> +	isi_writel(isi, V2_CTRL, ctrl);
> +
> +	return 0;
> +}
> +
> +static struct soc_camera_host_ops isi_soc_camera_host_ops = {
> +	.owner		= THIS_MODULE,
> +	.add		= isi_camera_add_device,
> +	.remove		= isi_camera_remove_device,
> +	.set_fmt	= isi_camera_set_fmt,
> +	.try_fmt	= isi_camera_try_fmt,
> +	.get_formats	= isi_camera_get_formats,
> +	.init_videobuf2	= isi_camera_init_videobuf,
> +	.poll		= isi_camera_poll,
> +	.querycap	= isi_camera_querycap,
> +	.set_bus_param	= isi_camera_set_bus_param,
> +};
> +
> +/* -----------------------------------------------------------------------*/
> +static int __exit atmel_isi_remove(struct platform_device *pdev)
> +{
> +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> +	struct atmel_isi *isi = container_of(soc_host,
> +					struct atmel_isi, soc_host);
> +
> +	soc_camera_host_unregister(soc_host);
> +	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
> +
> +	free_irq(isi->irq, isi);
> +	iounmap(isi->regs);
> +	clk_disable(isi->pclk);
> +	clk_put(isi->pclk);
> +
> +	return 0;
> +}
> +
> +static int __init atmel_isi_probe(struct platform_device *pdev)
> +{
> +	unsigned int irq;
> +	struct atmel_isi *isi;
> +	struct clk *pclk;
> +	struct resource *regs;
> +	int ret;
> +	struct device *dev = &pdev->dev;
> +	struct isi_platform_data *pdata;
> +	struct soc_camera_host *soc_host;
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		return -ENXIO;
> +
> +	pclk = clk_get(&pdev->dev, "isi_clk");
> +	if (IS_ERR(pclk))
> +		return PTR_ERR(pclk);
> +
> +	clk_enable(pclk);

You've got already comments to the clock API usage.

> +
> +	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
> +	if (!isi) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "can't allocate interface!\n");
> +		goto err_alloc_isi;
> +	}
> +
> +	isi->pclk = pclk;
> +
> +	spin_lock_init(&isi->lock);
> +	init_waitqueue_head(&isi->capture_wq);
> +
> +	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(isi->alloc_ctx)) {
> +		ret = PTR_ERR(isi->alloc_ctx);
> +		goto err_alloc_isi;
> +	}
> +
> +	isi->regs = ioremap(regs->start, resource_size(regs));
> +	if (!isi->regs) {
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +	if (dev->platform_data)
> +		pdata = (struct isi_platform_data *) dev->platform_data;
> +	else {

Missing braces

> +		static struct isi_platform_data isi_default_data = {
> +			.frate		= 0,
> +			.has_emb_sync	= 0,
> +			.emb_crc_sync	= 0,
> +			.hsync_act_low	= 0,
> +			.vsync_act_low	= 0,
> +			.pclk_act_falling = 0,
> +			.isi_full_mode	= 1,
> +			/* to use codec and preview path simultaneously */
> +			.flags = ISI_DATAWIDTH_8 |
> +				ISI_DATAWIDTH_10,
> +		};

Hm, I'm not in favour of hard-coding every single parameter, but I'm not 
sure I like allowing platforms to completely omit platform data. And I 
agree with a previous reviewer: a static struct doesn't look very nice 
here.

> +		dev_info(&pdev->dev,
> +			"No config available using default values\n");
> +		pdata = &isi_default_data;
> +	}
> +
> +	isi->pdata = pdata;
> +	isi->platform_flags = pdata->flags;
> +	if (isi->platform_flags == 0)
> +		isi->platform_flags = ISI_DATAWIDTH_8;
> +
> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_DIS));
> +	/* Check if module disable */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS))
> +		cpu_relax();
> +
> +	irq = platform_get_irq(pdev, 0);
> +	ret = request_irq(irq, isi_interrupt, 0, "isi", isi);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to request irq %d\n", irq);
> +		goto err_req_irq;
> +	}
> +	isi->irq = irq;
> +
> +	INIT_LIST_HEAD(&isi->video_buffer_list);
> +	isi->still_capture = 0;
> +	isi->active = NULL;
> +
> +	soc_host		= &isi->soc_host;
> +	soc_host->drv_name	= "isi-camera";
> +	soc_host->ops		= &isi_soc_camera_host_ops;
> +	soc_host->priv		= isi;
> +	soc_host->v4l2_dev.dev	= &pdev->dev;
> +	soc_host->nr		= pdev->id;
> +
> +	ret = soc_camera_host_register(soc_host);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to register soc camera host\n");
> +		goto err_register_soc_camera_host;
> +	}
> +	return 0;
> +
> +err_register_soc_camera_host:
> +	free_irq(isi->irq, isi);
> +err_req_irq:
> +	iounmap(isi->regs);
> +err_ioremap:
> +	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
> +	kfree(isi);
> +err_alloc_isi:
> +	clk_disable(pclk);
> +
> +	return ret;
> +}
> +
> +static struct platform_driver atmel_isi_driver = {
> +	.probe		= atmel_isi_probe,
> +	.remove		= __exit_p(atmel_isi_remove),
> +	.driver		= {
> +		.name = "atmel_isi",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static int __init atmel_isi_init_module(void)
> +{
> +	return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
> +}
> +
> +static void __exit atmel_isi_exit(void)
> +{
> +	platform_driver_unregister(&atmel_isi_driver);
> +}
> +module_init(atmel_isi_init_module);
> +module_exit(atmel_isi_exit);
> +
> +MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
> +MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("video");
> -- 
> 1.6.3.3
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
