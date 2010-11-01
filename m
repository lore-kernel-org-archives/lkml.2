Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0KAPvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:51:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64918 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab0KAPvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x4LoTWSuNniz9Qpi9Ucnd8lPDzV50atL2e+rRNsUci5vf8QI8q4NrXMtL2zU15zKvz
         BDTFLx6NkIgK5EVvnn/kMEjXQjq6R9cCdBzb2PqybEDquUjFZUD2Xc3D8/SXhH39oA2Z
         lxzyV9IpL6IicGkuhK/EPSXlVneJwtTlAt+zQ=
Date: Mon, 1 Nov 2010 18:51:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible
	arch_trigger_all_cpu_backtrace_handler
Message-ID: <20101101155110.GC5985@lenovo>
References: <4CCEB51C.7010901@web.de> <20101101154536.GT4823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101154536.GT4823@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:45:36AM -0400, Don Zickus wrote:
...
> Heh.  Yeah when I migrated the code, I completely forgot the notifier
> chain could be called from a preemptible context (ie not NMI).
> 
> This patch should fix it and I think it is the correct fix.  Let me know
> how it works out.
> 
> Cheers,
> Don
> 
> diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
> index c7c9ae4..1bdd0b5 100644
> --- a/arch/x86/kernel/apic/hw_nmi.c
> +++ b/arch/x86/kernel/apic/hw_nmi.c
> @@ -63,7 +63,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>  {
>  	struct die_args *args = __args;
>  	struct pt_regs *regs;
> -	int cpu = smp_processor_id();
> +	int cpu;
>  
>  	switch (cmd) {
>  	case DIE_NMI:
> @@ -74,6 +74,7 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
>  	}
>  
>  	regs = args->regs;
> +	cpu = smp_processor_id();
>  
>  	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
>  		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
> 

 yup, this will do the trick for a while. In general I believe we might have
kind of NMI exclusive chain so we wouldn't need the 'case:'s.

  Cyrill
