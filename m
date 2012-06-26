Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab2FZQCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:02:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab2FZQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:02:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] No sound on HP Pavilion dv6, STAC92xx
References: <87d34mtb3c.fsf@canonical.com> <s5hvcie5faz.wl%tiwai@suse.de>
	<s5hk3yu5ct9.wl%tiwai@suse.de> <s5hd34m5av0.wl%tiwai@suse.de>
Date: Tue, 26 Jun 2012 17:02:30 +0100
In-Reply-To: <s5hd34m5av0.wl%tiwai@suse.de> (Takashi Iwai's message of "Tue,
	26 Jun 2012 17:52:35 +0200")
Message-ID: <87hatyrrhl.fsf@canonical.com>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Takashi Iwai <tiwai@suse.de> writes:

> At Tue, 26 Jun 2012 17:10:26 +0200,
> Takashi Iwai wrote:
>> 
>> At Tue, 26 Jun 2012 16:16:36 +0200,
>> Takashi Iwai wrote:
>> > 
>> > At Tue, 26 Jun 2012 15:13:43 +0100,
>> > Luis Henriques wrote:
>> > > 
>> > > Hi,
>> > > 
>> > > After commit b0791dda813c179e539b0fc1ecd3f5f30f2571e2 ("ALSA: hda/idt
>> > > - Fix power-map for speaker-pins with some HP laptops") we have
>> > > several bug reports about not having sound on HP Pavilion laptops.
>> > > 
>> > > Here's a link to one of these bug reports:
>> > > 
>> > >  http://bugs.launchpad.net/bugs/1013183
>> > > 
>> > > After reverting the referred commit, everything seems to be working
>> > > fine again.
>> > > 
>> > > Any ideas/fixes?
>> > 
>> > Could you give alsa-info.sh output on both working and non-working
>> > kernels?
>> 
>> Also, does it really happen with the upstream kernels (vanilla 3.2.y
>> and Linus tree) without ubuntu changes?  If yes, I'd need alsa-info.sh
>> outputs on these, too.
>
> Never mind, I found the culprit.
> The fixed patch for 3.5 kernel is below.
>
> For 3.4 and older kernels, another patch is necessary.  Will put in
> another post.
>

Great, thanks a lot for your help.  I was trying to gather the data
from bug reporters, but I guess I can abort that.

I'll try to get someone testing the patch.

Cheers,
--
Luis

>
> Takashi
>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Fix power-map regression for HP dv6 & co
>
> The recent fix for power-map controls (commit b0791dda813) caused
> regressions on some other HP laptops.  They have fixed pins but these
> pins are exposed as jack-detectable.  Thus the driver tries to control
> the power-map dynamically per jack detection where it never gets on.
>
> This patch adds the check of connection and it assumes the no jack
> detection is available for fixed pins no matter what pin capability
> says.
>
> BugLink: http://bugs.launchpad.net/bugs/1013183
> Reported-by: Luis Henriques <luis.henriques@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_sigmatel.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
> index 7db8228..0767528 100644
> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -4367,7 +4367,7 @@ static int stac92xx_init(struct hda_codec *codec)
>  					 AC_PINCTL_IN_EN);
>  	for (i = 0; i < spec->num_pwrs; i++)  {
>  		hda_nid_t nid = spec->pwr_nids[i];
> -		int pinctl, def_conf;
> +		unsigned int pinctl, def_conf;
>  
>  		def_conf = snd_hda_codec_get_pincfg(codec, nid);
>  		def_conf = get_defcfg_connect(def_conf);
> @@ -4376,6 +4376,11 @@ static int stac92xx_init(struct hda_codec *codec)
>  			stac_toggle_power_map(codec, nid, 0);
>  			continue;
>  		}
> +		if (def_conf == AC_JACK_PORT_FIXED) {
> +			/* no need for jack detection for fixed pins */
> +			stac_toggle_power_map(codec, nid, 1);
> +			continue;
> +		}
>  		/* power on when no jack detection is available */
>  		/* or when the VREF is used for controlling LED */
>  		if (!spec->hp_detect ||
