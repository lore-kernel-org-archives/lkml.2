Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1FRPMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:12:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37350 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1FRPMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:12:31 -0400
Date: Sat, 18 Jun 2011 16:12:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        dg77.kim@samsung.com, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH 1/2] Exynos4 NURI: configure regulators and PMIC
Message-ID: <20110618151227.GB25163@sirena.org.uk>
References: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 06:09:31PM +0900, MyungJoo Ham wrote:

>  static struct regulator_init_data emmc_fixed_voltage_init_data = {
>  	.constraints		= {
> +		.min_uV		= 2800000,
> +		.max_uV		= 2800000,
>  		.name		= "VMEM_VDD_2.8V",
>  		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,

Since the regualtor can't change voltage specifying the voltage here
isn't going to achieve anything - to get the voltage reported through
get_voltage() you need to put the voltage in the platform data for the
fixed regulator.

> +static struct regulator_consumer_supply nuri_max8997_ldo1_consumer[] = {
> +	REGULATOR_SUPPLY("vadc", NULL), /* Used by CPU's ADC drv */
> +};

In the ADC regulator patch you called the supply vdd (though the chip
normally calls it vadc so that's the better name)...

Extra ' too.

> +static struct regulator_consumer_supply nuri_max8997_ldo8_consumer[] = {
> +	REGULATOR_SUPPLY("vusb_d", NULL), /* Used by CPU */
> +	REGULATOR_SUPPLY("vdac", NULL), /* Used by CPU */
> +};

Another VADC?  For a different supply?

> +		.state_mem	= {
> +			.enabled	= 0,

No need to initialize to zero.

> +static struct regulator_init_data nuri_max8997_ldo10_data = {
> +	.constraints	= {

You should be able to use __initdata for a lot of this by the way.

> +#define NURI_PMIC_GPIO		EXYNOS4_GPX0(7)
> +static void __init nuri_pmic_init(void)
> +{
> +	int gpio;
> +
> +	nuri_max8997_pdata.irq_base = irq_get_next_irq(IRQ_GPIO_END);
> +	gpio = NURI_PMIC_GPIO;
> +	gpio_request(gpio, "AP_PMIC_IRQ");
> +	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
> +	s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
> +}

I'm not sure both the #define and the variable make sense here...
