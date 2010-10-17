Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0JQJGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:06:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59302 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab0JQJGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nA/0HI2/GU/3ry9RV/EfntsEUfJUvugZwKuFBEg33PLfUnIqT41hwlCtlUrtQxojjY
         s06GnZMFeC/+ZHDGTc2VheXbxcJQPWD+6qiMIE+jOCHkUuwymV/7S6moueE/J7dBKdT7
         3GrUg/hcYkOcMfpcY493mDPznu9hQkFzRuqVw=
Date: Sun, 17 Oct 2010 17:05:45 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 8/8] Call tick_check_idle before __irq_enter
Message-ID: <20101017090545.GA3468@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
 <1286237003-12406-9-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1286237003-12406-9-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 05:03:23PM -0700, Venkatesh Pallipadi wrote:
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 267f7b7..6bb7e19 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -296,10 +296,16 @@ void irq_enter(void)
>  
>  	rcu_irq_enter();
>  	if (idle_cpu(cpu) && !in_interrupt()) {
> -		__irq_enter();
> +		/*
> +		 * Prevent raise_softirq from needlessly waking up ksoftirqd
> +		 * here, as softirq will be serviced on return from interrupt.
> +		 */
> +		local_bh_disable();
>  		tick_check_idle(cpu);
> -	} else
> -		__irq_enter();
> +		local_bh_enable();

		_local_bh_enable()

local_bh_enable() could invoke do_softirq().

> +	}
> +
> +	__irq_enter();
>  }
>  
>  #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
