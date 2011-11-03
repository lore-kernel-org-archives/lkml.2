Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab1KCUAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 16:00:21 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49361 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750803Ab1KCUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 16:00:20 -0400
Date: Thu, 3 Nov 2011 13:00:11 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 5/7] drm/i915: Make DP prepare/commit
 consistent with DP dpms
Message-ID: <20111103130011.7946090a@jbarnes-desktop>
In-Reply-To: <1320214830-12696-6-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-6-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2E_QW0WvhYzJrsIrYnNZqu_"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2E_QW0WvhYzJrsIrYnNZqu_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Nov 2011 23:20:28 -0700
Keith Packard <keithp@keithp.com> wrote:

> Make sure the sequence of operations in all three functions makes
> sense:
>=20
>  1) The backlight must be off unless the screen is running
>  2) The link must be running to turn the eDP panel on/off
>  3) The CPU eDP PLL must be running until everything is off

A few comments on this one (also, is it strictly required to fix your
bug)?

> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel=
_dp.c
> index d6c6608..6be6a04 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -1234,17 +1234,18 @@ static void intel_dp_prepare(struct drm_encoder *=
encoder)
>  {
>  	struct intel_dp *intel_dp =3D enc_to_intel_dp(encoder);
> =20
> +	ironlake_edp_backlight_off(intel_dp);
> +	ironlake_edp_panel_off(intel_dp);
> +
>  	/* Wake up the sink first */
>  	ironlake_edp_panel_vdd_on(intel_dp);
>  	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
> +	intel_dp_link_down(intel_dp);
>  	ironlake_edp_panel_vdd_off(intel_dp, false);
> =20
>  	/* Make sure the panel is off before trying to
>  	 * change the mode
>  	 */
> -	ironlake_edp_backlight_off(intel_dp);
> -	intel_dp_link_down(intel_dp);
> -	ironlake_edp_panel_off(intel_dp);
>  }

Ok so you're making sure the panel has power to down the link, I think
that's fine.

>  static void intel_dp_commit(struct drm_encoder *encoder)
> @@ -1276,16 +1277,20 @@ intel_dp_dpms(struct drm_encoder *encoder, int mo=
de)
>  	uint32_t dp_reg =3D I915_READ(intel_dp->output_reg);
> =20
>  	if (mode !=3D DRM_MODE_DPMS_ON) {
> +		ironlake_edp_backlight_off(intel_dp);
> +		ironlake_edp_panel_off(intel_dp);
> +
>  		ironlake_edp_panel_vdd_on(intel_dp);
> -		if (is_edp(intel_dp))
> -			ironlake_edp_backlight_off(intel_dp);
>  		intel_dp_sink_dpms(intel_dp, mode);
>  		intel_dp_link_down(intel_dp);
> -		ironlake_edp_panel_off(intel_dp);
> -		if (is_edp(intel_dp) && !is_pch_edp(intel_dp))
> -			ironlake_edp_pll_off(encoder);
>  		ironlake_edp_panel_vdd_off(intel_dp, false);
> +
> +		if (is_cpu_edp(intel_dp))
> +			ironlake_edp_pll_off(encoder);


But here it looks like you're shutting it off, then downing the link?
Should this be reordered?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/2E_QW0WvhYzJrsIrYnNZqu_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsvLLAAoJEIEoDkX4Qk9hNW8QALbHa4tmzXXps8WVYzAk+ZTD
eFGzBM0wuZ3rkqfqN0+S18DJJ1k0lh4tGjKstZDLPVV9UuscAlPG3qmI33IzUVbg
wYEYwx95SNiR+DxXPds1+D+nvRPudoy8Ok+EH+Yf/sNz4f+BEQQswi1hWfkZvWSL
Txv/+G05UIc7i9gDz9cIJWsd3YWgy481IoK0jW7zi0uC00b7uV5vRcu8frTlkj0v
MPscCTuZVRHWYsx/mNkli/KPKzZkmS4QoRmsKbZgpWNgH+lxRupb10sPKtbE9fMg
yKJEIrMa6KxRpbI4ILzaus8kRdrzvCF40I8bX+Z+uw+Y03Hq24pwD+TMGTjcudUk
wCvvCMZYynT4yrUMdJvHuyGruqsNipX2dQK0M6OdQsaKg4swaY2CB+a5iYaCaanE
XzfmG5JAqVali3yvDyOkhgjo2c4y8fogRYE37r0SnaLwhJkF69DBVY8dyVLvRwJz
zZ3mAVTERTo9cJGB+8gp4RHdWDAsgvsw3ppsJVPSGfFybdFdocXXitGQ+BKp/OHt
RYlJR7SUuQPr1/xktYTsLUh64PXaDm4G7Qw7IWb1ulnoW5XHcevxVDFnS6S5B0kL
ZCvIhvjOHyFelza9DiLw0jmKGWUtuBBtu/6cybU3iMjEMf7kDWdq6GgvDvojq0PI
vDbdnvQvc2Kw6wF9IXOt
=GbZf
-----END PGP SIGNATURE-----

--Sig_/2E_QW0WvhYzJrsIrYnNZqu_--
