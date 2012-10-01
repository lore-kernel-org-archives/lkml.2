Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2JATa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2JATay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:30:54 -0400
Date: Mon, 1 Oct 2012 16:30:38 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>, Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v10] kvm: notify host when the guest is
 panicked
Message-ID: <20121001193038.GA24388@amt.cnet>
References: <503DA63E.40608@cn.fujitsu.com>
 <20121001155740.00336a83@doriath.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001155740.00336a83@doriath.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 03:57:40PM -0300, Luiz Capitulino wrote:
> On Wed, 29 Aug 2012 13:18:54 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
> > We can know the guest is panicked when the guest runs on xen.
> > But we do not have such feature on kvm.
> 
> What's the status of this series?
> 
> It got lost in my queue and I ended up not reviewing it, but it seems
> to be stuck.
> 
> > 
> > Another purpose of this feature is: management app(for example:
> > libvirt) can do auto dump when the guest is panicked. If management
> > app does not do auto dump, the guest's user can do dump by hand if
> > he sees the guest is panicked.
> > 
> > We have three solutions to implement this feature:
> > 1. use vmcall
> > 2. use I/O port
> > 3. use virtio-serial.
> > 
> > We have decided to avoid touching hypervisor. The reason why I choose
> > choose the I/O port is:
> > 1. it is easier to implememt
> > 2. it does not depend any virtual device
> > 3. it can work when starting the kernel

Have you tried to move it early enough to minimize the number
of calls to panic()? Say, how many panics can occur between
first Linux instruction and initialization of netconsole?

Because this interface (all the way to QEMU) is going to be 
reimplemented with different code later, in case other architectures
want similar interface, which makes maintenance more difficult.

Using PCI would basically replacing I/O port write with PCI write
(or virtio write).

Avi?


> > Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> > ---
> >  Documentation/virtual/kvm/pv_event.txt |   32 ++++++++++++++++++++++++++++++++
> >  arch/ia64/include/asm/kvm_para.h       |   14 ++++++++++++++
> >  arch/powerpc/include/asm/kvm_para.h    |   14 ++++++++++++++
> >  arch/s390/include/asm/kvm_para.h       |   14 ++++++++++++++
> >  arch/x86/include/asm/kvm_para.h        |   27 +++++++++++++++++++++++++++
> >  arch/x86/kernel/kvm.c                  |   25 +++++++++++++++++++++++++
> >  include/linux/kvm_para.h               |   23 +++++++++++++++++++++++
> >  7 files changed, 149 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/virtual/kvm/pv_event.txt
> > 
> > diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
> > new file mode 100644
> > index 0000000..bb04de0
> > --- /dev/null
> > +++ b/Documentation/virtual/kvm/pv_event.txt
> > @@ -0,0 +1,32 @@
> > +The KVM paravirtual event interface
> > +=================================
> > +
> > +Initializing the paravirtual event interface
> > +======================
> > +kvm_pv_event_init()
> > +Argiments:
> > +	None
> > +
> > +Return Value:
> > +	0: The guest kernel can use paravirtual event interface.
> > +	1: The guest kernel can't use paravirtual event interface.
> > +
> > +Querying whether the event can be ejected
> > +======================
> > +kvm_pv_has_feature()
> > +Arguments:
> > +	feature: The bit value of this paravirtual event to query
> > +
> > +Return Value:
> > +	0 : The guest kernel can't eject this paravirtual event.
> > +	-1: The guest kernel can eject this paravirtual event.
> > +
> > +
> > +Ejecting paravirtual event
> > +======================
> > +kvm_pv_eject_event()
> > +Arguments:
> > +	event: The event to be ejected.
> > +
> > +Return Value:
> > +	None
> > diff --git a/arch/ia64/include/asm/kvm_para.h b/arch/ia64/include/asm/kvm_para.h
> > index 2019cb9..b5ec658 100644
> > --- a/arch/ia64/include/asm/kvm_para.h
> > +++ b/arch/ia64/include/asm/kvm_para.h
> > @@ -31,6 +31,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
> >  	return false;
> >  }
> >  
> > +static inline int kvm_arch_pv_event_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline unsigned int kvm_arch_pv_features(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void kvm_arch_pv_eject_event(unsigned int event)
> > +{
> > +}
> > +
> >  #endif
> >  
> >  #endif
> > diff --git a/arch/powerpc/include/asm/kvm_para.h b/arch/powerpc/include/asm/kvm_para.h
> > index c18916b..01b98c7 100644
> > --- a/arch/powerpc/include/asm/kvm_para.h
> > +++ b/arch/powerpc/include/asm/kvm_para.h
> > @@ -211,6 +211,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
> >  	return false;
> >  }
> >  
> > +static inline int kvm_arch_pv_event_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline unsigned int kvm_arch_pv_features(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void kvm_arch_pv_eject_event(unsigned int event)
> > +{
> > +}
> > +
> >  #endif /* __KERNEL__ */
> >  
> >  #endif /* __POWERPC_KVM_PARA_H__ */
> > diff --git a/arch/s390/include/asm/kvm_para.h b/arch/s390/include/asm/kvm_para.h
> > index da44867..00ce058 100644
> > --- a/arch/s390/include/asm/kvm_para.h
> > +++ b/arch/s390/include/asm/kvm_para.h
> > @@ -154,6 +154,20 @@ static inline bool kvm_check_and_clear_guest_paused(void)
> >  	return false;
> >  }
> >  
> > +static inline int kvm_arch_pv_event_init(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline unsigned int kvm_arch_pv_features(void)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void kvm_arch_pv_eject_event(unsigned int event)
> > +{
> > +}
> > +
> >  #endif
> >  
> >  #endif /* __S390_KVM_PARA_H */
> > diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> > index 2f7712e..7d297f0 100644
> > --- a/arch/x86/include/asm/kvm_para.h
> > +++ b/arch/x86/include/asm/kvm_para.h
> > @@ -96,8 +96,11 @@ struct kvm_vcpu_pv_apf_data {
> >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> >  #define KVM_PV_EOI_DISABLED 0x0
> >  
> > +#define KVM_PV_EVENT_PORT	(0x505UL)
> > +
> >  #ifdef __KERNEL__
> >  #include <asm/processor.h>
> > +#include <linux/ioport.h>
> >  
> >  extern void kvmclock_init(void);
> >  extern int kvm_register_clock(char *txt);
> > @@ -228,6 +231,30 @@ static inline void kvm_disable_steal_time(void)
> >  }
> >  #endif
> >  
> > +static inline int kvm_arch_pv_event_init(void)
> > +{
> > +	if (!request_region(KVM_PV_EVENT_PORT, 1, "KVM_PV_EVENT"))
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static inline unsigned int kvm_arch_pv_features(void)
> > +{
> > +	unsigned int features = inl(KVM_PV_EVENT_PORT);
> > +
> > +	/* Reading from an invalid I/O port will return -1 */
> > +	if (features == ~0)
> > +		features = 0;
> > +
> > +	return features;
> > +}
> > +
> > +static inline void kvm_arch_pv_eject_event(unsigned int event)
> > +{
> > +	outl(event, KVM_PV_EVENT_PORT);
> > +}
> > +
> >  #endif /* __KERNEL__ */
> >  
> >  #endif /* _ASM_X86_KVM_PARA_H */
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index c1d61ee..6129459 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -368,6 +368,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
> >  	.notifier_call = kvm_pv_reboot_notify,
> >  };
> >  
> > +static int
> > +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
> > +{
> > +	kvm_pv_eject_event(KVM_PV_EVENT_PANICKED);
> > +	return NOTIFY_DONE;
> > +}
> > +
> > +static struct notifier_block kvm_pv_panic_nb = {
> > +	.notifier_call = kvm_pv_panic_notify,
> > +};
> > +
> >  static u64 kvm_steal_clock(int cpu)
> >  {
> >  	u64 steal;
> > @@ -447,6 +458,20 @@ static void __init kvm_apf_trap_init(void)
> >  	set_intr_gate(14, &async_page_fault);
> >  }
> >  
> > +static void __init kvm_pv_panicked_event_init(void)
> > +{
> > +	if (!kvm_para_available())
> > +		return;
> > +
> > +	if (kvm_pv_event_init())
> > +		return;
> > +
> > +	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
> > +		atomic_notifier_chain_register(&panic_notifier_list,
> > +			&kvm_pv_panic_nb);
> > +}
> > +arch_initcall(kvm_pv_panicked_event_init);
> > +
> >  void __init kvm_guest_init(void)
> >  {
> >  	int i;
> > diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> > index ff476dd..8e0fb81 100644
> > --- a/include/linux/kvm_para.h
> > +++ b/include/linux/kvm_para.h
> > @@ -20,6 +20,12 @@
> >  #define KVM_HC_FEATURES			3
> >  #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
> >  
> > +/* The bit of supported pv event */
> > +#define KVM_PV_FEATURE_PANICKED	0
> > +
> > +/* The pv event value */
> > +#define KVM_PV_EVENT_PANICKED	1
> > +
> >  /*
> >   * hypercalls use architecture specific
> >   */
> > @@ -33,5 +39,22 @@ static inline int kvm_para_has_feature(unsigned int feature)
> >  		return 1;
> >  	return 0;
> >  }
> > +
> > +static inline int kvm_pv_event_init(void)
> > +{
> > +	return kvm_arch_pv_event_init();
> > +}
> > +
> > +static inline int kvm_pv_has_feature(unsigned int feature)
> > +{
> > +	if (kvm_arch_pv_features() & (1UL << feature))
> > +		return 1;
> > +	return 0;
> > +}
> > +
> > +static inline void kvm_pv_eject_event(unsigned int event)
> > +{
> > +	kvm_arch_pv_eject_event(event);
> > +}
> >  #endif /* __KERNEL__ */
> >  #endif /* __LINUX_KVM_PARA_H */
