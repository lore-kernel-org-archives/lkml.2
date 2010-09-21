Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0IUVtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0IUVtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:49:09 -0400
Date: Tue, 21 Sep 2010 17:48:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
Message-ID: <20100921214847.GF26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:51:00AM +0800, Huang Ying wrote:
> Replace the NMI related magic numbers with symbol constants.

Hi Huang,

Sorry for disappearing for a week..

Ingo asked me to shepherd these patches.  I finally got around to do some
testing on them.  I'll do some more tomorrow.

Anyway, I don't have a problem with patches 1-3 and 6 (I guess the rename
and rename again doesn't really bother me and it kinda makes some logical
sense).

I am ok with most of patch 4 but I was wondering if you could split out
the part of using other cpus to access the reason register.  To me it seem
like the nmi handler rewrite and allowing !bsp cpus to access the reason
registers were two different ideas.  For bisecting reasons it would be
easier to seperate them in case we have problems with lost NMIs later.  It
would be easier to determine if the lost NMIs were from the rewrite or the
migration of the reason register to other cpus.

I still have a stupid hangup about the raw_spin_lock but if no one else
has any issues, then I'll just shutup about it. :-)

As for patch 5, I am worried about breaking existing user systems.  I went
through the fedora buglist and noticed a couple dozen bugzillas
complaining about unknown nmis.  The people complaining still seemed to
have functioning systems (at least they seemed to think so).  Adding in
the panic gets me worried that we might break a user's setup and cause
them regressions.

Though I understand what Andi is saying an unknown NMI is bad and the
system should panic, but on the other hand, unless we have a way of
analyzing it and give a user an option to either fix it or override it,
just panicing may not be the best way right now IMO.

I guess adding either another knob to override the hardware error option
or tying it in with the panic_on_unknown_error option might make me more
comfortable.  That way enterprise customers can always just enable it by
default and desktop users (for now) could have it off.

Thoughts?

Cheers,
Don
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/include/asm/mach_traps.h |   12 +++++++++++-
>  arch/x86/kernel/traps.c           |   18 +++++++++---------
>  2 files changed, 20 insertions(+), 10 deletions(-)
> 
> --- a/arch/x86/include/asm/mach_traps.h
> +++ b/arch/x86/include/asm/mach_traps.h
> @@ -7,9 +7,19 @@
>  
>  #include <asm/mc146818rtc.h>
>  
> +#define NMI_REASON_PORT		0x61
> +
> +#define NMI_REASON_MEMPAR	0x80
> +#define NMI_REASON_IOCHK	0x40
> +#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
> +
> +#define NMI_REASON_CLEAR_MEMPAR	0x04
> +#define NMI_REASON_CLEAR_IOCHK	0x08
> +#define NMI_REASON_CLEAR_MASK	0x0f
> +
>  static inline unsigned char get_nmi_reason(void)
>  {
> -	return inb(0x61);
> +	return inb(NMI_REASON_PORT);
>  }
>  
>  static inline void reassert_nmi(void)
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -323,8 +323,8 @@ mem_parity_error(unsigned char reason, s
>  	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
>  
>  	/* Clear and disable the memory parity error line. */
> -	reason = (reason & 0xf) | 4;
> -	outb(reason, 0x61);
> +	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_MEMPAR;
> +	outb(reason, NMI_REASON_PORT);
>  }
>  
>  static notrace __kprobes void
> @@ -339,15 +339,15 @@ io_check_error(unsigned char reason, str
>  		panic("NMI IOCK error: Not continuing");
>  
>  	/* Re-enable the IOCK line, wait for a few seconds */
> -	reason = (reason & 0xf) | 8;
> -	outb(reason, 0x61);
> +	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
> +	outb(reason, NMI_REASON_PORT);
>  
>  	i = 2000;
>  	while (--i)
>  		udelay(1000);
>  
> -	reason &= ~8;
> -	outb(reason, 0x61);
> +	reason &= ~NMI_REASON_CLEAR_IOCHK;
> +	outb(reason, NMI_REASON_PORT);
>  }
>  
>  static notrace __kprobes void
> @@ -388,7 +388,7 @@ static notrace __kprobes void default_do
>  	if (!cpu)
>  		reason = get_nmi_reason();
>  
> -	if (!(reason & 0xc0)) {
> +	if (!(reason & NMI_REASON_MASK)) {
>  		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
>  								== NOTIFY_STOP)
>  			return;
> @@ -418,9 +418,9 @@ static notrace __kprobes void default_do
>  		return;
>  
>  	/* AK: following checks seem to be broken on modern chipsets. FIXME */
> -	if (reason & 0x80)
> +	if (reason & NMI_REASON_MEMPAR)
>  		mem_parity_error(reason, regs);
> -	if (reason & 0x40)
> +	if (reason & NMI_REASON_IOCHK)
>  		io_check_error(reason, regs);
>  #ifdef CONFIG_X86_32
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
