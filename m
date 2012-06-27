Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2F0JJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:09:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] No sound on HP Pavilion dv6, STAC92xx
References: <87d34mtb3c.fsf@canonical.com> <s5hvcie5faz.wl%tiwai@suse.de>
	<s5hk3yu5ct9.wl%tiwai@suse.de> <s5hd34m5av0.wl%tiwai@suse.de>
	<s5hbok65arx.wl%tiwai@suse.de>
Date: Wed, 27 Jun 2012 10:09:43 +0100
In-Reply-To: <s5hbok65arx.wl%tiwai@suse.de> (Takashi Iwai's message of "Tue,
	26 Jun 2012 17:54:26 +0200")
Message-ID: <87zk7pyvc8.fsf@canonical.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Takashi Iwai <tiwai@suse.de> writes:

> Below is the patch for 3.4 and older.
>

Just to let you know that we are receiving positive feedback on this
patch from the bug reporters.

I believe you plan to Cc: this patch to -stable, right?  We had this
issue reported against 3.2.y.

Cheers,
--
Luis

> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Fix power-map regression for HP dv6 & co
>
> commit 6e1c39c6b00d9141a82c231ba7c5e5b1716974b2 upstream.
>
> The recent fix for power-map controls (commit b0791dda813) caused
> regressions on some other HP laptops.  They have fixed pins but these
> pins are exposed as jack-detectable.  Thus the driver tries to control
> the power-map dynamically per jack detection where it never gets on.
>
> This patch corrects the condition check for fixed pins so that the
> power-map is set always for these pins.
>
> NOTE: this is no simple backport from 3.5 kernel.  Since 3.5 kernel
> had significant code change in the relevant part, I had to fix this
> differently.
>
> BugLink: http://bugs.launchpad.net/bugs/1013183
> Reported-by: Luis Henriques <luis.henriques@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_sigmatel.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
> index 7b7a516..2b973f5 100644
> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -4457,7 +4457,7 @@ static int stac92xx_init(struct hda_codec *codec)
>  					 AC_PINCTL_IN_EN);
>  	for (i = 0; i < spec->num_pwrs; i++)  {
>  		hda_nid_t nid = spec->pwr_nids[i];
> -		int pinctl, def_conf;
> +		unsigned int pinctl, def_conf;
>  
>  		/* power on when no jack detection is available */
>  		/* or when the VREF is used for controlling LED */
> @@ -4484,7 +4484,7 @@ static int stac92xx_init(struct hda_codec *codec)
>  		def_conf = get_defcfg_connect(def_conf);
>  		/* skip any ports that don't have jacks since presence
>   		 * detection is useless */
> -		if (def_conf != AC_JACK_PORT_NONE &&
> +		if (def_conf != AC_JACK_PORT_COMPLEX ||
>  		    !is_jack_detectable(codec, nid)) {
>  			stac_toggle_power_map(codec, nid, 1);
>  			continue;
