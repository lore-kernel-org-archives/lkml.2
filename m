Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2CWO7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:59:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47400 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab2CWO72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120322124919.GG28523@wantstofly.org>
References: <20120322124919.GG28523@wantstofly.org>
Date: Fri, 23 Mar 2012 10:59:27 -0400
Message-ID: <CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
Subject: Re: radeon + DVI->mDP converter + mDP display blank screen issue
 since 3.0
From: Alex Deucher <alexdeucher@gmail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        alexander.deucher@amd.com
Content-Type: multipart/mixed; boundary=e89a8f3ba9315ad29804bbea4526
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f3ba9315ad29804bbea4526
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 22, 2012 at 8:49 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> Hi!
>
> Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
> to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DVI
> to Mini DisplayPort converter has started to stop giving screen
> output on switching from text mode to graphical framebuffer during
> system startup.
>
> I finally had some time to look at this, and it seems to have stopped
> working after this commit:
>
> =A0 =A0 =A0 =A0commit df271bec805b42527d864777ed035fcbb42e76c0
> =A0 =A0 =A0 =A0Author: Alex Deucher <alexdeucher@gmail.com>
> =A0 =A0 =A0 =A0Date: =A0 Fri May 20 04:34:15 2011 -0400
>
> =A0 =A0 =A0 =A0 =A0 =A0drm/radeon/kms: properly handle bpc >8 in atom com=
mand tables
>
> =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail.com=
>
> =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> ...and with the patch below (i.e. reverting part of the commit above)
> applied to 3.3 I get screen output again.
>
> Even though the monitor seems to have an 8 bit panel, it reports 10
> bits per channel in its EDID:
>
> =A0 =A0 =A0 =A0[...]
> =A0 =A0 =A0 =A0Manufacturer: APP Model 9226 Serial Number 41959462
> =A0 =A0 =A0 =A0Made week 38 of 2010
> =A0 =A0 =A0 =A0EDID version: 1.4
> =A0 =A0 =A0 =A0Digital display
> =A0 =A0 =A0 =A010 bits per primary color channel
> =A0 =A0 =A0 =A0DisplayPort interface
> =A0 =A0 =A0 =A0Maximum image size: 60 cm x 34 cm
> =A0 =A0 =A0 =A0[...]
>
> The (active, dual link) DVI->mDP converter spec sheet says it supports
> 24 bit color, and I'm guessing that it can't deal with 30. =A0Is the
> converter at fault here for passing through the EDID unchanged?
>
> Also, what would be the right way to handle this, a kernel command
> line or module option to limit color depth or something like that?
> ("Buy a video card with DP output." is a valid answer, I suppose.)
>
> I have no clue at all about graphics, and I have no idea whatsoever
> what I'm doing here, but I just wanted to post this somewhere for
> Google to find in case someone else runs into this!

I've inquired with out display team on how to best handle this.  In
the meantime, it's probably best to just default to 8 bpc.  Does the
attached patch fix your issue?

Alex

>
>
> thanks,
> Lennert
>
>
>
> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/rad=
eon/atombios_crtc.c
> index 742f17f..77a6a04 100644
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -513,11 +513,9 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc=
,
> =A0 =A0 =A0 =A0struct radeon_device *rdev =3D dev->dev_private;
> =A0 =A0 =A0 =A0struct drm_encoder *encoder =3D NULL;
> =A0 =A0 =A0 =A0struct radeon_encoder *radeon_encoder =3D NULL;
> - =A0 =A0 =A0 struct drm_connector *connector =3D NULL;
> =A0 =A0 =A0 =A0u32 adjusted_clock =3D mode->clock;
> =A0 =A0 =A0 =A0int encoder_mode =3D 0;
> =A0 =A0 =A0 =A0u32 dp_clock =3D mode->clock;
> - =A0 =A0 =A0 int bpc =3D 8;
> =A0 =A0 =A0 =A0bool is_duallink =3D false;
>
> =A0 =A0 =A0 =A0/* reset the pll flags */
> @@ -549,13 +547,11 @@ static u32 atombios_adjust_pll(struct drm_crtc *crt=
c,
> =A0 =A0 =A0 =A0list_for_each_entry(encoder, &dev->mode_config.encoder_lis=
t, head) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (encoder->crtc =3D=3D crtc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_encoder =3D to_rade=
on_encoder(encoder);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connector =3D radeon_get_co=
nnector_for_encoder(encoder);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (connector && connector-=
>display_info.bpc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D con=
nector->display_info.bpc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0encoder_mode =3D atombios_=
get_encoder_mode(encoder);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_duallink =3D radeon_dig=
_monitor_is_duallink(encoder, mode->clock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((radeon_encoder->devic=
es & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(radeon_encoder_ge=
t_dp_bridge_encoder_id(encoder) !=3D ENCODER_OBJECT_ID_NONE)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct drm_=
connector *connector =3D radeon_get_connector_for_encoder(encoder);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (connec=
tor) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0struct radeon_connector *radeon_connector =3D to_radeon_connector(co=
nnector);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0struct radeon_connector_atom_dig *dig_connector =3D
> @@ -645,7 +641,7 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0if (encoder_mode =3D=3D ATOM_ENCODER_MODE_HDMI)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0/* deep color support */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0args.v3.sInput.usPixelClock =3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16((mode->clock * bpc / 8) / =
10);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(mode->clock / 10);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0if (dig->coherent_mode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0args.v3.sInput.ucDispPllConfig |=3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DISPPLL_CONFIG_COHERENT_MODE;
> @@ -753,7 +749,6 @@ static void atombios_crtc_program_pll(struct drm_crtc=
 *crtc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0u32 fb_div,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0u32 frac_fb_div,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0u32 post_div,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 int bpc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0bool ss_enabled,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0struct radeon_atom_ss *ss)
> =A0{
> @@ -817,15 +812,6 @@ static void atombios_crtc_program_pll(struct drm_crt=
c *crtc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v5.ucMiscInfo =3D 0; =
/* HDMI depth, etc. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ss_enabled && (ss->typ=
e & ATOM_EXTERNAL_SS_MASK))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v5.uc=
MiscInfo |=3D PIXEL_CLOCK_V5_MISC_REF_DIV_SRC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (bpc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 8:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v5.ucM=
iscInfo |=3D PIXEL_CLOCK_V5_MISC_HDMI_24BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 10:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v5.ucM=
iscInfo |=3D PIXEL_CLOCK_V5_MISC_HDMI_30BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v5.ucTransmitterID =
=3D encoder_id;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v5.ucEncoderMode =3D =
encoder_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v5.ucPpll =3D pll_id;
> @@ -839,21 +825,6 @@ static void atombios_crtc_program_pll(struct drm_crt=
c *crtc,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v6.ucMiscInfo =3D 0; =
/* HDMI depth, etc. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ss_enabled && (ss->typ=
e & ATOM_EXTERNAL_SS_MASK))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v6.uc=
MiscInfo |=3D PIXEL_CLOCK_V6_MISC_REF_DIV_SRC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (bpc) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 8:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v6.ucM=
iscInfo |=3D PIXEL_CLOCK_V6_MISC_HDMI_24BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 10:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v6.ucM=
iscInfo |=3D PIXEL_CLOCK_V6_MISC_HDMI_30BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 12:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v6.ucM=
iscInfo |=3D PIXEL_CLOCK_V6_MISC_HDMI_36BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 16:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 args.v6.ucM=
iscInfo |=3D PIXEL_CLOCK_V6_MISC_HDMI_48BPP;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v6.ucTransmitterID =
=3D encoder_id;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v6.ucEncoderMode =3D =
encoder_mode;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.v6.ucPpll =3D pll_id;
> @@ -885,7 +856,6 @@ static void atombios_crtc_set_pll(struct drm_crtc *cr=
tc, struct drm_display_mode
> =A0 =A0 =A0 =A0int encoder_mode =3D 0;
> =A0 =A0 =A0 =A0struct radeon_atom_ss ss;
> =A0 =A0 =A0 =A0bool ss_enabled =3D false;
> - =A0 =A0 =A0 int bpc =3D 8;
>
> =A0 =A0 =A0 =A0list_for_each_entry(encoder, &dev->mode_config.encoder_lis=
t, head) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (encoder->crtc =3D=3D crtc) {
> @@ -922,7 +892,6 @@ static void atombios_crtc_set_pll(struct drm_crtc *cr=
tc, struct drm_display_mode
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct radeon_connector_atom_dig *dig_conn=
ector =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_connector->con_priv=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int dp_clock;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (encoder_mode) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ATOM_ENCODER_MODE_DP_MST:
> @@ -995,7 +964,7 @@ static void atombios_crtc_set_pll(struct drm_crtc *cr=
tc, struct drm_display_mode
>
> =A0 =A0 =A0 =A0atombios_crtc_program_pll(crtc, radeon_crtc->crtc_id, rade=
on_crtc->pll_id,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0encode=
r_mode, radeon_encoder->encoder_id, mode->clock,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ref_div=
, fb_div, frac_fb_div, post_div, bpc, ss_enabled, &ss);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ref_div=
, fb_div, frac_fb_div, post_div, ss_enabled, &ss);
>
> =A0 =A0 =A0 =A0if (ss_enabled) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* calculate ss amount and step size */
> @@ -1587,7 +1556,7 @@ static void atombios_crtc_disable(struct drm_crtc *=
crtc)
> =A0 =A0 =A0 =A0case ATOM_PPLL2:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* disable the ppll */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atombios_crtc_program_pll(crtc, radeon_crt=
c->crtc_id, radeon_crtc->pll_id,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, 0, ATOM_DISABLE, 0, 0, 0, 0, 0, false, &ss);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, 0, ATOM_DISABLE, 0, 0, 0, 0, false, &ss);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

--e89a8f3ba9315ad29804bbea4526
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-atom-force-bpc-to-8-for-now.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-atom-force-bpc-to-8-for-now.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h05cvlqv0

RnJvbSAyMmNhNDU0ZWI3NDk5NjhmMjY2ZDY3ODhhNWY0Nzc4YWNjMDhjYzY2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IEZyaSwgMjMgTWFyIDIwMTIgMTA6NTQ6NDUgLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uL2ttcy9hdG9tOiBmb3JjZSBicGMgdG8gOCBmb3Igbm93CgpVc2luZyB0aGUg
YnBjIChiaXRzIHBlciBjb2xvcikgc3BlY2lmaWVkIGJ5IHRoZSBtb25pdG9yCmNhbiBjYXVzZSBw
cm9ibGVtcyBpbiBzb21lIGNhc2VzLiAgVW50aWwgd2UgZ2V0IGEgYmV0dGVyCmhhbmRsZSBvbiBo
b3cgdG8gZGVhbCB3aXRoIHRob3NlIGNhc2VzLCBqdXN0IHVzZSBhIGJwYyBvZiA4LgoKUmVwb3J0
ZWQtYnk6IExlbm5lcnQgQnV5dGVuaGVrIDxidXl0ZW5oQHdhbnRzdG9mbHkub3JnPgpTaWduZWQt
b2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+CkNjOiBzdGFi
bGVAa2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5j
ICAgICB8ICAgIDggKysrKystLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZHAu
YyAgICAgICB8ICAgIDMgKysrCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29k
ZXJzLmMgfCAgICA0ICsrLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9z
X2NydGMuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jCmluZGV4IDA4
M2IzZWEuLmI1ZmYxZjcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJp
b3NfY3J0Yy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jCkBA
IC01ODgsOCArNTg4LDggQEAgc3RhdGljIHUzMiBhdG9tYmlvc19hZGp1c3RfcGxsKHN0cnVjdCBk
cm1fY3J0YyAqY3J0YywKIAkJaWYgKGVuY29kZXItPmNydGMgPT0gY3J0YykgewogCQkJcmFkZW9u
X2VuY29kZXIgPSB0b19yYWRlb25fZW5jb2RlcihlbmNvZGVyKTsKIAkJCWNvbm5lY3RvciA9IHJh
ZGVvbl9nZXRfY29ubmVjdG9yX2Zvcl9lbmNvZGVyKGVuY29kZXIpOwotCQkJaWYgKGNvbm5lY3Rv
ciAmJiBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGMpCi0JCQkJYnBjID0gY29ubmVjdG9yLT5k
aXNwbGF5X2luZm8uYnBjOworCQkJLyogaWYgKGNvbm5lY3RvciAmJiBjb25uZWN0b3ItPmRpc3Bs
YXlfaW5mby5icGMpCisJCQkJYnBjID0gY29ubmVjdG9yLT5kaXNwbGF5X2luZm8uYnBjOyAqLwog
CQkJZW5jb2Rlcl9tb2RlID0gYXRvbWJpb3NfZ2V0X2VuY29kZXJfbW9kZShlbmNvZGVyKTsKIAkJ
CWlzX2R1YWxsaW5rID0gcmFkZW9uX2RpZ19tb25pdG9yX2lzX2R1YWxsaW5rKGVuY29kZXIsIG1v
ZGUtPmNsb2NrKTsKIAkJCWlmICgocmFkZW9uX2VuY29kZXItPmRldmljZXMgJiAoQVRPTV9ERVZJ
Q0VfTENEX1NVUFBPUlQgfCBBVE9NX0RFVklDRV9ERlBfU1VQUE9SVCkpIHx8CkBAIC05NjUsNyAr
OTY1LDkgQEAgc3RhdGljIHZvaWQgYXRvbWJpb3NfY3J0Y19zZXRfcGxsKHN0cnVjdCBkcm1fY3J0
YyAqY3J0Yywgc3RydWN0IGRybV9kaXNwbGF5X21vZGUKIAkJc3RydWN0IHJhZGVvbl9jb25uZWN0
b3JfYXRvbV9kaWcgKmRpZ19jb25uZWN0b3IgPQogCQkJcmFkZW9uX2Nvbm5lY3Rvci0+Y29uX3By
aXY7CiAJCWludCBkcF9jbG9jazsKLQkJYnBjID0gY29ubmVjdG9yLT5kaXNwbGF5X2luZm8uYnBj
OworCisJCS8qIGlmIChjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGMpCisJCQlicGMgPSBjb25u
ZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7ICovCiAKIAkJc3dpdGNoIChlbmNvZGVyX21vZGUpIHsK
IAkJY2FzZSBBVE9NX0VOQ09ERVJfTU9ERV9EUF9NU1Q6CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2F0b21iaW9zX2RwLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21i
aW9zX2RwLmMKaW5kZXggNmM2MmJlMi4uYzU3ZDg1NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9hdG9tYmlvc19kcC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRv
bWJpb3NfZHAuYwpAQCAtNDA1LDEwICs0MDUsMTMgQEAgc3RhdGljIHZvaWQgZHBfZ2V0X2FkanVz
dF90cmFpbih1OCBsaW5rX3N0YXR1c1tEUF9MSU5LX1NUQVRVU19TSVpFXSwKIC8qIGdldCBicGMg
ZnJvbSB0aGUgRURJRCAqLwogc3RhdGljIGludCBjb252ZXJ0X2JwY190b19icHAoaW50IGJwYykK
IHsKKyNpZiAwCiAJaWYgKGJwYyA9PSAwKQogCQlyZXR1cm4gMjQ7CiAJZWxzZQogCQlyZXR1cm4g
YnBjICogMzsKKyNlbmRpZgorCXJldHVybiAyNDsKIH0KIAogLyogZ2V0IHRoZSBtYXggcGl4IGNs
b2NrIHN1cHBvcnRlZCBieSB0aGUgbGluayByYXRlIGFuZCBsYW5lIG51bSAqLwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jIGIvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jCmluZGV4IDQ2OGI4NzQuLmU2MDdjNGQg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYwor
KysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29kZXJzLmMKQEAgLTU0MSw3
ICs1NDEsNyBAQCBhdG9tYmlvc19kaWdfZW5jb2Rlcl9zZXR1cChzdHJ1Y3QgZHJtX2VuY29kZXIg
KmVuY29kZXIsIGludCBhY3Rpb24sIGludCBwYW5lbF9tbwogCQlkcF9jbG9jayA9IGRpZ19jb25u
ZWN0b3ItPmRwX2Nsb2NrOwogCQlkcF9sYW5lX2NvdW50ID0gZGlnX2Nvbm5lY3Rvci0+ZHBfbGFu
ZV9jb3VudDsKIAkJaHBkX2lkID0gcmFkZW9uX2Nvbm5lY3Rvci0+aHBkLmhwZDsKLQkJYnBjID0g
Y29ubmVjdG9yLT5kaXNwbGF5X2luZm8uYnBjOworCQkvKiBicGMgPSBjb25uZWN0b3ItPmRpc3Bs
YXlfaW5mby5icGM7ICovCiAJfQogCiAJLyogbm8gZGlnIGVuY29kZXIgYXNzaWduZWQgKi8KQEAg
LTExNTksNyArMTE1OSw3IEBAIGF0b21iaW9zX2V4dGVybmFsX2VuY29kZXJfc2V0dXAoc3RydWN0
IGRybV9lbmNvZGVyICplbmNvZGVyLAogCQlkcF9sYW5lX2NvdW50ID0gZGlnX2Nvbm5lY3Rvci0+
ZHBfbGFuZV9jb3VudDsKIAkJY29ubmVjdG9yX29iamVjdF9pZCA9CiAJCQkocmFkZW9uX2Nvbm5l
Y3Rvci0+Y29ubmVjdG9yX29iamVjdF9pZCAmIE9CSkVDVF9JRF9NQVNLKSA+PiBPQkpFQ1RfSURf
U0hJRlQ7Ci0JCWJwYyA9IGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYzsKKwkJLyogYnBjID0g
Y29ubmVjdG9yLT5kaXNwbGF5X2luZm8uYnBjOyAqLwogCX0KIAogCW1lbXNldCgmYXJncywgMCwg
c2l6ZW9mKGFyZ3MpKTsKLS0gCjEuNy43LjUKCg==
--e89a8f3ba9315ad29804bbea4526--
