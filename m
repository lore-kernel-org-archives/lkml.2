Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0FIIdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:33:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab0FIIdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:33:53 -0400
Message-ID: <4C0F51DD.3080200@redhat.com>
Date: Wed, 09 Jun 2010 11:33:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [RFC] para virt interface of perf to support kvm guest os statistics
 collection in guest os
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
In-Reply-To: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 06:30 AM, Zhang, Yanmin wrote:
> From: Zhang, Yanmin<yanmin_zhang@linux.intel.com>
>
> Based on Ingo's idea, I implement a para virt interface for perf to support
> statistics collection in guest os. That means we could run tool perf in guest
> os directly.
>
> Great thanks to Peter Zijlstra. He is really the architect and gave me architecture
> design suggestions. I also want to thank Yangsheng and LinMing for their generous
> help.
>
> The design is:
>
> 1) Add a kvm_pmu whose callbacks mostly just calls hypercall to vmexit to host kernel;
> 2) Create a host perf_event per guest perf_event;
> 3) Host kernel syncs perf_event count/overflows data changes to guest perf_event
> when processing perf_event overflows after NMI arrives. Host kernel inject NMI to guest
> kernel if a guest event overflows.
> 4) Guest kernel goes through all enabled event on current cpu and output data when they
> overflows.
> 5) No change in user space.
>    

One thing that's missing is documentation of the guest/host ABI.  It 
will be a requirement for inclusion, but it will also be a great help 
for review, so please provide it ASAP.

Please also split the guest and host parts into separate patches.

>
> -#define KVM_MAX_MMU_OP_BATCH           32
>    

Keep that please.

> +/* Operations for KVM_PERF_OP */
> +#define KVM_PERF_OP_OPEN		1
> +#define KVM_PERF_OP_CLOSE		2
> +#define KVM_PERF_OP_ENABLE		3
> +#define KVM_PERF_OP_DISABLE		4
> +#define KVM_PERF_OP_START		5
> +#define KVM_PERF_OP_STOP		6
> +#define KVM_PERF_OP_READ		7
>    

Where is the hypercall number for the perf hypercall?

> +static bool kvm_reserve_pmc_hardware(void)
> +{
> +	if (nmi_watchdog == NMI_LOCAL_APIC)
> +		disable_lapic_nmi_watchdog();
> +
> +	return true;
> +}
> +
> +static void kvm_release_pmc_hardware(void)
> +{
> +	if (nmi_watchdog == NMI_LOCAL_APIC)
> +		enable_lapic_nmi_watchdog();
> +}
>    

Disabling the watchdog is unfortunate.  Why is it necessary?

> +
> +static int kvm_pmu_enable(struct perf_event *event)
> +{
> +	int ret;
> +	unsigned long addr = __pa(event);
> +
> +	if (kvm_add_event(event))
> +		return -1;
> +
> +	ret = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_ENABLE,
> +	 		addr, (unsigned long) event->shadow);
>    

This is suspicious.  Passing virtual addresses to the host is always 
problematic.  Or event->shadow only used as an opaque cookie?

> +int __init kvm_init_hw_perf_events(void)
> +{
> +	if (!kvm_para_available())
> +		return -1;
> +
> +	x86_pmu.handle_irq = kvm_default_x86_handle_irq;
> +
> +	pr_cont("KVM PARA PMU driver.\n");
> +	register_die_notifier(&kvm_perf_event_nmi_notifier);
> +
> +	return 0;
> +}
>    

Need to detect the kvm pmu via its own cpuid bit.

> +
> +static int __kvm_hw_perf_event_init(struct perf_event *event)
> +{
> +	struct hw_perf_event *hwc =&event->hw;
> +	int err;
> +	unsigned long result;
> +	unsigned long addr;
> +
> +	err = 0;
> +	if (!atomic_inc_not_zero(&active_events)) {
> +		mutex_lock(&pmc_reserve_mutex);
> +		if (atomic_read(&active_events) == 0) {
> +			if (!kvm_reserve_pmc_hardware())
> +				err = -EBUSY;
> +		}
> +		if (!err)
> +			atomic_inc(&active_events);
> +		mutex_unlock(&pmc_reserve_mutex);
> +		if (err)
> +			return err;
> +	}
> +
> +	event->destroy = kvm_hw_perf_event_destroy;
> +
> +	hwc->idx = -1;
> +	hwc->last_cpu = -1;
> +	hwc->last_tag = ~0ULL;
> +
> +	addr = __pa(event);
> +	result = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, addr, 0);
> +
> +	if (result)
> +		event->shadow = (void *) result;
> +	else
> +		err = -1;
>    

Ok, so event->shadow is never dereferenced.  In that case better not 
make it a pointer at all, keep it unsigned long.

Note that you can run 32-bit guests on 64-bit hosts, so the cookie 
better not exceed 32 bits.

> +
> +static void kvm_sync_event_to_guest(struct perf_event *event, int overflows)
> +{
> +	struct hw_perf_event *hwc =&event->hw;
> +	struct kvmperf_event *kvmevent;
> +	int offset, len, data_len, copied, page_offset;
> +	struct page *event_page;
> +	void *shared_kaddr;
> +
> +	kvmevent = event->shadow;
> +	offset = kvmevent->event_offset;
> +
> +	/* Copy perf_event->count firstly */
> +	offset += offsetof(struct perf_event, count);
> +	if (offset<  PAGE_SIZE) {
> +		event_page = kvmevent->event_page;
> +		page_offset = offset;
> +	} else {
> +		event_page = kvmevent->event_page2;
> +		page_offset = offset - PAGE_SIZE;
> +	}
> +	shared_kaddr = kmap_atomic(event_page, KM_USER0);
> +	*((atomic64_t *)(shared_kaddr + page_offset)) = event->count;
>    

This copy will not be atomic on 32-bit hosts.

> +
> +	offset = kvmevent->event_offset;
> +	offset += offsetof(struct perf_event, hw);
> +	if (offset<  PAGE_SIZE) {
> +		if (event_page == kvmevent->event_page2) {
> +			kunmap_atomic(shared_kaddr, KM_USER0);
> +			event_page = kvmevent->event_page;
> +			shared_kaddr = kmap_atomic(event_page, KM_USER0);
> +		}
> +		page_offset = offset;
> +	} else {
> +		if (event_page == kvmevent->event_page) {
> +			kunmap_atomic(shared_kaddr, KM_USER0);
> +			event_page = kvmevent->event_page2;
> +			shared_kaddr = kmap_atomic(event_page, KM_USER0);
> +		}
> +		page_offset = offset - PAGE_SIZE;
> +	}
> +
> +	if (overflows)
> +		atomic_add(overflows, (atomic_t *)(shared_kaddr + page_offset));
> +
> +	kunmap_atomic(shared_kaddr, KM_USER0);
>    

Where is the actual event copied?  I'm afraid it's hard to understand 
the code.

> +#if 0
> +	offset += offsetof(struct hw_perf_event, prev_count);
> +	data_len = sizeof(struct hw_perf_event) -
> +		offsetof(struct hw_perf_event, prev_count);
> +	if (event_page == kvmevent->event_page2) {
> +		page_offset += offsetof(struct hw_perf_event, prev_count);
> +		memcpy(shared_kaddr + page_offset,
> +				&hwc->prev_count, data_len);
> +		kunmap_atomic(shared_kaddr, KM_USER0);
> +
> +		return;
> +	}
> +
> +	copied = 0;
> +	if (offset<  PAGE_SIZE) {
> +		len = PAGE_SIZE - offset;
> +		if (len>  data_len)
> +			len = data_len;
> +		memcpy(shared_kaddr + offset,
> +				&hwc->prev_count, data_len);
> +		copied = len;
> +		page_offset = 0;
> +	} else
> +		page_offset = offset - PAGE_SIZE;
> +
> +	kunmap_atomic(shared_kaddr, KM_USER0);
> +	len = data_len - copied;
> +	if (len) {
> +		/* Copy across pages */
> +		shared_kaddr = kmap_atomic(kvmevent->event_page2, KM_USER0);
> +		memcpy(shared_kaddr + page_offset,
> +				((void *)&hwc->prev_count) + copied, len);
> +		kunmap_atomic(shared_kaddr, KM_USER0);
> +	}
> +#endif
>    

Maybe here, but the #if 0 doesn't help.

> +}
> +
>
> +static struct perf_event *
> +kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
> +{
> +	int ret;
> +	struct perf_event *event;
> +	struct perf_event *host_event = NULL;
> +	struct kvmperf_event *shadow = NULL;
> +
> +	event = kzalloc(sizeof(*event), GFP_KERNEL);
> +	if (!event)
> +		goto out;
> +
> +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
> +	if (!shadow)
> +		goto out;
> +
> +	shadow->event_page = gfn_to_page(vcpu->kvm, addr>>  PAGE_SHIFT);
> +	shadow->event_offset = addr&  ~PAGE_MASK;
>    

Might truncate on 32-bit hosts.  PAGE_MASK is 32-bit while addr is 64 bit.

> +	if (shadow->event_offset + sizeof(struct perf_event)>  PAGE_SIZE) {
> +		shadow->event_page2 = gfn_to_page(vcpu->kvm,
> +					(addr>>  PAGE_SHIFT) + 1);
> +	}
>    

My be simpler to make event_pages an array instead of two independent 
variables.

> +
> +	ret = kvm_read_guest(vcpu->kvm, addr, event, sizeof(*event));
> +	if (ret)
> +		goto out;
>    

I assume this is to check existence?  It doesn't work well with memory 
hotplug.  In general it's preferred to use 
kvm_read_guest()/kvm_write_guest() instead of gfn_to_page() during 
initialization to prevent pinning and allow for hotplug.

> +
> +	/*
> +	 * By default, we disable the host event. Later on, guets os
> +	 * triggers a perf_event_attach to enable it
> +	 */
> +	event->attr.disabled = 1;
> +	event->attr.inherit = 0;
> +	event->attr.enable_on_exec = 0;
> +	/*
> +	 * We don't support exclude mode of user and kernel for guest os,
> +	 * which mean we always collect both user and kernel for guest os
> +	 */
> +	event->attr.exclude_user = 0;
> +	event->attr.exclude_kernel = 0;
> +	/* We always create a cpu context host perf event */
> +
> +	host_event = perf_event_create_kernel_counter(&event->attr, -1,
> +				current->pid, kvm_perf_event_overflow);
> +
> +	if (IS_ERR(host_event)) {
> +		host_event = NULL;
> +		goto out;
> +	}
> +	host_event->shadow = shadow;
> +
> +out:
> +	if (!host_event)
> +		kfree(shadow);
> +	kfree(event);
> +
> +	return host_event;
> +}
> +
>
> +
> +int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
> +		unsigned long a2, unsigned long *result)
> +{
> +	unsigned long ret;
> +	struct perf_event *host_event;
> +	gpa_t addr;
> +
> +	addr = (gpa_t)(a1);
>    

A 32-bit guest has a 64-bit gpa_t but 32-bit ulongs, so gpas need to be 
passed in two hypervall arguments.

> +
> +	switch(op_code) {
> +	case KVM_PERF_OP_OPEN:
> +		ret = (unsigned long) kvm_pv_perf_op_open(vcpu, addr);
> +		break;
> +	case KVM_PERF_OP_CLOSE:
> +		host_event = (struct perf_event *) a2;
>    

First, you get truncation in a 32-bit guest.  Second, you must validate 
the argument!  The guest kernel can easily subvert the host by passing a 
bogus host_event.

It may be better to have the guest create an id to the host, and the 
host can simply look up the id in a table:

   if (a2 >= KVM_PMU_MAX_EVENTS)
       bail out;
   host_event = vcpu->pmu.host_events[a2];

> @@ -4052,6 +4054,16 @@ static unsigned long kvm_get_guest_ip(vo
>   	return ip;
>   }
>
> +int kvm_notify_event_overflow(void)
> +{
> +	if (percpu_read(current_vcpu)) {
> +		kvm_inject_nmi(percpu_read(current_vcpu));
> +		return 0;
> +	}
> +
> +	return -1;
> +}
>    

This should really go through the APIC PERF LVT.  No interface 
currently, but we are working on it.

This way the guest can configure the perf interrupt to be NMI, INTR, or 
anything it likes.

-- 
error compiling committee.c: too many arguments to function

