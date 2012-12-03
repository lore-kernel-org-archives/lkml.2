Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2LCNrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:47:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab2LCNrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:47:01 -0500
Date: Mon, 3 Dec 2012 15:46:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/2] x86/kexec: VMCLEAR VMCSs loaded on all cpus if
 necessary
Message-ID: <20121203134641.GA19514@redhat.com>
References: <50B43299.9030409@cn.fujitsu.com>
 <50B432CA.70804@cn.fujitsu.com>
 <20121127121847.GU25516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127121847.GU25516@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:18:47PM +0200, Gleb Natapov wrote:
> Eric, can you ACK it?
> 
Eric, ping.

> On Tue, Nov 27, 2012 at 11:26:02AM +0800, Zhang Yanfei wrote:
> > This patch provides a way to VMCLEAR VMCSs related to guests
> > on all cpus before executing the VMXOFF when doing kdump. This
> > is used to ensure the VMCSs in the vmcore updated and
> > non-corrupted.
> > 
> > Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > ---
> >  arch/x86/include/asm/kexec.h |    2 ++
> >  arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
> >  2 files changed, 27 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> > index 317ff17..28feeba 100644
> > --- a/arch/x86/include/asm/kexec.h
> > +++ b/arch/x86/include/asm/kexec.h
> > @@ -163,6 +163,8 @@ struct kimage_arch {
> >  };
> >  #endif
> >  
> > +extern void (*crash_vmclear_loaded_vmcss)(void);
> > +
> >  #endif /* __ASSEMBLY__ */
> >  
> >  #endif /* _ASM_X86_KEXEC_H */
> > diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> > index 13ad899..4a2a12f 100644
> > --- a/arch/x86/kernel/crash.c
> > +++ b/arch/x86/kernel/crash.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/elf.h>
> >  #include <linux/elfcore.h>
> > +#include <linux/module.h>
> >  
> >  #include <asm/processor.h>
> >  #include <asm/hardirq.h>
> > @@ -29,6 +30,20 @@
> >  #include <asm/virtext.h>
> >  
> >  int in_crash_kexec;
> > + 
> > +/*
> > + * This is used to VMCLEAR all VMCSs loaded on the
> > + * processor. And when loading kvm_intel module, the
> > + * callback function pointer will be assigned.
> > + */
> > +void (*crash_vmclear_loaded_vmcss)(void) = NULL;
> > +EXPORT_SYMBOL_GPL(crash_vmclear_loaded_vmcss);
> > +
> > +static inline void cpu_emergency_vmclear_loaded_vmcss(void)
> > +{
> > +	if (crash_vmclear_loaded_vmcss)
> > +		crash_vmclear_loaded_vmcss();
> > +}
> >  
> >  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
> >  
> > @@ -46,6 +61,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
> >  #endif
> >  	crash_save_cpu(regs, cpu);
> >  
> > +	/*
> > +	 * VMCLEAR VMCSs loaded on all cpus if needed.
> > +	 */
> > +	cpu_emergency_vmclear_loaded_vmcss();
> > +
> >  	/* Disable VMX or SVM if needed.
> >  	 *
> >  	 * We need to disable virtualization on all CPUs.
> > @@ -88,6 +108,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
> >  
> >  	kdump_nmi_shootdown_cpus();
> >  
> > +	/*
> > +	 * VMCLEAR VMCSs loaded on this cpu if needed.
> > +	 */
> > +	cpu_emergency_vmclear_loaded_vmcss();
> > +
> >  	/* Booting kdump kernel with VMX or SVM enabled won't work,
> >  	 * because (among other limitations) we can't disable paging
> >  	 * with the virt flags.
> > -- 
> > 1.7.1
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
