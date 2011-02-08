Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1BHNfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:35:10 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:64773 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab1BHNfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:35:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M0RybAiL37VX8nN+Y2lFu/K5yDFghGrJfncjbG0l+iy91wY22aNjUSnD6K9g1HpUxM
         Xl0YbQ3uB5DOHOC8uewIWgivumVmbrRu9mNZ6NT6fg12UecARLYOSC+KUOwUZXAtvhTj
         uEL5R4JDDTJ+u16V3Fx8jk/EQus73wYarW304=
Date: Tue, 8 Feb 2011 21:34:57 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, tglx <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep: possible reason: unannotated irqs-off. (was: Re:
 Linux 2.6.38-rc4)
Message-ID: <20110208133457.GA5813@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <20110208101730.GB7020@liondog.tnic>
 <1297161712.13327.100.camel@laptop>
 <20110208121108.GA4824@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110208121108.GA4824@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 08:11:08PM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH 1/2] softirq: introduce loacal_bh_enable_force_wake()
> 
> If there is pending softirq, don't handle it in the caller's
> context, invoke ksoftirqd directly instead.
> 
> del_timer_sync() will be the first caller.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/bottom_half.h |    1 +
>  kernel/softirq.c            |   21 +++++++++++++++------
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
> index 27b1bcf..665d697 100644
> --- a/include/linux/bottom_half.h
> +++ b/include/linux/bottom_half.h
> @@ -5,5 +5,6 @@ extern void local_bh_disable(void);
>  extern void _local_bh_enable(void);
>  extern void local_bh_enable(void);
>  extern void local_bh_enable_ip(unsigned long ip);
> +extern void local_bh_enable_force_wake(void);
>  
>  #endif /* _LINUX_BH_H */
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 68eb5ef..3c05dfa 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -154,9 +154,9 @@ void _local_bh_enable(void)
>  
>  EXPORT_SYMBOL(_local_bh_enable);
>  
> -static inline void _local_bh_enable_ip(unsigned long ip)
> +static inline void _local_bh_enable_ip(unsigned long ip, bool force_wake)
>  {
> -	WARN_ON_ONCE(in_irq() || irqs_disabled());
> +	WARN_ON_ONCE(in_irq() || (!force_wake && irqs_disabled()));

Only suppressing the warning is not enough here :(

>  #ifdef CONFIG_TRACE_IRQFLAGS
>  	local_irq_disable();


The semantic "called with irqs_disabled" is showed on several place
of _local_bh_enable_ip().

Need more thinking about it...
