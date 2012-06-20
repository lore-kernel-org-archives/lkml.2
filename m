Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2FTDgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:36:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53361 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab2FTDgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:36:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4FE14505.9090307@jp.fujitsu.com>
Date: Wed, 20 Jun 2012 12:35:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 3/5] x86: mce: Split timer init
References: <20120606214941.104735929@linutronix.de> <20120606215116.614980367@linutronix.de>
In-Reply-To: <20120606215116.614980367@linutronix.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/07 6:53), Thomas Gleixner wrote:
> --- tip.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ tip/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1554,23 +1554,28 @@ static void __mcheck_cpu_init_vendor(str
>  	}
>  }
>  
> -static void __mcheck_cpu_init_timer(void)
> +static void mce_start_timer(unsigned int cpu, struct timer_list *t)
>  {
> -	struct timer_list *t = &__get_cpu_var(mce_timer);
>  	unsigned long iv = check_interval * HZ;
>  
> -	setup_timer(t, mce_timer_fn, smp_processor_id());
> +	__this_cpu_write(mce_next_interval, iv);
>  
> -	if (mce_ignore_ce)
> +	if (mce_ignore_ce || !iv)
>  		return;
>  
> -	__this_cpu_write(mce_next_interval, iv);
> -	if (!iv)
> -		return;
>  	t->expires = round_jiffies(jiffies + iv);
>  	add_timer_on(t, smp_processor_id());

add_timer_on(t, cpu) ?

If so, using __this_cpu_write() here is wrong too.

>  }
>  

Thanks,
H.Seto

