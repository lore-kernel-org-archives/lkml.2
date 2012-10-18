Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2JRSvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:51:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2JRSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:51:03 -0400
Date: Thu, 18 Oct 2012 15:50:56 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 108/147] ALSA: hda - Fix internal mic for Lenovo Ideapad U300s
Message-ID: <20121018185055.GC3025@herton-Z68MA-D2H-B3>
References: <20121014143533.742627615@decadent.org.uk>
 <20121014143548.361462458@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014143548.361462458@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 03:37:21PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: David Henningsson <david.henningsson@canonical.com>
> 
> commit 18dcd3044e4c4b3ab6341c98e8d0e81e0d58d5e3 upstream.
> 
> The internal mic input is phase inverted on one channel.
> To avoid people in userspace summing the channels together
> and get zero result, use a separate mixer control for the
> inverted channel.
> 
> BugLink: https://bugs.launchpad.net/bugs/903853
> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - Change both invocations of apply_pin_fixup()]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I noted today that a follow up fix for this is needed to avoid an oops
in apply_fixup, please consider adding to the next 3.2 stable this:

commit 83b0c6ba999643ee8ad6329f26e1cdc870e1a920
ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Lenovo Ideapad U300s"

[...]
> +static void apply_fixup(struct hda_codec *codec,
>  			    const struct snd_pci_quirk *quirk,
>  			    const struct cxt_pincfg **table)
>  {
> +	struct conexant_spec *spec = codec->spec;
> +
>  	quirk = snd_pci_quirk_lookup(codec->bus->pci, quirk);
> -	if (quirk) {
> +	if (quirk && table[quirk->value]) {
>  		snd_printdd(KERN_INFO "hda_codec: applying pincfg for %s\n",
>  			    quirk->name);
>  		apply_pincfg(codec, table[quirk->value]);
>  	}
> +	if (quirk->value == CXT_FIXUP_STEREO_DMIC) {
> +		snd_printdd(KERN_INFO "hda_codec: applying internal mic workaround for %s\n",
> +			    quirk->name);
> +		spec->fixup_stereo_dmic = 1;
> +	}
>  }
[...]

-- 
[]'s
Herton
