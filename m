Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2BTByO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:54:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50515 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab2BTByN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:54:13 -0500
Date: Sun, 19 Feb 2012 17:54:02 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 1/5] Extcon (external connector): import Android's
 switch class and modify.
Message-ID: <20120220015400.GD3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1328856038-21912-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 10, 2012 at 03:40:34PM +0900, MyungJoo Ham wrote:
> External connector class (extcon) is based on and an extension of Android
> kernel's switch class located at linux/drivers/switch/.

This looks good though I've skipped some bits as it's taken me far too
long to get round to reviewing, it'd be really good if we could get it
into 3.4 at least in staging if not in fully.  I don't know if arm-soc
might be a good route if there's some concerns?  A few things below but
they're relatively minor. =20

One thing I'd suggest is splitting the GPIO implementation into a
separate patch, mostly just to reduce the size of the initial patch for
ease of review.

> +	if (edev->state !=3D state) {
> +		edev->state =3D state;
> +
> +		prop_buf =3D (char *)get_zeroed_page(GFP_KERNEL);
> +		if (prop_buf) {

Is the cast really needed here?

> +static int create_extcon_class(void)
> +{
> +	if (!extcon_class) {
> +		extcon_class =3D class_create(THIS_MODULE, "extcon");
> +		if (IS_ERR(extcon_class))
> +			return PTR_ERR(extcon_class);
> +		extcon_class->dev_attrs =3D extcon_attrs;

I thought we were trying to remove classes, though I'm not sure if we're
actually at the point where that's happening yet?  Greg?

> +static int create_extcon_class_for_android(void)
> +{
> +	if (!extcon_class_for_android) {
> +		extcon_class_for_android =3D class_create(THIS_MODULE, "switch");
> +		if (IS_ERR(extcon_class_for_android))
> +			return PTR_ERR(extcon_class_for_android);
> +		extcon_class_for_android->dev_attrs =3D extcon_attrs;
> +	}
> +	return 0;
> +}

Might be better to put this as a separate Kconfig option or just leave
it as an out of tree patch (given how trivial it is).  We're going to
end up renaming a bunch of the classes anyway I expect...

> +static int __init extcon_class_init(void)
> +{
> +	return create_extcon_class();
> +}
> +
> +static void __exit extcon_class_exit(void)
> +{
> +	class_destroy(extcon_class);
> +
> +	if (extcon_class_for_android)
> +		class_destroy(extcon_class_for_android);
> +}
> +
> +module_init(extcon_class_init);
> +module_exit(extcon_class_exit);

Ideally these should go next to the functions.

> +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> +{
> +	struct gpio_extcon_data *extcon_data =3D
> +	    (struct gpio_extcon_data *)dev_id;
> +
> +	schedule_work(&extcon_data->work);
> +	return IRQ_HANDLED;
> +}

Given that all this does is schedule some work it'd seem useful to make
this a threaded IRQ and just do the work directly in the interrupt
handler.  Though on the other hand we don't have any debounce here so
perhaps it's even better to allow the user to specify a debunce time in
the platform data and change this to schedule_delayed_work() to
implement it?

> +static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *bu=
f)
> +{
> +	struct gpio_extcon_data	*extcon_data =3D
> +		container_of(edev, struct gpio_extcon_data, edev);
> +	const char *state;
> +	if (extcon_get_state(edev))
> +		state =3D extcon_data->state_on;
> +	else
> +		state =3D extcon_data->state_off;
> +
> +	if (state)
> +		return sprintf(buf, "%s\n", state);
> +	return -1;

-EINVAL or something?

> +	extcon_data =3D kzalloc(sizeof(struct gpio_extcon_data), GFP_KERNEL);
> +	if (!extcon_data)
> +		return -ENOMEM;

devm_kzalloc().

> +	ret =3D request_irq(extcon_data->irq, gpio_irq_handler,
> +			  IRQF_TRIGGER_LOW, pdev->name, extcon_data);
> +	if (ret < 0)
> +		goto err_request_irq;

request_any_context_irq() would allow use with any GPIO - sometimes the
GPIOs for accessory detection are on GPIO expanders which need threaded
context and there's nothing in the code that minds.  It would also be a
good idea if the user could specify the triggers, lots of circuits need
edge triggers for example.

> +static int __init gpio_extcon_init(void)
> +{
> +	return platform_driver_register(&gpio_extcon_driver);
> +}
> +
> +static void __exit gpio_extcon_exit(void)
> +{
> +	platform_driver_unregister(&gpio_extcon_driver);
> +}
> +
> +module_init(gpio_extcon_init);
> +module_exit(gpio_extcon_exit);

module_platform_driver().

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQaexAAoJEBus8iNuMP3dFPgP/0GZcmqCuTTB/ZnMI8dtXH6g
DFWSZwBEYlUJTC95z+T5cJl6g2jP3v/JMKRnT3jD/4ahp//cUXx/GnbDxmbICQSA
NVnNkXtzH/LLyb4wbyTN1oELF9tiN7P6xdU5wIN7pxiCUiQ2TUl6MCvNJyEydAuA
EyXBruqqHRlFPJJ5uNpvCa6XYBTmwHDXjDqy1NKFOKRexWF1GJ2z8WvzGHElQOD4
NDZCd7TkGMRxvDegbDvUwXvvi24lEcbhzCMGACO8bLKCzgieq9PasIL5ezZ8Kgqd
iOxv1Pc9BqFPD0CLtr8DMZXPApnj50rvu+1PWzrOIb/2sMCYdOoPFpw19ci9J6bT
YbTQpRBXORl+e3qmlDX7iU1Vx5QVsGV3FmNnXbECwM6xlbQ96yvB9kUonHt0ZNuV
xjP5AlOQXk47ZwJIPSyVLh18gp9wEHtnMMFQ1tlfDDoVzZ/mWFarYQbFwFhfzKdt
lDUK4qwPEgB76PEfDAcVgoc8LFsM6jcMT50VR4++yQ2P4tBL7QptzzB0fwF1gzkC
HhCix3xThWQ9osq6AV98GYMzyX9/spUc00gQiSqSBoqroysgBpkwB9sOAQeVERyQ
7wvwukBWr91f2ruQYY5ZrDQvEAMR6tfbMWHlIQGJaFU71/mlOLV6pv/vf9S618xQ
D1iaCKkJ3qUO/BiM+cMX
=XrEo
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
