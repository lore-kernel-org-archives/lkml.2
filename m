Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2JRWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:03:34 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:41293 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755239Ab2JRWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:03:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH 5/5] snd-ice1712: Fix resume on ice1724
Date: Fri, 19 Oct 2012 00:02:44 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
References: <1350241763-7248-1-git-send-email-linux@rainbow-software.org> <1350241763-7248-6-git-send-email-linux@rainbow-software.org> <s5hhapt7fh8.wl%tiwai@suse.de>
In-Reply-To: <s5hhapt7fh8.wl%tiwai@suse.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210190002.44819.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012 08:57:39 Takashi Iwai wrote:
> At Sun, 14 Oct 2012 21:09:23 +0200,
>
> Ondrej Zary wrote:
> > set_pro_rate() is called from hw_params() but not from prepare(),
> > breaking running PCM on suspend/resume. Call it from prepare() if PCM was
> > suspended to fix the problem.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> This should be fixed in the resume callback.  Could you check the
> patch below instead?

Now I'm confused. This patch does not work with mplayer+dmix. And my patch 
doesn't either...
When mplayer is set to s32le (without dmix), it works fine without this or my 
patch. Also aplay seems to work without these patches.
I bet that when I tested my patch before, it fixed some real problem. But I'm 
now unable to reproduce that...


> thanks,
>
> Takashi
>
> ---
> diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
> index 161c8f6..5cc3fa5 100644
> --- a/sound/pci/ice1712/ice1724.c
> +++ b/sound/pci/ice1712/ice1724.c
> @@ -2867,7 +2867,12 @@ static int snd_vt1724_resume(struct device *dev)
>  		ice->set_spdif_clock(ice, 0);
>  	} else {
>  		/* internal on-card clock */
> -		snd_vt1724_set_pro_rate(ice, ice->pro_rate_default, 1);
> +		int rate;
> +		if (ice->cur_rate)
> +			rate = ice->cur_rate;
> +		else
> +			rate = ice->pro_rate_default;
> +		snd_vt1724_set_pro_rate(ice, rate, 1);
>  	}
>
>  	update_spdif_bits(ice, ice->pm_saved_spdif_ctrl);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ondrej Zary
