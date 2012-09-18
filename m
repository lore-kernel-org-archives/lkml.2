Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2IREz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:55:56 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57799 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab2IREzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:55:54 -0400
Date: Tue, 18 Sep 2012 07:51:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Walmsley <paul@pwsan.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing cpu_is_omap
 usage
Message-ID: <20120918045108.GB22055@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120917202943.GV4521@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20120917202943.GV4521@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2012 at 01:29:44PM -0700, Tony Lindgren wrote:
> Commit 7d7e1eba (ARM: OMAP2+: Prepare for irqs.h removal) broke
> compile for non-omap as include plat/cpu.h was added:
>=20
> drivers/mfd/twl-core.c:49:22: fatal error: plat/cpu.h: No such file or di=
rectory
>=20
> This header was indirectly included earlier when SPARSE_IRQ was not
> set, but does not exist on most platforms.
>=20
> Fix the problem by removing the cpu_is_omap usage that should
> not exist in drivers at all. We can do this by adding proper
> clock aliases for the twl-core.c drivers, and drop separate
> handling for cases when clock framework is not available as
> the behaviour will stay the same.
>=20
> Note that we need to add a platform device to avoid using the
> i2c provided names that may be different on various omaps.
>=20
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
> Samuel, I'd like to queue this via arm-soc as that's where I have
> the breaking patch is if this patch is OK with you.
>=20
> --- a/arch/arm/mach-omap2/clock2430_data.c
> +++ b/arch/arm/mach-omap2/clock2430_data.c
> @@ -1856,6 +1856,7 @@ static struct omap_clk omap2430_clks[] =3D {
>  	CLK(NULL,	"func_32k_ck",	&func_32k_ck,	CK_243X),
>  	CLK(NULL,	"secure_32k_ck", &secure_32k_ck, CK_243X),
>  	CLK(NULL,	"osc_ck",	&osc_ck,	CK_243X),
> +	CLK("twl",	"fck",		&osc_ck,	CK_243X),
>  	CLK(NULL,	"sys_ck",	&sys_ck,	CK_243X),
>  	CLK(NULL,	"alt_ck",	&alt_ck,	CK_243X),
>  	CLK(NULL,	"mcbsp_clks",	&mcbsp_clks,	CK_243X),
> --- a/arch/arm/mach-omap2/clock3xxx_data.c
> +++ b/arch/arm/mach-omap2/clock3xxx_data.c
> @@ -3226,6 +3226,7 @@ static struct omap_clk omap3xxx_clks[] =3D {
>  	CLK(NULL,	"virt_26000000_ck",	&virt_26000000_ck,	CK_3XXX),
>  	CLK(NULL,	"virt_38_4m_ck", &virt_38_4m_ck, CK_3XXX),
>  	CLK(NULL,	"osc_sys_ck",	&osc_sys_ck,	CK_3XXX),
> +	CLK("twl",	"fck",		&osc_sys_ck,	CK_3XXX),
>  	CLK(NULL,	"sys_ck",	&sys_ck,	CK_3XXX),
>  	CLK(NULL,	"sys_altclk",	&sys_altclk,	CK_3XXX),
>  	CLK(NULL,	"mcbsp_clks",	&mcbsp_clks,	CK_3XXX),
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -46,8 +46,6 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c/twl.h>
> =20
> -#include <plat/cpu.h>
> -
>  #include "twl-core.h"
> =20
>  /*
> @@ -1134,12 +1132,7 @@ static void clocks_init(struct device *dev,
>  	u32 rate;
>  	u8 ctrl =3D HFCLK_FREQ_26_MHZ;
> =20
> -#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
> -	if (cpu_is_omap2430())
> -		osc =3D clk_get(dev, "osc_ck");
> -	else
> -		osc =3D clk_get(dev, "osc_sys_ck");
> -
> +	osc =3D clk_get(dev, "fck");
>  	if (IS_ERR(osc)) {
>  		printk(KERN_WARNING "Skipping twl internal clock init and "
>  				"using bootloader value (unknown osc rate)\n");
> @@ -1149,18 +1142,6 @@ static void clocks_init(struct device *dev,
>  	rate =3D clk_get_rate(osc);
>  	clk_put(osc);
> =20
> -#else
> -	/* REVISIT for non-OMAP systems, pass the clock rate from
> -	 * board init code, using platform_data.
> -	 */
> -	osc =3D ERR_PTR(-EIO);
> -
> -	printk(KERN_WARNING "Skipping twl internal clock init and "
> -	       "using bootloader value (unknown osc rate)\n");
> -
> -	return;
> -#endif
> -
>  	switch (rate) {
>  	case 19200000:
>  		ctrl =3D HFCLK_FREQ_19p2_MHZ;
> @@ -1222,10 +1203,23 @@ twl_probe(struct i2c_client *client, const struct=
 i2c_device_id *id)
>  {
>  	struct twl4030_platform_data	*pdata =3D client->dev.platform_data;
>  	struct device_node		*node =3D client->dev.of_node;
> +	struct platform_device		*pdev;
>  	int				irq_base =3D 0;
>  	int				status;
>  	unsigned			i, num_slaves;
> =20
> +	pdev =3D platform_device_alloc(DRIVER_NAME, -1);
> +	if (!pdev) {
> +		dev_err(&client->dev, "can't alloc pdev\n");
> +		return -ENOMEM;
> +	}
> +
> +	status =3D platform_device_add(pdev);
> +	if (status) {
> +		platform_device_put(pdev);
> +		return status;
> +	}
> +
>  	if (node && !pdata) {
>  		/*
>  		 * XXX: Temporary pdata until the information is correctly
> @@ -1234,23 +1228,30 @@ twl_probe(struct i2c_client *client, const struct=
 i2c_device_id *id)
>  		pdata =3D devm_kzalloc(&client->dev,
>  				     sizeof(struct twl4030_platform_data),
>  				     GFP_KERNEL);
> -		if (!pdata)
> -			return -ENOMEM;
> +		if (!pdata) {
> +			status =3D -ENOMEM;
> +			goto free;
> +		}
>  	}
> =20
>  	if (!pdata) {
>  		dev_dbg(&client->dev, "no platform data?\n");
> -		return -EINVAL;
> +		status =3D -EINVAL;
> +		goto free;
>  	}
> =20
> +	platform_set_drvdata(pdev, pdata);
> +
>  	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) =3D=3D 0) {
>  		dev_dbg(&client->dev, "can't talk I2C?\n");
> -		return -EIO;
> +		status =3D -EIO;
> +		goto free;
>  	}
> =20
>  	if (inuse) {
>  		dev_dbg(&client->dev, "driver is already in use\n");
> -		return -EBUSY;
> +		status =3D -EBUSY;
> +		goto free;
>  	}
> =20
>  	if ((id->driver_data) & TWL6030_CLASS) {
> @@ -1285,7 +1286,7 @@ twl_probe(struct i2c_client *client, const struct i=
2c_device_id *id)
>  	inuse =3D true;
> =20
>  	/* setup clock framework */
> -	clocks_init(&client->dev, pdata->clock);
> +	clocks_init(&pdev->dev, pdata->clock);
> =20
>  	/* read TWL IDCODE Register */
>  	if (twl_id =3D=3D TWL4030_CLASS_ID) {
> @@ -1335,6 +1336,9 @@ twl_probe(struct i2c_client *client, const struct i=
2c_device_id *id)
>  fail:
>  	if (status < 0)
>  		twl_remove(client);
> +free:
> +	if (status < 0)
> +		platform_device_unregister(pdev);
> =20
>  	return status;
>  }

--=20
balbi

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQV/28AAoJEIaOsuA1yqREkzoP/2bYJX+CEPfzipWE0lKX9il9
54IHlk7Wyz+9lgW1NV9QrX3+qKCT98VecMS09bPZJVErN3szJAuT/eFP4MzjVgxi
pkBNCfYYFSoqBOmGYUFdpeMlXkEbGlJ3ofMIztxt55/mBwxwJrdJSRS70qdiJ6uA
4vk7/leshPGaJ6vZabAaKRSIL38VZhFzmVng2Ltc3A4R0ZbQ+SHh6A63ge5OU9zo
wFKcmqlbe0T3prxlDowA4CjWVA8btvRPkk1m4qlXw3Vjmp7+N52+vHKhDV5bHVKZ
KSInk4cpxnDODacrNr/648/VDcuTe7gN+l+V7GN/wwy22op5HA23HEyQCGBPjL8d
oZc2nsJgL2/c2EYkea7KF66NnuxKnXLSAwA0dKM9IcjkDbqga5x5MRoVNWK1mJqz
AnOZRqhAPr8WLpN9TuNdX9y8qP9Yx1Fz/voPG4NnnkDcDASknuHOvd6plDRXhD93
hAEbjLJWbxNerhY5ncwHg+l28pno1HtKanc9XwoB0zsKkQYnBZCVkQMXbWRgkHFN
bFPi1wuV9aeIEWajNS71JtQeZ8Eqi8ats7iac8h3kB/Cbr2X1i65yzr7erWQtcDP
m7gM3nwL8K3RD2CW0ICFlvXp+BMo8+Z83emHjJSPOo0pY8rMEPTmM07rSuYCKOmb
vyxlyS/vIzw2+MiEiwfk
=LyEK
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
