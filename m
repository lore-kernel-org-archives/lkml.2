Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0HMHkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:40:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33308 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0HMHkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:40:19 -0400
Date: Fri, 13 Aug 2010 09:40:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: dmaengine questions
Message-ID: <20100813074014.GD27749@pengutronix.de>
References: <20100812150030.GB27749@pengutronix.de> <AANLkTikSExz3ELLEZ90LgitTsxwkE1dxu1BM1VhfCOmy@mail.gmail.com> <20100812201601.GC27749@pengutronix.de> <AANLkTikPs_03fX77FHAMuuq2kBtr6wrekrgExAp+ki2V@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikPs_03fX77FHAMuuq2kBtr6wrekrgExAp+ki2V@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:38:49 up 40 days, 21:49, 17 users,  load average: 0.38, 0.31,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 12:32:08AM +0200, Linus Walleij wrote:
> 2010/8/12 Sascha Hauer <s.hauer@pengutronix.de>:
> > [Dan]
> >> Hopefully dma_chan->private can eventually be phased out in favor of
> >> Linus' dma_slave_config scheme [1].
> >
> > This looks promising. Two things are missing here for the SDMA engine.
> > First is the DMA request line which is probably needed for other dma
> > engines aswell, so this could be added to dma_slave_config.
> 
> Do you really need to configure this at runtime?
> The idea is to pass in stuff that is changed dynamically wheras
> things that are fixed are passed in from platform data.

It's not changed dynamically, but the information which dma request a
client has to use is in its resources. So the client does a
platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx0"); to get the
request line to use. Somehow this information must get to the SDMA
engine. By platform data do you mean the private pointer in dma_chan?

> 
> In the PL180 there was multiplexing functions for the lines even
> (so one line was shared between different devices) in that case
> I implemented platform-specific callbacks in the platform data
> to request the lines.

Do you have a pointer to the code?

> 
> > The other
> > one is really specific to the SDMA engine, it's the following enum. The
> > SDMA engine is a programmable controller in the i.MX and each peripheral
> > has its own copy function in this controller. This enum is used to
> > determine their start addresses.
> 
> Can't you pass in the actual address in src_address for RX and
> dst_address for TX?

I'm not talking about addresses in the physical address space of the
i.MX here. I'm talking about addresses in the program address space of
the SDMA controller. Let me explain this a little more in detail. The
SDMA engine has a little microcontroller in it which gets a 6k or
something firmware image. The firmware consists of several functions
(which are running in the controller). The SDMA driver now translates
the information 'sdhc controller receive' into an offset in the firmware
image.

The actual FIFO address of the peripheral is of course passed in
src_address/dst_address.

> 
> The idea here is that the driver know the physical address where
> the bitpipe is supposed to end up, and the DMAengine does not.
> If it was always the same address we could pass that also through
> platform data but experience shows that some devices use different
> addresses for different kinds of configurations, that's why it's there.
> 
> Maybe I'm just not getting it...

I hope my explanation above helps. The following function is the snippet
in the SDMA driver which does this translation work:

static void sdma_get_pc(struct sdma_channel *sdma,
		sdma_peripheral_type peripheral_type)
{
	int res = 0;
	int per_2_emi = 0, emi_2_per = 0;
	int per_2_int = 0, int_2_per = 0;
	int per_2_per = 0, emi_2_emi = 0;

	sdma->pc_from_device = 0;
	sdma->pc_to_device = 0;

	switch (peripheral_type) {
	case IMX_DMATYPE_MEMORY:
		emi_2_emi = sdma_script_addrs->ap_2_ap_addr;
		break;
	case IMX_DMATYPE_DSP:
		emi_2_per = sdma_script_addrs->bp_2_ap_addr;
		per_2_emi = sdma_script_addrs->ap_2_bp_addr;
		break;
	case IMX_DMATYPE_FIRI:
		per_2_int = sdma_script_addrs->firi_2_per_addr;
		per_2_emi = sdma_script_addrs->firi_2_mcu_addr;
		int_2_per = sdma_script_addrs->per_2_firi_addr;
		emi_2_per = sdma_script_addrs->mcu_2_firi_addr;
		break;
	case IMX_DMATYPE_UART:
		per_2_int = sdma_script_addrs->uart_2_per_addr;
		per_2_emi = sdma_script_addrs->uart_2_mcu_addr;
		int_2_per = sdma_script_addrs->per_2_app_addr;
		emi_2_per = sdma_script_addrs->mcu_2_app_addr;
		break;
	case IMX_DMATYPE_UART_SP:
		per_2_int = sdma_script_addrs->uartsh_2_per_addr;
		per_2_emi = sdma_script_addrs->uartsh_2_mcu_addr;
		int_2_per = sdma_script_addrs->per_2_shp_addr;
		emi_2_per = sdma_script_addrs->mcu_2_shp_addr;
		break;
	case IMX_DMATYPE_ATA:
		per_2_emi = sdma_script_addrs->ata_2_mcu_addr;
		emi_2_per = sdma_script_addrs->mcu_2_ata_addr;
		break;
	case IMX_DMATYPE_CSPI:
	case IMX_DMATYPE_EXT:
	case IMX_DMATYPE_SSI:
		per_2_int = sdma_script_addrs->app_2_per_addr;
		per_2_emi = sdma_script_addrs->app_2_mcu_addr;
		int_2_per = sdma_script_addrs->per_2_app_addr;
		emi_2_per = sdma_script_addrs->mcu_2_app_addr;
		break;
	case IMX_DMATYPE_SSI_SP:
	case IMX_DMATYPE_MMC:
	case IMX_DMATYPE_SDHC:
	case IMX_DMATYPE_CSPI_SP:
	case IMX_DMATYPE_ESAI:
	case IMX_DMATYPE_MSHC_SP:
		per_2_int = sdma_script_addrs->shp_2_per_addr;
		per_2_emi = sdma_script_addrs->shp_2_mcu_addr;
		int_2_per = sdma_script_addrs->per_2_shp_addr;
		emi_2_per = sdma_script_addrs->mcu_2_shp_addr;
		break;
	case IMX_DMATYPE_ASRC:
		per_2_emi = sdma_script_addrs->asrc_2_mcu_addr;
		emi_2_per = sdma_script_addrs->asrc_2_mcu_addr;
		per_2_per = sdma_script_addrs->per_2_per_addr;
		break;
	case IMX_DMATYPE_MSHC:
		per_2_emi = sdma_script_addrs->mshc_2_mcu_addr;
		emi_2_per = sdma_script_addrs->mcu_2_mshc_addr;
		break;
	case IMX_DMATYPE_CCM:
		per_2_emi = sdma_script_addrs->dptc_dvfs_addr;
		break;
	case IMX_DMATYPE_FIFO_MEMORY:
		res = sdma_script_addrs->ap_2_ap_fixed_addr;
		break;
	case IMX_DMATYPE_SPDIF:
		per_2_emi = sdma_script_addrs->spdif_2_mcu_addr;
		emi_2_per = sdma_script_addrs->mcu_2_spdif_addr;
		break;
	case IMX_DMATYPE_IPU_MEMORY:
		emi_2_per = sdma_script_addrs->ext_mem_2_ipu_addr;
		break;
	default:
		break;
	}

	sdma->pc_from_device = per_2_emi;
	sdma->pc_to_device = emi_2_per;
}

Regards,
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
