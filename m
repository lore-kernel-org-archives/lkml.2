Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2C0Xp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:45:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab2C0Xp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:45:58 -0400
Date: Wed, 28 Mar 2012 10:45:44 +1100
From: NeilBrown <neilb@suse.de>
To: shuahkhan@gmail.com
Cc: rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120328104544.593f3d1a@notabene.brown>
In-Reply-To: <1332861697.2834.9.camel@lorien2>
References: <1332861697.2834.9.camel@lorien2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7Yt1XQ7x=a_4zrN+hFSt9Bp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7Yt1XQ7x=a_4zrN+hFSt9Bp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Mar 2012 09:21:37 -0600 Shuah Khan <shuahkhan@gmail.com> wrote:

> LED infrastructure lacks support for one shot timer trigger and activatio=
n.
> The current support allows for setting two timers, one for specifying how=
=20
> long a state to be on, and the second for how long the state to be off. F=
or
> example, delay_on value specifies the time period an LED should stay in on
> state, followed by a delay_off value that specifies how long the LED shou=
ld
> stay in off state. The on and off cycle repeats until the trigger gets=20
> deactivated. There is no provision for one time activation to implement
> features that require an on or off state to be held just once and then st=
ay
> in the original state forever.
>=20
> This feature will help implement vibrate functionality which requires one
> shot activation of vibrate mode without a continuous vibrate on/off cycle=
s.

In general I approve of this - thanks for your efforts.

However there are some details that need attention.

>=20
> This patch implements the one-shot-timer trigger support by enhancing the
> current led-class and ledtrig-timer drivers to support the following
> use-cases:
>=20
> use-case 1:
> echo one-shot-timer > /sys/class/leds/SOMELED/trigger

I don't like the name "one-shot-timer".  This name describes how you expect
the functionality to be used, but not what the actual difference between
"timer" and "one-shot-timer" is.
That difference is simply that one-shot-timer does not start an initial
default blink, while "timer" does.
So a name like "timer-no-default" would be a more accurate description and =
so
should be preferred.


> echo 2000 > /sys/class/leds/SOMELED/delay_on

This command will call led_blink_set with an on time of '2000' and an off
time of '0'.  This will cause led_set_software_blink to turn the LED on and
set no off timer.  This is just as bad as starting a default blink - there =
is
no guarantee that the LED (or vibrator) will ever be turned off.

You need to set 'delay_off' to 'forever' first.

> echo forever > /sys/class/leds/SOMELED/delay_off
>=20
> When one-shot-timer is activated in step1, unlike the timer trigger case,
> one-shot-timer activate routine activates the trigger without starting
> any timers. The default 1 HZ delay_on and delay_off timers won't be start=
ed
> like in the case of timer trigger activation. Not starting timers ensures=
=20
> that the one shot state isn't stuck if some error occurs before actual ti=
mer
> periods are specified. delay_on and delay_off files get created with 0
> values.
>=20
> When delay_on value is specified in step 2, a timer gets started for dela=
y_on
> period, and delay_off stays at 0 or whatever its current value is.=20
>=20
> When delay_off value is specified in step 3, delay_off_store recognizes t=
he
> special forever tag and records it and returns without starting any timer.
>=20
> use-case 2:
> echo one-shot-timer > /sys/class/leds/SOMELED/trigger
> echo 2000 > /sys/class/leds/SOMELED/delay_off
> echo forever > /sys/class/leds/SOMELED/delay_on
>=20
> When one-shot-timer is activated in step1, unlike the timer trigger case,
> one-shot-timer activate routine activates the trigger without starting
> any timers. The default 1 HZ delay_on and delay_off timers won't be start=
ed
> like in the case of timer trigger activation. Not starting timers ensures=
=20
> that the one shot state isn't stuck if some error occurs before actual ti=
mer
> periods are specified. delay_on and delay_off files get created with 0
> values.
>=20
> When delay_off value is specified in step 2, a timer gets started for del=
ay_off
> period, and delay_on stays at 0 or whatever its current value is.=20
>=20
> When delay_on value is specified in step 3, delay_on_store recognizes the
> special forever tag and records it and returns without starting any timer.

I think you should also mention here that:

 - The 'forever' value is stored as 'ULONG_MAX'.  Possibly a=20
       #define FOREVER ULONG_MAX
   in the code would be appropriate.  This mapping is only used internally,
   not in the interface.

 - The led_blink_set function - which takes two pointers to times - has
   been extended so that a NULL instead of a pointer means "forever".

>=20
> >From ebc4c08c138bc8ac1ac8f4eb80f879e8e7f105d3 Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Mon, 26 Mar 2012 17:34:42 -0600
> Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
>=20
>=20
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  drivers/leds/led-class.c     |    4 +-
>  drivers/leds/led-core.c      |   26 +++++++++--
>  drivers/leds/ledtrig-timer.c |  101 +++++++++++++++++++++++++++++-------=
-----
>  3 files changed, 96 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 5bff843..be7400a 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -107,7 +107,9 @@ static void led_timer_function(unsigned long data)
> =20
>  	led_set_brightness(led_cdev, brightness);
> =20
> -	mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> +	if (delay !=3D ULONG_MAX)
> +		mod_timer(&led_cdev->blink_timer,
> +			jiffies + msecs_to_jiffies(delay));
>  }
> =20
>  /**
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index d686004..40685f1 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -72,17 +72,35 @@ void led_blink_set(struct led_classdev *led_cdev,
>  		   unsigned long *delay_on,
>  		   unsigned long *delay_off)
>  {
> +	unsigned long val_on;
> +	unsigned long val_off;
> +
>  	del_timer_sync(&led_cdev->blink_timer);
> =20
> -	if (led_cdev->blink_set &&
> +	if (delay_on && delay_off && led_cdev->blink_set &&
>  	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
>  		return;
> =20
> +	/* if delay_on is null, leave it on forever after delay_off period
> +	   if delay_off is null, leave it off forever after delay on period */
> +	if (!delay_on)
> +		val_on =3D ULONG_MAX;
> +	else
> +		val_on =3D *delay_on;
> +
> +	if (!delay_off)
> +		val_off =3D ULONG_MAX;
> +	else
> +		val_off =3D *delay_off;
> +
>  	/* blink with 1 Hz as default if nothing specified */
> -	if (!*delay_on && !*delay_off)
> -		*delay_on =3D *delay_off =3D 500;
> +	if (!val_on && !val_off) {
> +		val_on =3D val_off =3D 500;
> +		*delay_on =3D 500;
> +		*delay_off =3D 500;
> +	}
> =20
> -	led_set_software_blink(led_cdev, *delay_on, *delay_off);
> +	led_set_software_blink(led_cdev, val_on, val_off);
>  }
>  EXPORT_SYMBOL(led_blink_set);
> =20
> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
> index 328c64c..bfda51c 100644
> --- a/drivers/leds/ledtrig-timer.c
> +++ b/drivers/leds/ledtrig-timer.c
> @@ -24,6 +24,9 @@ static ssize_t led_delay_on_show(struct device *dev,
>  {
>  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> =20
> +	if (led_cdev->blink_delay_on =3D=3D ULONG_MAX)
> +		return sprintf(buf, "%s\n", "forever");
> +

I think
                return sprintf(buf, "forever\n");

if the more common usage.

Also in led_delay_off_show() below.


>  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
>  }
> =20
> @@ -32,17 +35,25 @@ static ssize_t led_delay_on_store(struct device *dev,
>  {
>  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
>  	int ret =3D -EINVAL;
> -	char *after;
> -	unsigned long state =3D simple_strtoul(buf, &after, 10);
> -	size_t count =3D after - buf;
> -
> -	if (isspace(*after))
> -		count++;
> =20
> -	if (count =3D=3D size) {
> -		led_blink_set(led_cdev, &state, &led_cdev->blink_delay_off);
> -		led_cdev->blink_delay_on =3D state;
> -		ret =3D count;
> +	if (strncmp(buf, "forever", 7) =3D=3D 0) {
> +		led_blink_set(led_cdev, NULL, &led_cdev->blink_delay_off);
> +		led_cdev->blink_delay_on =3D ULONG_MAX;
> +		ret =3D size;
> +	} else {
> +		char *after;
> +		unsigned long state =3D simple_strtoul(buf, &after, 10);

kstrtoul is currently preferred.  It ensures uniform error codes.


> +		size_t count =3D after - buf;
> +
> +		if (isspace(*after))
> +			count++;
> +
> +		if (count =3D=3D size) {
> +			led_blink_set(led_cdev, &state,
> +				&led_cdev->blink_delay_off);
> +			led_cdev->blink_delay_on =3D state;
> +			ret =3D count;
> +		}
>  	}
> =20
>  	return ret;
> @@ -53,6 +64,9 @@ static ssize_t led_delay_off_show(struct device *dev,
>  {
>  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
> =20
> +	if (led_cdev->blink_delay_off =3D=3D ULONG_MAX)
> +		return sprintf(buf, "%s\n", "forever");
> +
>  	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
>  }
> =20
> @@ -61,17 +75,24 @@ static ssize_t led_delay_off_store(struct device *dev,
>  {
>  	struct led_classdev *led_cdev =3D dev_get_drvdata(dev);
>  	int ret =3D -EINVAL;
> -	char *after;
> -	unsigned long state =3D simple_strtoul(buf, &after, 10);
> -	size_t count =3D after - buf;
> =20
> -	if (isspace(*after))
> -		count++;
> -
> -	if (count =3D=3D size) {
> -		led_blink_set(led_cdev, &led_cdev->blink_delay_on, &state);
> -		led_cdev->blink_delay_off =3D state;
> -		ret =3D count;
> +	if (strncmp(buf, "forever", 7) =3D=3D 0) {
> +		led_blink_set(led_cdev, &led_cdev->blink_delay_on, NULL);
> +		led_cdev->blink_delay_off =3D ULONG_MAX;
> +	} else {
> +		char *after;
> +		unsigned long state =3D simple_strtoul(buf, &after, 10);
> +		size_t count =3D after - buf;
> +
> +		if (isspace(*after))
> +			count++;
> +
> +		if (count =3D=3D size) {
> +			led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> +				&state);
> +			led_cdev->blink_delay_off =3D state;
> +			ret =3D count;
> +		}
>  	}
> =20
>  	return ret;
> @@ -80,7 +101,7 @@ static ssize_t led_delay_off_store(struct device *dev,
>  static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store=
);
>  static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_st=
ore);
> =20
> -static void timer_trig_activate(struct led_classdev *led_cdev)
> +static void timer_trig_activate_common(struct led_classdev *led_cdev)
>  {
>  	int rc;
> =20
> @@ -91,17 +112,24 @@ static void timer_trig_activate(struct led_classdev =
*led_cdev)
>  		return;
>  	rc =3D device_create_file(led_cdev->dev, &dev_attr_delay_off);
>  	if (rc)
> -		goto err_out_delayon;
> -
> -	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> -		      &led_cdev->blink_delay_off);
> +		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> =20
> -	led_cdev->trigger_data =3D (void *)1;
> +	else
> +		led_cdev->trigger_data =3D (void *)1;
> +}
> =20
> -	return;
> +static void timer_trig_activate_one_shot(struct led_classdev *led_cdev)
> +{
> +	timer_trig_activate_common(led_cdev);
> +}
> =20
> -err_out_delayon:
> -	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> +static void timer_trig_activate(struct led_classdev *led_cdev)
> +{
> +	timer_trig_activate_common(led_cdev);
> +	if (led_cdev->trigger_data) {
> +		led_blink_set(led_cdev, &led_cdev->blink_delay_on,
> +		      &led_cdev->blink_delay_off);
> +	}
>  }
> =20
>  static void timer_trig_deactivate(struct led_classdev *led_cdev)
> @@ -121,14 +149,27 @@ static struct led_trigger timer_led_trigger =3D {
>  	.deactivate =3D timer_trig_deactivate,
>  };
> =20
> +static struct led_trigger one_shot_timer_led_trigger =3D {
> +	.name     =3D "one-shot-timer",
> +	.activate =3D timer_trig_activate_one_shot,
> +	.deactivate =3D timer_trig_deactivate,
> +};
> +
>  static int __init timer_trig_init(void)
>  {
> -	return led_trigger_register(&timer_led_trigger);
> +	int rc =3D 0;
> +
> +	rc =3D led_trigger_register(&timer_led_trigger);
> +	if (!rc)
> +		rc =3D led_trigger_register(&one_shot_timer_led_trigger);

Do you need to led_trigger_unregister(&timer_led_trigger) if the registrati=
on
of one_shot_timer_led_trigger fails?

> +
> +	return rc;
>  }
> =20
>  static void __exit timer_trig_exit(void)
>  {
>  	led_trigger_unregister(&timer_led_trigger);
> +	led_trigger_unregister(&one_shot_timer_led_trigger);
>  }
> =20
>  module_init(timer_trig_init);

Thanks,
NeilBrown=20



--Sig_/7Yt1XQ7x=a_4zrN+hFSt9Bp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3JRKDnsnt1WYoG5AQKZVw/8D6qAx9dPD7IfJNjxoCdiz6j5egibO++C
wrkigeG1eS8xvnwq1k3F1PS1nWU9YtBTX44cn6kbMWzmgbKyfTPJCWhMNejl0Z5z
iDefZwgOuqcJBDBuFC1vwqxxDlIW0RT8gzV2TdZzsJU96Li4+D/5IYed3sTnjM/w
HwruzUUIOJ3JaNBFk0UKyFq3R8QQoO9g3LYtl/Yz7rmX5OY2uc8HdtMObzHJKrmU
6GUZv1gJM5WOV94LokMHR3spkqn2++oEIDUwn31658wZe+HmXCdCypFb0ODhl5Xl
lDVVuq7e5KrgZag9KCRGcdRrjFzBuPs80ivKIJYW6G+XewUDpDDQGr6AMeY7sotL
BnshakVwGsEhDZoKZSHkNMS6Rc67xc7q/BhWwGTPNOWjDS6fC13COZE9D+1GZm7a
I/747rdJ9VzsjVbbihd4Tzb3w3WJGHbQy2+JdtIAbKJa9TZKU2KTXeANcwbrNXQG
C9zsd1d3ZJ/Jl/6cJh64zCcMWIWS8OUHTTcVPL/6L+610cils/upOhdQeHrjzwkM
pt7rqUD5oWhQCwu3p+zp/te8asbvsP3e9JQ85XPqHbkAij4KbWTxOjiQPqP3n+jF
u1bDaP+n7pkEOdy6ZZ6nydBgo+zeI9cX4sxQGGPgRgkJbZ2tnM58X+NyXa7l6e4B
yMVPAcA7SWg=
=XFk5
-----END PGP SIGNATURE-----

--Sig_/7Yt1XQ7x=a_4zrN+hFSt9Bp--
