Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650Ab1FATxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:53:33 -0400
Received: from smtp208.alice.it ([82.57.200.104]:43134 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1FATxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:53:31 -0400
Date: Wed, 1 Jun 2011 21:53:22 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcin Tolysz <tolysz@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] sony_ff_byteswap_accelerometer
Message-Id: <20110601215322.2572aecf.ospite@studenti.unina.it>
In-Reply-To: <1306145999-15643-2-git-send-email-simon@mungewell.org>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
	<1306145999-15643-1-git-send-email-simon@mungewell.org>
	<1306145999-15643-2-git-send-email-simon@mungewell.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_21_53_22_+0200_3/6yweirqv+SsRu="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_21_53_22_+0200_3/6yweirqv+SsRu=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 23 May 2011 03:19:59 -0700
Simon Wood <simon@mungewell.org> wrote:

> The accelerometers/gyro on the sixaxis are reported in the wrong
> endianness (ie. not compatible with HID), so this patch intercepts
> the report and swaps the appropriate bytes over.
>=20
> Accelerometers are scaled with a nominal value of +/-4000 =3D 1G,
> maximum value would be around +/-32768 =3D 8G.
>=20
> Gyro on my device always reports -32768, might need some calibration
> set within the controller.
> ---
>  drivers/hid/hid-sony.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>

Should this one have Marcin as the original author or at least as the
first Signed-off-by, and an additional Signed-off-by you Simon?

Thanks,
  Antonio

> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index 5c930dc..f219746 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -57,6 +57,24 @@ static __u8 *sony_report_fixup(struct hid_device *hdev=
, __u8 *rdesc,
>  	return rdesc;
>  }
> =20
> +/* Sixaxis HID report has acclerometers/gyro with MSByte first, this has
> + * to be BYTE_SWAPPED before passing up to joystick interface
> + */
> +static int sony_raw_event(struct hid_device *hdev, struct hid_report *re=
port, __u8 *rd, int size)
> +{
> +	struct sony_sc *sc =3D hid_get_drvdata(hdev);
> +
> +	if ((sc->quirks & SIXAXIS_CONTROLLER_USB) &&
> +			rd[0] =3D=3D 0x01 && size =3D=3D 49) {
> +		swap(rd[41], rd[42]);
> +		swap(rd[43], rd[44]);
> +		swap(rd[45], rd[46]);
> +		swap(rd[47], rd[48]);
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * The Sony Sixaxis does not handle HID Output Reports on the Interrupt =
EP
>   * like it should according to usbhid/hid-core.c::usbhid_output_raw_repo=
rt()
> @@ -205,6 +223,7 @@ static struct hid_driver sony_driver =3D {
>  	.probe =3D sony_probe,
>  	.remove =3D sony_remove,
>  	.report_fixup =3D sony_report_fixup,
> +	.raw_event =3D sony_raw_event
>  };
> =20
>  static int __init sony_init(void)
> --=20
> 1.7.4.1
>=20
>=20


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__1_Jun_2011_21_53_22_+0200_3/6yweirqv+SsRu=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3mmLIACgkQ5xr2akVTsAHjbACeJ8f77OTZieYv2B2gPYEpcYHv
Fo0AniWe3H6CItfp40F1EhkYrK1GfrEQ
=G5q4
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_21_53_22_+0200_3/6yweirqv+SsRu=--
