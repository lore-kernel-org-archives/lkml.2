Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1GGN54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:57:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51671 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1GGN5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <1309995012-5873-4-git-send-email-reimth@gmail.com>
References: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
	<1309995012-5873-1-git-send-email-reimth@gmail.com>
	<1309995012-5873-4-git-send-email-reimth@gmail.com>
Date: Thu, 7 Jul 2011 09:57:54 -0400
Message-ID: <CADnq5_N8mjGM+dxQS=PG5g4xxN-nuLSTOAfKqDLOH0bdTd5usQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm: Separate EDID Header Check from EDID Block Check
From: Alex Deucher <alexdeucher@gmail.com>
To: reimth@googlemail.com
Cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 7:30 PM,  <reimth@googlemail.com> wrote:
> From: Thomas Reim <rdratlos@yahoo.co.uk>
>
>    Provides function drm_edid_header_is_valid() for EDID header check
>    and replaces EDID header check part of function drm_edid_block_valid()
>    by a call of drm_edid_header_is_valid().
>    This is a prerequisite to extend DDC probing, e. g. in function
>    radeon_ddc_probe() for Radeon devices, by a central EDID header check.
>
>    Tested for kernel 2.35, 2.38 and 3.0
>
> Signed-off-by: Thomas Reim <rdratlos@yahoo.co.uk>

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

> ---
>  drivers/gpu/drm/drm_edid.c |   24 ++++++++++++++++++------
>  include/drm/drm_crtc.h     |    1 +
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 0929219..1bbb85b 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -127,6 +127,23 @@ static const u8 edid_header[] = {
>        0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
>  };
>
> + /*
> + * Sanity check the header of the base EDID block.  Return 8 if the header
> + * is perfect, down to 0 if it's totally wrong.
> + */
> +int drm_edid_header_is_valid(const u8 *raw_edid)
> +{
> +       int i, score = 0;
> +
> +       for (i = 0; i < sizeof(edid_header); i++)
> +               if (raw_edid[i] == edid_header[i])
> +                       score++;
> +
> +       return score;
> +}
> +EXPORT_SYMBOL(drm_edid_header_is_valid);
> +
> +
>  /*
>  * Sanity check the EDID block (base or extension).  Return 0 if the block
>  * doesn't check out, or 1 if it's valid.
> @@ -139,12 +156,7 @@ drm_edid_block_valid(u8 *raw_edid)
>        struct edid *edid = (struct edid *)raw_edid;
>
>        if (raw_edid[0] == 0x00) {
> -               int score = 0;
> -
> -               for (i = 0; i < sizeof(edid_header); i++)
> -                       if (raw_edid[i] == edid_header[i])
> -                               score++;
> -
> +               int score = drm_edid_header_is_valid(raw_edid);
>                if (score == 8) ;
>                else if (score >= 6) {
>                        DRM_DEBUG("Fixing EDID header, your hardware may be failing\n");
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index 33d12f8..0ec3687 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -802,6 +802,7 @@ extern struct drm_display_mode *drm_gtf_mode_complex(struct drm_device *dev,
>  extern int drm_add_modes_noedid(struct drm_connector *connector,
>                                int hdisplay, int vdisplay);
>
> +extern int drm_edid_header_is_valid(const u8 *raw_edid);
>  extern bool drm_edid_is_valid(struct edid *edid);
>  struct drm_display_mode *drm_mode_find_dmt(struct drm_device *dev,
>                                           int hsize, int vsize, int fresh);
> --
> 1.7.1
>
>
