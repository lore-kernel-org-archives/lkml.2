Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab1ANUCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:02:05 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:65157 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1ANUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:02:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qebUvY2oxRz+ZTfev2VsI
Date: Fri, 14 Jan 2011 12:01:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
Message-ID: <20110114200155.GN4957@atomide.com>
References: <524702.86777.qm@web121609.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524702.86777.qm@web121609.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sutharsan Ramamoorthy <sutharsan.ramamoorthy@yahoo.com> [110113 15:22]:
> --- linux-2.6.37_vanilla/arch/arm/mach-omap2/usb-cywb-pnand.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.37-gpmc/arch/arm/mach-omap2/usb-cywb-pnand.c	2011-01-12 12:37:23.154716913 -0800
...

> +/*
> + * switch GPMC DATA bus mode
> + */
> +void cywb_gpmc_enable_16bit_bus(bool dbus16_enabled)
> +{
> +	u32 tmp32;
> +
> +	/*
> +	 * disable gpmc CS4 operation 1st
> +	 */
> +	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS,
> +				GPMC_CS_CONFIG7) & ~GPMC_CONFIG7_CSVALID;
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
> +
> +	/*
> +	 * GPMC NAND data bus can be 8 or 16 bit wide
> +	 */
> +	if (dbus16_enabled) {
> +		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
> +				(GPMC_CONFIG1_DEVICETYPE(2) |
> +				GPMC_CONFIG1_WAIT_PIN_SEL(2) |
> +				GPMC_CONFIG1_DEVICESIZE_16));
> +	} else {
> +		gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
> +				(GPMC_CONFIG1_DEVICETYPE(2) |
> +				GPMC_CONFIG1_WAIT_PIN_SEL(2)));
> +	}
> +
> +	/*
> +	 * re-enable astoria CS operation on GPMC
> +	 */
> +	 gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
> +			(tmp32 | GPMC_CONFIG7_CSVALID));
> +}

This should be static, right?


> +int cywb_pnand_platform_retime()
> +{
> +	u32 tmp32;
> +	struct gpmc_timings timings;
> +	int retval = 0;
> +
> +
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
> +					(GPMC_CONFIG1_DEVICETYPE(2) |
> +					GPMC_CONFIG1_WAIT_PIN_SEL(2)));
> +
> +	memset(&timings, 0, sizeof(timings));
> +
> +	/* cs timing */
> +	timings.cs_on = WB_GPMC_CS_T_O_N;
> +	timings.cs_wr_off = WB_GPMC_BUSCYC_T;
> +	timings.cs_rd_off = WB_GPMC_BUSCYC_T;
> +
> +	/* adv timing */
> +	timings.adv_on = WB_GPMC_ADV_T_O_N;
> +	timings.adv_rd_off = WB_GPMC_BUSCYC_T;
> +	timings.adv_wr_off = WB_GPMC_BUSCYC_T;
> +
> +	/* oe timing */
> +	timings.oe_on = WB_GPMC_OE_T_O_N;
> +	timings.oe_off = WB_GPMC_OE_T_O_F_F;
> +	timings.access = WB_GPMC_RD_T_A_C_C;
> +	timings.rd_cycle = WB_GPMC_BUSCYC_T;
> +
> +	/* we timing */
> +	timings.we_on = WB_GPMC_WE_T_O_N;
> +	timings.we_off = WB_GPMC_WE_T_O_F_F;
> +	timings.wr_access = WB_GPMC_WR_T_A_C_C;
> +	timings.wr_cycle = WB_GPMC_BUSCYC_T;
> +
> +	timings.page_burst_access = WB_GPMC_BUSCYC_T;
> +	timings.wr_data_mux_bus = WB_GPMC_BUSCYC_T;
> +	gpmc_cs_set_timings(AST_GPMC_CS, &timings);
> +
> +	/*
> +	 * DISABLE cs4, NOTE GPMC REG7 is already configured
> +	 * at this point by gpmc_cs_request
> +	 */
> +	tmp32 = gpmc_cs_read_reg(AST_GPMC_CS, GPMC_CS_CONFIG7) &
> +					~GPMC_CONFIG7_CSVALID;
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7, tmp32);
> +
> +	/*
> +	 * PROGRAM chip select Region, (see OMAP3430 TRM PAGE 1088)
> +	 */
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
> +				(AS_CS_MASK | AS_CS_BADDR));
> +
> +	/*
> +	 * by default configure GPMC into 8 bit mode
> +	 * (to match astoria default mode)
> +	 */
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
> +				(GPMC_CONFIG1_DEVICETYPE(2) |
> +				GPMC_CONFIG1_WAIT_PIN_SEL(2)));
> +
> +	/*
> +	 * ENABLE astoria cs operation on GPMC
> +	 */
> +	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG7,
> +					(tmp32 | GPMC_CONFIG7_CSVALID));
> +
> +	return retval;
> +
> +}
> +
> +static struct cywb_platform_data cywb_plat = {
> +	.retime			= cywb_pnand_platform_retime,
> +	.config_bus_width	= cywb_gpmc_enable_16bit_bus,
> +};
> +
> +static struct platform_device cywb_device = {
> +	.name		= "west_bridge_dev",
> +	.id		= -1,
> +	.dev = {
> +		.platform_data		= &cywb_plat,
> +	}
> +};
> +
> +#ifdef CONFIG_WESTBRIDGE_ASTORIA
> +void __init usb_cywb_init()
> +{
> +	if (platform_device_register(&cywb_device) < 0)
> +		dev_err(&cywb_device.dev, "Unable to register cywb-astoria device\n");
> +}
> +#else
> +void __init usb_cywb_init()
> +{
> +}
> +#endif /* CONFIG_WESTBRIDGE_ASTORIA */

Can you also move gpmc_cs_request to this file too?

Regards,

Tony
