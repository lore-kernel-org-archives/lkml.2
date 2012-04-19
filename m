Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2DSQHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:07:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51695 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2DSQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:07:36 -0400
Date: Thu, 19 Apr 2012 18:07:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: vitalywool@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v4] i2c: Add device tree support to i2c-pnx.c
Message-ID: <20120419160715.GD24987@pengutronix.de>
References: <1334850612-24151-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz+pwK2yUstbofK6"
Content-Disposition: inline
In-Reply-To: <1334850612-24151-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rz+pwK2yUstbofK6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2012 at 05:50:12PM +0200, Roland Stigge wrote:
> This patch adds device tree support to the pnx-i2c driver by using platfo=
rm
> resources for memory region and irq and removing dependency on mach inclu=
des.
>=20
> The following platforms are affected:
>=20
> * PNX
> * LPC31xx (WIP)
> * LPC32xx
>=20
> The patch is based on a patch by Jon Smirl, working on lpc31xx integration
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>=20
> ---
>=20
> Applies to v3.4-rc3 + already applied i2c-pnx.c patches from this series
>=20
> NOTE: I separated out this patch from the first patch series of the LPC32=
xx
> device tree conversion because most of those patches are already applied =
to
> -next. This is the last patch of this first series, a precondition for the
> LPC32xx device tree switch.
>=20
> Changes since v3:
> * Documentation/devicetree/bindings/i2c/pnx.txt:
>   - Documented interrupt-parent as required
>   - Documented slave-addr default in hex
>=20
>  Documentation/devicetree/bindings/i2c/pnx.txt |   40 ++++++++++++++++
>  drivers/i2c/busses/i2c-pnx.c                  |   65 +++++++++++++++++++=
-------
>  include/linux/i2c-pnx.h                       |    1=20
>  3 files changed, 89 insertions(+), 17 deletions(-)
>=20
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/i2c/pnx.txt
> @@ -0,0 +1,40 @@
> +* NXP PNX I2C Controller
> +
> +Required properties:
> +
> + - reg: Offset and length of the register set for the device
> + - compatible: should be "nxp,pnx-i2c"
> + - interrupts: configure one interrupt line
> + - #address-cells: always 1 (for i2c addresses)
> + - #size-cells: always 0
> + - interrupt-parent: the phandle for the interrupt controller that
> +   services interrupts for this device.
> +
> +Optional properties:
> +
> + - clock-frequency: desired I2C bus clock frequency in Hz, Default: 1000=
00 Hz
> + - pnx,timeout: I2C bus timeout in milliseconds, Default: 10 ms

I'd like to repeat my question to the devicetree folks here: Can we have
timeout generic? It doesn't make sense to me to have that per vendor
again and again. I searched devicetree.org and EPAPR but couldn't find a
hint.

> + - slave-addr: Address used by the controller, Hardware default: 0x6e
> +
> +Examples:
> +
> +	i2c1: i2c@400a0000 {
> +		compatible =3D "nxp,pnx-i2c";
> +		reg =3D <0x400a0000 0x100>;
> +		interrupt-parent =3D <&mic>;
> +		interrupts =3D <51 0>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +	};
> +
> +	i2c2: i2c@400a8000 {
> +		compatible =3D "nxp,pnx-i2c";
> +		reg =3D <0x400a8000 0x100>;
> +		interrupt-parent =3D <&mic>;
> +		interrupts =3D <50 0>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +		clock-frequency =3D <0x186a0>;
> +		pnx,timeout =3D <0x64>;

Did you change this, too? Timeouts are better readable in dec :)

> +		slave-addr =3D <0x11>;
> +	};
> --- linux-2.6.orig/drivers/i2c/busses/i2c-pnx.c
> +++ linux-2.6/drivers/i2c/busses/i2c-pnx.c
> @@ -23,10 +23,11 @@
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/slab.h>
> +#include <linux/of_i2c.h>
> =20
> -#define I2C_PNX_TIMEOUT		10 /* msec */
> -#define I2C_PNX_SPEED_KHZ	100
> -#define I2C_PNX_REGION_SIZE	0x100
> +#define I2C_PNX_TIMEOUT_DEFAULT		10 /* msec */
> +#define I2C_PNX_SPEED_KHZ_DEFAULT	100
> +#define I2C_PNX_REGION_SIZE		0x100
> =20
>  enum {
>  	mstatus_tdi =3D 0x00000001,
> @@ -74,8 +75,9 @@ enum {
>  #define I2C_REG_TXS(a)	((a)->ioaddr + 0x28)	/* Tx slave FIFO (RO) */
>  #define I2C_REG_STFL(a)	((a)->ioaddr + 0x2c)	/* Tx slave FIFO level (RO)=
 */
> =20
> -static inline int wait_timeout(long timeout, struct i2c_pnx_algo_data *d=
ata)
> +static inline int wait_timeout(struct i2c_pnx_algo_data *data)
>  {
> +	long timeout =3D data->timeout;
>  	while (timeout > 0 &&
>  			(ioread32(I2C_REG_STS(data)) & mstatus_active)) {
>  		mdelay(1);
> @@ -84,8 +86,9 @@ static inline int wait_timeout(long time
>  	return (timeout <=3D 0);
>  }
> =20
> -static inline int wait_reset(long timeout, struct i2c_pnx_algo_data *dat=
a)
> +static inline int wait_reset(struct i2c_pnx_algo_data *data)
>  {
> +	long timeout =3D data->timeout;
>  	while (timeout > 0 &&
>  			(ioread32(I2C_REG_CTL(data)) & mcntrl_reset)) {
>  		mdelay(1);
> @@ -97,7 +100,7 @@ static inline int wait_reset(long timeou
>  static inline void i2c_pnx_arm_timer(struct i2c_pnx_algo_data *alg_data)
>  {
>  	struct timer_list *timer =3D &alg_data->mif.timer;
> -	unsigned long expires =3D msecs_to_jiffies(I2C_PNX_TIMEOUT);
> +	unsigned long expires =3D msecs_to_jiffies(alg_data->timeout);
> =20
>  	if (expires <=3D 1)
>  		expires =3D 2;
> @@ -135,7 +138,7 @@ static int i2c_pnx_start(unsigned char s
>  	}
> =20
>  	/* First, make sure bus is idle */
> -	if (wait_timeout(I2C_PNX_TIMEOUT, alg_data)) {
> +	if (wait_timeout(alg_data)) {
>  		/* Somebody else is monopolizing the bus */
>  		dev_err(&alg_data->adapter.dev,
>  			"%s: Bus busy. Slave addr =3D %02x, cntrl =3D %x, stat =3D %x\n",
> @@ -228,7 +231,7 @@ static int i2c_pnx_master_xmit(struct i2
>  		if (alg_data->mif.len =3D=3D 0) {
>  			if (alg_data->last) {
>  				/* Wait until the STOP is seen. */
> -				if (wait_timeout(I2C_PNX_TIMEOUT, alg_data))
> +				if (wait_timeout(alg_data))
>  					dev_err(&alg_data->adapter.dev,
>  						"The bus is still active after timeout\n");
>  			}
> @@ -326,7 +329,7 @@ static int i2c_pnx_master_rcv(struct i2c
>  		if (alg_data->mif.len =3D=3D 0) {
>  			if (alg_data->last)
>  				/* Wait until the STOP is seen. */
> -				if (wait_timeout(I2C_PNX_TIMEOUT, alg_data))
> +				if (wait_timeout(alg_data))
>  					dev_err(&alg_data->adapter.dev,
>  						"The bus is still active after timeout\n");
> =20
> @@ -442,7 +445,7 @@ static void i2c_pnx_timeout(unsigned lon
> =20
>  	ctl |=3D mcntrl_reset;
>  	iowrite32(ctl, I2C_REG_CTL(alg_data));
> -	wait_reset(I2C_PNX_TIMEOUT, alg_data);
> +	wait_reset(alg_data);
>  	alg_data->mif.ret =3D -EIO;
>  	complete(&alg_data->mif.complete);
>  }
> @@ -457,18 +460,18 @@ static inline void bus_reset_if_active(s
>  			alg_data->adapter.name);
>  		iowrite32(ioread32(I2C_REG_CTL(alg_data)) | mcntrl_reset,
>  			  I2C_REG_CTL(alg_data));
> -		wait_reset(I2C_PNX_TIMEOUT, alg_data);
> +		wait_reset(alg_data);
>  	} else if (!(stat & mstatus_rfe) || !(stat & mstatus_tfe)) {
>  		/* If there is data in the fifo's after transfer,
>  		 * flush fifo's by reset.
>  		 */
>  		iowrite32(ioread32(I2C_REG_CTL(alg_data)) | mcntrl_reset,
>  			  I2C_REG_CTL(alg_data));
> -		wait_reset(I2C_PNX_TIMEOUT, alg_data);
> +		wait_reset(alg_data);
>  	} else if (stat & mstatus_nai) {
>  		iowrite32(ioread32(I2C_REG_CTL(alg_data)) | mcntrl_reset,
>  			  I2C_REG_CTL(alg_data));
> -		wait_reset(I2C_PNX_TIMEOUT, alg_data);
> +		wait_reset(alg_data);
>  	}
>  }
> =20
> @@ -612,6 +615,8 @@ static int __devinit i2c_pnx_probe(struc
>  	struct i2c_pnx_algo_data *alg_data;
>  	unsigned long freq;
>  	struct resource *res;
> +	u32 speed =3D I2C_PNX_SPEED_KHZ_DEFAULT * 1000;
> +	u32 slave_addr =3D ~0;
> =20
>  	alg_data =3D kzalloc(sizeof(*alg_data), GFP_KERNEL);
>  	if (!alg_data) {
> @@ -626,6 +631,18 @@ static int __devinit i2c_pnx_probe(struc
>  	alg_data->adapter.algo_data =3D alg_data;
>  	alg_data->adapter.nr =3D pdev->id;
> =20
> +	alg_data->timeout =3D I2C_PNX_TIMEOUT_DEFAULT;
> +#ifdef CONFIG_OF
> +	alg_data->adapter.dev.of_node =3D of_node_get(pdev->dev.of_node);
> +	if (pdev->dev.of_node) {
> +		of_property_read_u32(pdev->dev.of_node, "pnx,timeout",
> +				     &alg_data->timeout);
> +		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> +				     &speed);
> +		of_property_read_u32(pdev->dev.of_node, "slave-addr",
> +				     &slave_addr);
> +	}
> +#endif
>  	alg_data->clk =3D clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(alg_data->clk)) {
>  		ret =3D PTR_ERR(alg_data->clk);
> @@ -651,7 +668,7 @@ static int __devinit i2c_pnx_probe(struc
>  		dev_err(&pdev->dev,
>  		       "I/O region 0x%08x for I2C already in use.\n",
>  		       res->start);
> -		ret =3D -ENODEV;
> +		ret =3D -ENOMEM;
>  		goto out_clkget;
>  	}
> =20
> @@ -667,6 +684,9 @@ static int __devinit i2c_pnx_probe(struc
>  	if (ret)
>  		goto out_unmap;
> =20
> +	if (slave_addr !=3D ~0)
> +		iowrite32(slave_addr, I2C_REG_ADR(alg_data));
> +
>  	freq =3D clk_get_rate(alg_data->clk);
> =20
>  	/*
> @@ -680,14 +700,14 @@ static int __devinit i2c_pnx_probe(struc
>  	 * the deglitching filter length.
>  	 */
> =20
> -	tmp =3D ((freq / 1000) / I2C_PNX_SPEED_KHZ) / 2 - 2;
> +	tmp =3D (freq / speed) / 2 - 2;
>  	if (tmp > 0x3FF)
>  		tmp =3D 0x3FF;
>  	iowrite32(tmp, I2C_REG_CKH(alg_data));
>  	iowrite32(tmp, I2C_REG_CKL(alg_data));
> =20
>  	iowrite32(mcntrl_reset, I2C_REG_CTL(alg_data));
> -	if (wait_reset(I2C_PNX_TIMEOUT, alg_data)) {
> +	if (wait_reset(alg_data)) {
>  		ret =3D -ENODEV;
>  		goto out_clock;
>  	}
> @@ -699,7 +719,7 @@ static int __devinit i2c_pnx_probe(struc
>  		goto out_irq;
>  	}
>  	ret =3D request_irq(alg_data->irq, i2c_pnx_interrupt,
> -			0, pdev->name, alg_data);
> +			  0, pdev->name, alg_data);
>  	if (ret)
>  		goto out_clock;
> =20
> @@ -710,6 +730,8 @@ static int __devinit i2c_pnx_probe(struc
>  		goto out_irq;
>  	}
> =20
> +	of_i2c_register_devices(&alg_data->adapter);
> +
>  	dev_dbg(&pdev->dev, "%s: Master at %#8x, irq %d.\n",
>  		alg_data->adapter.name, res->start, alg_data->irq);
> =20
> @@ -748,10 +770,19 @@ static int __devexit i2c_pnx_remove(stru
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_OF
> +static const struct of_device_id i2c_pnx_of_match[] =3D {
> +	{ .compatible =3D "nxp,pnx-i2c" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, i2c_pnx_of_match);
> +#endif
> +
>  static struct platform_driver i2c_pnx_driver =3D {
>  	.driver =3D {
>  		.name =3D "pnx-i2c",
>  		.owner =3D THIS_MODULE,
> +		.of_match_table =3D of_match_ptr(i2c_pnx_of_match),
>  	},
>  	.probe =3D i2c_pnx_probe,
>  	.remove =3D __devexit_p(i2c_pnx_remove),
> --- linux-2.6.orig/include/linux/i2c-pnx.h
> +++ linux-2.6/include/linux/i2c-pnx.h
> @@ -32,6 +32,7 @@ struct i2c_pnx_algo_data {
>  	struct i2c_adapter	adapter;
>  	phys_addr_t		base;
>  	int			irq;
> +	u32			timeout;
>  };
> =20
>  #endif /* __I2C_PNX_H__ */

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--rz+pwK2yUstbofK6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+QODMACgkQD27XaX1/VRuXKQCfYwCvGLWVwFWv0nUnJYXt3CO0
0UUAnRm5L+Ok5YwTEMr65GsyP4GZ0T3Z
=109H
-----END PGP SIGNATURE-----

--rz+pwK2yUstbofK6--
