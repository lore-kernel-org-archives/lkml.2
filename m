Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2LXWba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 17:31:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2LXWb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 17:31:28 -0500
Date: Mon, 24 Dec 2012 23:31:05 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH 18/25] TMIO MMC: don't use [delayed_]work_pending()
In-Reply-To: <1356141435-17340-19-git-send-email-tj@kernel.org>
Message-ID: <Pine.LNX.4.64.1212242314420.31888@axis700.grange>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-19-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:uLY3ggbanh7xOlcOZPJn/fAlB2wJuYOFUUmL+X5W8jg
 EYmbY3ZxJexnTsm8IMbM3N0URCss1AgUDhH7DFh39JNmaTbnqH
 MRcWKj6XqutJsWdIo0/xd8wPZmq3D6fPUT2K1S/enoFjzP0uWR
 JMzHE/TYsbtD79kzi8W/qgj6V/UTTizggW30r+NpVVcZdPG4Cz
 hTXWcE1fC2DuiOth2ckyg8fCJNWjXT/pTLroFcAEQFTUrIq2sH
 PC+eHO59od0/qBGpparjp5XkA6Zycg9TDSR7pKt3tJtMLokOqz
 CgcMMS3azKoVyIIK//UaVrfmmGc11qnXiU/+xrrI005K3JxePr
 X8ok/lGQzTxHe/UJyTkY9+cBIwdW9cMhYm+8kxMG75VuigrnJk
 Vm5Ga0SGHuQyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On Fri, 21 Dec 2012, Tejun Heo wrote:

> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from tmio mmc.  Only compile tested.

Thanks for the patch. It looks good to me. What happens below is upon mmc 
card detection IRQs, of which there are typically several due to pin 
debouncing, a delayed work is scheduled to verify a possibly new card 
state (plugged in or removed). So, the code below checks, that after the 
first of those interrupts the work is already scheduled and doesn't 
schedule it again. IIUC, this is indeed unneeded, since 
queue_delayed_work_on() only has any effect if the work isn't queued yet. 
Ah, there's a nitpick - you can remove one pair of parenthesis;-) 
Otherwise, I guess, this is an

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

and Chris can take it (preferably, after the correction) via his queue. If 
you give me a bit more time I can also test this, but it really looks 
pretty obvious. Maybe Chris will prefer you to take this via your queue - 
that's up to you two to decide.

Thanks
Guennadi

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: linux-mmc@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  drivers/mmc/host/tmio_mmc_pio.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
> index 50bf495..f4f18b3 100644
> --- a/drivers/mmc/host/tmio_mmc_pio.c
> +++ b/drivers/mmc/host/tmio_mmc_pio.c
> @@ -573,8 +573,7 @@ static bool __tmio_mmc_card_detect_irq(struct tmio_mmc_host *host,
>  		tmio_mmc_ack_mmc_irqs(host, TMIO_STAT_CARD_INSERT |
>  			TMIO_STAT_CARD_REMOVE);
>  		if ((((ireg & TMIO_STAT_CARD_REMOVE) && mmc->card) ||
> -		     ((ireg & TMIO_STAT_CARD_INSERT) && !mmc->card)) &&
> -		    !work_pending(&mmc->detect.work))
> +		     ((ireg & TMIO_STAT_CARD_INSERT) && !mmc->card)))
>  			mmc_detect_change(host->mmc, msecs_to_jiffies(100));
>  		return true;
>  	}
> -- 
> 1.8.0.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
