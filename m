Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab1CQXNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:13:13 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:60936 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1CQXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:13:11 -0400
Message-ID: <4D82957A.1080200@t-online.de>
Date: Fri, 18 Mar 2011 00:12:58 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        =?UTF-8?B?RGF2aWQgTcO8bGxl?= =?UTF-8?B?cg==?= 
	<d.mueller@elsoft.ch>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
References: <4D81D6F9.3040304@t-online.de>	<AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com> <s5haagtvfc2.wl%tiwai@suse.de>
In-Reply-To: <s5haagtvfc2.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ID: JlOwUeZrQh8Qjb9XRNpweeXCU4Gb2Kx33lvguQXPBzR2Z9IHhjjAcRMxotJUyPLQ1C
X-TOI-MSGID: c1ff8a9e-c80a-4ac8-9cc0-082d2c955f8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot. That patch below does indeed
solve the irq lock inversion problem.

cu,
 Knut

>
> The trigger callback should be called always in irq-disabled context,
> so this should be OK.  But loopback_pos_update() is called in the
> timer callback, and this can be the issue.
>
> Knut, how about the patch below?
>
>
> thanks,
>
> Takashi
>
> ---
> diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
> index 12b44b0..a0da775 100644
> --- a/sound/drivers/aloop.c
> +++ b/sound/drivers/aloop.c
> @@ -482,8 +482,9 @@ static unsigned int loopback_pos_update(struct loopback_cable *cable)
>  			cable->streams[SNDRV_PCM_STREAM_CAPTURE];
>  	unsigned long delta_play = 0, delta_capt = 0;
>  	unsigned int running;
> +	unsigned long flags;
>  
> -	spin_lock(&cable->lock);	
> +	spin_lock_irqsave(&cable->lock, flags);
>  	running = cable->running ^ cable->pause;
>  	if (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) {
>  		delta_play = jiffies - dpcm_play->last_jiffies;
> @@ -495,10 +496,8 @@ static unsigned int loopback_pos_update(struct loopback_cable *cable)
>  		dpcm_capt->last_jiffies += delta_capt;
>  	}
>  
> -	if (delta_play == 0 && delta_capt == 0) {
> -		spin_unlock(&cable->lock);
> -		return running;
> -	}
> +	if (delta_play == 0 && delta_capt == 0)
> +		goto unlock;
>  		
>  	if (delta_play > delta_capt) {
>  		loopback_bytepos_update(dpcm_play, delta_play - delta_capt,
> @@ -510,14 +509,14 @@ static unsigned int loopback_pos_update(struct loopback_cable *cable)
>  		delta_capt = delta_play;
>  	}
>  
> -	if (delta_play == 0 && delta_capt == 0) {
> -		spin_unlock(&cable->lock);
> -		return running;
> -	}
> +	if (delta_play == 0 && delta_capt == 0)
> +		goto unlock;
> +
>  	/* note delta_capt == delta_play at this moment */
>  	loopback_bytepos_update(dpcm_capt, delta_capt, BYTEPOS_UPDATE_COPY);
>  	loopback_bytepos_update(dpcm_play, delta_play, BYTEPOS_UPDATE_POSONLY);
> -	spin_unlock(&cable->lock);
> + unlock:
> +	spin_unlock_irqrestore(&cable->lock, flags);
>  	return running;
>  }
>  
>

