Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1KCUDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 16:03:34 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60693 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750814Ab1KCUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 16:03:33 -0400
Date: Thu, 3 Nov 2011 13:03:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 6/7] drm/i915: Try harder during dp pattern
 1 link training
Message-ID: <20111103130329.56505cd0@jbarnes-desktop>
In-Reply-To: <1320214830-12696-7-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-7-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lxuPtqQeD6RuTOoO5uFxEBC"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lxuPtqQeD6RuTOoO5uFxEBC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:29 -0700
Keith Packard <keithp@keithp.com> wrote:

> Instead of going through the sequence just once, run through the whole
> set up to 5 times to see if something can work. This isn't part of the
> DP spec, but the BIOS seems to do it, and given that link training
> failure is so bad, it seems reasonable to follow suit.
>=20
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   41 +++++++++++++++++++++++++--------=
-----
>  1 files changed, 27 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel=
_dp.c
> index 6be6a04..bf20a35 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1576,8 +1576,9 @@ intel_dp_set_link_train(struct intel_dp *intel_dp,
> =20
>  	ret =3D intel_dp_aux_native_write(intel_dp,
>  					DP_TRAINING_LANE0_SET,
> -					intel_dp->train_set, 4);
> -	if (ret !=3D 4)
> +					intel_dp->train_set,
> +					intel_dp->lane_count);
> +	if (ret !=3D intel_dp->lane_count)
>  		return false;
> =20
>  	return true;

Sneaky putting this bug fix into this patch. :)

> @@ -1593,7 +1594,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
>  	int i;
>  	uint8_t voltage;
>  	bool clock_recovery =3D false;
> -	int tries;
> +	int voltage_tries, loop_tries;
>  	u32 reg;
>  	uint32_t DP =3D intel_dp->DP;
> =20
> @@ -1620,7 +1621,8 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
>  		DP &=3D ~DP_LINK_TRAIN_MASK;
>  	memset(intel_dp->train_set, 0, 4);
>  	voltage =3D 0xff;
> -	tries =3D 0;
> +	voltage_tries =3D 0;
> +	loop_tries =3D 0;
>  	clock_recovery =3D false;
>  	for (;;) {
>  		/* Use intel_dp->train_set[0] to set the voltage and pre emphasis valu=
es */
> @@ -1663,17 +1665,28 @@ intel_dp_start_link_train(struct intel_dp *intel_=
dp)
>  		for (i =3D 0; i < intel_dp->lane_count; i++)
>  			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) =3D=3D 0)
>  				break;
> -		if (i =3D=3D intel_dp->lane_count)
> -			break;
> -
> -		/* Check to see if we've tried the same voltage 5 times */
> -		if ((intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK) =3D=3D volt=
age) {
> -			++tries;
> -			if (tries =3D=3D 5)
> +		if (i =3D=3D intel_dp->lane_count) {
> +			++loop_tries;
> +			if (loop_tries =3D=3D 5) {
> +				DRM_DEBUG_KMS("too many full retries, give up\n");
>  				break;
> -		} else
> -			tries =3D 0;
> -		voltage =3D intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;
> +			}
> +			memset(intel_dp->train_set, 0, 4);
> +			voltage_tries =3D 0;
> +			continue;
> +		} else {
> +
> +			/* Check to see if we've tried the same voltage 5 times */
> +			if ((intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK) =3D=3D vol=
tage) {
> +				++voltage_tries;
> +				if (voltage_tries =3D=3D 5) {
> +					DRM_DEBUG_KMS("too many voltage retries, give up\n");
> +					break;
> +				}
> +			} else
> +				voltage_tries =3D 0;
> +			voltage =3D intel_dp->train_set[0] & DP_TRAIN_VOLTAGE_SWING_MASK;
> +		}
> =20
>  		/* Compute new intel_dp->train_set as requested by target */
>  		intel_get_adjust_train(intel_dp, link_status);

Don't you love the training state machine?  I think this looks ok, and
the DP compliance test should catch any grievous errors, so aside from
the bug fix hunk which should be split out:

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/lxuPtqQeD6RuTOoO5uFxEBC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsvORAAoJEIEoDkX4Qk9hlLIP/1zGpA/E6/AZ3hwKRaGdjwid
r75GPqQp9W5Zw2D17EYMWM4KVtv31iHXv9Z1JJd9lWTOSKWDI18eMQt5r+kQ8XyO
mQiyvGs3gyXjB5eTdP14Pp/Jv+bhJtZtnwGh/GrEXPh4yGAs6WgIa3QuYQEPz+8N
exju1DE4LTyOfDdlkS4l99LdEa5H84BDGuAB80Sm489kvUFiQTRHkWjoIrBGY+bi
/lUcaSNan9xHKKHXNoVhDkGm0PnLZCFMlhi0LKT21Ft2KPaPIvJbMJFmqZZllezw
qMisvizMs7Ywp0ZJ4dDQg5e7SX3V/nK4zmc90IxQ4h+9uc11g407OgyCfEDup5NC
wBxGDfvW9MrcScq+5OLW1OiW9o3+P/YlIHXKZ8adu/wDopyg9QH6+RGyFCIR1V7C
OmpoKSjthriCONx1iMhDVRJrAE76eQkcJNo4A8UPRgqY7+3ywX023b0+eLW9cvue
uwZGgwBhjyqHwW9AIf0Y/Kk+ZdgLpYnb+y3swcDwOYjgnlwOUG/WTpK6dFF1tpEr
d56+QcxXdhntgxtVdmclEOMBWyRYj4Kl5C+SXRdkigY1xdscJNApZi6ds0XL7xi3
jvZ4Rl+JCpz77VwxJkgqvX0tAA3uY6i+Rrpj+9W3icEGBv+u8Ws9cQn4s+eLpcyP
6IXI84qT1lfJKn1GN+uy
=ii5u
-----END PGP SIGNATURE-----

--Sig_/lxuPtqQeD6RuTOoO5uFxEBC--
