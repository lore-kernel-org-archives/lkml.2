Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2FKLTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:19:40 -0400
Received: from na6sys009bog005.obsmtp.com ([74.125.150.50]:49003 "EHLO
	na6sys009bog005.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab2FKLTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:19:38 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2012 07:19:37 EDT
Date: Mon, 11 Jun 2012 14:09:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
Message-ID: <20120611110958.GT6845@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QILrdhYozogw5Vly"
Content-Disposition: inline
In-Reply-To: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QILrdhYozogw5Vly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 11, 2012 at 08:01:20PM +0900, Jonghwa Lee wrote:
> Maxim 77686 has three 32KHz clock outputs through the its crystal oscilla=
tor.
> This driver can control those ouputs by I2C bus. The clocks are used to s=
upply
> to SOC and peripheral chips as a clock source. Clocks can be enabled/disa=
bled only.
> It uses regmap interface to communicate with I2C bus.
>=20
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v3
>  - Add mutex to the max77686_clk structure to make atomic execution of en=
able/disable function.
>=20
> v2
>  - Modify Kconfig symbol to depend on COMMON_CLK and MFD_MAX77686
>  - Fix max77686_clk structure and get_max77686_clk fuction to remove obsc=
ure points.
>=20
>  drivers/clk/Kconfig        |    8 ++
>  drivers/clk/Makefile       |    2 +
>  drivers/clk/clk-max77686.c |  209 ++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 219 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/clk-max77686.c
>=20
> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
> index 165e1fe..3f63330 100644
> --- a/drivers/clk/Kconfig
> +++ b/drivers/clk/Kconfig
> @@ -45,3 +45,11 @@ config COMMON_CLK_DEBUG
>  	  clk_notifier_count.
> =20
>  endmenu
> +
> +config CLK_MAX77686
> +	tristate "Maxim 77686 32KHz crystal oscillator driver"
> +	depends on MFD_MAX77686 && COMMON_CLK
> +	---help---
> +	  This driver supports for Maxim 77686's crystal oscillator.
> +	  Maxim 77686 has three 32KHz buffered outputs and It can
> +	  controls them over I2C bus.
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index 1f736bc..a952555b 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -2,3 +2,5 @@
>  obj-$(CONFIG_CLKDEV_LOOKUP)	+=3D clkdev.o
>  obj-$(CONFIG_COMMON_CLK)	+=3D clk.o clk-fixed-rate.o clk-gate.o \
>  				   clk-mux.o clk-divider.o
> +
> +obj-$(CONFIG_CLK_MAX77686)	+=3D clk-max77686.o
> diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
> new file mode 100644
> index 0000000..bf4d452
> --- /dev/null
> +++ b/drivers/clk/clk-max77686.c
> @@ -0,0 +1,209 @@
> +/*
> + * clk-max77686.c - Clock driver for Maxim 77686
> + *
> + * Copyright (C) 2012 Samsung Electornics
> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify=
 it
> + * under  the terms of  the GNU General  Public License as published by =
the
> + * Free Software Foundation;  either version 2 of the  License, or (at y=
our
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 =
 USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/max77686.h>
> +#include <linux/mfd/max77686-private.h>
> +#include <linux/clk-private.h>
> +#include <linux/mutex.h>
> +
> +enum {
> +	MAX77686_32KH_AP,
> +	MAX77686_32KH_CP,
> +	MAX77686_P32KH,
> +	MAX77686_CLKS_NUM,
> +};
> +
> +struct max77686_clk {
> +	struct max77686_dev *iodev;
> +	u32 mask;
> +	struct clk_hw hw;
> +	struct mutex mutex;
> +};
> +
> +struct clk *clk32khz_ap;

static

> +struct clk *clk32khz_cp;

static

> +struct clk *clk32khz_pmic;

static

also, why don't you place these pointers inside max77686_clk structure ?
If you keep them here, you will prevent boards with multiple instances
of this device to work.

> +char *max77686_clks[] =3D {

static const

> +	"32khap",
> +	"32khcp",
> +	"p32kh",
> +};
> +
> +static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
> +{
> +	return container_of(hw, struct max77686_clk, hw);
> +}
> +
> +static int max77686_clk_enable(struct clk_hw *hw)
> +{
> +	struct max77686_clk *max77686;
> +	int ret;
> +
> +	max77686 =3D get_max77686_clk(hw);
> +	if (!max77686)
> +		return -ENOMEM;

container_of() will never return NULL. You should check if hw is valid
before the container_of() instead.

> +	mutex_lock(&max77686->mutex);
> +	ret =3D regmap_update_bits(max77686->iodev->regmap,
> +		MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
> +	mutex_unlock(&max77686->mutex);
> +
> +	return ret;
> +}
> +
> +static void max77686_clk_disable(struct clk_hw *hw)
> +{
> +	struct max77686_clk *max77686;
> +
> +	max77686 =3D get_max77686_clk(hw);
> +	if (!max77686)
> +		return;
> +
> +	mutex_lock(&max77686->mutex);
> +	regmap_update_bits(max77686->iodev->regmap,
> +		MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
> +	mutex_unlock(&max77686->mutex);
> +}
> +
> +static int max77686_clk_is_enabled(struct clk_hw *hw)
> +{
> +	struct max77686_clk *max77686 =3D NULL;
> +	int ret;
> +	u32 val;
> +
> +	max77686 =3D get_max77686_clk(hw);
> +	if (!max77686)
> +		return -ENOMEM;
> +
> +	mutex_lock(&max77686->mutex);
> +	ret =3D regmap_read(max77686->iodev->regmap,
> +				MAX77686_REG_32KHZ, &val);
> +	mutex_unlock(&max77686->mutex);
> +
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	return val & max77686->mask;
> +}
> +
> +static struct clk_ops max77686_clk_ops =3D {
> +	.enable		=3D max77686_clk_enable,
> +	.disable	=3D max77686_clk_disable,
> +	.is_enabled	=3D max77686_clk_is_enabled,
> +};
> +
> +

one blank line is enough.

> +static __devinit int max77686_clk_probe(struct platform_device *pdev)

why platform_device ? Isn't this an i2c device ? So this should be
i2c-client driver...

> +{
> +	struct max77686_dev *iodev =3D dev_get_drvdata(pdev->dev.parent);
> +	struct max77686_clk *max77686[MAX77686_CLKS_NUM];
> +	int i, ret;
> +
> +	for (i =3D 0; i < MAX77686_CLKS_NUM; i++) {
> +		max77686[i] =3D devm_kzalloc(&pdev->dev,
> +				 sizeof(struct max77686_clk), GFP_KERNEL);
> +		if (!max77686[i])
> +			return -ENOMEM;
> +
> +		max77686[i]->iodev =3D iodev;
> +		max77686[i]->mask =3D 1 << i;
> +		mutex_init(&max77686[i]->mutex);
> +	}

doesn't look like the right way to do this. What if a user doesn't use
all clk outputs ?

> +
> +

one blank line.

> +	clk32khz_ap =3D clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_AP=
],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_32KH_AP]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_ap)) {
> +		ret =3D PTR_ERR(clk32khz_ap);
> +		goto err;
> +	}
> +
> +	clk32khz_cp =3D clk_register(&pdev->dev, max77686_clks[MAX77686_32KH_CP=
],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_32KH_CP]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_cp)) {
> +		ret =3D PTR_ERR(clk32khz_cp);

here you will leak clk32khz_ap.

> +		goto err;
> +	}
> +
> +	clk32khz_pmic =3D clk_register(&pdev->dev, max77686_clks[MAX77686_P32KH=
],
> +				&max77686_clk_ops,
> +				&max77686[MAX77686_P32KH]->hw,
> +				NULL, 0, CLK_IS_ROOT);
> +	if (IS_ERR(clk32khz_pmic)) {
> +		ret =3D PTR_ERR(clk32khz_pmic);

here you will leak clk32khz_cp and clk32khz_ap.

> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	dev_err(&pdev->dev, "Fail to register clock\n");
> +	return ret;
> +}
> +
> +static int __devexit max77686_clk_remove(struct platform_device *pdev)
> +{
> +	kfree(clk32khz_ap);
> +	kfree(clk32khz_cp);
> +	kfree(clk32khz_pmic);

kfree() or clk_unregister() ??

--=20
balbi

--QILrdhYozogw5Vly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1dIFAAoJEIaOsuA1yqREPEkP/2bgvoa7FY4H2URDgNFF8Lq3
hdbjNFperMUIRHUhdGh+UiZW1EwdtOz3c/N3FyyM2UgltpP9BXJISK3h+3tpZHEa
X9A5LyGa79PFhnBF9DpJQXgcSgNuFD45h5+xCbcBKyseELm6wx10TQWKE1PG1fnb
2NNNlkjBlYdIEzRlV9bYIcuoHCDOwWMWocDnSDE4KnKpb71PoF4g9bv13LebJp+l
s1PTsriCo/AtHfKhLb6cGBYJnkal0B8CKhdWvkmFgu8FPwECnHk7GMQr3dyGg6s4
qh4cahupJvNSCgJ4I2GVE48nHfsYK94BmgGuvF/g1pYp+XqDpTu6olx/D+hl7P26
qCgk4JOcYyX2nN0hdDHidlD3RkQEODl8dA3rbUmm8vgZ4QLdDqdDgoPBCRjfpxGW
L/s7YOownCosmAjzgzewcmcQ+DxoxKK3rfquWJW70ghrXm87tapovSnF+Frm9RKE
QAm4r+anHtYoMsU/rANqfi/lWJthEDHaudLKvXEevkCGMZnUIaShWk2iCqIQfq6T
lRNEoXBQ2Z9Zt3pF63oxdCRcuEA8D/JvgYtDc2Gh80nuUWVnbBnN6xgP8MLxM/06
+TcP+BEHqNvuontMURG22yfn/qFcelQVqAZrvxJX4Q106JHt0UPanf0InAhpOBZu
PCo298KQDtyRNsbP6h3V
=Cj1J
-----END PGP SIGNATURE-----

--QILrdhYozogw5Vly--
