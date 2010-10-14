Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0JNVtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:49:09 -0400
Received: from asmtpout030.mac.com ([17.148.16.105]:38702 "EHLO
	asmtpout030.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab0JNVtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:49:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010140162
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-14_07:2010-10-14,2010-10-14,1970-01-01 signatures=0
From: Elvis Dowson <elvis.dowson@mac.com>
Subject: Difference between twl4030_hsmmc_info and omap_mmc_platform_data
Date: Fri, 15 Oct 2010 01:48:53 +0400
Message-id: <DB759C09-975B-4088-B334-79F9010573F8@mac.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
       I'm trying to bring up a TI WL1271 wlan module connected to MMC2 controller of a TI OMAP 3530 processor. 

I am unclear about the difference between the use of twl4030_hsmmc_info and omap_mmc_platform_data, to set the attributes and constraints for the MMC1 (connected to microSD card) and MMC2 (connected to WLAN module). 

The beagleboard uses twl4030_mmc_init, which has a wrapper for omap_mmc_platform_data defined in mmc-twl4030.h. 

The board-sholes-hsmmc.c doesn't use twl4030, but directly uses the omap_mmc_platform_data structure. 

Example: 

board-omap3beagle.c uses twl4030_mmc_init, which internally uses the following structure to define mmc properties. 

static struct twl4030_hsmmc_info mmc[] = {
	{
		.mmc            = 1,
		.wires          = 8,
		.gpio_wp        = -ENOSYS,
		.gpio_cd        = -ENOSYS,
		.name           = "MMC1 controller slot"
	},
	{
		.mmc            = 2,
		.wires          = 4,
		.gpio_cd        = -EINVAL,
		.gpio_wp        = -EINVAL,
//		.transceiver    = true,
		.name           = "MMC2 controller slot",
		.ocr_mask       = 0x00000080,
	},
	{}	/* Terminator */
};

For board-sholes-hsmmc.c, it uses a omap_mmc_platform_data

static struct omap_mmc_platform_data mmc1_data = {
	.nr_slots			= 1,
	.init				= hsmmc_late_init,
	.cleanup			= hsmmc_cleanup,
#ifdef CONFIG_PM
	.suspend			= hsmmc_suspend,
	.resume				= hsmmc_resume,
#endif
	.dma_mask			= 0xffffffff,
	.slots[0] = {
		.wires			= 8,
		.set_power		= hsmmc_set_power,
		.ocr_mask		= MMC_VDD_32_33 | MMC_VDD_33_34 |
						MMC_VDD_165_195,
		.name			= "first slot",
		/* we get car_detect_irq later */
		.card_detect_irq	= 0,
		.card_detect            = hsmmc_card_detect,
	},
};

#if defined(CONFIG_OMAP_HS_MMC2)
#ifdef CONFIG_MMC_EMBEDDED_SDIO
static struct sdio_embedded_func wifi_func_array[] = {
	{
		.f_class        = SDIO_CLASS_NONE,
		.f_maxblksize   = 0,
	},
	{
		.f_class        = SDIO_CLASS_WLAN,
		.f_maxblksize   = 512,
	},
};

static struct embedded_sdio_data sholes_wifi_emb_data = {
	.cis    = {
		.vendor         = 0x104c,
		.device         = 0x9066,
		.blksize        = 512,
		.max_dtr        = 24000000,
	},
	.cccr   = {
		.multi_block    = 1,
		.low_speed      = 0,
		.wide_bus       = 1,
		.high_power     = 0,
		.high_speed     = 0,
	},
	.funcs  = wifi_func_array,
	.num_funcs = 2,
};
#endif

static struct omap_mmc_platform_data mmc2_data = {
	.nr_slots			= 1,
	.init				= hsmmc2_late_init,
	.cleanup			= hsmmc2_cleanup,
#ifdef CONFIG_PM
	.suspend			= hsmmc2_suspend,
	.resume				= hsmmc2_resume,
#endif
	.dma_mask			= 0xffffffff,
#ifndef CONFIG_MMC_EMBEDDED_SDIO
	.name				= "TIWLAN_SDIO",
#endif
	.slots[0] = {
		.wires			= 4,
		.set_power		= hsmmc2_set_power,
		.ocr_mask		= MMC_VDD_32_33 | MMC_VDD_33_34 |
						MMC_VDD_165_195,
		.name			= "first slot",
		.internal_clock		= 1,
		.card_detect_irq        = 0,
		.card_detect            = hsmmc2_card_detect,
#ifdef CONFIG_MMC_EMBEDDED_SDIO
		.embedded_sdio		= &sholes_wifi_emb_data,
		.register_status_notify	= &sholes_wifi_status_register,
#endif
	},
};
#endif

Best regards,

Elvis Dowson
