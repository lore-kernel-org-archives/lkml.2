Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2IBT7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:59:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:59:30 -0400
Date: Sun, 2 Sep 2012 21:59:17 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH 3/3] pwm: Add Ingenic JZ4740 support
Message-ID: <20120902195917.GB10930@avionic-0098.mockup.avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
 <1346579550-5990-4-git-send-email-thierry.reding@avionic-design.de>
 <504370BF.6090702@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <504370BF.6090702@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:PnTmiHAzihGawP3wR8kWu0bPTPilCuLUqbUVl0/GwvS
 9d8mIm5WUQXtd3LOJxAWkknNpbnJRnbr2VYpSAo7UNdFRSIkid
 /F3XWdEppoPqP0uggjkqbY2GxkGsvT6YlqaZoLILFZrVQap74X
 muxPA1Du99LupIGtu14lA539FoswtLGnGLXXG4uUC4lcI4WXzC
 iHJUzqVV7fdMnYSE1M9qXIAseMB64xe59A0x40J+f11QsfrNe3
 S7E5BrPcf+SA7quJtrMj78UwaG7s3DbW6v+o5T46AX8AO7bQDu
 Ka0nW2MeYnEw+z7D5BDXQiPDdTL098jyoBBtKvveiEaiVCnaJF
 xAQAnVKJMNUacG+JN+BtiYzDZ2MxzibhqnC3sjzLkmvr9Rcz5F
 +NbQNgow878lWWap9SHxT8JOhQKSR04/aY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 02, 2012 at 04:44:15PM +0200, Lars-Peter Clausen wrote:
> On 09/02/2012 11:52 AM, Thierry Reding wrote:
> > diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> > index 92b1782..f5acdaa 100644
> > --- a/drivers/pwm/core.c
> > +++ b/drivers/pwm/core.c
> > @@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(pwm_free);
> >   */
> >  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> >  {
> > -	if (!pwm || period_ns =3D=3D 0 || duty_ns > period_ns)
> > +	if (!pwm || duty_ns < 0 || period_ns <=3D 0 || duty_ns > period_ns)
> >  		return -EINVAL;
> > =20
>=20
> This change seems to be unrelated.

Yes, that slipped in by mistake. That was supposed to go into a separate
patch so that the .config of each driver doesn't have to repeat these
checks.

> >  	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
> > diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> > new file mode 100644
> > index 0000000..db29b37
> > --- /dev/null
> > +++ b/drivers/pwm/pwm-jz4740.c
> > @@ -0,0 +1,205 @@
> > +/*
> > + *  Copyright (C) 2010, Lars-Peter Clausen <lars@metafoo.de>
> > + *  JZ4740 platform PWM support
> > + *
> > + *  This program is free software; you can redistribute it and/or modi=
fy it
> > + *  under  the terms of the GNU General  Public License as published b=
y the
> > + *  Free Software Foundation;  either version 2 of the License, or (at=
 your
> > + *  option) any later version.
> > + *
> > + *  You should have received a copy of the GNU General Public License =
along
> > + *  with this program; if not, write to the Free Software Foundation, =
Inc.,
> > + *  675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/err.h>
> > +#include <linux/gpio.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwm.h>
> > +
> > +#include <asm/mach-jz4740/gpio.h>
> > +#include <timer.h>
>=20
> #include <asm/mach-jz4740/timer.h>
>=20
> > +
> > +#define NUM_PWM 6
> > +
> > +static const unsigned int jz4740_pwm_gpio_list[NUM_PWM] =3D {
>=20
> As mth said, it would be better to have JZ_GPIO_PWM0 and here as well and=
 set
> NUM_PWM to 8. Right now we are using the timers associated to PWM channel=
 0 and
> 1 as system timers. But there might be devices where this is not possible=
, e.g.
> because the PWM is actually connected to something. Also this fixes the o=
f by
> two for the hwpwm id.

Okay. I was actually planning on doing some cleanup in a follow-up patch
and try to limit actual changes in this patch to what is required by the
conversion. However if Maarten and you both are okay with it I can make
these additional changes while at it.

> > +	if (ret) {
> > +		printk(KERN_ERR "Failed to request pwm gpio: %d\n", ret);
>=20
> dev_err(chip->dev, ....

Okay.

> > +	is_enabled =3D jz4740_timer_is_enabled(pwm->hwpwm);
> > +	if (is_enabled)
> > +		pwm_disable(pwm);
>=20
> I think this should be jz4740_pwm_disable
>=20
> > +
> > +	jz4740_timer_set_count(pwm->hwpwm, 0);
> > +	jz4740_timer_set_duty(pwm->hwpwm, duty);
> > +	jz4740_timer_set_period(pwm->hwpwm, period);
> > +
> > +	ctrl =3D JZ_TIMER_CTRL_PRESCALER(prescaler) | JZ_TIMER_CTRL_SRC_EXT |
> > +		JZ_TIMER_CTRL_PWM_ABBRUPT_SHUTDOWN;
> > +
> > +	jz4740_timer_set_ctrl(pwm->hwpwm, ctrl);
> > +
> > +	if (is_enabled)
> > +		pwm_enable(pwm);
>=20
> and jz4740_pwm_enable here.

I wonder if this is actually required here. Can the timer really not be
reprogrammed while enabled?

> > +
> > +	return 0;
> > +}
> > +
>=20
> > +
> > +static const struct pwm_ops jz4740_pwm_ops =3D {
> > +	.request =3D jz4740_pwm_request,
> > +	.free =3D jz4740_pwm_free,
> > +	.config =3D jz4740_pwm_config,
> > +	.enable =3D jz4740_pwm_enable,
> > +	.disable =3D jz4740_pwm_disable,
>=20
> .owner =3D THIS_MODULE,

Yes, I forgot that one.

> > +};
> > +
> > +static int jz4740_pwm_probe(struct platform_device *pdev)
> __devinit

Yes, I'll add that.

> > +{
> > +	struct jz4740_pwm_chip *jz4740;
> > +	int ret =3D 0;
>=20
> The '=3D 0' is not really necessary since it will be overwritten anyway.

Right, I'll drop it.

> > +static int jz4740_pwm_remove(struct platform_device *pdev)
> __devexit

Can do.

> > +{
> > +	struct jz4740_pwm_chip *jz4740 =3D platform_get_drvdata(pdev);
> > +	int ret;
> > +
> > +	ret =3D pwmchip_remove(&jz4740->chip);
> > +	if (ret < 0)
> > +		return ret;
>=20
> remove is not really allowed to fail, the return value is never really te=
sted
> and the device is removed nevertheless. But this seems to be a problem wi=
th the
> PWM API. It should be possible to remove a PWM chip even if it is current=
ly in
> use and after a PWM chip has been removed all calls to a pwm_device of th=
at
> chip it should return an error. This will require reference counting for =
the
> pwm_device struct though. E.g. by adding a 'struct device' to it.

I beg to differ. It shouldn't be possible to remove a PWM chip that
provides requested PWM devices. All other drivers do the same here.

> > +
> > +	clk_put(jz4740->clk);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver jz4740_pwm_driver =3D {
> > +	.driver =3D {
> > +		.name =3D "jz4740-pwm",
>=20
> .owner =3D THIS_MODULE,

There are a number of other drivers where this is missing. I'll make a
note to add it to those as well.

> > +	},
> > +	.probe =3D jz4740_pwm_probe,
> > +	.remove =3D jz4740_pwm_remove,
>=20
> .remove =3D __devexit_p(jz4740_pwm_remove),

Yes.

>=20
> > +};
> > +module_platform_driver(jz4740_pwm_driver);
>=20
> MODULE_LICENSE(...), MODULE_AUTHOR(...), MODULE_DESCRIPTION(...), MODULE_=
ALIAS(...)

Those weren't present previously. I suppose they should be "GPL", you,
"Ingenic JZ4740 PWM driver" and "platform:jz4740-pwm", respectively?

Thierry

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQQ7qVAAoJEN0jrNd/PrOhDG4P/igXgZNIdiGYvb5vkxCiwaL6
qtnc9r4I+lv4j9LjS1QMz/wTkQ6jw3inPqlLt0hYZ2PX9a+fSeevzaMRDscqnk/W
yqRA1cHAKa+SDRI0gf/G73tZ8tX7Ntxl9i8/hiSvHk0ohzTNJNRM35e1EBhPb5bt
wNSa5p/nH01ZeRM3CHpmfItOFGDF4WBpjzrniY967ZvnPU4bSoLozhGUwroEMlfW
eBJagUVQz5lscZL41szSY11mCzPWvYORMWz6YDfem21DQ/OLR6ZVdu6cgpxE1Bj/
Mu/cnQ/FVABxubzxVEaasTFmWfRflCXOEJm3L5zDcBJqVCvCzokeKm5NPFQS3zWQ
XUQ+tcec1zH5T9Xmq//flqYDn+8fme09dAEBUTqri6zKnxkVUGOUzp0AHXv4iYVF
J9O8BgPkhA0+zk68hIJ7q5blVqnSFTtZk5mxJ10sI5/d5T7kRgNnRZ7tS6AwErpP
AIH8GmCC86XURsdSYlWwy07rhWzKp/+u03JWvQrD+uRZQoBOrm7jVxaA3LX5+J0A
YUpyCGNP5h9Jd/s/kAvEIEbByiSikibnzx7CII0i4HTmxodocVbPUD5rHI8NMIgs
ErKoZTcdBFxzyTr2f+QBRbZBe/z95Orj070R+KL0G7J6Z2igpR7ZZWXLnZabE9ZB
QQ7RUtbt80cY4aP+fP2z
=XQVe
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
