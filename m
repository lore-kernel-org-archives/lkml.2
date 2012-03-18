Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2CRLJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 07:09:14 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46177 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab2CRLJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 07:09:13 -0400
Message-ID: <4F65C281.4000907@metafoo.de>
Date: Sun, 18 Mar 2012 12:09:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2 2/2] regulator: Convert pcf50633 to get_voltage_sel
References: <1331942824.6622.1.camel@phoenix> <1331942914.6622.3.camel@phoenix>
In-Reply-To: <1331942914.6622.3.camel@phoenix>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 01:08 AM, Axel Lin wrote:
> Convert pcf50633 to get_voltage_sel and then we can remove
> pcf50633_regulator_voltage_value function and move its implementation
> to pcf50633_regulator_list_voltage.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

One minor comment inline though.

> ---
>  drivers/regulator/pcf50633-regulator.c |   65 ++++++++++++++-----------------
>  1 files changed, 29 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
> index 9ef7dff..b02cbb9 100644
> --- a/drivers/regulator/pcf50633-regulator.c
> +++ b/drivers/regulator/pcf50633-regulator.c
> @@ -151,23 +151,43 @@ static int pcf50633_regulator_set_voltage(struct regulator_dev *rdev,
>  	return pcf50633_reg_write(pcf, regnr, volt_bits);
>  }
>  
> -static int pcf50633_regulator_voltage_value(enum pcf50633_regulator_id id,
> -						u8 bits)
> +static int pcf50633_regulator_get_voltage_sel(struct regulator_dev *rdev)
>  {
> +	struct pcf50633 *pcf;
> +	int regulator_id;
> +	u8 volt_bits, regnr;
> +
> +	pcf = rdev_get_drvdata(rdev);
> +
> +	regulator_id = rdev_get_id(rdev);
> +	if (regulator_id >= PCF50633_NUM_REGULATORS)
> +		return -EINVAL;
> +
> +	regnr = pcf50633_regulator_registers[regulator_id];
> +
> +	volt_bits = pcf50633_reg_read(pcf, regnr);
> +
> +	return volt_bits;

Might as well just do "return pcf50633_reg_read(pcf, regnr);"


