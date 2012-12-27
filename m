Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2L0XAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:00:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56531 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab2L0XAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:00:20 -0500
Date: Fri, 28 Dec 2012 00:59:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-i2c@vger.kernel.org>,
        <naveenkrishna.ch@gmail.com>, <kgene.kim@samsung.com>,
        <grant.likely@secretlab.ca>, <w.sang@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <taeggyun.ko@samsung.com>,
        <balbi@ti.com>, <thomas.abraham@linaro.org>
Subject: Re: [PATCH 2/2] i2c-exynos5: add debugfs support for registers
Message-ID: <20121227225950.GC12665@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1356434755-13702-1-git-send-email-ch.naveen@samsung.com>
 <1356434755-13702-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <1356434755-13702-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 25, 2012 at 04:55:55PM +0530, Naveen Krishna Chatradhi wrote:
> This patch replaces the dev_vdbg with debugfs function calls
> in i2c-exynos5.c driver.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v1:
> The debugfs implementation is a suggestion by Felipe Balbi.
> Its not tested, Implemented only for review purpose..
>=20
>  drivers/i2c/busses/i2c-exynos5.c |  140 +++++++++++++++++++++++++++++---=
------
>  1 file changed, 109 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-ex=
ynos5.c
> index 7614f60..2d2da22 100644
> --- a/drivers/i2c/busses/i2c-exynos5.c
> +++ b/drivers/i2c/busses/i2c-exynos5.c
> @@ -12,6 +12,7 @@
> =20
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/debugfs.h>
> =20
>  #include <linux/i2c.h>
>  #include <linux/init.h>
> @@ -55,6 +56,7 @@ struct exynos5_i2c {
> =20
>  	int			bus_num;
>  	int			speed_mode;
> +	struct dentry		*debugfs_root;
>  };
> =20
>  static const struct of_device_id exynos5_i2c_match[] =3D {
> @@ -63,39 +65,112 @@ static const struct of_device_id exynos5_i2c_match[]=
 =3D {
>  };
>  MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
> =20
> -/* TODO: Should go to debugfs */
> -static inline void dump_i2c_register(struct exynos5_i2c *i2c)
> +static int exynos5_i2c_regs_show(struct seq_file *s, void *data)
>  {
> -	dev_vdbg(i2c->dev, "Register dump(%d) :\n %x\n %x\n %x\n %x\n"
> -		" %x\n %x\n %x\n %x\n %x\n"
> -		" %x\n %x\n %x\n %x\n %x\n"
> -		" %x\n %x\n %x\n %x\n %x\n"
> -		" %x\n %x\n %x\n %x\n %x\n",
> -		i2c->suspended,
> -		readl(i2c->regs + HSI2C_CTL),
> -		readl(i2c->regs + HSI2C_FIFO_CTL),
> -		readl(i2c->regs + HSI2C_TRAILIG_CTL),
> -		readl(i2c->regs + HSI2C_CLK_CTL),
> -		readl(i2c->regs + HSI2C_CLK_SLOT),
> -		readl(i2c->regs + HSI2C_INT_ENABLE),
> -		readl(i2c->regs + HSI2C_INT_STATUS),
> -		readl(i2c->regs + HSI2C_ERR_STATUS),
> -		readl(i2c->regs + HSI2C_FIFO_STATUS),
> -		readl(i2c->regs + HSI2C_TX_DATA),
> -		readl(i2c->regs + HSI2C_RX_DATA),
> -		readl(i2c->regs + HSI2C_CONF),
> -		readl(i2c->regs + HSI2C_AUTO_CONF),
> -		readl(i2c->regs + HSI2C_TIMEOUT),
> -		readl(i2c->regs + HSI2C_MANUAL_CMD),
> -		readl(i2c->regs + HSI2C_TRANS_STATUS),
> -		readl(i2c->regs + HSI2C_TIMING_HS1),
> -		readl(i2c->regs + HSI2C_TIMING_HS2),
> -		readl(i2c->regs + HSI2C_TIMING_HS3),
> -		readl(i2c->regs + HSI2C_TIMING_FS1),
> -		readl(i2c->regs + HSI2C_TIMING_FS2),
> -		readl(i2c->regs + HSI2C_TIMING_FS3),
> -		readl(i2c->regs + HSI2C_TIMING_SLA),
> +	struct exynos5_i2c *i2c =3D (struct exynos5_i2c *)s->private;
> +
> +	if (i2c->suspended) {
> +		seq_printf(s, "i2c suspended, can't read registers\n");
> +		return 0;
> +	}
> +
> +	pm_runtime_get_sync(i2c->dev);
> +
> +	seq_printf(s, "CTL:\t\t0x%08x\n",
> +		readl(i2c->regs + HSI2C_CTL));

BTW, there is a generic regdump debugfs interface nowadays, please use
that instead (look for debugfs_create_regset32)

--=20
balbi

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ3NLmAAoJEIaOsuA1yqREV8gP/0t+V6LGzhei/9urBbKCTid6
ZH3Xf7TwjjaWLgr/x/TL6aDuPhtnrovJJq5hU2us813Qt1qcLmt3Rtux/m4gZb6n
nKhyQAtAvSxMbB9d3MSRI8+iHrF3Ehqo2wLdoQrpK/kzc0wWIrPdtUxrUNlNCiDh
jmy/bphYskmQqQc7AtyaIWL+gllxzg9hw4M7wAteW352WLSwDY5I4UrvX9jGHwfW
+rqFy6kp2XllMpJZgvcWrK4uo4VkyshA1Bp5Kt7hA2IybXwf7X5BpAz/SG0BpUrA
gvkgSpe3nVCyN0GFpTOTMv3S2NboTU0JvOsfPYYR0jfC5ftymusMi3C+remHV7fF
CX1Dd2x54TL4TVypBgd/sqlewn0872+Mggn0KgAWnkboTU+r0oEwc52F+s+EkkLq
q//ZE8lqmEcicF0487veXKOFLUyv7w+5rxB3TvtfCG4qW9Q9wg4/1BGgLzLoy6lh
m5AkZh1+f0c9EcV9H3tTLiFJvkYz0qAMOumf2G8P7gVY8jaXg5oCUcrtMNzqoSWZ
pf9rDYoIHn37YuU9dMveFn3QZK6DIGeOC0Z+PilkPLRTeyHAaxI0VFQXIRo/fNgW
jH+6UXU4S59JeKfJugRx05Ewx0i5lUTh/kcl+GHx5yCGhtM7/fJQYGIos9v57FGX
fl2Ldqxta/ulrSyOFhZH
=Nm/6
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--
