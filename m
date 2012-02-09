Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab2BINkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:40:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab2BINkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:40:42 -0500
Message-ID: <4F33CCD8.6050407@pengutronix.de>
Date: Thu, 09 Feb 2012 14:40:40 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Marc Kleine-Budde <mkl@blackshift.org>, linux-kernel@vger.kernel.org,
        Imre Kaloz <kaloz@openwrt.org>, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org> <1328729069-21308-2-git-send-email-mkl@blackshift.org> <20120209091124.GR889@n2100.arm.linux.org.uk>
In-Reply-To: <20120209091124.GR889@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6A74E0B9DDC62114ECA010A9"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6A74E0B9DDC62114ECA010A9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/09/2012 10:11 AM, Russell King - ARM Linux wrote:
> On Wed, Feb 08, 2012 at 08:24:28PM +0100, Marc Kleine-Budde wrote:
>> diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/comm=
on.c
>> index 3841ab4..963f752 100644
>> --- a/arch/arm/mach-ixp4xx/common.c
>> +++ b/arch/arm/mach-ixp4xx/common.c
>> @@ -36,6 +36,7 @@
>>  #include <asm/page.h>
>>  #include <asm/irq.h>
>>  #include <asm/sched_clock.h>
>> +#include <asm/gpio.h>
>=20
> linux/gpio.h

Done.

>=20
>> diff --git a/arch/arm/mach-ixp4xx/include/mach/gpio.h b/arch/arm/mach-=
ixp4xx/include/mach/gpio.h
>> index 83d6b4e..093dfad 100644
>> --- a/arch/arm/mach-ixp4xx/include/mach/gpio.h
>> +++ b/arch/arm/mach-ixp4xx/include/mach/gpio.h
>> @@ -27,49 +27,31 @@
>> =20
>>  #include <linux/kernel.h>
>>  #include <mach/hardware.h>
>> +#include <asm-generic/gpio.h>			/* cansleep wrappers */
>> =20
>>  #define __ARM_GPIOLIB_COMPLEX
>> =20
>> -static inline int gpio_request(unsigned gpio, const char *label)
>> -{
>> -	return 0;
>> -}
>> -
>> -static inline void gpio_free(unsigned gpio)
>> -{
>> -	might_sleep();
>> -
>> -	return;
>> -}
>> -
>> -static inline int gpio_direction_input(unsigned gpio)
>> -{
>> -	gpio_line_config(gpio, IXP4XX_GPIO_IN);
>> -	return 0;
>> -}
>> -
>> -static inline int gpio_direction_output(unsigned gpio, int level)
>> -{
>> -	gpio_line_set(gpio, level);
>> -	gpio_line_config(gpio, IXP4XX_GPIO_OUT);
>> -	return 0;
>> -}
>> +#define NR_BUILTIN_GPIO 16
>> =20
>>  static inline int gpio_get_value(unsigned gpio)
>>  {
>> -	int value;
>> -
>> -	gpio_line_get(gpio, &value);
>> -
>> -	return value;
>> +	if (gpio < NR_BUILTIN_GPIO) {
>> +		int value;
>> +		gpio_line_get(gpio, &value);
>> +		return value;
>> +	} else
>> +		return __gpio_get_value(gpio);
>>  }
>> =20
>>  static inline void gpio_set_value(unsigned gpio, int value)
>>  {
>> -	gpio_line_set(gpio, value);
>> +	if (gpio < NR_BUILTIN_GPIO)
>> +		gpio_line_set(gpio, value);
>> +	else
>> +		__gpio_set_value(gpio, value);
>>  }
>> =20
>> -#include <asm-generic/gpio.h>			/* cansleep wrappers */
>> +#define gpio_cansleep __gpio_cansleep
>> =20
>>  extern int gpio_to_irq(int gpio);
>>  #define gpio_to_irq gpio_to_irq
>=20
> Does anything on ixp4xx require fast access to on-chip GPIOs?  If not,

I don't know the ixp4xx hardware enough. Can someone comment on this?

> it would be much better to get rid of this and just use the standard
> wrapping, which can be done by changing this entire file to be just a
> single line:
>=20
> /* empty */

I have to remove the ixp4xx specific gpio_to_irq and irq_to_gpio
functions or keep the #define gpio_to_irq gpio_to_irq.

It compiles now, I'll test on the hardware when I'm home.

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6A74E0B9DDC62114ECA010A9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8zzNgACgkQjTAFq1RaXHOxnQCdFm+Ff0+3hxcrfKdcLeB4r/77
zZsAnAmYM12W97/sshb3VUdJ7gTEaOZZ
=z8Y3
-----END PGP SIGNATURE-----

--------------enig6A74E0B9DDC62114ECA010A9--
