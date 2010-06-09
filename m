Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0FIJTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:19:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:7678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0FIJTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:19:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,390,1272870000"; 
   d="scan'208";a="574671546"
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C0F51DD.3080200@redhat.com>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
	 <4C0F51DD.3080200@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 09 Jun 2010 17:21:20 +0800
Message-Id: <1276075280.2096.427.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 11:33 +0300, Avi Kivity wrote:
> On 06/09/2010 06:30 AM, Zhang, Yanmin wrote:
> > From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
> >
> > Based on Ingo's idea, I implement a para virt interface for perf to support
> > statistics collection in guest os. That means we could run tool perf in guest
> > os directly.
> >
> > Great thanks to Peter Zijlstra. He is really the architect and gave me architecture
> > design suggestions. I also want to thank Yangsheng and LinMing for their generous
> > help.
> >
> > The design is:
> >
> > 1) Add a kvm_pmu whose callbacks mostly just calls hypercall to vmexit to host kernel;
> > 2) Create a host perf_event per guest perf_event;
> > 3) Host kernel syncs perf_event count/overflows data changes to guest perf_event
> > when processing perf_event overflows after NMI arrives. Host kernel inject NMI to guest
> > kernel if a guest event overflows.
> > 4) Guest kernel goes through all enabled event on current cpu and output data when they
> > overflows.
> > 5) No change in user space.
> >    
> 
Thanks for your kind comments.

> One thing that's missing is documentation of the guest/host ABI.  It 
> will be a requirement for inclusion, but it will also be a great help 
> for review, so please provide it ASAP.
I will add such document. It will includes:
1) Data struct perf_event definition. Guest os and host os have to share the same
data structure as host kernel will sync data (counte/overflows and others if needed)
changes back to guest os.
2) A list of all hypercalls
3) Guest need have NMI handler which checks all guest events.


> 
> Please also split the guest and host parts into separate patches.
I will do so.

> 
> >
> > -#define KVM_MAX_MMU_OP_BATCH           32
> >    
> 
> Keep that please.
I will do so.

> 
> > +/* Operations for KVM_PERF_OP */
> > +#define KVM_PERF_OP_OPEN		1
> > +#define KVM_PERF_OP_CLOSE		2
> > +#define KVM_PERF_OP_ENABLE		3
> > +#define KVM_PERF_OP_DISABLE		4
> > +#define KVM_PERF_OP_START		5
> > +#define KVM_PERF_OP_STOP		6
> > +#define KVM_PERF_OP_READ		7
> >    
> 
> Where is the hypercall number for the perf hypercall?
I defines it in file kvm_para.h like KVM_HC_MMU_OP.

> 
> > +static bool kvm_reserve_pmc_hardware(void)
> > +{
> > +	if (nmi_watchdog == NMI_LOCAL_APIC)
> > +		disable_lapic_nmi_watchdog();
> > +
> > +	return true;
> > +}
> > +
> > +static void kvm_release_pmc_hardware(void)
> > +{
> > +	if (nmi_watchdog == NMI_LOCAL_APIC)
> > +		enable_lapic_nmi_watchdog();
> > +}
> >    
> 
> Disabling the watchdog is unfortunate.  Why is it necessary?
perf always uses NMI, so we disable the nmi_watchdog when a perf_event is
set up in case they might have impact.

> 
> > +
> > +static int kvm_pmu_enable(struct perf_event *event)
> > +{
> > +	int ret;
> > +	unsigned long addr = __pa(event);
> > +
> > +	if (kvm_add_event(event))
> > +		return -1;
> > +
> > +	ret = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_ENABLE,
> > +	 		addr, (unsigned long) event->shadow);
> >    
> 
> This is suspicious.  Passing virtual addresses to the host is always 
> problematic.  Or event->shadow only used as an opaque cookie?
I use perf_event->shadow at both host and guest side.
1) At host side, perf_event->shadow points to an area including the page
mapping information about guest perf_event. Host kernel uses it to sync data
changes back to guest;
2) At guest side, perf_event->shadow save the virtual address of host
perf_event at host side. At guest side,
kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, ...) return the virtual address.
Guest os shouldn't use it but using it to pass it back to host kernel in following
hypercalls. It might be a security issue for host kernel. Originally, I planed guest
os not to use perf_event->shadow. Host kernel maintains a per-vcpu event-related
list whose key is addr of guest perf_event. But considering the vcpu thread migration
on logical cpu, such list needs lock and implementation becomes a little complicated.

I will double-check the list method as the security issue is there.

> 
> > +int __init kvm_init_hw_perf_events(void)
> > +{
> > +	if (!kvm_para_available())
> > +		return -1;
> > +
> > +	x86_pmu.handle_irq = kvm_default_x86_handle_irq;
> > +
> > +	pr_cont("KVM PARA PMU driver.\n");
> > +	register_die_notifier(&kvm_perf_event_nmi_notifier);
> > +
> > +	return 0;
> > +}
> >    
> 
> Need to detect the kvm pmu via its own cpuid bit.
Ok. I will add a feature, KVM_FEATURE_PARA_PERF, something like
bit KVM_FEATURE_CLOCKSOURCE.

> 
> > +
> > +static int __kvm_hw_perf_event_init(struct perf_event *event)
> > +{
> > +	struct hw_perf_event *hwc =&event->hw;
> > +	int err;
> > +	unsigned long result;
> > +	unsigned long addr;
> > +
> > +	err = 0;
> > +	if (!atomic_inc_not_zero(&active_events)) {
> > +		mutex_lock(&pmc_reserve_mutex);
> > +		if (atomic_read(&active_events) == 0) {
> > +			if (!kvm_reserve_pmc_hardware())
> > +				err = -EBUSY;
> > +		}
> > +		if (!err)
> > +			atomic_inc(&active_events);
> > +		mutex_unlock(&pmc_reserve_mutex);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	event->destroy = kvm_hw_perf_event_destroy;
> > +
> > +	hwc->idx = -1;
> > +	hwc->last_cpu = -1;
> > +	hwc->last_tag = ~0ULL;
> > +
> > +	addr = __pa(event);
> > +	result = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, addr, 0);
> > +
> > +	if (result)
> > +		event->shadow = (void *) result;
> > +	else
> > +		err = -1;
> >    
> 
> Ok, so event->shadow is never dereferenced.  In that case better not 
> make it a pointer at all, keep it unsigned long.
Host kernel also uses it.

> 
> Note that you can run 32-bit guests on 64-bit hosts, so the cookie 
> better not exceed 32 bits.
I forgot 32 bits. I need double-check it. It seems I have to implement a list
at host side and don't use it at guest side any more.

> 
> > +
> > +static void kvm_sync_event_to_guest(struct perf_event *event, int overflows)
> > +{
> > +	struct hw_perf_event *hwc =&event->hw;
> > +	struct kvmperf_event *kvmevent;
> > +	int offset, len, data_len, copied, page_offset;
> > +	struct page *event_page;
> > +	void *shared_kaddr;
> > +
> > +	kvmevent = event->shadow;
> > +	offset = kvmevent->event_offset;
> > +
> > +	/* Copy perf_event->count firstly */
> > +	offset += offsetof(struct perf_event, count);
> > +	if (offset<  PAGE_SIZE) {
> > +		event_page = kvmevent->event_page;
> > +		page_offset = offset;
> > +	} else {
> > +		event_page = kvmevent->event_page2;
> > +		page_offset = offset - PAGE_SIZE;
> > +	}
> > +	shared_kaddr = kmap_atomic(event_page, KM_USER0);
> > +	*((atomic64_t *)(shared_kaddr + page_offset)) = event->count;
> >    
> 
> This copy will not be atomic on 32-bit hosts.
Right. But it shouldn't be a problem as vcpu thread stops when vmexit to
host to process events. In addition, only current cpu in guest accesses
perf_events linked to current cpu.

> 
> > +
> > +	offset = kvmevent->event_offset;
> > +	offset += offsetof(struct perf_event, hw);
> > +	if (offset<  PAGE_SIZE) {
> > +		if (event_page == kvmevent->event_page2) {
> > +			kunmap_atomic(shared_kaddr, KM_USER0);
> > +			event_page = kvmevent->event_page;
> > +			shared_kaddr = kmap_atomic(event_page, KM_USER0);
> > +		}
> > +		page_offset = offset;
> > +	} else {
> > +		if (event_page == kvmevent->event_page) {
> > +			kunmap_atomic(shared_kaddr, KM_USER0);
> > +			event_page = kvmevent->event_page2;
> > +			shared_kaddr = kmap_atomic(event_page, KM_USER0);
> > +		}
> > +		page_offset = offset - PAGE_SIZE;
> > +	}
> > +
> > +	if (overflows)
> > +		atomic_add(overflows, (atomic_t *)(shared_kaddr + page_offset));
> > +
> > +	kunmap_atomic(shared_kaddr, KM_USER0);
> >    
> 
> Where is the actual event copied?  I'm afraid it's hard to understand 
> the code.
Sorry, I should have more statements around the codes.
When an event overflows, host kernel sync perf_event->count to guest os
perf_event->count, and increases the perf_event->hw.overflows.

+struct kvmperf_event {
+       unsigned int event_offset;
+       struct page *event_page;
+       struct page *event_page2;
+};

Actually, at host side, perf_event->shadow points to a kvmperf_event.
kvmperf_event->event_page points the physical page of guest perf_event. event_page2
points to the 2nd page if perf_event data structure layouts across 2 pages.
event_offset marks the offset start in the 1st page.

> 
> > +#if 0
> > +	offset += offsetof(struct hw_perf_event, prev_count);
> > +	data_len = sizeof(struct hw_perf_event) -
> > +		offsetof(struct hw_perf_event, prev_count);
> > +	if (event_page == kvmevent->event_page2) {
> > +		page_offset += offsetof(struct hw_perf_event, prev_count);
> > +		memcpy(shared_kaddr + page_offset,
> > +				&hwc->prev_count, data_len);
> > +		kunmap_atomic(shared_kaddr, KM_USER0);
> > +
> > +		return;
> > +	}
> > +
> > +	copied = 0;
> > +	if (offset<  PAGE_SIZE) {
> > +		len = PAGE_SIZE - offset;
> > +		if (len>  data_len)
> > +			len = data_len;
> > +		memcpy(shared_kaddr + offset,
> > +				&hwc->prev_count, data_len);
> > +		copied = len;
> > +		page_offset = 0;
> > +	} else
> > +		page_offset = offset - PAGE_SIZE;
> > +
> > +	kunmap_atomic(shared_kaddr, KM_USER0);
> > +	len = data_len - copied;
> > +	if (len) {
> > +		/* Copy across pages */
> > +		shared_kaddr = kmap_atomic(kvmevent->event_page2, KM_USER0);
> > +		memcpy(shared_kaddr + page_offset,
> > +				((void *)&hwc->prev_count) + copied, len);
> > +		kunmap_atomic(shared_kaddr, KM_USER0);
> > +	}
> > +#endif
> >    
> 
> Maybe here, but the #if 0 doesn't help.
The codes in '#if 0' is trying to copy more data back to guest os
perf_event. I comment them out as they are not really used by guest os.
 
> 
> > +}
> > +
> >
> > +static struct perf_event *
> > +kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
> > +{
> > +	int ret;
> > +	struct perf_event *event;
> > +	struct perf_event *host_event = NULL;
> > +	struct kvmperf_event *shadow = NULL;
> > +
> > +	event = kzalloc(sizeof(*event), GFP_KERNEL);
> > +	if (!event)
> > +		goto out;
> > +
> > +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
> > +	if (!shadow)
> > +		goto out;
> > +
> > +	shadow->event_page = gfn_to_page(vcpu->kvm, addr>>  PAGE_SHIFT);
> > +	shadow->event_offset = addr&  ~PAGE_MASK;
> >    
> 
> Might truncate on 32-bit hosts.  PAGE_MASK is 32-bit while addr is 64 bit.
Above codes just run at host side. Is it possible that host kernel is 32 bit and
guest kernel is 64bits? I really need separate the patch to host and guest parts
as one patch misleads you guys.

> 
> > +	if (shadow->event_offset + sizeof(struct perf_event)>  PAGE_SIZE) {
> > +		shadow->event_page2 = gfn_to_page(vcpu->kvm,
> > +					(addr>>  PAGE_SHIFT) + 1);
> > +	}
> >    
> 
> My be simpler to make event_pages an array instead of two independent 
> variables.
Ok, I will do so.

> 
> > +
> > +	ret = kvm_read_guest(vcpu->kvm, addr, event, sizeof(*event));
> > +	if (ret)
> > +		goto out;
> >    
> 
> I assume this is to check existence?
Here calling kvm_read_guest is to get a copy of guest perf_event as it has
perf_event.attr. Host need the attr to create host perf_event.

>   It doesn't work well with memory 
> hotplug.  In general it's preferred to use 
> kvm_read_guest()/kvm_write_guest() instead of gfn_to_page() during 
> initialization to prevent pinning and allow for hotplug.
That's an issue. But host kernel couldn't go to sleep when processing event
overflows under NMI context.

> 
> > +
> > +	/*
> > +	 * By default, we disable the host event. Later on, guets os
> > +	 * triggers a perf_event_attach to enable it
> > +	 */
> > +	event->attr.disabled = 1;
> > +	event->attr.inherit = 0;
> > +	event->attr.enable_on_exec = 0;
> > +	/*
> > +	 * We don't support exclude mode of user and kernel for guest os,
> > +	 * which mean we always collect both user and kernel for guest os
> > +	 */
> > +	event->attr.exclude_user = 0;
> > +	event->attr.exclude_kernel = 0;
> > +	/* We always create a cpu context host perf event */
> > +
> > +	host_event = perf_event_create_kernel_counter(&event->attr, -1,
> > +				current->pid, kvm_perf_event_overflow);
> > +
> > +	if (IS_ERR(host_event)) {
> > +		host_event = NULL;
> > +		goto out;
> > +	}
> > +	host_event->shadow = shadow;
> > +
> > +out:
> > +	if (!host_event)
> > +		kfree(shadow);
> > +	kfree(event);
> > +
> > +	return host_event;
> > +}
> > +
> >
> > +
> > +int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
> > +		unsigned long a2, unsigned long *result)
> > +{
> > +	unsigned long ret;
> > +	struct perf_event *host_event;
> > +	gpa_t addr;
> > +
> > +	addr = (gpa_t)(a1);
> >    
> 
> A 32-bit guest has a 64-bit gpa_t but 32-bit ulongs, so gpas need to be 
> passed in two hypervall arguments.
Ok. Originally I pass 2 parameters like hc_gpa. I will redo it.

> 
> > +
> > +	switch(op_code) {
> > +	case KVM_PERF_OP_OPEN:
> > +		ret = (unsigned long) kvm_pv_perf_op_open(vcpu, addr);
> > +		break;
> > +	case KVM_PERF_OP_CLOSE:
> > +		host_event = (struct perf_event *) a2;
> >    
> 
> First, you get truncation in a 32-bit guest.  Second, you must validate 
> the argument!  The guest kernel can easily subvert the host by passing a 
> bogus host_event.
You are right. I will implement the list method at host side.

> 
> It may be better to have the guest create an id to the host, and the 
> host can simply look up the id in a table:
Perhaps the address of guest perf_event is the best id.

> 
>    if (a2 >= KVM_PMU_MAX_EVENTS)
>        bail out;
>    host_event = vcpu->pmu.host_events[a2];
> 
> > @@ -4052,6 +4054,16 @@ static unsigned long kvm_get_guest_ip(vo
> >   	return ip;
> >   }
> >
> > +int kvm_notify_event_overflow(void)
> > +{
> > +	if (percpu_read(current_vcpu)) {
> > +		kvm_inject_nmi(percpu_read(current_vcpu));
> > +		return 0;
> > +	}
> > +
> > +	return -1;
> > +}
> >    
> 
> This should really go through the APIC PERF LVT.  No interface 
> currently, but we are working on it.
> 
> This way the guest can configure the perf interrupt to be NMI, INTR, or 
> anything it likes.
> 
Thanks for the pointer.

Yanmin


