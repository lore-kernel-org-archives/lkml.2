Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab2CWPov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:44:51 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:61370 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2CWPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:44:50 -0400
Date: Fri, 23 Mar 2012 16:44:46 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        alexander.deucher@amd.com
Subject: Re: radeon + DVI->mDP converter + mDP display blank screen issue
 since 3.0
Message-ID: <20120323154446.GK28523@wantstofly.org>
References: <20120322124919.GG28523@wantstofly.org>
 <CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 10:59:27AM -0400, Alex Deucher wrote:

> > Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
> > to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DVI
> > to Mini DisplayPort converter has started to stop giving screen
> > output on switching from text mode to graphical framebuffer during
> > system startup.
> >
> > I finally had some time to look at this, and it seems to have stopped
> > working after this commit:
> >
> >        commit df271bec805b42527d864777ed035fcbb42e76c0
> >        Author: Alex Deucher <alexdeucher@gmail.com>
> >        Date:   Fri May 20 04:34:15 2011 -0400
> >
> >            drm/radeon/kms: properly handle bpc >8 in atom command tables
> >
> >            Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
> >            Signed-off-by: Dave Airlie <airlied@redhat.com>
> >
> > ...and with the patch below (i.e. reverting part of the commit above)
> > applied to 3.3 I get screen output again.
> >
> > Even though the monitor seems to have an 8 bit panel, it reports 10
> > bits per channel in its EDID:
> >
> >        [...]
> >        Manufacturer: APP Model 9226 Serial Number 41959462
> >        Made week 38 of 2010
> >        EDID version: 1.4
> >        Digital display
> >        10 bits per primary color channel
> >        DisplayPort interface
> >        Maximum image size: 60 cm x 34 cm
> >        [...]
> >
> > The (active, dual link) DVI->mDP converter spec sheet says it supports
> > 24 bit color, and I'm guessing that it can't deal with 30.  Is the
> > converter at fault here for passing through the EDID unchanged?
> >
> > Also, what would be the right way to handle this, a kernel command
> > line or module option to limit color depth or something like that?
> > ("Buy a video card with DP output." is a valid answer, I suppose.)
> >
> > I have no clue at all about graphics, and I have no idea whatsoever
> > what I'm doing here, but I just wanted to post this somewhere for
> > Google to find in case someone else runs into this!
> 
> I've inquired with out display team on how to best handle this.  In
> the meantime, it's probably best to just default to 8 bpc.  Does the
> attached patch fix your issue?

I've been using the patch below in a custom Fedora 17 kernel RPM, and
that seems to fix the issue.  Your patch seems to be a superset of
this patch, so logically, your patch should do the trick as well. :)


thanks,
Lennert


diff -up linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c.orig linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c
--- linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c.orig	2012-03-22 14:52:20.538854547 +0100
+++ linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c	2012-03-22 14:55:39.740794113 +0100
@@ -550,8 +550,6 @@ static u32 atombios_adjust_pll(struct dr
 		if (encoder->crtc == crtc) {
 			radeon_encoder = to_radeon_encoder(encoder);
 			connector = radeon_get_connector_for_encoder(encoder);
-			if (connector && connector->display_info.bpc)
-				bpc = connector->display_info.bpc;
 			encoder_mode = atombios_get_encoder_mode(encoder);
 			is_duallink = radeon_dig_monitor_is_duallink(encoder, mode->clock);
 			if ((radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
@@ -922,7 +920,6 @@ static void atombios_crtc_set_pll(struct
 		struct radeon_connector_atom_dig *dig_connector =
 			radeon_connector->con_priv;
 		int dp_clock;
-		bpc = connector->display_info.bpc;
 
 		switch (encoder_mode) {
 		case ATOM_ENCODER_MODE_DP_MST:



> From 22ca454eb749968f266d6788a5f4778acc08cc66 Mon Sep 17 00:00:00 2001
> From: Alex Deucher <alexander.deucher@amd.com>
> Date: Fri, 23 Mar 2012 10:54:45 -0400
> Subject: [PATCH] drm/radeon/kms/atom: force bpc to 8 for now
> 
> Using the bpc (bits per color) specified by the monitor
> can cause problems in some cases.  Until we get a better
> handle on how to deal with those cases, just use a bpc of 8.
> 
> Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@kernel.org
> ---
>  drivers/gpu/drm/radeon/atombios_crtc.c     |    8 +++++---
>  drivers/gpu/drm/radeon/atombios_dp.c       |    3 +++
>  drivers/gpu/drm/radeon/atombios_encoders.c |    4 ++--
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
> index 083b3ea..b5ff1f7 100644
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -588,8 +588,8 @@ static u32 atombios_adjust_pll(struct drm_crtc *crtc,
>  		if (encoder->crtc == crtc) {
>  			radeon_encoder = to_radeon_encoder(encoder);
>  			connector = radeon_get_connector_for_encoder(encoder);
> -			if (connector && connector->display_info.bpc)
> -				bpc = connector->display_info.bpc;
> +			/* if (connector && connector->display_info.bpc)
> +				bpc = connector->display_info.bpc; */
>  			encoder_mode = atombios_get_encoder_mode(encoder);
>  			is_duallink = radeon_dig_monitor_is_duallink(encoder, mode->clock);
>  			if ((radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
> @@ -965,7 +965,9 @@ static void atombios_crtc_set_pll(struct drm_crtc *crtc, struct drm_display_mode
>  		struct radeon_connector_atom_dig *dig_connector =
>  			radeon_connector->con_priv;
>  		int dp_clock;
> -		bpc = connector->display_info.bpc;
> +
> +		/* if (connector->display_info.bpc)
> +			bpc = connector->display_info.bpc; */
>  
>  		switch (encoder_mode) {
>  		case ATOM_ENCODER_MODE_DP_MST:
> diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
> index 6c62be2..c57d856 100644
> --- a/drivers/gpu/drm/radeon/atombios_dp.c
> +++ b/drivers/gpu/drm/radeon/atombios_dp.c
> @@ -405,10 +405,13 @@ static void dp_get_adjust_train(u8 link_status[DP_LINK_STATUS_SIZE],
>  /* get bpc from the EDID */
>  static int convert_bpc_to_bpp(int bpc)
>  {
> +#if 0
>  	if (bpc == 0)
>  		return 24;
>  	else
>  		return bpc * 3;
> +#endif
> +	return 24;
>  }
>  
>  /* get the max pix clock supported by the link rate and lane num */
> diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
> index 468b874..e607c4d 100644
> --- a/drivers/gpu/drm/radeon/atombios_encoders.c
> +++ b/drivers/gpu/drm/radeon/atombios_encoders.c
> @@ -541,7 +541,7 @@ atombios_dig_encoder_setup(struct drm_encoder *encoder, int action, int panel_mo
>  		dp_clock = dig_connector->dp_clock;
>  		dp_lane_count = dig_connector->dp_lane_count;
>  		hpd_id = radeon_connector->hpd.hpd;
> -		bpc = connector->display_info.bpc;
> +		/* bpc = connector->display_info.bpc; */
>  	}
>  
>  	/* no dig encoder assigned */
> @@ -1159,7 +1159,7 @@ atombios_external_encoder_setup(struct drm_encoder *encoder,
>  		dp_lane_count = dig_connector->dp_lane_count;
>  		connector_object_id =
>  			(radeon_connector->connector_object_id & OBJECT_ID_MASK) >> OBJECT_ID_SHIFT;
> -		bpc = connector->display_info.bpc;
> +		/* bpc = connector->display_info.bpc; */
>  	}
>  
>  	memset(&args, 0, sizeof(args));
> -- 
> 1.7.7.5
> 
