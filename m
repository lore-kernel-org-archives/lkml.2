Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2F3SrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 14:47:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53393 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F3SrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:47:08 -0400
Message-ID: <4FEF499E.1090107@gmail.com>
Date: Sat, 30 Jun 2012 13:46:54 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120625 Thunderbird/10.0.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Sven Joachim <svenjoac@gmx.de>, dri-devel@lists.freedesktop.org,
        Adam Jackson <ajax@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de> <87obo7jnmn.fsf@turtle.gmx.de> <s5ha9zr2o1a.wl%tiwai@suse.de> <87r4t3w59r.fsf@turtle.gmx.de> <s5hsjdi1qtv.wl%tiwai@suse.de>
In-Reply-To: <s5hsjdi1qtv.wl%tiwai@suse.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 02:21 AM, Takashi Iwai wrote:
> At Mon, 25 Jun 2012 21:38:56 +0200,
> Sven Joachim wrote:
>>
>> Am 25.06.2012 um 21:24 schrieb Takashi Iwai:
>>
>>>>> And, does the patch below help?
>>>>
>>>> Somewhat: at least I get 1280x1024 again, but at 60 rather than 75 Hz.
>>>
>>> I guess it worked casually because 1280x1024@75 was the highest
>>> resolution / rate, so it was picked up as the preferred mode...
>>
>> Quite possible.  Problem is that 1280x1024@60 looks worse, so I'd like
>> to get the 75 Hz back.
>>
>>>> The xrandr command shows various bogus modes.
>>>
>>> Can't these values be displayed on your monitor at all?
>>
>> It's a TFT LCD with 1280x1024 pixels.
> 
> Yes, but displaying higher resolutions wasn't too uncommon in the
> earlier VGA days.  So, this doesn't mean the higher modes are
> "bogus" as long they are in the range the monitor itself advertises.
> 
> On the second thought, if there are many such broken monitors, it
> might be safer to exclude the inferred modes with higher resolutions.
> 
> The original problem was that the resolution like 1366x768 or 1600x900
> doesn't appear in the mode list.  These are supposed to be lower than
> the native.  Restricting the higher resolutions won't regress for
> these problems.
> 
> The patch below is a quick fix.
> 
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] drm: edid: Don't add inferred modes with higher resolution
> 
> When a monitor EDID doesn't give the preferred bit, driver assumes
> that the mode with the higest resolution and rate is the preferred
> mode.  Meanwhile the recent changes for allowing more modes in the
> GFT/CVT ranges give actually more modes, and some modes may be over
> the native size.  Thus such a mode would be picked up as the preferred
> mode although it's no native resolution.
> 
> For avoiding such a problem, this patch limits the addition of
> inferred modes by checking not to be greater than other modes.
> Also, it checks the duplicated mode entry at the same time.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/gpu/drm/drm_edid.c |   27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 5873e48..a8743c3 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -1039,6 +1039,24 @@ mode_in_range(const struct drm_display_mode *mode, struct edid *edid,
>  	return true;
>  }
>  
> +static bool valid_inferred_mode(const struct drm_connector *connector,
> +				const struct drm_display_mode *mode)
> +{
> +	struct drm_display_mode *m;
> +	bool ok = false;
> +
> +	list_for_each_entry(m, &connector->probed_modes, head) {
> +		if (mode->hdisplay == m->hdisplay &&
> +		    mode->vdisplay == m->vdisplay &&
> +		    drm_mode_vrefresh(mode) == drm_mode_vrefresh(m))
> +			return false; /* duplicated */
> +		if (mode->hdisplay <= m->hdisplay &&
> +		    mode->vdisplay <= m->vdisplay)
> +			ok = true;
> +	}
> +	return ok;
> +}
> +
>  static int
>  drm_dmt_modes_for_range(struct drm_connector *connector, struct edid *edid,
>  			struct detailed_timing *timing)
> @@ -1048,7 +1066,8 @@ drm_dmt_modes_for_range(struct drm_connector *connector, struct edid *edid,
>  	struct drm_device *dev = connector->dev;
>  
>  	for (i = 0; i < drm_num_dmt_modes; i++) {
> -		if (mode_in_range(drm_dmt_modes + i, edid, timing)) {
> +		if (mode_in_range(drm_dmt_modes + i, edid, timing) &&
> +		    valid_inferred_mode(connector, drm_dmt_modes + i)) {
>  			newmode = drm_mode_duplicate(dev, &drm_dmt_modes[i]);
>  			if (newmode) {
>  				drm_mode_probed_add(connector, newmode);
> @@ -1088,7 +1107,8 @@ drm_gtf_modes_for_range(struct drm_connector *connector, struct edid *edid,
>  			return modes;
>  
>  		fixup_mode_1366x768(newmode);
> -		if (!mode_in_range(newmode, edid, timing)) {
> +		if (!mode_in_range(newmode, edid, timing) ||
> +		    !valid_inferred_mode(connector, newmode)) {
>  			drm_mode_destroy(dev, newmode);
>  			continue;
>  		}
> @@ -1116,7 +1136,8 @@ drm_cvt_modes_for_range(struct drm_connector *connector, struct edid *edid,
>  			return modes;
>  
>  		fixup_mode_1366x768(newmode);
> -		if (!mode_in_range(newmode, edid, timing)) {
> +		if (!mode_in_range(newmode, edid, timing) ||
> +		    !valid_inferred_mode(connector, newmode)) {
>  			drm_mode_destroy(dev, newmode);
>  			continue;
>  		}

Hello all,

I had the exact same problem as Sven, bisected to cb21aafe121b1c3ad4c77cc5c22320163f16ba42.
Takashi's patch (supra) fixes the issue for me.

Regards,
Calvin Owens
