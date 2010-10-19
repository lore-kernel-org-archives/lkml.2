Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0JSPJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:09:05 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:35730
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250Ab0JSPJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:09:04 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0LAJLZN-02-AH4-02
X-M-MSG: 
Date: Tue, 19 Oct 2010 17:07:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>
Subject: Re: [PATCH 4/5] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
Message-ID: <20101019150701.GR5969@erda.amd.com>
References: <1287195738-3136-1-git-send-email-dzickus@redhat.com>
 <1287195738-3136-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1287195738-3136-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.10 22:22:17, Don Zickus wrote:
> From: Huang Ying <ying.huang@intel.com>
> 
> In original NMI handler, NMI reason io port (0x61) is only processed
> on BSP. This makes it impossible to hot-remove BSP. To solve the
> issue, a raw spinlock is used to make the port can be processed on any
> CPU.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/traps.c |   45 +++++++++++++++++++++++++--------------------
>  1 files changed, 25 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index d8acab3..accb2f4 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -83,6 +83,12 @@ EXPORT_SYMBOL_GPL(used_vectors);
>  
>  static int ignore_nmis;
>  
> +/*
> + * Prevent NMI reason port (0x61) being accessed simultaneously, can
> + * only be used in NMI handler.
> + */
> +static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
> +
>  static inline void conditional_sti(struct pt_regs *regs)
>  {
>  	if (regs->flags & X86_EFLAGS_IF)
> @@ -383,7 +389,6 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
> -	int cpu;
>  
>  	/*
>  	 * CPU-specific NMI must be processed before non-CPU-specific
> @@ -400,28 +405,28 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  		return;
>  
>  	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> -	cpu = smp_processor_id();
> -	/* Only the BSP gets external NMIs from the system. */
> -	if (!cpu) {
> -		reason = get_nmi_reason();
> -		if (reason & NMI_REASON_MASK) {
> -			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> -			    == NOTIFY_STOP)
> -				return;
> -			if (reason & NMI_REASON_SERR)
> -				pci_serr_error(reason, regs);
> -			else if (reason & NMI_REASON_IOCHK)
> -				io_check_error(reason, regs);
> +	raw_spin_lock(&nmi_reason_lock);

What about using raw_spin_trylock() instead? We don't have to wait
here since we are already processing it by another cpu.

-Robert

> +	reason = get_nmi_reason();
> +	if (reason & NMI_REASON_MASK) {
> +		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
> +		    == NOTIFY_STOP)
> +			goto unlock_return;
> +		if (reason & NMI_REASON_SERR)
> +			pci_serr_error(reason, regs);
> +		else if (reason & NMI_REASON_IOCHK)
> +			io_check_error(reason, regs);
>  #ifdef CONFIG_X86_32
> -			/*
> -			 * Reassert NMI in case it became active
> -			 * meanwhile as it's edge-triggered:
> -			 */
> -			reassert_nmi();
> +		/*
> +		 * Reassert NMI in case it became active
> +		 * meanwhile as it's edge-triggered:
> +		 */
> +		reassert_nmi();
>  #endif
> -			return;
> -		}
> +unlock_return:
> +		raw_spin_unlock(&nmi_reason_lock);
> +		return;
>  	}
> +	raw_spin_unlock(&nmi_reason_lock);
>  
>  	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>  		return;
> -- 
> 1.7.2.3
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

