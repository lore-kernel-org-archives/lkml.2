Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0IJQNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab0IJQNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:13:36 -0400
Date: Fri, 10 Sep 2010 12:13:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 6/6] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100910161319.GI4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-6-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284087065-32722-6-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:51:05AM +0800, Huang Ying wrote:
>  
> +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> +extern int nmi_watchdog_tick(struct pt_regs *regs);
> +#else
> +static inline int nmi_watchdog_tick(struct pt_regs *regs)
> +{
> +	return 0;
> +}
> +#endif
> +
>  extern atomic_t nmi_active;
>  extern unsigned int nmi_watchdog;
>  #define NMI_NONE	0

<snip>

> @@ -421,12 +429,8 @@ static notrace __kprobes void default_do
>  	}
>  	raw_spin_unlock(&nmi_reason_lock);
>  
> -#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> -	if (nmi_watchdog_tick(regs, reason))
> -		return;
> -	if (do_nmi_callback(regs, smp_processor_id()))
> +	if (nmi_watchdog_tick(regs))
>  		return;
> -#endif
>  
>  	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
>  	    == NOTIFY_STOP)

I wonder if these two chunks are going to confuse people when they read
the code.  The old nmi watchdog exists in the arch/x86 area but the new
nmi watchdog code is now in kernel/watchdog.c.

If someone sees nmi_watchdog_tick() here will they assume the nmi watchdog
code is still inside arch/x86?

I would suggest keep it wrapped with CONFIG_LOCKUP_DETECTOR to make it
obvious.  Thoughts?

Cheers,
Don
