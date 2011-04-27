Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab1D0KkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:40:10 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:34609 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab1D0KkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:40:09 -0400
Date: Wed, 27 Apr 2011 13:40:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, balbi@ti.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/4] MFD: TWL6025: add phoenix lite support to twl6030
Message-ID: <20110427104001.GX13227@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-2-git-send-email-gg@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303897191-14792-2-git-send-email-gg@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:39:48AM +0100, Graeme Gregory wrote:
> Phoenix Lite is based on the twl6030 family of PMICs. It has mostly the
> same feature set of twl6030 but with small changes. The codec block has
> also been removed. It also has a new charger block and new features in
> its ADC block. VUSB handling also differs.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> ---
>  drivers/mfd/twl-core.c  |  103 ++++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/i2c/twl.h |   38 +++++++++++++++++-
>  2 files changed, 130 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 960b5be..6b9562a 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -198,6 +198,7 @@
>  #define TWL6030_BASEADD_GASGAUGE	0x00C0
>  #define TWL6030_BASEADD_PIH		0x00D0
>  #define TWL6030_BASEADD_CHARGER		0x00E0
> +#define TWL6025_BASEADD_CHARGER		0x00DA
>  
>  /* subchip/slave 2 0x4A - DFT */
>  #define TWL6030_BASEADD_DIEID		0x00C0
> @@ -236,6 +237,17 @@ unsigned int twl_rev(void)
>  }
>  EXPORT_SYMBOL(twl_rev);
>  
> +/* Export a function so child drivers of this mfd can tell which subclass
> + * of the chip is being used. eg regulator needs to know that it is a
> + * 6025 variant.
> + */
> +static unsigned int twl_feat;
> +unsigned int twl_features(void)
> +{
> +	return twl_feat;
> +}
> +EXPORT_SYMBOL(twl_features);

Why do you need other parts of the stack to access features ? It would
be better to use features to initialize proper fields in the TWL
structure and use that for runtime checking.

> @@ -328,6 +340,7 @@ static struct twl_mapping twl6030_map[] = {
>  
>  	{ SUB_CHIP_ID0, TWL6030_BASEADD_RTC },
>  	{ SUB_CHIP_ID0, TWL6030_BASEADD_MEM },
> +	{ SUB_CHIP_ID1, TWL6025_BASEADD_CHARGER },
>  };
>  
>  /*----------------------------------------------------------------------*/
> @@ -685,9 +698,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  	}
>  	if (twl_has_usb() && pdata->usb && twl_class_is_6030()) {
>  
> -		static struct regulator_consumer_supply usb3v3 = {
> -			.supply =	"vusb",
> -		};
> +		static struct regulator_consumer_supply usb3v3;
> +		int regulator;
>  
>  		if (twl_has_regulator()) {
>  			/* this is a template that gets copied */
> @@ -700,8 +712,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  					| REGULATOR_CHANGE_STATUS,
>  			};
>  
> -			child = add_regulator_linked(TWL6030_REG_VUSB,
> -						      &usb_fixed, &usb3v3, 1);
> +			if (features & TWL6025_SUBCLASS) {
> +				usb3v3.supply =	"ldousb";
> +				regulator = TWL6025_REG_LDOUSB;
> +			} else {
> +				usb3v3.supply = "vusb";
> +				regulator = TWL6030_REG_VUSB;
> +			}

that's just a name. Why don't you use the same name for both variants ?

> @@ -718,7 +737,15 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  		/* we need to connect regulators to this transceiver */
>  		if (twl_has_regulator() && child)
>  			usb3v3.dev = child;
> +	} else if (twl_has_regulator() && twl_class_is_6030()) {
> +		if (features & TWL6025_SUBCLASS)
> +			child = add_regulator(TWL6025_REG_LDOUSB,
> +						pdata->ldousb);
> +		else
> +			child = add_regulator(TWL6030_REG_VUSB, pdata->vusb);

see, then you need to add more fields to the platform_data structure
just because of a string.

> @@ -1093,6 +1173,8 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		twl_i2c_write_u8(TWL4030_MODULE_INTBR, temp, REG_GPPUPDCTR1);
>  	}
>  
> +	twl_feat = id->driver_data;

NACK. Avoid globals as much as possible.

> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index 0c0d1ae..f85f0ed 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -698,7 +703,21 @@ struct twl4030_platform_data {
>  	struct regulator_init_data              *vana;
>  	struct regulator_init_data              *vcxio;
>  	struct regulator_init_data              *vusb;
> -	struct regulator_init_data		*clk32kg;
> +	struct regulator_init_data              *clk32kg;

here you converted TABs into spaces. Fix it.

> +	/* TWL6025 LDO regulators */
> +	struct regulator_init_data		*ldo1;
> +	struct regulator_init_data		*ldo2;
> +	struct regulator_init_data		*ldo3;
> +	struct regulator_init_data		*ldo4;
> +	struct regulator_init_data		*ldo5;
> +	struct regulator_init_data		*ldo6;
> +	struct regulator_init_data		*ldo7;
> +	struct regulator_init_data		*ldoln;
> +	struct regulator_init_data		*ldousb;
> +	/* TWL6025 DCDC regulators */
> +	struct regulator_init_data		*smps3;
> +	struct regulator_init_data		*smps4;
> +	struct regulator_init_data		*vio6025;

this is just becoming really really ugly. You need a more clever way of
handling this. Maybe passing an array of regulators and the array size
instead of continuously adding fields to this structure.

> @@ -780,4 +799,21 @@ static inline int twl4030charger_usb_en(int enable) { return 0; }
>  #define TWL6030_REG_VRTC	47
>  #define TWL6030_REG_CLK32KG	48
>  
> +/* LDOs on 6025 have different names */
> +#define TWL6025_REG_LDO2	49
> +#define TWL6025_REG_LDO4	50
> +#define TWL6025_REG_LDO3	51
> +#define TWL6025_REG_LDO5	52
> +#define TWL6025_REG_LDO1	53
> +#define TWL6025_REG_LDO7	54
> +#define TWL6025_REG_LDO6	55
> +#define TWL6025_REG_LDOLN	56
> +#define TWL6025_REG_LDOUSB	57
> +
> +/* 6025 DCDC supplies */
> +#define TWL6025_REG_SMPS3	58
> +#define TWL6025_REG_SMPS4	59
> +#define TWL6025_REG_VIO		60
> +
> +

one blank line only.

-- 
balbi
