Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2H2L4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 07:56:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44430 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2H2L4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 07:56:12 -0400
Message-ID: <503E0377.6000107@gmail.com>
Date: Wed, 29 Aug 2012 13:56:39 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120826 Thunderbird/14.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v10] kvm: notify host when the guest is panicked
References: <503DA63E.40608@cn.fujitsu.com>
In-Reply-To: <503DA63E.40608@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 07:18 AM, Wen Congyang wrote:
> We can know the guest is panicked when the guest runs on xen.
> But we do not have such feature on kvm.
> 
> Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is panicked. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is panicked.
> 
> We have three solutions to implement this feature:
> 1. use vmcall
> 2. use I/O port
> 3. use virtio-serial.
> 
> We have decided to avoid touching hypervisor. The reason why I choose
> choose the I/O port is:
> 1. it is easier to implememt
> 2. it does not depend any virtual device
> 3. it can work when starting the kernel
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  Documentation/virtual/kvm/pv_event.txt |   32 ++++++++++++++++++++++++++++++++
>  arch/ia64/include/asm/kvm_para.h       |   14 ++++++++++++++
>  arch/powerpc/include/asm/kvm_para.h    |   14 ++++++++++++++
>  arch/s390/include/asm/kvm_para.h       |   14 ++++++++++++++
>  arch/x86/include/asm/kvm_para.h        |   27 +++++++++++++++++++++++++++
>  arch/x86/kernel/kvm.c                  |   25 +++++++++++++++++++++++++
>  include/linux/kvm_para.h               |   23 +++++++++++++++++++++++
>  7 files changed, 149 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/virtual/kvm/pv_event.txt
> 
> diff --git a/Documentation/virtual/kvm/pv_event.txt b/Documentation/virtual/kvm/pv_event.txt
> new file mode 100644
> index 0000000..bb04de0
> --- /dev/null
> +++ b/Documentation/virtual/kvm/pv_event.txt
> @@ -0,0 +1,32 @@
> +The KVM paravirtual event interface
> +=================================
> +
> +Initializing the paravirtual event interface
> +======================
> +kvm_pv_event_init()
> +Argiments:
> +	None
> +
> +Return Value:
> +	0: The guest kernel can use paravirtual event interface.
> +	1: The guest kernel can't use paravirtual event interface.
> +
> +Querying whether the event can be ejected
> +======================
> +kvm_pv_has_feature()
> +Arguments:
> +	feature: The bit value of this paravirtual event to query
> +
> +Return Value:
> +	0 : The guest kernel can't eject this paravirtual event.
> +	-1: The guest kernel can eject this paravirtual event.
> +
> +
> +Ejecting paravirtual event
> +======================
> +kvm_pv_eject_event()
> +Arguments:
> +	event: The event to be ejected.
> +
> +Return Value:
> +	None

What's the protocol for communicating with the hypervisor? What is it supposed
to do on reads/writes to that ioport?

> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 2f7712e..7d297f0 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -96,8 +96,11 @@ struct kvm_vcpu_pv_apf_data {
>  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>  #define KVM_PV_EOI_DISABLED 0x0
>  
> +#define KVM_PV_EVENT_PORT	(0x505UL)
> +
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
> +#include <linux/ioport.h>
>  
>  extern void kvmclock_init(void);
>  extern int kvm_register_clock(char *txt);
> @@ -228,6 +231,30 @@ static inline void kvm_disable_steal_time(void)
>  }
>  #endif
>  
> +static inline int kvm_arch_pv_event_init(void)
> +{
> +	if (!request_region(KVM_PV_EVENT_PORT, 1, "KVM_PV_EVENT"))

Only one byte is requested here, but the rest of the code is reading/writing longs?

The struct resource * returned from request_region is simply being leaked here?

What happens if we go ahead with adding another event (let's say OOM event)?
request_region() is going to fail for anything but the first call.

> +		return -1;

This return value doesn't correspond with the documentation.

> +
> +	return 0;
> +}
> +
> +static inline unsigned int kvm_arch_pv_features(void)
> +{
> +	unsigned int features = inl(KVM_PV_EVENT_PORT);
> +
> +	/* Reading from an invalid I/O port will return -1 */

Just wondering, where is that documented? For lkvm for example the return value
from an ioport without a device on the other side is undefined, so it's possible
we're doing something wrong there.

> +	if (features == ~0)
> +		features = 0;
> +
> +	return features;
> +}
> +
> +static inline void kvm_arch_pv_eject_event(unsigned int event)
> +{
> +	outl(event, KVM_PV_EVENT_PORT);
> +}
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* _ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index c1d61ee..6129459 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -368,6 +368,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>  	.notifier_call = kvm_pv_reboot_notify,
>  };
>  
> +static int
> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
> +{
> +	kvm_pv_eject_event(KVM_PV_EVENT_PANICKED);
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block kvm_pv_panic_nb = {
> +	.notifier_call = kvm_pv_panic_notify,
> +};
> +
>  static u64 kvm_steal_clock(int cpu)
>  {
>  	u64 steal;
> @@ -447,6 +458,20 @@ static void __init kvm_apf_trap_init(void)
>  	set_intr_gate(14, &async_page_fault);
>  }
>  
> +static void __init kvm_pv_panicked_event_init(void)
> +{
> +	if (!kvm_para_available())
> +		return;
> +
> +	if (kvm_pv_event_init())
> +		return;
> +
> +	if (kvm_pv_has_feature(KVM_PV_FEATURE_PANICKED))
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +			&kvm_pv_panic_nb);
> +}
> +arch_initcall(kvm_pv_panicked_event_init);

So it starts automatically on boot? Is there a way to disable it?


Thanks,
Sasha
