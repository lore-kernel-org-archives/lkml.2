Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2IBT16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 15:27:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2IBT15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 15:27:57 -0400
Date: Sun, 2 Sep 2012 21:27:53 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Message-ID: <20120902192752.GA10930@avionic-0098.mockup.avionic-design.de>
References: <1346579550-5990-1-git-send-email-thierry.reding@avionic-design.de>
 <1890769.KjIbOv8Xbz@hyperion>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1890769.KjIbOv8Xbz@hyperion>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:dgNimggAZ/nVAOd0sKtFYtOuGdOXRt0vh+QKn+jnmVn
 pNmDgofn87qH/t/lsX/6t/DjRdg7HvENMRLEEBpkdvhK6sRnsO
 mQz0CAHRZycvws3TnSoYxvZpavopTQ3yOBYVtqgEo1mCEVzYyc
 EoOLgKW2w++KSwckn+/bT/qdJg+GVFK7T4KP4+9C8eebcwlJCv
 ueU8h7wLFXF7p+WC6YDw+l1KFi3eW2Z0PqPRL2R6r3fiWzAp2N
 E4MIv9VekvlxtQq+p6UiuBcWt56G00dS65ThW+o9OgbqKCipGi
 N101S9dSPd3QsPqCk/Cj4KBA0zqaGm0t54SIq7RLo0aAM+5cQq
 +Tcynyo6qU29V12W1aDoRGbsU9KSSemXSxRwa4pqDsLxCjzzcI
 FNju8O4+8Ng1DZeNtSq6Aef7s0fBG+FD+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 02, 2012 at 03:25:55PM +0200, Maarten ter Huurne wrote:
> On Sunday 02 September 2012 11:52:27 Thierry Reding wrote:
>=20
> > This small series fixes a build error due to a circular header
> > dependency, exports the timer API so it can be used outside of
> > the arch/mips/jz4740 tree and finally moves and converts the
> > JZ4740 PWM driver to the PWM framework.
> >=20
> > Note that I don't have any hardware to test this on, so I had to
> > rely on compile tests only. Patches 1 and 2 should probably go
> > through the MIPS tree, while I can take patch 3 through the PWM
> > tree. It touches a couple of files in arch/mips but the changes
> > are unlikely to cause conflicts.
>=20
> Exporting the hardware outputs PWM2-7 as index 0-5 in the PWM core is rat=
her=20
> confusing. I discussed with Lars on IRC and it's probably better to expos=
e=20
> PWM0-7 through the API, but refuse to hand out PWM0 and PWM1 when request=
ed,=20
> since their associated timers are in use by the system. I attached a diff=
=20
> that illustrates this approach.
>=20
> Note that if this approach is taken, the beeper ID in board-qi_lb60.c sho=
uld=20
> be changed back from 2 to 4, since the beeper is attached to PWM4.
>=20
> I tested the "for-next" branch on the Dingoo A320 with the pwm-backlight=
=20
> driver. It didn't work at first, because the PWM number and the timer num=
ber=20
> didn't align: I requested PWM number 5 to get PWM7 and the GPIO of PWM7 w=
as=20
> used, but with timer 5 instead of timer 7, resulting in a dark screen.=20
> However, it works fine after adding PWM0/1 as described above.

I haven't seen any usage of the pwm-backlight driver in mainline. I
assume this is only present in some downstream repository?

> If other people want to test on real hardware, you can find the code in=
=20
> branch jz-3.6-rc2-pwm in the qi-kernel repository. Unfortunately our web=
=20
> interface for git is still broken, but the repo itself is fine.
>   git://projects.qi-hardware.com/qi-kernel.git
>=20
> Bye,
> 		Maarten

> diff --git a/drivers/pwm/pwm-jz4740.c b/drivers/pwm/pwm-jz4740.c
> index db29b37..554e414 100644
> --- a/drivers/pwm/pwm-jz4740.c
> +++ b/drivers/pwm/pwm-jz4740.c
> @@ -24,9 +24,11 @@
>  #include <asm/mach-jz4740/gpio.h>
>  #include <timer.h>
> =20
> -#define NUM_PWM 6
> +#define NUM_PWM 8
> =20
>  static const unsigned int jz4740_pwm_gpio_list[NUM_PWM] =3D {
> +	JZ_GPIO_PWM0,
> +	JZ_GPIO_PWM1,
>  	JZ_GPIO_PWM2,
>  	JZ_GPIO_PWM3,
>  	JZ_GPIO_PWM4,
> @@ -50,6 +52,13 @@ static int jz4740_pwm_request(struct pwm_chip *chip, s=
truct pwm_device *pwm)
>  	unsigned int gpio =3D jz4740_pwm_gpio_list[pwm->hwpwm];
>  	int ret;
> =20
> +	/*
> +	 * Timer 0 and 1 are used for system tasks, so they are unavailable
> +	 * for use as PWMs.
> +	 */
> +	if (pwm->hwpwm < 2)
> +		return -EBUSY;
> +
>  	ret =3D gpio_request(gpio, pwm->label);
> =20
>  	if (ret) {

An alternative approach would be to change pwm_chip.base from -1
(dynamically allocated) to 2, which would leave 0 and 1 unavailable.
That should at least solve the problem that you had regarding the GPIO
and timer mismatch.

But the above also sounds sensible, and since both you and Lars agree
that this is the better option, I can squash these changes into my patch
with your permission.

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQQ7M4AAoJEN0jrNd/PrOhCE8QAMIDtLnVUn8z+sH+ybggaN6m
QACwD4L+el+pXo0qFWQNKX5hrd5otSmHIVduRdZmUsD8k3G503jP3NQzJ5wUxyXl
PTtfSf6rifk82R0BFSNCOwqo7yiv4oWwdOmZC87W1tGHHW3QaN9zRaf4o9rHcHOj
wsSCqIY3KKvfWHrYkx+45XF4UmvES8UpMdio6nETDsp4+WOIzDzqh2JNGFAcmqkF
kSEVwITKW1UKEW+JUY7JCcGZ0CMQvrk9r2tefrucis03zX+qWZM3d6PJ+ItAbt9U
qc7ML6y33FItdQMnAqX/gaYD8WlqQPh7Lk2CcxKFJuVr/DQhvCB4sWnvj7jOOoIi
qvhdhejBaMN1SR95Evm7myzLnYply6RNXMwWv+RAwIdcvgCkK7luVcJ0N7mWK55H
c2fOus+eCEsrE5plIUvA8nrvIyD6Sqfe8ybu0ziBi1WYZWnpdoMSNfUVBq1zSz4e
LKJBxZUMp/91CS/Q+MAVLGzRpz22eoGCc4EbDOHkz4fGWqToNBPXKJ/dazJdPJvh
1zsxAMOZADNKl3+1/bH1nGCo2EhD8Tp0SlA/FRpp+ApBfQfyXNkYGEEBm3AuR2BT
xhZ4U8pV6GlGcJmEICtF2MiHTzk1goI70e21GPpf+H+NQyc/73d0XsEcHT0D/K55
gWXr/To/HbvzIS3d5M5B
=EIhv
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
