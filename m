Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2AWUdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:33:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51945 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2AWUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:33:37 -0500
Date: Mon, 23 Jan 2012 21:33:33 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Lars-Peter Clausen <lars@metafoo.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [RFC][PATCH] watchdog: Convert jz4740_wdt driver to watchdog core
Message-ID: <20120123203333.GA14133@pengutronix.de>
References: <1327067054.15205.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <1327067054.15205.6.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Fri, Jan 20, 2012 at 09:44:14PM +0800, Axel Lin wrote:
> This patch converts jz4740_wdt driver to use watchdog core APIs.
> Also use devm_* APIs to save a few error handling code.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Paul and Lars,
> I don't have this hardware handy.
> I'd appreciate if you can review and test this patch.
>=20
> Thanks,
> Axel
>=20
>  drivers/watchdog/Kconfig      |    1 +
>  drivers/watchdog/jz4740_wdt.c |  250 ++++++++++++++---------------------=
------
>  2 files changed, 86 insertions(+), 165 deletions(-)
>=20
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 877b107..32d48b8 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -955,6 +955,7 @@ config INDYDOG
>  config JZ4740_WDT
>  	tristate "Ingenic jz4740 SoC hardware watchdog"
>  	depends on MACH_JZ4740
> +	select WATCHDOG_CORE
>  	help
>  	  Hardware driver for the built-in watchdog timer on Ingenic jz4740 SoC=
s.
> =20
> diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
> index 17ef300..2cdb67f 100644
> --- a/drivers/watchdog/jz4740_wdt.c
> +++ b/drivers/watchdog/jz4740_wdt.c
> @@ -17,11 +17,9 @@
>  #include <linux/moduleparam.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> -#include <linux/fs.h>
>  #include <linux/miscdevice.h>
>  #include <linux/watchdog.h>
>  #include <linux/init.h>
> -#include <linux/bitops.h>
>  #include <linux/platform_device.h>
>  #include <linux/spinlock.h>
>  #include <linux/uaccess.h>

I'd think the latter two includes could go. Maybe even more?

> =20
> -static void jz4740_wdt_set_heartbeat(int new_heartbeat)
> +static int jz4740_wdt_set_heartbeat(struct watchdog_device *wdt_dev,
> +				    unsigned int new_heartbeat)
>  {
> +	struct jz4740_wdt_drvdata *drvdata =3D watchdog_get_drvdata(wdt_dev);
>  	unsigned int rtc_clk_rate;
>  	unsigned int timeout_value;
>  	unsigned short clock_div =3D JZ_WDT_CLOCK_DIV_1;
> =20
>  	heartbeat =3D new_heartbeat;

I'd think it would be better to drop 'heartbeat' usage in this function her=
e,
but simply use 'new_heartbeat' and...

> -static int jz4740_wdt_open(struct inode *inode, struct file *file)
> +static int jz4740_wdt_start(struct watchdog_device *wdt_dev)
>  {
> -	if (test_and_set_bit(WDT_IN_USE, &jz4740_wdt.status))
> -		return -EBUSY;
> -
> -	jz4740_wdt_enable();
> +	jz4740_timer_enable_watchdog();
> +	jz4740_wdt_set_heartbeat(wdt_dev, heartbeat);

=2E.. use wdt_dev->timeout here (which would need to get initialized in pro=
be
using the global 'heartbeat')


[...]

> +	drvdata->mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (drvdata->mem =3D=3D NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		return -ENXIO;

You don't need the pointer check here. devm_request_and_ioremap will do tha=
t, too.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8dxB0ACgkQD27XaX1/VRuozgCbBeC5UjILg6wuxvEu7anHnaMT
snkAoLET1vnV50jA7xtyX7ypbqaSP1Dj
=/mJE
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
