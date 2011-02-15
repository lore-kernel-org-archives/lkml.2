Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1BOHcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:32:15 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3227 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1BOHcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: achew@nvidia.com
Subject: Re: [PATCH 1/1] media: ov9740: Initial submission of OV9740 driver
Date: Tue, 15 Feb 2011 08:31:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
References: <1297722375-16278-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1297722375-16278-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102150831.34508.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 14, 2011 23:26:15 achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> This driver is for Omnivision's OV9740 sensor.  This initial submission
> provides support for YUV422 output at 1280x720 (the sensor's native
> resolution), and 640x480 (cropping and scaling performed by the sensor's ISP).

Looks good. Just one thing that needs to be changed: new drivers have to use
the new control framework (see Documentation/video4linux/v4l2-controls.txt).

Take a look at drivers/media/video/noon010pc30.c for how it should be done.
It's pretty easy.

Work is in progress to convert all V4L drivers to the control framework, but
the bulk probably won't be done until 2.6.40/41.

Regards,

	Hans

> 
> This driver is heavily based off of the existing OV9640 driver.
> 
> Change-Id: I4a75d097143a189a5ec0ae0a7be8d8f3531ea155
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/media/video/Kconfig     |    6 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/ov9740.c    |  988 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-chip-ident.h |    1 +
>  4 files changed, 996 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov9740.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index d40a8fc..52b6271 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -837,6 +837,12 @@ config SOC_CAMERA_OV9640
>  	help
>  	  This is a ov9640 camera driver
>  
> +config SOC_CAMERA_OV9740
> +	tristate "ov9740 camera support"
> +	depends on SOC_CAMERA && I2C
> +	help
> +	  This is a ov9740 camera driver
> +
>  config MX1_VIDEO
>  	bool
>  
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 251b7ca..ac54652 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -79,6 +79,7 @@ obj-$(CONFIG_SOC_CAMERA_OV2640)		+= ov2640.o
>  obj-$(CONFIG_SOC_CAMERA_OV6650)		+= ov6650.o
>  obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
>  obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
> +obj-$(CONFIG_SOC_CAMERA_OV9740)		+= ov9740.o
>  obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
>  obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
>  
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> new file mode 100644
> index 0000000..1c61c1e
> --- /dev/null
> +++ b/drivers/media/video/ov9740.c
> @@ -0,0 +1,988 @@
> +/*
> + * OmniVision OV9740 Camera Driver
> + *
> + * Copyright (C) 2011 NVIDIA Corporation
> + *
> + * Based on ov9640 camera driver.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/soc_camera.h>
> +
> +#define to_ov9740_sensor(sd)	container_of(sd, struct ov9740_priv, subdev)
> +
> +/* General Status Registers */
> +#define OV9740_MODEL_ID_HI		0x0000
> +#define OV9740_MODEL_ID_LO		0x0001
> +#define OV9740_REVISION_NUMBER		0x0002
> +#define OV9740_MANUFACTURER_ID		0x0003
> +#define OV9740_SMIA_VERSION		0x0004
> +
> +/* General Setup Registers */
> +#define OV9740_MODE_SELECT		0x0100
> +#define OV9740_IMAGE_ORT		0x0101
> +#define OV9740_SOFTWARE_RESET		0x0103
> +#define OV9740_GRP_PARAM_HOLD		0x0104
> +#define OV9740_MSK_CORRUP_FM		0x0105
> +
> +/* Timing Setting */
> +#define OV9740_FRM_LENGTH_LN_HI		0x0340 /*VTS*/
> +#define OV9740_FRM_LENGTH_LN_LO		0x0341 /*VTS*/
> +#define OV9740_LN_LENGTH_PCK_HI		0x0342 /*HTS*/
> +#define OV9740_LN_LENGTH_PCK_LO		0x0343 /*HTS*/
> +#define OV9740_X_ADDR_START_HI		0x0344
> +#define OV9740_X_ADDR_START_LO		0x0345
> +#define OV9740_Y_ADDR_START_HI		0x0346
> +#define OV9740_Y_ADDR_START_LO		0x0347
> +#define OV9740_X_ADDR_END_HI		0x0348
> +#define OV9740_X_ADDR_END_LO		0x0349
> +#define OV9740_Y_ADDR_END_HI		0x034A
> +#define OV9740_Y_ADDR_END_LO		0x034B
> +#define OV9740_X_OUTPUT_SIZE_HI		0x034C
> +#define OV9740_X_OUTPUT_SIZE_LO		0x034D
> +#define OV9740_Y_OUTPUT_SIZE_HI		0x034E
> +#define OV9740_Y_OUTPUT_SIZE_LO		0x034F
> +
> +/* IO Control Registers */
> +#define OV9740_IO_CREL00		0x3002
> +#define OV9740_IO_CREL01		0x3004
> +#define OV9740_IO_CREL02		0x3005
> +#define OV9740_IO_OUTPUT_SEL01		0x3026
> +#define OV9740_IO_OUTPUT_SEL02		0x3027
> +
> +/* AWB Registers */
> +#define OV9740_AWB_MANUAL_CTRL		0x3406
> +
> +/* Analog Control Registers */
> +#define OV9740_ANALOG_CTRL01		0x3601
> +#define OV9740_ANALOG_CTRL02		0x3602
> +#define OV9740_ANALOG_CTRL03		0x3603
> +#define OV9740_ANALOG_CTRL04		0x3604
> +#define OV9740_ANALOG_CTRL10		0x3610
> +#define OV9740_ANALOG_CTRL12		0x3612
> +#define OV9740_ANALOG_CTRL20		0x3620
> +#define OV9740_ANALOG_CTRL21		0x3621
> +#define OV9740_ANALOG_CTRL22		0x3622
> +#define OV9740_ANALOG_CTRL30		0x3630
> +#define OV9740_ANALOG_CTRL31		0x3631
> +#define OV9740_ANALOG_CTRL32		0x3632
> +#define OV9740_ANALOG_CTRL33		0x3633
> +
> +/* Sensor Control */
> +#define OV9740_SENSOR_CTRL03		0x3703
> +#define OV9740_SENSOR_CTRL04		0x3704
> +#define OV9740_SENSOR_CTRL05		0x3705
> +#define OV9740_SENSOR_CTRL07		0x3707
> +
> +/* Timing Control */
> +#define OV9740_TIMING_CTRL17		0x3817
> +#define OV9740_TIMING_CTRL19		0x3819
> +#define OV9740_TIMING_CTRL33		0x3833
> +#define OV9740_TIMING_CTRL35		0x3835
> +
> +/* Banding Filter */
> +#define OV9740_AEC_MAXEXPO_60_H		0x3A02
> +#define OV9740_AEC_MAXEXPO_60_L		0x3A03
> +#define OV9740_AEC_B50_STEP_HI		0x3A08
> +#define OV9740_AEC_B50_STEP_LO		0x3A09
> +#define OV9740_AEC_B60_STEP_HI		0x3A0A
> +#define OV9740_AEC_B60_STEP_LO		0x3A0B
> +#define OV9740_AEC_CTRL0D		0x3A0D
> +#define OV9740_AEC_CTRL0E		0x3A0E
> +#define OV9740_AEC_MAXEXPO_50_H		0x3A14
> +#define OV9740_AEC_MAXEXPO_50_L		0x3A15
> +
> +/* AEC/AGC Control */
> +#define OV9740_AEC_ENABLE		0x3503
> +#define OV9740_GAIN_CEILING_01		0x3A18
> +#define OV9740_GAIN_CEILING_02		0x3A19
> +#define OV9740_AEC_HI_THRESHOLD		0x3A11
> +#define OV9740_AEC_3A1A			0x3A1A
> +#define OV9740_AEC_CTRL1B_WPT2		0x3A1B
> +#define OV9740_AEC_CTRL0F_WPT		0x3A0F
> +#define OV9740_AEC_CTRL10_BPT		0x3A10
> +#define OV9740_AEC_CTRL1E_BPT2		0x3A1E
> +#define OV9740_AEC_LO_THRESHOLD		0x3A1F
> +
> +/* BLC Control */
> +#define OV9740_BLC_AUTO_ENABLE		0x4002
> +#define OV9740_BLC_MODE			0x4005
> +
> +/* VFIFO */
> +#define OV9740_VFIFO_READ_START_HI	0x4608
> +#define OV9740_VFIFO_READ_START_LO	0x4609
> +
> +/* DVP Control */
> +#define OV9740_DVP_VSYNC_CTRL02		0x4702
> +#define OV9740_DVP_VSYNC_MODE		0x4704
> +#define OV9740_DVP_VSYNC_CTRL06		0x4706
> +
> +/* PLL Setting */
> +#define OV9740_PLL_MODE_CTRL01		0x3104
> +#define OV9740_PRE_PLL_CLK_DIV		0x0305
> +#define OV9740_PLL_MULTIPLIER		0x0307
> +#define OV9740_VT_SYS_CLK_DIV		0x0303
> +#define OV9740_VT_PIX_CLK_DIV		0x0301
> +#define OV9740_PLL_CTRL3010		0x3010
> +#define OV9740_VFIFO_CTRL00		0x460E
> +
> +/* ISP Control */
> +#define OV9740_ISP_CTRL00		0x5000
> +#define OV9740_ISP_CTRL01		0x5001
> +#define OV9740_ISP_CTRL03		0x5003
> +#define OV9740_ISP_CTRL05		0x5005
> +#define OV9740_ISP_CTRL12		0x5012
> +#define OV9740_ISP_CTRL19		0x5019
> +#define OV9740_ISP_CTRL1A		0x501A
> +#define OV9740_ISP_CTRL1E		0x501E
> +#define OV9740_ISP_CTRL1F		0x501F
> +#define OV9740_ISP_CTRL20		0x5020
> +#define OV9740_ISP_CTRL21		0x5021
> +
> +/* AWB */
> +#define OV9740_AWB_CTRL00		0x5180
> +#define OV9740_AWB_CTRL01		0x5181
> +#define OV9740_AWB_CTRL02		0x5182
> +#define OV9740_AWB_CTRL03		0x5183
> +#define OV9740_AWB_ADV_CTRL01		0x5184
> +#define OV9740_AWB_ADV_CTRL02		0x5185
> +#define OV9740_AWB_ADV_CTRL03		0x5186
> +#define OV9740_AWB_ADV_CTRL04		0x5187
> +#define OV9740_AWB_ADV_CTRL05		0x5188
> +#define OV9740_AWB_ADV_CTRL06		0x5189
> +#define OV9740_AWB_ADV_CTRL07		0x518A
> +#define OV9740_AWB_ADV_CTRL08		0x518B
> +#define OV9740_AWB_ADV_CTRL09		0x518C
> +#define OV9740_AWB_ADV_CTRL10		0x518D
> +#define OV9740_AWB_ADV_CTRL11		0x518E
> +#define OV9740_AWB_CTRL0F		0x518F
> +#define OV9740_AWB_CTRL10		0x5190
> +#define OV9740_AWB_CTRL11		0x5191
> +#define OV9740_AWB_CTRL12		0x5192
> +#define OV9740_AWB_CTRL13		0x5193
> +#define OV9740_AWB_CTRL14		0x5194
> +
> +/* MIPI Control */
> +#define OV9740_MIPI_CTRL00		0x4800
> +#define OV9740_MIPI_3837		0x3837
> +#define OV9740_MIPI_CTRL01		0x4801
> +#define OV9740_MIPI_CTRL03		0x4803
> +#define OV9740_MIPI_CTRL05		0x4805
> +#define OV9740_VFIFO_RD_CTRL		0x4601
> +#define OV9740_MIPI_CTRL_3012		0x3012
> +#define OV9740_SC_CMMM_MIPI_CTR		0x3014
> +
> +/* supported resolutions */
> +#define RES_1280x720_W			1280
> +#define RES_1280x720_H			720
> +#define RES_640x480_W			640
> +#define RES_640x480_H			480
> +
> +/* Misc. structures */
> +struct ov9740_reg {
> +	u16				reg;
> +	u8				val;
> +};
> +
> +struct ov9740_priv {
> +	struct v4l2_subdev		subdev;
> +
> +	int				ident;
> +	u16				model;
> +	u8				revision;
> +	u8				manid;
> +	u8				smiaver;
> +
> +	bool				flag_vflip;
> +	bool				flag_hflip;
> +};
> +
> +static const struct ov9740_reg ov9740_defaults[] = {
> +	/* Banding Filter */
> +	{ OV9740_AEC_B50_STEP_HI,	0x00},
> +	{ OV9740_AEC_B50_STEP_LO,	0xe8},
> +	{ OV9740_AEC_CTRL0E,		0x03},
> +	{ OV9740_AEC_MAXEXPO_50_H,	0x15},
> +	{ OV9740_AEC_MAXEXPO_50_L,	0xc6},
> +	{ OV9740_AEC_B60_STEP_HI,	0x00},
> +	{ OV9740_AEC_B60_STEP_LO,	0xc0},
> +	{ OV9740_AEC_CTRL0D,		0x04},
> +	{ OV9740_AEC_MAXEXPO_60_H,	0x18},
> +	{ OV9740_AEC_MAXEXPO_60_L,	0x20},
> +
> +	/* LC */
> +	{ 0x5842, 0x02}, { 0x5843, 0x5e}, { 0x5844, 0x04}, { 0x5845, 0x32},
> +	{ 0x5846, 0x03}, { 0x5847, 0x29}, { 0x5848, 0x02}, { 0x5849, 0xcc},
> +
> +	/* Un-documented OV9740 registers */
> +	{ 0x5800, 0x29}, { 0x5801, 0x25}, { 0x5802, 0x20}, { 0x5803, 0x21},
> +	{ 0x5804, 0x26}, { 0x5805, 0x2e}, { 0x5806, 0x11}, { 0x5807, 0x0c},
> +	{ 0x5808, 0x09}, { 0x5809, 0x0a}, { 0x580A, 0x0e}, { 0x580B, 0x16},
> +	{ 0x580C, 0x06}, { 0x580D, 0x02}, { 0x580E, 0x00}, { 0x580F, 0x00},
> +	{ 0x5810, 0x04}, { 0x5811, 0x0a}, { 0x5812, 0x05}, { 0x5813, 0x02},
> +	{ 0x5814, 0x00}, { 0x5815, 0x00}, { 0x5816, 0x03}, { 0x5817, 0x09},
> +	{ 0x5818, 0x0f}, { 0x5819, 0x0a}, { 0x581A, 0x07}, { 0x581B, 0x08},
> +	{ 0x581C, 0x0b}, { 0x581D, 0x14}, { 0x581E, 0x28}, { 0x581F, 0x23},
> +	{ 0x5820, 0x1d}, { 0x5821, 0x1e}, { 0x5822, 0x24}, { 0x5823, 0x2a},
> +	{ 0x5824, 0x4f}, { 0x5825, 0x6f}, { 0x5826, 0x5f}, { 0x5827, 0x7f},
> +	{ 0x5828, 0x9f}, { 0x5829, 0x5f}, { 0x582A, 0x8f}, { 0x582B, 0x9e},
> +	{ 0x582C, 0x8f}, { 0x582D, 0x9f}, { 0x582E, 0x4f}, { 0x582F, 0x87},
> +	{ 0x5830, 0x86}, { 0x5831, 0x97}, { 0x5832, 0xae}, { 0x5833, 0x3f},
> +	{ 0x5834, 0x8e}, { 0x5835, 0x7c}, { 0x5836, 0x7e}, { 0x5837, 0xaf},
> +	{ 0x5838, 0x8f}, { 0x5839, 0x8f}, { 0x583A, 0x9f}, { 0x583B, 0x7f},
> +	{ 0x583C, 0x5f},
> +
> +	/* Y Gamma */
> +	{ 0x5480, 0x07}, { 0x5481, 0x18}, { 0x5482, 0x2c}, { 0x5483, 0x4e},
> +	{ 0x5484, 0x5e}, { 0x5485, 0x6b}, { 0x5486, 0x77}, { 0x5487, 0x82},
> +	{ 0x5488, 0x8c}, { 0x5489, 0x95}, { 0x548A, 0xa4}, { 0x548B, 0xb1},
> +	{ 0x548C, 0xc6}, { 0x548D, 0xd8}, { 0x548E, 0xe9},
> +
> +	/* UV Gamma */
> +	{ 0x5490, 0x0f}, { 0x5491, 0xff}, { 0x5492, 0x0d}, { 0x5493, 0x05},
> +	{ 0x5494, 0x07}, { 0x5495, 0x1a}, { 0x5496, 0x04}, { 0x5497, 0x01},
> +	{ 0x5498, 0x03}, { 0x5499, 0x53}, { 0x549A, 0x02}, { 0x549B, 0xeb},
> +	{ 0x549C, 0x02}, { 0x549D, 0xa0}, { 0x549E, 0x02}, { 0x549F, 0x67},
> +	{ 0x54A0, 0x02}, { 0x54A1, 0x3b}, { 0x54A2, 0x02}, { 0x54A3, 0x18},
> +	{ 0x54A4, 0x01}, { 0x54A5, 0xe7}, { 0x54A6, 0x01}, { 0x54A7, 0xc3},
> +	{ 0x54A8, 0x01}, { 0x54A9, 0x94}, { 0x54AA, 0x01}, { 0x54AB, 0x72},
> +	{ 0x54AC, 0x01}, { 0x54AD, 0x57},
> +
> +	/* AWB */
> +	{ OV9740_AWB_CTRL00,		0xf0},
> +	{ OV9740_AWB_CTRL01,		0x00},
> +	{ OV9740_AWB_CTRL02,		0x41},
> +	{ OV9740_AWB_CTRL03,		0x42},
> +	{ OV9740_AWB_ADV_CTRL01,	0x8a},
> +	{ OV9740_AWB_ADV_CTRL02,	0x61},
> +	{ OV9740_AWB_ADV_CTRL03,	0xce},
> +	{ OV9740_AWB_ADV_CTRL04,	0xa8},
> +	{ OV9740_AWB_ADV_CTRL05,	0x17},
> +	{ OV9740_AWB_ADV_CTRL06,	0x1f},
> +	{ OV9740_AWB_ADV_CTRL07,	0x27},
> +	{ OV9740_AWB_ADV_CTRL08,	0x41},
> +	{ OV9740_AWB_ADV_CTRL09,	0x34},
> +	{ OV9740_AWB_ADV_CTRL10,	0xf0},
> +	{ OV9740_AWB_ADV_CTRL11,	0x10},
> +	{ OV9740_AWB_CTRL0F,		0xff},
> +	{ OV9740_AWB_CTRL10,		0x00},
> +	{ OV9740_AWB_CTRL11,		0xff},
> +	{ OV9740_AWB_CTRL12,		0x00},
> +	{ OV9740_AWB_CTRL13,		0xff},
> +	{ OV9740_AWB_CTRL14,		0x00},
> +
> +	/* CIP */
> +	{ 0x530D, 0x12},
> +
> +	/* CMX */
> +	{ 0x5380, 0x01}, { 0x5381, 0x00}, { 0x5382, 0x00}, { 0x5383, 0x17},
> +	{ 0x5384, 0x00}, { 0x5385, 0x01}, { 0x5386, 0x00}, { 0x5387, 0x00},
> +	{ 0x5388, 0x00}, { 0x5389, 0xe0}, { 0x538A, 0x00}, { 0x538B, 0x20},
> +	{ 0x538C, 0x00}, { 0x538D, 0x00}, { 0x538E, 0x00}, { 0x538F, 0x16},
> +	{ 0x5390, 0x00}, { 0x5391, 0x9c}, { 0x5392, 0x00}, { 0x5393, 0xa0},
> +	{ 0x5394, 0x18},
> +
> +	/* 50/60 Detection */
> +	{ 0x3C0A, 0x9c}, { 0x3C0B, 0x3f},
> +
> +	/* Output Select */
> +	{ OV9740_IO_OUTPUT_SEL01,	0x00},
> +	{ OV9740_IO_OUTPUT_SEL02,	0x00},
> +	{ OV9740_IO_CREL00,		0x00},
> +	{ OV9740_IO_CREL01,		0x00},
> +	{ OV9740_IO_CREL02,		0x00},
> +
> +	/* AWB Control */
> +	{ OV9740_AWB_MANUAL_CTRL,	0x00},
> +
> +	/* Analog Control */
> +	{ OV9740_ANALOG_CTRL03,		0xaa},
> +	{ OV9740_ANALOG_CTRL32,		0x2f},
> +	{ OV9740_ANALOG_CTRL20,		0x66},
> +	{ OV9740_ANALOG_CTRL21,		0xc0},
> +	{ OV9740_ANALOG_CTRL31,		0x52},
> +	{ OV9740_ANALOG_CTRL33,		0x50},
> +	{ OV9740_ANALOG_CTRL30,		0xca},
> +	{ OV9740_ANALOG_CTRL04,		0x0c},
> +	{ OV9740_ANALOG_CTRL01,		0x40},
> +	{ OV9740_ANALOG_CTRL02,		0x16},
> +	{ OV9740_ANALOG_CTRL10,		0xa1},
> +	{ OV9740_ANALOG_CTRL12,		0x24},
> +	{ OV9740_ANALOG_CTRL22,		0x9f},
> +
> +	/* Sensor Control */
> +	{ OV9740_SENSOR_CTRL03,		0x42},
> +	{ OV9740_SENSOR_CTRL04,		0x10},
> +	{ OV9740_SENSOR_CTRL05,		0x45},
> +	{ OV9740_SENSOR_CTRL07,		0x14},
> +
> +	/* Timing Control */
> +	{ OV9740_TIMING_CTRL33,		0x04},
> +	{ OV9740_TIMING_CTRL35,		0x02},
> +	{ OV9740_TIMING_CTRL19,		0x6e},
> +	{ OV9740_TIMING_CTRL17,		0x94},
> +
> +	/* AEC/AGC Control */
> +	{ OV9740_AEC_ENABLE,		0x10},
> +	{ OV9740_GAIN_CEILING_01,	0x00},
> +	{ OV9740_GAIN_CEILING_02,	0x7f},
> +	{ OV9740_AEC_HI_THRESHOLD,	0xa0},
> +	{ OV9740_AEC_3A1A,		0x05},
> +	{ OV9740_AEC_CTRL1B_WPT2,	0x50},
> +	{ OV9740_AEC_CTRL0F_WPT,	0x50},
> +	{ OV9740_AEC_CTRL10_BPT,	0x4c},
> +	{ OV9740_AEC_CTRL1E_BPT2,	0x4c},
> +	{ OV9740_AEC_LO_THRESHOLD,	0x26},
> +
> +	/* BLC Control */
> +	{ OV9740_BLC_AUTO_ENABLE,	0x45},
> +	{ OV9740_BLC_MODE,		0x18},
> +
> +	/* DVP Control */
> +	{ OV9740_DVP_VSYNC_CTRL02,	0x04},
> +	{ OV9740_DVP_VSYNC_MODE,	0x00},
> +	{ OV9740_DVP_VSYNC_CTRL06,	0x08},
> +
> +	/* PLL Setting */
> +	{ OV9740_PLL_MODE_CTRL01,	0x20},
> +	{ OV9740_PRE_PLL_CLK_DIV,	0x03},
> +	{ OV9740_PLL_MULTIPLIER,	0x4c},
> +	{ OV9740_VT_SYS_CLK_DIV,	0x01},
> +	{ OV9740_VT_PIX_CLK_DIV,	0x08},
> +	{ OV9740_PLL_CTRL3010,		0x01},
> +	{ OV9740_VFIFO_CTRL00,		0x82},
> +
> +	/* Timing Setting */
> +	/*VTS*/
> +	{ OV9740_FRM_LENGTH_LN_HI,	0x03},
> +	{ OV9740_FRM_LENGTH_LN_LO,	0x07},
> +	/*HTS*/
> +	{ OV9740_LN_LENGTH_PCK_HI,	0x06},
> +	{ OV9740_LN_LENGTH_PCK_LO,	0x62},
> +
> +	/* MIPI Control */
> +	{ OV9740_MIPI_CTRL00,		0x44},
> +	{ OV9740_MIPI_3837,		0x01},
> +	{ OV9740_MIPI_CTRL01,		0x0f},
> +	{ OV9740_MIPI_CTRL03,		0x05},
> +	{ OV9740_MIPI_CTRL05,		0x10},
> +	{ OV9740_VFIFO_RD_CTRL,		0x16},
> +	{ OV9740_MIPI_CTRL_3012,	0x70},
> +	{ OV9740_SC_CMMM_MIPI_CTR,	0x01},
> +};
> +
> +static const struct ov9740_reg ov9740_start_streaming[] = {
> +	/* Start Streaming */
> +	{ OV9740_MODE_SELECT,		0x01},
> +};
> +
> +static const struct ov9740_reg ov9740_stop_streaming[] = {
> +	/* Software Reset */
> +	{ OV9740_SOFTWARE_RESET,	0x01},
> +
> +	/* Setting Streaming to Standby */
> +	{ OV9740_MODE_SELECT,		0x00},
> +};
> +
> +static const struct ov9740_reg ov9740_regs_640x480[] = {
> +	{ OV9740_X_ADDR_START_HI,	0x00},
> +	{ OV9740_X_ADDR_START_LO,	0xa0},
> +	{ OV9740_Y_ADDR_START_HI,	0x00},
> +	{ OV9740_Y_ADDR_START_LO,	0x00},
> +	{ OV9740_X_ADDR_END_HI,		0x04},
> +	{ OV9740_X_ADDR_END_LO,		0x63},
> +	{ OV9740_Y_ADDR_END_HI,		0x02},
> +	{ OV9740_Y_ADDR_END_LO,		0xd3},
> +	{ OV9740_X_OUTPUT_SIZE_HI,	0x02},
> +	{ OV9740_X_OUTPUT_SIZE_LO,	0x80},
> +	{ OV9740_Y_OUTPUT_SIZE_HI,	0x01},
> +	{ OV9740_Y_OUTPUT_SIZE_LO,	0xe0},
> +	{ OV9740_ISP_CTRL1E,		0x03},
> +	{ OV9740_ISP_CTRL1F,		0xc0},
> +	{ OV9740_ISP_CTRL20,		0x02},
> +	{ OV9740_ISP_CTRL21,		0xd0},
> +	{ OV9740_VFIFO_READ_START_HI,	0x01},
> +	{ OV9740_VFIFO_READ_START_LO,	0x40},
> +	{ OV9740_ISP_CTRL00,		0xff},
> +	{ OV9740_ISP_CTRL01,		0xff},
> +	{ OV9740_ISP_CTRL03,		0xff},
> +};
> +
> +static const struct ov9740_reg ov9740_regs_1280x720[] = {
> +	{ OV9740_X_ADDR_START_HI,	0x00},
> +	{ OV9740_X_ADDR_START_LO,	0x00},
> +	{ OV9740_Y_ADDR_START_HI,	0x00},
> +	{ OV9740_Y_ADDR_START_LO,	0x00},
> +	{ OV9740_X_ADDR_END_HI,		0x05},
> +	{ OV9740_X_ADDR_END_LO,		0x03},
> +	{ OV9740_Y_ADDR_END_HI,		0x02},
> +	{ OV9740_Y_ADDR_END_LO,		0xd3},
> +	{ OV9740_X_OUTPUT_SIZE_HI,	0x05},
> +	{ OV9740_X_OUTPUT_SIZE_LO,	0x00},
> +	{ OV9740_Y_OUTPUT_SIZE_HI,	0x02},
> +	{ OV9740_Y_OUTPUT_SIZE_LO,	0xd0},
> +	{ OV9740_ISP_CTRL1E,		0x05},
> +	{ OV9740_ISP_CTRL1F,		0x00},
> +	{ OV9740_ISP_CTRL20,		0x02},
> +	{ OV9740_ISP_CTRL21,		0xd0},
> +	{ OV9740_VFIFO_READ_START_HI,	0x02},
> +	{ OV9740_VFIFO_READ_START_LO,	0x30},
> +	{ OV9740_ISP_CTRL00,		0xff},
> +	{ OV9740_ISP_CTRL01,		0xef},
> +	{ OV9740_ISP_CTRL03,		0xff},
> +};
> +
> +static enum v4l2_mbus_pixelcode ov9740_codes[] = {
> +	V4L2_MBUS_FMT_YUYV8_2X8,
> +};
> +
> +static const struct v4l2_queryctrl ov9740_controls[] = {
> +	{
> +		.id		= V4L2_CID_VFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Vertically",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +	{
> +		.id		= V4L2_CID_HFLIP,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "Flip Horizontally",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},
> +};
> +
> +/* read a register */
> +static int ov9740_reg_read(struct i2c_client *client, u16 reg, u8 *val)
> +{
> +	int ret;
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr	= client->addr,
> +			.flags	= 0,
> +			.len	= 2,
> +			.buf	= (u8*)&reg,
> +		},
> +		{
> +			.addr	= client->addr,
> +			.flags	= I2C_M_RD,
> +			.len	= 1,
> +			.buf	= val,
> +		},
> +	};
> +
> +	reg = swab16(reg);
> +
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(&client->dev, "Failed reading register 0x%04x!\n", reg);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* write a register */
> +static int ov9740_reg_write(struct i2c_client *client, u16 reg, u8 val)
> +{
> +	struct i2c_msg msg;
> +	u8 buf[3];
> +	int ret;
> +
> +	reg = swab16(reg);
> +
> +	memcpy(buf + 0, &reg, 2);
> +	memcpy(buf + 2, &val, 1);
> +
> +	msg.addr	= client->addr;
> +	msg.flags	= 0;
> +	msg.len		= 3;
> +	msg.buf		= buf;
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(&client->dev, "Failed writing register 0x%04x!\n", reg);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/* Read a register, alter its bits, write it back */
> +static int ov9740_reg_rmw(struct i2c_client *client, u16 reg, u8 set, u8 unset)
> +{
> +	u8 val;
> +	int ret;
> +
> +	ret = ov9740_reg_read(client, reg, &val);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(&client->dev,
> +			"[Read]-Modify-Write of register %02x failed!\n", reg);
> +		return ret;
> +	}
> +
> +	val |= set;
> +	val &= ~unset;
> +
> +	ret = ov9740_reg_write(client, reg, val);
> +	if (IS_ERR_VALUE(ret)) {
> +		dev_err(&client->dev,
> +			"Read-Modify-[Write] of register %02x failed!\n", reg);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov9740_reg_write_ary(struct i2c_client *client,
> +				const struct ov9740_reg *regary, int regarylen)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i = 0; i < regarylen; i++) {
> +		ret = ov9740_reg_write(client, regary[i].reg, regary[i].val);
> +		if (IS_ERR_VALUE(ret))
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Start/Stop streaming from the device */
> +static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov9740_priv *priv = to_ov9740_sensor(sd);
> +	int ret;
> +
> +	/* Program orientation register. */
> +	if (priv->flag_vflip)
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0x2, 0);
> +	else
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0, 0x2);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	if (priv->flag_hflip)
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0x1, 0);
> +	else
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0, 0x1);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	if (enable) {
> +		dev_info(&client->dev, "Enabling Streaming\n");
> +		ret = ov9740_reg_write_ary(client, ov9740_start_streaming,
> +					   ARRAY_SIZE(ov9740_start_streaming));
> +	} else {
> +		dev_info(&client->dev, "Disabling Streaming\n");
> +		ret = ov9740_reg_write_ary(client, ov9740_stop_streaming,
> +					   ARRAY_SIZE(ov9740_stop_streaming));
> +	}
> +
> +	return ret;
> +}
> +
> +/* Alter bus settings on camera side */
> +static int ov9740_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long flags)
> +{
> +	return 0;
> +}
> +
> +/* Request bus settings on camera side */
> +static unsigned long ov9740_query_bus_param(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_link *icl = to_soc_camera_link(icd);
> +
> +	/*
> +	 * REVISIT: the camera probably can do 10 bit transfers, but I don't
> +	 *          have those pins connected on my hardware.
> +	 */
> +	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
> +		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
> +
> +	return soc_camera_apply_sensor_flags(icl, flags);
> +}
> +
> +/* Get status of additional camera capabilities */
> +static int ov9740_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct ov9740_priv *priv = to_ov9740_sensor(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		ctrl->value = priv->flag_vflip;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		ctrl->value = priv->flag_hflip;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Set status of additional camera capabilities */
> +static int ov9740_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct ov9740_priv *priv = to_ov9740_sensor(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		priv->flag_vflip = ctrl->value;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		priv->flag_hflip = ctrl->value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Get chip identification */
> +static int ov9740_g_chip_ident(struct v4l2_subdev *sd,
> +			       struct v4l2_dbg_chip_ident *id)
> +{
> +	struct ov9740_priv *priv = to_ov9740_sensor(sd);
> +
> +	id->ident = priv->ident;
> +	id->revision = priv->revision;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int ov9740_get_register(struct v4l2_subdev *sd,
> +			       struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +	u8 val;
> +
> +	if (reg->reg & ~0xffff)
> +		return -EINVAL;
> +
> +	reg->size = 2;
> +
> +	ret = ov9740_reg_read(client, reg->reg, &val);
> +	if (ret)
> +		return ret;
> +
> +	reg->val = (__u64)val;
> +
> +	return ret;
> +}
> +
> +static int ov9740_set_register(struct v4l2_subdev *sd,
> +			       struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	if (reg->reg & ~0xffff || reg->val & ~0xff)
> +		return -EINVAL;
> +
> +	return ov9740_reg_write(client, reg->reg, reg->val);
> +}
> +#endif
> +
> +/* select nearest higher resolution for capture */
> +static void ov9740_res_roundup(u32 *width, u32 *height)
> +{
> +	int i;
> +	enum { RES_640x480, RES_1280x720 };
> +	int res_x[] = { 640, 1280 };
> +	int res_y[] = { 480, 720 };
> +
> +	for (i = 0; i < ARRAY_SIZE(res_x); i++)
> +		if (res_x[i] >= *width && res_y[i] >= *height) {
> +			*width = res_x[i];
> +			*height = res_y[i];
> +			return;
> +		}
> +
> +	*width = res_x[RES_1280x720];
> +	*height = res_y[RES_1280x720];
> +}
> +
> +/* Setup registers according to resolution and color encoding */
> +static int ov9740_set_res_code(struct i2c_client *client, u32 width,
> +			       enum v4l2_mbus_pixelcode code)
> +{
> +	int ret;
> +
> +	/* select register configuration for given resolution */
> +	switch (width) {
> +	case RES_640x480_W:
> +		dev_info(&client->dev, "Setting image size to 640x480\n");
> +		ret = ov9740_reg_write_ary(client, ov9740_regs_640x480,
> +					   ARRAY_SIZE(ov9740_regs_640x480));
> +		break;
> +	case RES_1280x720_W:
> +		dev_info(&client->dev, "Setting image size to 1280x720\n");
> +		ret = ov9740_reg_write_ary(client, ov9740_regs_1280x720,
> +					   ARRAY_SIZE(ov9740_regs_1280x720));
> +		break;
> +	default:
> +		dev_err(&client->dev, "Failed to select resolution!\n");
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +/* set the format we will capture in */
> +static int ov9740_s_fmt(struct v4l2_subdev *sd,
> +			struct v4l2_mbus_framefmt *mf)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	enum v4l2_colorspace cspace;
> +	enum v4l2_mbus_pixelcode code = mf->code;
> +	int ret;
> +
> +	ov9740_res_roundup(&mf->width, &mf->height);
> +
> +	switch (code) {
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		cspace = V4L2_COLORSPACE_SRGB;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = ov9740_reg_write_ary(client, ov9740_defaults,
> +				   ARRAY_SIZE(ov9740_defaults));
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	ret = ov9740_set_res_code(client, mf->width, code);
> +	if (IS_ERR_VALUE(ret))
> +		return ret;
> +
> +	mf->code	= code;
> +	mf->colorspace	= cspace;
> +
> +	return ret;
> +}
> +
> +static int ov9740_try_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_mbus_framefmt *mf)
> +{
> +	ov9740_res_roundup(&mf->width, &mf->height);
> +
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	switch (mf->code) {
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		mf->colorspace = V4L2_COLORSPACE_SRGB;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov9740_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
> +			   enum v4l2_mbus_pixelcode *code)
> +{
> +	if (index >= ARRAY_SIZE(ov9740_codes))
> +		return -EINVAL;
> +
> +	*code = ov9740_codes[index];
> +
> +	return 0;
> +}
> +
> +static int __devinit ov9740_video_probe(struct soc_camera_device *icd,
> +					struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct ov9740_priv *priv = to_ov9740_sensor(sd);
> +	const char *devname;
> +	int ret;
> +
> +	/*
> +	 * We must have a parent by now. And it cannot be a wrong one.
> +	 * So this entire test is completely redundant.
> +	 */
> +	if (!icd->dev.parent ||
> +	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface) {
> +		dev_err(&client->dev, "Parent missing or invalid!\n");
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	/*
> +	 * check and show product ID and manufacturer ID
> +	 */
> +	ret = ov9740_reg_read(client, OV9740_MODEL_ID_HI,
> +			      ((u8*)(&priv->model))+1);
> +	if (IS_ERR_VALUE(ret))
> +		goto err;
> +
> +	ret = ov9740_reg_read(client, OV9740_MODEL_ID_LO,
> +			      ((u8*)(&priv->model)));
> +	if (IS_ERR_VALUE(ret))
> +		goto err;
> +
> +	ret = ov9740_reg_read(client, OV9740_REVISION_NUMBER, &priv->revision);
> +	if (IS_ERR_VALUE(ret))
> +		goto err;
> +
> +	ret = ov9740_reg_read(client, OV9740_MANUFACTURER_ID, &priv->manid);
> +	if (IS_ERR_VALUE(ret))
> +		goto err;
> +
> +	ret = ov9740_reg_read(client, OV9740_SMIA_VERSION, &priv->smiaver);
> +	if (IS_ERR_VALUE(ret))
> +		goto err;
> +
> +	if (priv->model != 0x9740) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +
> +	devname = "ov9740";
> +	priv->ident = V4L2_IDENT_OV9740;
> +
> +	dev_info(&client->dev, "%s Model ID 0x%04x, Revision 0x%02x, "
> +		 "Manufacturer 0x%02x, SMIA Version 0x%02x\n",
> +		 devname, priv->model, priv->revision,
> +		 priv->manid, priv->smiaver);
> +
> +err:
> +	return ret;
> +}
> +
> +static struct soc_camera_ops ov9740_ops = {
> +	.set_bus_param		= ov9740_set_bus_param,
> +	.query_bus_param	= ov9740_query_bus_param,
> +	.controls		= ov9740_controls,
> +	.num_controls		= ARRAY_SIZE(ov9740_controls),
> +};
> +
> +static struct v4l2_subdev_core_ops ov9740_core_ops = {
> +	.g_ctrl			= ov9740_g_ctrl,
> +	.s_ctrl			= ov9740_s_ctrl,
> +	.g_chip_ident		= ov9740_g_chip_ident,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register		= ov9740_get_register,
> +	.s_register		= ov9740_set_register,
> +#endif
> +
> +};
> +
> +static struct v4l2_subdev_video_ops ov9740_video_ops = {
> +	.s_stream		= ov9740_s_stream,
> +	.s_mbus_fmt		= ov9740_s_fmt,
> +	.try_mbus_fmt		= ov9740_try_fmt,
> +	.enum_mbus_fmt		= ov9740_enum_fmt,
> +
> +};
> +
> +static struct v4l2_subdev_ops ov9740_subdev_ops = {
> +	.core			= &ov9740_core_ops,
> +	.video			= &ov9740_video_ops,
> +};
> +
> +/*
> + * i2c_driver function
> + */
> +static int __devinit ov9740_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *did)
> +{
> +	struct ov9740_priv *priv;
> +	struct soc_camera_device *icd	= client->dev.platform_data;
> +	struct soc_camera_link *icl;
> +	int ret;
> +
> +	if (!icd) {
> +		dev_err(&client->dev, "Missing soc-camera data!\n");
> +		return -EINVAL;
> +	}
> +
> +	icl = to_soc_camera_link(icd);
> +	if (!icl) {
> +		dev_err(&client->dev, "Missing platform_data for driver\n");
> +		return -EINVAL;
> +	}
> +
> +	priv = kzalloc(sizeof(struct ov9740_priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&client->dev, "Failed to allocate private data!\n");
> +		return -ENOMEM;
> +	}
> +
> +	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9740_subdev_ops);
> +
> +	icd->ops = &ov9740_ops;
> +
> +	ret = ov9740_video_probe(icd, client);
> +	if (IS_ERR_VALUE(ret)) {
> +		icd->ops = NULL;
> +		kfree(priv);
> +	}
> +
> +	return ret;
> +}
> +
> +static int __devexit ov9740_remove(struct i2c_client *client)
> +{
> +	struct ov9740_priv *priv = i2c_get_clientdata(client);
> +
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov9740_id[] = {
> +	{ "ov9740", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov9740_id);
> +
> +static struct i2c_driver ov9740_i2c_driver = {
> +	.driver = {
> +		.name = "ov9740",
> +	},
> +	.probe    = ov9740_probe,
> +	.remove   = __devexit_p(ov9740_remove),
> +	.id_table = ov9740_id,
> +};
> +
> +static int __init ov9740_module_init(void)
> +{
> +	return i2c_add_driver(&ov9740_i2c_driver);
> +}
> +
> +static void __exit ov9740_module_exit(void)
> +{
> +	i2c_del_driver(&ov9740_i2c_driver);
> +}
> +
> +module_init(ov9740_module_init);
> +module_exit(ov9740_module_exit);
> +
> +MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV9740");
> +MODULE_AUTHOR("Andrew Chew <achew@nvidia.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index ff4a52c..b3edb67 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -75,6 +75,7 @@ enum {
>  	V4L2_IDENT_OV9640 = 257,
>  	V4L2_IDENT_OV6650 = 258,
>  	V4L2_IDENT_OV2640 = 259,
> +	V4L2_IDENT_OV9740 = 260,
>  
>  	/* module saa7146: reserved range 300-309 */
>  	V4L2_IDENT_SAA7146 = 300,
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
