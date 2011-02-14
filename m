Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1BNOvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:51:46 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33343 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab1BNOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DlI44BEQPCWO43syo5mLQ5i7hVhSn1ctBMjV/a1eosZzBiYIa9s00M7ZU3kwPVrU3z
         TVXUKydW2iKuQ0nKfK3/z8Uv7s1/SFMFkENqlyk3u5FF8SeN5CETs5nsW0PLP2Q722Rf
         1c27Ky2OyK8SDUgWzRNDwfv2u0LMZMV4A/89o=
Date: Mon, 14 Feb 2011 22:51:25 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
Message-ID: <20110214145125.GA2937@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110208101730.GB7020@liondog.tnic>
 <1297161712.13327.100.camel@laptop>
 <20110208121108.GA4824@zhy>
 <20110208133457.GA5813@zhy>
 <1297172906.13327.104.camel@laptop>
 <1297174680.13327.107.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1297174680.13327.107.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 03:18:00PM +0100, Peter Zijlstra wrote:
> Subject: lockdep, timer: Revert the del_timer_sync() annotation
> 
> Both attempts at trying to allow softirq usage failed, revert for this
> release and try again later.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/timer.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 343ff27..c848cd8 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -959,7 +959,7 @@ EXPORT_SYMBOL(try_to_del_timer_sync);
>   *
>   * Synchronization rules: Callers must prevent restarting of the timer,
>   * otherwise this function is meaningless. It must not be called from
> - * hardirq contexts. The caller must not hold locks which would prevent
> + * interrupt contexts. The caller must not hold locks which would prevent

I think we don't need to revert this comment.

>   * completion of the timer's handler. The timer's handler must not call
>   * add_timer_on(). Upon exit the timer is not queued and the handler is
>   * not running on any CPU.
> @@ -971,12 +971,10 @@ int del_timer_sync(struct timer_list *timer)
>  #ifdef CONFIG_LOCKDEP
>  	unsigned long flags;
>  
> -	raw_local_irq_save(flags);
> -	local_bh_disable();
> +	local_irq_save(flags);

Going back to local_irq_save()/local_irq_restore() doesn't prevent
it from using in softirq context.

Thanks,
Yong
