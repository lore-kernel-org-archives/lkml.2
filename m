Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1BWCkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:40:00 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41101 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1BWCj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:39:59 -0500
Date: Wed, 23 Feb 2011 02:39:58 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Don Zickus <dzickus@redhat.com>
cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        gorcunov@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
In-Reply-To: <1294348732-15030-6-git-send-email-dzickus@redhat.com>
Message-ID: <alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com> <1294348732-15030-6-git-send-email-dzickus@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Don Zickus wrote:

> In original NMI handler, NMI reason io port (0x61) is only processed
> on BSP.  This makes it impossible to hot-remove BSP.  To solve the
> issue, a raw spinlock is used to allow the port to be processed on any
> CPU.
> 
> Originally-by: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/kernel/traps.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 23f6ac0..613b3d2 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -402,13 +406,12 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>  		return;
>  
> -	cpu = smp_processor_id();
> -
> -	/* Only the BSP gets external NMIs from the system. */
> -	if (!cpu)
> -		reason = get_nmi_reason();
> +	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
> +	raw_spin_lock(&nmi_reason_lock);
> +	reason = get_nmi_reason();
>  
>  	if (!(reason & NMI_REASON_MASK)) {
> +		raw_spin_unlock(&nmi_reason_lock);
>  		unknown_nmi_error(reason, regs);
>  
>  		return;

 [Catching up with old e-mail...]

 In line with the comment above that you're removing -- have you (or 
anyone else) adjusted code elsewhere so that external NMIs are actually 
delivered to processors other than the BSP?  I can't see such code in this 
series nor an explanation as to why it wouldn't be needed.

 For the record -- the piece of code above reflects our setup where the 
LINT1 input is enabled and configured for the NMI delivery mode on the BSP 
only and all the other processors have this line disabled in their local 
APIC units.  If system NMIs are to be handled after the removal of the 
BSP, then another processor has to be selected and configured for NMI 
reception.  Alternatively, all local units could have their LINT1 input 
enabled and arbitrate handling, although it would be quite disruptive as 
all the processors would take the interrupt if it happened.  OTOH it would 
be more fault-tolerant in the case of a CPU failure.  On a typical x86 box 
the system NMI cannot be routed to an I/O APIC input.

  Maciej
