Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab2J3Tet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:34:49 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:60722 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab2J3Ter (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:34:47 -0400
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH 5/5] snd-ice1712: Fix resume on ice1724
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Tue, 30 Oct 2012 20:34:00 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210302034.00890.linux@rainbow-software.org>
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

I've now verified that this patch fixes a real problem. When "multi track rate 
locking" is disabled and some sound is played at non-default (non-48kHz) 
frequency during suspend, the frequency is wrong (48kHz) after resume. This 
patch fixes that.

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
