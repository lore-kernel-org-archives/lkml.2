Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2GPMIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:08:43 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:43245 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab2GPMIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:08:40 -0400
Message-ID: <50040440.80703@ti.com>
Date: Mon, 16 Jul 2012 17:38:32 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, loml <linux-omap@vger.kernel.org>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH RFT] regulator: twl: Fix list_voltate for twl6030ldo_ops
References: <1342434670.4717.6.camel@phoenix>
In-Reply-To: <1342434670.4717.6.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel,

On Monday 16 July 2012 04:01 PM, Axel Lin wrote:
> According to the datasheet, the voltage for twl6030ldo_ops is not linear for
> all cases. Linear mapping is only for the selection code from
> 00000001 to 00011000.
>
> Table 9. LDO Output Voltage Selection Code
> CODE     VOUT(V)    COD      VOUT(V)    CODE     VOUT(V)    CODE     VOUT(V)
> 00000000 0          00001000 1.7        00010000 2.5        00011000 3.3
> 00000001 1.0        00001001 1.8        00010001 2.6        00011001 Reserved
> 00000010 1.1        00001010 1.9        00010010 2.7        00011010 Reserved
> 00000011 1.2        00001011 2.0        00010011 2.8        00011011 Reserved
> 00000100 1.3        00001100 2.1        00010100 2.9        00011100 Reserved
> 00000101 1.4        00001101 2.2        00010101 3.0        00011101 Reserved
> 00000110 1.5        00001110 2.3        00010110 3.1        00011110 Reserved
> 00000111 1.6        00001111 2.4        00010111 3.2        00011111 2.75
>
> This patch implements the list_voltage callback based on above table.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>

Seems to work fine on my 4460 Panda.

Without this fix..

[    0.337341] V1V8: 1800 mV normal standby
[    0.338531] V2V1: 2100 mV normal standby
[    0.339813] VMMC: 1200 <--> 3000 mV at 3100 mV normal standby
					^^^^^^^^
[    0.341278] VPP: 1800 <--> 2500 mV at 2000 mV normal standby
					^^^^^^^^^
[    0.343505] VCXIO: 1800 mV normal standby
[    0.343597] VCXIO: supplied by V2V1
[    0.345855] VDAC: 1800 mV normal standby
[    0.345947] VDAC: supplied by V2V1
[    0.347717] VAUX2_6030: 1200 <--> 2800 mV at 1900 mV normal standby
						^^^^^^^^
[    0.349212] VAUX3_6030: 1000 <--> 3000 mV at 1300 mV normal standby
						^^^^^^^^

And with the fix..

[    0.337707] V1V8: 1800 mV normal standby
[    0.338897] V2V1: 2100 mV normal standby
[    0.340179] VMMC: 1200 <--> 3000 mV at 3000 mV normal standby
[    0.341674] VPP: 1800 <--> 2500 mV at 1900 mV normal standby
[    0.343383] VCXIO: 1800 mV normal standby
[    0.343475] VCXIO: supplied by V2V1
[    0.345764] VDAC: 1800 mV normal standby
[    0.345825] VDAC: supplied by V2V1
[    0.347656] VAUX2_6030: 1200 <--> 2800 mV at 1800 mV normal standby
[    0.349121] VAUX3_6030: 1000 <--> 3000 mV at 1200 mV normal standby

Thanks for the patch.

Tested-by: Rajendra Nayak <rnayak@ti.com>

> ---
>   drivers/regulator/twl-regulator.c |   31 ++++++++++++++++++++++++-------
>   1 file changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index de99b78..242fe90 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -559,6 +559,27 @@ static struct regulator_ops twl6030coresmps_ops = {
>   	.get_voltage	= twl6030coresmps_get_voltage,
>   };
>
> +static int twl6030ldo_list_voltage(struct regulator_dev *rdev, unsigned sel)
> +{
> +	struct twlreg_info *info = rdev_get_drvdata(rdev);
> +
> +	switch (sel) {
> +	case 0:
> +		return 0;
> +	case 1 ... 24:
> +		/* Linear mapping from 00000001 to 00011000:
> +		 * Absolute voltage value = 1.0 V + 0.1 V × (sel – 00000001)
> +		 */
> +		return (info->min_mV + 100 * (sel - 1)) * 1000;
> +	case 25 ... 30:
> +		return -EINVAL;
> +	case 31:
> +		return 2750000;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>   static int
>   twl6030ldo_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
>   {
> @@ -577,7 +598,7 @@ static int twl6030ldo_get_voltage_sel(struct regulator_dev *rdev)
>   }
>
>   static struct regulator_ops twl6030ldo_ops = {
> -	.list_voltage	= regulator_list_voltage_linear,
> +	.list_voltage	= twl6030ldo_list_voltage,
>
>   	.set_voltage_sel = twl6030ldo_set_voltage_sel,
>   	.get_voltage_sel = twl6030ldo_get_voltage_sel,
> @@ -906,12 +927,10 @@ static struct twlreg_info TWL6030_INFO_##label = { \
>   	.desc = { \
>   		.name = #label, \
>   		.id = TWL6030_REG_##label, \
> -		.n_voltages = (max_mVolts - min_mVolts)/100 + 1, \
> +		.n_voltages = 32, \
>   		.ops =&twl6030ldo_ops, \
>   		.type = REGULATOR_VOLTAGE, \
>   		.owner = THIS_MODULE, \
> -		.min_uV = min_mVolts * 1000, \
> -		.uV_step = 100 * 1000, \
>   		}, \
>   	}
>
> @@ -923,12 +942,10 @@ static struct twlreg_info TWL6025_INFO_##label = { \
>   	.desc = { \
>   		.name = #label, \
>   		.id = TWL6025_REG_##label, \
> -		.n_voltages = ((max_mVolts - min_mVolts)/100) + 1, \
> +		.n_voltages = 32, \
>   		.ops =&twl6030ldo_ops, \
>   		.type = REGULATOR_VOLTAGE, \
>   		.owner = THIS_MODULE, \
> -		.min_uV = min_mVolts * 1000, \
> -		.uV_step = 100 * 1000, \
>   		}, \
>   	}
>

