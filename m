Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1DVQDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:03:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44215 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab1DVQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:03:40 -0400
Message-ID: <4DB1A6CE.2080803@pengutronix.de>
Date: Fri, 22 Apr 2011 18:03:26 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        Kevin Hilman <khilman@ti.com>, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 11/11] da850: pruss CAN board specific additions.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1303474109-6212-12-git-send-email-subhasish@mistralsolutions.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC6C8A98F4FBE583E5BD5B940"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC6C8A98F4FBE583E5BD5B940
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/22/2011 02:08 PM, Subhasish Ghosh wrote:
> This patch adds the pruss CAN pinmux and registers the device
> with the pruss mfd driver.
>=20
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |   46 +++++++++++++++++++++++=
++++++++
>  1 files changed, 46 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-da=
vinci/board-da850-evm.c
> index e7fdf31..e1ff18c 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -48,6 +48,7 @@
> =20
>  #define DA850_MMCSD_CD_PIN		GPIO_TO_PIN(4, 0)
>  #define DA850_MMCSD_WP_PIN		GPIO_TO_PIN(4, 1)
> +#define DA850_PRUSS_CAN_TRX_PIN		GPIO_TO_PIN(2, 0)
> =20
>  #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
> =20
> @@ -1117,6 +1118,43 @@ static __init int da850_evm_init_cpufreq(void)
>  static __init int da850_evm_init_cpufreq(void) { return 0; }
>  #endif
> =20
> +static const short da850_evm_pruss_can_pins[] =3D {
> +	DA850_PRUSS_PRU0_R31_0, DA850_PRUSS_PRU1_R30_15,
> +	DA850_PRUSS_PRU1_R31_18, DA850_GPIO2_0,
> +	-1
> +};
> +
> +static int __init da850_evm_pruss_can_setup(void)
> +{
> +	int ret, val =3D 0;
> +	void __iomem *cfg_chip3_reg;
> +
> +	ret =3D davinci_cfg_reg_list(da850_evm_pruss_can_pins);
> +	if (ret)
> +		pr_warning("%s: da850_evm_pruss_can_pins mux setup "
> +					"failed:%d\n", __func__, ret);
> +	cfg_chip3_reg =3D DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
> +	val =3D __raw_readl(cfg_chip3_reg);
> +	val |=3D BIT(3);
> +	__raw_writel(val, cfg_chip3_reg);
> +
> +	/* value =3D 0 to enable the CAN transceiver */
> +	ret =3D gpio_request_one(DA850_PRUSS_CAN_TRX_PIN,
> +			GPIOF_OUT_INIT_LOW, "pruss_can_en");
> +	if (ret) {
> +		pr_warning("Cannot setup GPIO %d\n", DA850_PRUSS_CAN_TRX_PIN);
> +		gpio_free(DA850_PRUSS_CAN_TRX_PIN);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct da850_evm_pruss_can_data can_data =3D {
> +	.version	=3D 1,
> +	.setup		=3D da850_evm_pruss_can_setup,

I suggest to do the pinmux setup unconditionally before registering the
can driver. Rename setup into transceiver_switch and extend the driver
to switch on and off the transceiver. Call the transceiver switch from
open and close in the can drver.

> +};
> +
> +
>  static const short da850_evm_pruss_suart_pins[] =3D {
>  	DA850_AHCLKX, DA850_ACLKX, DA850_AFSX,
>  	DA850_AHCLKR, DA850_ACLKR, DA850_AFSR,
> @@ -1161,6 +1199,14 @@ static struct mfd_cell cell[] =3D {
>  		.resources	=3D da850_evm_pruss_suart_resource,
>  	},
>  	{
> +		.id		=3D 1,
> +		.name		=3D "da8xx_pruss_can",
> +		.platform_data	=3D &can_data,
> +		.data_size	=3D sizeof(can_data),
> +		.num_resources  =3D 0,
> +		.resources	=3D NULL,
> +	},
> +	{
>  		.name		=3D NULL,
>  	},
>  };

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC6C8A98F4FBE583E5BD5B940
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2xps4ACgkQjTAFq1RaXHPAIACcCca7OfD7ScOpk3d+DV0wnjic
naMAn0dqrKUPEnXw/TqrnG51Q0+11+RO
=zNsb
-----END PGP SIGNATURE-----

--------------enigC6C8A98F4FBE583E5BD5B940--
