Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0IISRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:17:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44981 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0IISRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:17:21 -0400
Subject: Re: [PATCH] ntp: Clamp PLL update interval
From: john stultz <johnstul@us.ibm.com>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
References: <1283870626-9472-1-git-send-email-mlichvar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 11:16:54 -0700
Message-ID: <1284056214.2762.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-07 at 16:43 +0200, Miroslav Lichvar wrote:
> Clamp update interval to reduce PLL gain with low sampling rate (e.g.
> intermittent network connection) to avoid instability.
> 
> The clamp roughly corresponds to the loop time constant, it's 8 * poll
> interval for SHIFT_PLL 2 and 32 * poll interval for SHIFT_PLL 4. This
> gives good results without affecting the gain in normal conditions where
> ntpd skips only up to seven consecutive samples.
> 
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>

Thanks Miroslav!

Acked-by: John Stultz <johnstul@us.ibm.com>


> ---
>  kernel/time/ntp.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index c631168..d232189 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -149,10 +149,18 @@ static void ntp_update_offset(long offset)
>  	time_reftime = get_seconds();
> 
>  	offset64    = offset;
> -	freq_adj    = (offset64 * secs) <<
> -			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
> +	freq_adj    = ntp_update_offset_fll(offset64, secs);
> 
> -	freq_adj    += ntp_update_offset_fll(offset64, secs);
> +	/*
> +	 * Clamp update interval to reduce PLL gain with low
> +	 * sampling rate (e.g. intermittent network connection)
> +	 * to avoid instability.
> +	 */
> +	if (unlikely(secs > 1 << (SHIFT_PLL + 1 + time_constant)))
> +		secs = 1 << (SHIFT_PLL + 1 + time_constant);
> +
> +	freq_adj    += (offset64 * secs) <<
> +			(NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant));
> 
>  	freq_adj    = min(freq_adj + time_freq, MAXFREQ_SCALED);
> 


