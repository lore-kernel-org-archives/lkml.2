Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2APXPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:15:24 -0500
Received: from home.keithp.com ([63.227.221.253]:60259 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2APXPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:15:21 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Takashi Iwai <tiwai@suse.de>,
        "intel-gfx\@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
In-Reply-To: <20120116230809.GA7837@localhost>
References: <20120109131717.GA4713@localhost> <86y5tgx02g.fsf@sumi.keithp.com> <20120110054519.GA27257@localhost> <86ty404yhd.fsf@sumi.keithp.com> <20120116080252.GA18538@localhost> <20120116202618.GG3627@phenom.ffwll.local> <86obu31io4.fsf@sumi.keithp.com> <20120116230809.GA7837@localhost>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 16 Jan 2012 15:15:13 -0800
Message-ID: <86d3ajgry6.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012 07:08:09 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:
> On Mon, Jan 16, 2012 at 12:44:43PM -0800, Keith Packard wrote:
> > On Mon, 16 Jan 2012 21:26:18 +0100, Daniel Vetter <daniel@ffwll.ch> wro=
te:
> >=20
> > > Keith, does this address your concern and this patch is r-b: Keith or=
 do
> > > we want an
> > >=20
> > > } else {
> > > 	I915_WRITE(aud_config, 0);
> > > }
> > >=20
> > > for paranoia?
> >=20
> > I think we want this added, just to be sure we set the configuration
> > correctly in all cases; it's easy to imagine moving from DP to HDMI and
> > leaving this bit set.
>=20
> Ah good point! Here is the updated patch.
>=20
> ---
> Subject: drm/i915: set AUD_CONFIG N_value_index for DisplayPort
> Date: Fri Jan 06 14:41:31 CST 2012
>=20
> It should be programmed to "0" for HDMI or "1" for DisplayPort.
>=20
> This enables DisplayPort audio for
>=20
> - HP EliteBook 8460p
>   (whose BIOS does not set the N_value_index bit for us)
>=20
> - DisplayPort monitor hot plugged after boot
>   (otherwise most BIOS will fill the N_value_index bit for us)
>=20
> Tested-by: Robert Lemaire <rlemaire@suse.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Keith Packard <keithp@keithp.com>

> ---
>  drivers/gpu/drm/i915/i915_reg.h      |   12 ++++++++++++
>  drivers/gpu/drm/i915/intel_display.c |    8 +++++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>=20
> --- linux.orig/drivers/gpu/drm/i915/i915_reg.h	2012-01-07 23:11:10.000000=
000 +0800
> +++ linux/drivers/gpu/drm/i915/i915_reg.h	2012-01-10 13:20:17.000000000 +=
0800
> @@ -3582,4 +3582,16 @@
>  #define CPT_AUD_CNTL_ST_A		0xE50B4
>  #define CPT_AUD_CNTRL_ST2		0xE50C0
>=20=20
> +#define IBX_AUD_CONFIG_A			0xe2000
> +#define CPT_AUD_CONFIG_A			0xe5000
> +#define   AUD_CONFIG_N_VALUE_INDEX		(1 << 29)
> +#define   AUD_CONFIG_N_PROG_ENABLE		(1 << 28)
> +#define   AUD_CONFIG_UPPER_N_SHIFT		20
> +#define   AUD_CONFIG_UPPER_N_VALUE		(0xff << 20)
> +#define   AUD_CONFIG_LOWER_N_SHIFT		4
> +#define   AUD_CONFIG_LOWER_N_VALUE		(0xfff << 4)
> +#define   AUD_CONFIG_PIXEL_CLOCK_HDMI_SHIFT	16
> +#define   AUD_CONFIG_PIXEL_CLOCK_HDMI		(0xf << 16)
> +#define   AUD_CONFIG_DISABLE_NCTS		(1 << 3)
> +
>  #endif /* _I915_REG_H_ */
> --- linux.orig/drivers/gpu/drm/i915/intel_display.c	2012-01-07 23:11:10.0=
00000000 +0800
> +++ linux/drivers/gpu/drm/i915/intel_display.c	2012-01-17 07:06:29.000000=
000 +0800
> @@ -5908,15 +5908,18 @@ static void ironlake_write_eld(struct dr
>  	uint32_t i;
>  	int len;
>  	int hdmiw_hdmiedid;
> +	int aud_config;
>  	int aud_cntl_st;
>  	int aud_cntrl_st2;
>=20=20
>  	if (HAS_PCH_IBX(connector->dev)) {
>  		hdmiw_hdmiedid =3D IBX_HDMIW_HDMIEDID_A;
> +		aud_config =3D IBX_AUD_CONFIG_A;
>  		aud_cntl_st =3D IBX_AUD_CNTL_ST_A;
>  		aud_cntrl_st2 =3D IBX_AUD_CNTL_ST2;
>  	} else {
>  		hdmiw_hdmiedid =3D CPT_HDMIW_HDMIEDID_A;
> +		aud_config =3D CPT_AUD_CONFIG_A;
>  		aud_cntl_st =3D CPT_AUD_CNTL_ST_A;
>  		aud_cntrl_st2 =3D CPT_AUD_CNTRL_ST2;
>  	}
> @@ -5924,6 +5927,7 @@ static void ironlake_write_eld(struct dr
>  	i =3D to_intel_crtc(crtc)->pipe;
>  	hdmiw_hdmiedid +=3D i * 0x100;
>  	aud_cntl_st +=3D i * 0x100;
> +	aud_config +=3D i * 0x100;
>=20=20
>  	DRM_DEBUG_DRIVER("ELD on pipe %c\n", pipe_name(i));
>=20=20
> @@ -5943,7 +5947,9 @@ static void ironlake_write_eld(struct dr
>  	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
>  		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
>  		eld[5] |=3D (1 << 2);	/* Conn_Type, 0x1 =3D DisplayPort */
> -	}
> +		I915_WRITE(aud_config, AUD_CONFIG_N_VALUE_INDEX); /* 0x1 =3D DP */
> +	} else
> +		I915_WRITE(aud_config, 0);
>=20=20
>  	if (intel_eld_uptodate(connector,
>  			       aud_cntrl_st2, eldv,

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxSvgTYtFsjWk68qAQgRDRAAtucnD1EpQYP1G5eAuibf99j6AM8z+qc1
tMBI/WrvG6LQtBg86+kqmBWcf4ECB95BjFyi7zhEph7VJxu3m6/T/WVceUZ8fmrY
ND9qRvz/Hzi1J04qMLUDCfGYlB9KDyH8Axnnp9ycMLxYK4V1SazuYTQe+TwwKqu9
MVyn/yAkvIe6ZBgO3ObUlhrLWWy+mP/kKPD7JrjAEciIA4svGf+V/Is4w/rTdh63
Kfhw5FJk0h8XBDfN+YWIiYP+U4s+R+pWWkQRLTwbBrc7nV2wFDQoj/iRzkQfn2be
JbbljgKA2DkfMVE3NpEnVLuW7/Lk/2syxZIbXRV7GRZwpF4xJBJ0U0RCf2gn/tw9
MslaWGzfFL6o/rixmLxaHlgGGEgscA2xi27PLM6ZHCqypSDk3IDSHUhuEEOFk3Rx
ssa5VwDk1p+jtKN+yrIYG7vFi89Rb4ltx5d27gkhkcR/FQE2VgfOklmV8kDBDYgj
LV3TJSxqT5C7mAW3l112r8Bgc78+pcWmNxYlKcVETUnu/15yH459b6dnyOipJFAm
MZzhJDvRHmdMAZ0NnaIOAKdgd2RkXum8D3ZWhqa0JLmnGVgv825T12WKun0rWgGs
Re18gEJSnwR8S1CWPq7HXevjvt7RsSV5Dp8XmHqS30dXe+JP4vAh+VNBVjYJa9KU
FzbH13KQrdc=
=5sHx
-----END PGP SIGNATURE-----
--=-=-=--
