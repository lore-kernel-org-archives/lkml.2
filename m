Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041Ab2CQWHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 18:07:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030235Ab2CQWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 18:06:58 -0400
Subject: Re: [PATCH] timer: optimize apply_slack()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1332019895-59698-1-git-send-email-nbd@openwrt.org>
References: <1332019895-59698-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Mar 2012 15:06:54 -0700
Message-ID: <1332022014.9397.2.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 22:31 +0100, Felix Fietkau wrote:
> __fls(mask) is equivalent to find_last_bit(&mask, BITS_PER_LONG), but cheaper.
> find_last_bit was showing up high on the list when I was profiling for stalls
> on icache misses on a system with very small cache size (MIPS).
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  kernel/timer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index a297ffc..659371e 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -809,7 +809,7 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
>  	if (mask == 0)
>  		return expires;
>  
> -	bit = find_last_bit(&mask, BITS_PER_LONG);
> +	bit = __fls(mask);
>  
>  	mask = (1 << bit) - 1;
>  

Not a comment on your patch, but this code seems not correct.

This probably should be :

	mask = (1UL << bit) - 1;


