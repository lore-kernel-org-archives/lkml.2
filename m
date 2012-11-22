Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2KVTbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:31:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2KVTbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:48 -0500
Date: Thu, 22 Nov 2012 08:34:35 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] x86/kexec: VMCLEAR vmcss on all cpus if necessary
Message-ID: <20121122063435.GA21208@redhat.com>
References: <50AC3AA9.7080004@cn.fujitsu.com>
 <50AC3B10.3090005@cn.fujitsu.com>
 <20121121103316.GP21208@redhat.com>
 <50AD78E3.7080901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <50AD78E3.7080901@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 08:59:15AM +0800, Zhang Yanfei wrote:
> 于 2012年11月21日 18:33, Gleb Natapov 写道:
> > On Wed, Nov 21, 2012 at 10:23:12AM +0800, Zhang Yanfei wrote:
> >> This patch adds an atomic notifier list named crash_notifier_list.
> >> When loading kvm-intel module, a notifier will be registered in
> >> the list to enable vmcss loaded on all cpus to be VMCLEAR'd if
> >> needed.
> >>
> >> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> ---
> >>  arch/x86/include/asm/kexec.h |    2 ++
> >>  arch/x86/kernel/crash.c      |   25 +++++++++++++++++++++++++
> >>  2 files changed, 27 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> >> index 317ff17..5e22b00 100644
> >> --- a/arch/x86/include/asm/kexec.h
> >> +++ b/arch/x86/include/asm/kexec.h
> >> @@ -163,6 +163,8 @@ struct kimage_arch {
> >>  };
> >>  #endif
> >>  
> >> +extern struct atomic_notifier_head crash_notifier_list;
> >> +
> >>  #endif /* __ASSEMBLY__ */
> >>  
> >>  #endif /* _ASM_X86_KEXEC_H */
> >> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> >> index 13ad899..0f3d5b4 100644
> >> --- a/arch/x86/kernel/crash.c
> >> +++ b/arch/x86/kernel/crash.c
> >> @@ -16,6 +16,8 @@
> >>  #include <linux/delay.h>
> >>  #include <linux/elf.h>
> >>  #include <linux/elfcore.h>
> >> +#include <linux/module.h>
> >> +#include <linux/notifier.h>
> >>  
> >>  #include <asm/processor.h>
> >>  #include <asm/hardirq.h>
> >> @@ -30,6 +32,19 @@
> >>  
> >>  int in_crash_kexec;
> >>  
> >> +/*
> >> + * The list is used to VMCLEAR vmcss loaded on all
> >> + * cpus. And when loading kvm_intel module, the
> >> + * vmclear function will be registered in the list.
> >> + */
> >> +ATOMIC_NOTIFIER_HEAD(crash_notifier_list);
> >> +EXPORT_SYMBOL_GPL(crash_notifier_list);
> >> +
> >> +static inline void cpu_emergency_vmclear_loaded_vmcss(void)
> >> +{
> >> +	atomic_notifier_call_chain(&crash_notifier_list, 0, NULL);
> >> +}
> >> +
> > The notifier list is not VMX specific. It may be used for other
> > purposes, so please use better name or just open code it.
> 
> OK, thanks. crash_notifier_list --> vmclear_notifier_list?
It is even worse. You are adding general infrastructure here, not
related to KVM at all. Choose neutral names, drop all comments about
VMCLEAR.

> the new v6 version has been sent, any comments are welcome.
> 
> > 
> > ACKs from kexec side are needed.
> > 
> >>  #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
> >>  
> >>  static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
> >> @@ -46,6 +61,11 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
> >>  #endif
> >>  	crash_save_cpu(regs, cpu);
> >>  
> >> +	/*
> >> +	 * VMCLEAR vmcss loaded on all cpus if needed.
> >> +	 */
> >> +	cpu_emergency_vmclear_loaded_vmcss();
> >> +
> >>  	/* Disable VMX or SVM if needed.
> >>  	 *
> >>  	 * We need to disable virtualization on all CPUs.
> >> @@ -88,6 +108,11 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
> >>  
> >>  	kdump_nmi_shootdown_cpus();
> >>  
> >> +	/*
> >> +	 * VMCLEAR vmcss loaded on this cpu if needed.
> >> +	 */
> >> +	cpu_emergency_vmclear_loaded_vmcss();
> >> +
> >>  	/* Booting kdump kernel with VMX or SVM enabled won't work,
> >>  	 * because (among other limitations) we can't disable paging
> >>  	 * with the virt flags.
> >> -- 
> >> 1.7.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > --
> > 			Gleb.
> > 
> 

--
			Gleb.
