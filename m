Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2LSOmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:42:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2LSOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:42:36 -0500
Date: Wed, 19 Dec 2012 15:42:26 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
References: <20121219140456.GA14217@axis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <20121219140456.GA14217@axis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ImuFpNAqTEDYYmknPosnFfeaXYgefcHQE471yTuQ2WK
 iEuTph84IX31ayl3m5k9j3Fb4RYN2ALUpfxPn4KDphHBvkShxv
 T0f25Iq/gYQiJsAE8ANC0VWz8wePZRBAd6R4nKY2xRcFsHhEg6
 SgdARz/LfBiCiFH+bzyCiCPWKmLayM5k9rIeBnfffpQRYSQGEv
 5k1u7OEm7S5pv2etgkMRQ+Ps4kVpLMMyLQubLsFtJKp1hlPedg
 9tCu3k6SitosVVLpvGHPzxP/8fn+NIK7F42a/X98D1YlinlrK8
 ywciX0WJHI7YUWE4XKu8dKzZyn3yI/AlhiHRJMaLXcQ81xtRJX
 mQIQyUMWkGQvKIjlxhZbhFSXSaFHE1SRf7Yh3ZybD1MTZUTGgK
 P6yOOxxpkC0pNNzp5IGO5TWIr+nYy+rJ18=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 03:04:56PM +0100, Jesper Nilsson wrote:
> This patch implements reading of the battery voltage low signal for
> rtc-pcf8523.
>=20
> The bit is read-only and cannot be cleared by software, so no
> clear-function is implemented.
>=20
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> ---
> diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
> index be05a64..82a9895 100644
> --- a/drivers/rtc/rtc-pcf8523.c
> +++ b/drivers/rtc/rtc-pcf8523.c
> @@ -23,6 +23,7 @@
>  #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
>  #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
>  #define REG_CONTROL3_PM_MASK 0xe0
> +#define REG_CONTROL3_BLF (1 << 2) /* Battery low bit, read-only */

Nit: "battery" since you don't have a full sentence.

> =20
>  #define REG_SECONDS  0x03
>  #define REG_SECONDS_OS (1 << 7)
> @@ -250,9 +252,29 @@ static int pcf8523_rtc_set_time(struct device *dev, =
struct rtc_time *tm)
>  	return pcf8523_start_rtc(client);
>  }
> =20
> +static int pcf8523_rtc_read_vl(struct device *dev, int *vl)
> +{
> +	struct i2c_client *client =3D to_i2c_client(dev);
> +	u8 value;
> +	int err;
> +
> +	err =3D pcf8523_read(client, REG_CONTROL3, &value);
> +	if (err < 0)
> +		return err;
> +
> +	if (value & REG_CONTROL3_BLF)
> +		*vl =3D 1;
> +	else
> +		*vl =3D 0;
> +
> +	return 0;
> +}
> +
> +

That's one blank line too much.

>  static const struct rtc_class_ops pcf8523_rtc_ops =3D {
> -	.read_time =3D pcf8523_rtc_read_time,
> -	.set_time =3D pcf8523_rtc_set_time,
> +	.read_time	=3D pcf8523_rtc_read_time,
> +	.set_time	=3D pcf8523_rtc_set_time,

Maybe you shouldn't reindent these, but rather adopt the existing style
instead.

> +	.read_vl	=3D pcf8523_rtc_read_vl,

What tree is this based on? None of the trees I have contains .read_vl
in rtc_class_ops.

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0dJRAAoJEN0jrNd/PrOhlnUQAIUpcaGK4ZCP0UDrCEr2+jGw
NurDtLmBd0sTQQ2x4S/sxKBHZR+CLb6DnhudBD6uKFUoiGMagZyBEBZTQh8YcPml
tx09ct5cE1/wSfSR5u5NKmL1dBB/k0fPrVhFYebTYGum9egJlJJdixR3JDGEeTlB
vFJ5QGS4rFx4lY8jzp4WMPb575lfgGFZkHY5S30ATolcwX9JPubqGnDsv65f1QV/
VKoRZlW9aKtX9gtC6dCqv/z6dGvVQUdfDtH70nYQsS/eZv9CU3xWVX2BRGxEit9B
9klcLb72oYfh2a7hZ7NMeFOmLf+NiQHSB4RsXB+bvSWRGufS8TIG7nsBHAiUez9j
pyWcENYXtPo9xdQ6J+ZfZVmfq2V5wbR8r/+Ul75q35N/C19p0Crm0/HEirXg999t
w7m7b2fC5d6/4f5uPRf/u4xFDiH9zfF8dko2mC2lKYuuQwPelHH0Aq6T3QyLDBjf
q5qTWmEsLQvxIapdcVsydXba1OuGtJihReaMwyGZdp7P8S+GyJr3ZiPO5KhMlD5g
qsIr98G8anijFWfMUvQitVYESl5kxdyd4NbmyQOjZkAoq1h/R1kJFrURfPh95Q79
POM/UN3C8jR1W6Fjsyyqk5aXwJWd1Uwr3KWGnnkbUe9TyPp4PMaK+iYySujWuHbb
HUTbFeu5klHzvJF74tLv
=2Pyx
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
