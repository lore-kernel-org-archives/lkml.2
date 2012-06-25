Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2FYRkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 13:40:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37130 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753070Ab2FYRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 13:40:54 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18DlD9n05UDaFKNftPATp+85Yf1yXqPRVWFrDpNnw
	+Bs3G4pCD80htz
From: Sven Joachim <svenjoac@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: dri-devel@lists.freedesktop.org, Adam Jackson <ajax@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de>
Date: Mon, 25 Jun 2012 19:40:48 +0200
In-Reply-To: <s5ha9zr8k2f.wl%tiwai@suse.de> (Takashi Iwai's message of "Mon,
	25 Jun 2012 17:53:12 +0200")
Message-ID: <87obo7jnmn.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.06.2012 um 17:53 schrieb Takashi Iwai:

> Looking at the EDID data, the problem is likely that your monitor
> doesn't give the proper preferred mode.
> What does xrandr output show?

,----
| Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 8192 x 8192
| DVI-I-1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
|    1280x1024      75.0*    60.0  
|    1024x768       75.1     75.0     70.1     60.0  
|    832x624        74.6  
|    800x600        72.2     75.0     60.3     56.2  
|    640x480        72.8     75.0     66.7     60.0     59.9  
| VGA-1 disconnected (normal left inverted right x axis y axis)
`----

I should note that the monitor is actually connected via VGA, not DVI.
This seems to be similar to https://bugs.freedesktop.org/50830, but
since it never caused any real problems for me, I didn't bother.

> And, does the patch below help?

Somewhat: at least I get 1280x1024 again, but at 60 rather than 75 Hz.
The xrandr command shows various bogus modes.

,----
| Screen 0: minimum 320 x 200, current 1280 x 1024, maximum 8192 x 8192
| DVI-I-1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
|    1280x1024      60.0*+   75.0  
|    1680x945       60.0  
|    1400x1050      60.0  
|    1600x900       60.0  
|    1440x900       75.0     59.9  
|    1280x960       60.0  
|    1366x768       60.0  
|    1360x768       60.0  
|    1280x800       74.9     59.8  
|    1152x864       75.0  
|    1280x768       74.9     59.9  
|    1024x768       75.1     75.0     70.1     60.0  
|    1024x576       60.0  
|    832x624        74.6  
|    800x600        72.2     75.0     60.3     56.2  
|    848x480        60.0  
|    640x480        75.0     72.8     72.8     66.7     60.0     59.9  
| VGA-1 disconnected (normal left inverted right x axis y axis)
`----

Cheers,
       Sven


> ---
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 5873e48..dab8580 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -116,6 +116,7 @@ static struct edid_quirk {
>  
>  	/* Proview AY765C */
>  	{ "PTS", 765, EDID_QUIRK_FIRST_DETAILED_PREFERRED },
> +	{ "PTS", 793, EDID_QUIRK_FIRST_DETAILED_PREFERRED },
>  
>  	/* Samsung SyncMaster 205BW.  Note: irony */
>  	{ "SAM", 541, EDID_QUIRK_DETAILED_SYNC_PP },
> @@ -1404,7 +1405,9 @@ do_detailed_mode(struct detailed_timing *timing, void *c)
>  		if (!newmode)
>  			return;
>  
> -		if (closure->preferred)
> +		if (closure->preferred ||
> +		    ((closure->quirks & EDID_QUIRK_FIRST_DETAILED_PREFERRED) &&
> +		     !closure->modes))
>  			newmode->type |= DRM_MODE_TYPE_PREFERRED;
>  
>  		drm_mode_probed_add(closure->connector, newmode);
