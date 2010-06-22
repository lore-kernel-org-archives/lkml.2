Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0FVDL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 23:11:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:7154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0FVDL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 23:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,457,1272870000"; 
   d="scan'208";a="291456339"
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
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
       tim.c.chen@intel.com
In-Reply-To: <4C1F5C21.7070902@redhat.com>
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
	 <4C1F5C21.7070902@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 22 Jun 2010 11:12:13 +0800
Message-Id: <1277176333.2096.650.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 15:33 +0300, Avi Kivity wrote:
> On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> > The 3rd patch is to implement para virt perf at host kernel.
> >
> >
> > @@ -64,6 +73,85 @@ struct kvm_mmu_op_release_pt {
> >   #ifdef __KERNEL__
> >   #include<asm/processor.h>
> >
> >
> > +/*
> > + * In host kernel, perf_event->host_perf_shadow points to
> > + * host_perf_shadow which records some information
> > + * about the guest.
> > + */
> > +struct host_perf_shadow {
> > +	/* guest perf_event id passed from guest os */
> > +	int id;
> > +	/*
> > +	 * Host kernel saves data into data member counter firstly.
> > +	 * kvm will get data from this counter and calls kvm functions
> > +	 * to copy or add data back to guets os before entering guest os
> > +	 * next time
> > +	 */
> > +	struct guest_perf_event counter;
> > +	/* guest_event_addr is gpa_t pointing to guest os guest_perf_event*/
> > +	__u64 guest_event_addr;
> >    
> 
> So just use gpa_t as the type.
host_perf_shadow->guest_event_addr is a copy of guest_event_addr->guest_event_addr.
As the latter's type is __u64 as the interface between guest os and host os, I use
__u64 as the type of host_perf_shadow->guest_event_addr.

> 
> > +
> > +	/*
> > +	 * Link to  of kvm.kvm_arch.shadow_hash_table
> > +	 */
> > +	struct list_head shadow_entry;
> > +	struct kvm_vcpu *vcpu;
> > +
> > +	struct perf_event *host_event;
> > +	/*
> > +	 * Below counter is to prevent malicious guest os to try to
> > +	 * close/enable event at the same time.
> > +	 */
> > +	atomic_t ref_counter;
> >    
> 
> If events are made per-vcpu (like real hardware), races become impossible.
This design is to deal with a task context perf collection in guest os.
Scenario 1:
1) guest os starts to collect statistics of process A on vcpu 0;
2) process A is scheduled to vcpu 1. Then, the perf_event at host side need
to be moved to VCPU 1 's thread. With the per KVM instance design, we needn't
move host_perf_shadow among vcpus.

Scenario 2:
1) guest os creates a perf_event at host side on vcpu 0;
2) malicious guest os calls close to delete the host perf_event on vcpu 1, but
enables the perf_event on vcpu0 at the same time. When close thread runs to get the
host_perf_shadow from the list, enable thread also gets it. Then, close thread
deletes the perf_event, and enable thread will cause host kernel panic when using
host_perf_shadow.


> 
> > +};
> >    
> 
> Please move this structure to include/linux/kvm_host.h.  No need to spam 
> kvm_para.h.  Note it's not x86 specific (though you can leave arch 
> enabling to arch maintainers).
Ok. Originally, I wanted to do so, but I'm afraid other arch might be not happy.

> 
> > +
> > +/*
> > + * In guest kernel, perf_event->guest_shadow points to
> > + * guest_perf_shadow which records some information
> > + * about the guest.
> > + */
> > +struct guest_perf_shadow {
> > +	/* guest perf_event id passed from guest os */
> > +	int id;
> > +	/*
> > +	 * Host kernel kvm saves data into data member counter
> > +	 */
> > +	struct guest_perf_event counter;
> > +};
> >    
> 
> Don't ordinary perf structures already have a counter ID which we can reuse?
No. In the other hand, if we assume generic perf has, we couldn't use it, because
generic perf id (actually there is no) is host kernel system-wide while here
guest_perf_shadow->id is per kvm instance wide.

> 
> > +
> > +/*
> > + * guest_perf_attr is used when guest calls hypercall to
> > + * open a new perf_event at host side. Mostly, it's a copy of
> > + * perf_event_attr and deletes something not used by host kernel.
> > + */
> > +struct guest_perf_attr {
> > +	__u32			type;
> > +	__u64			config;
> > +	__u64			sample_period;
> > +	__u64			sample_type;
> > +	__u64			read_format;
> > +	__u64			flags;
> > +	__u32			bp_type;
> > +	__u64			bp_addr;
> > +	__u64			bp_len;
> > +};
> >    
> 
> This is really not a guest or host structure, it's part of the 
> interface.  So please rename it (and similar) kvm_pv_perf_*.
Good idea.

> 
> > @@ -24,6 +24,7 @@
> >   #include<asm/desc.h>
> >   #include<asm/mtrr.h>
> >   #include<asm/msr-index.h>
> > +#include<asm/perf_event.h>
> >
> >   #define KVM_MAX_VCPUS 64
> >   #define KVM_MEMORY_SLOTS 32
> > @@ -360,6 +361,18 @@ struct kvm_vcpu_arch {
> >
> >   	/* fields used by HYPER-V emulation */
> >   	u64 hv_vapic;
> > +
> > +	/*
> > +	 * Fields used by PARAVIRT perf interface:
> > +	 *
> > +	 * kvm checks overflow_events before entering guest os,
> > +	 * and copy data back to guest os.
> > +	 * event_mutex is to avoid a race between NMI perf event overflow
> > +	 * handler, event close, and enable/disable.
> > +	 */
> > +	struct mutex event_mutex;
> >    
> 
> No race can exist.  The host NMI handler cannot take any mutex
We use a mutex_trylock in NMI hanlder. If it can't get the lock, there is a NMI miss
happening, but host kernel still updates perf_event->host_perf_shadow.counter, so the
overflow data will be accumulated. 

>  so it 
> must be immune to races.  The guest NMI handlers and callbacks are all 
> serialized by the guest itself.
This is to fight with malicious guest os kernel. Just like what I mention above,
the race might happen when:
1) NMI handler accesses it;
2) vmx_handle_exit codes access overflow_events to sync data to guest os;
3) Another vcpu thread of the same guest os calls close to delete the perf_event;

> 
> > +	int overflows;
> > +	struct perf_event *overflow_events[X86_PMC_IDX_MAX];
> >   };
> >    
> 
> KVM_PV_PERF_MAX_EVENTS (which needs to be exposed to the guest via cpuid).
Ok.

> 
> >
> >   struct kvm_mem_alias {
> > @@ -377,6 +390,9 @@ struct kvm_mem_aliases {
> >   	int naliases;
> >   };
> >
> > +#define KVM_PARAVIRT_PERF_EVENT_ENTRY_BITS	(10)
> > +#define KVM_PARAVIRT_PERF_EVENT_ENTRY_NUM	(1<<KVM_PARAVIRT_PERF_EVENT_ENTRY_BITS)
> >    
> 
> What are these?
The length of kvm_arch->shadow_hash_table.

> 
> > +
> >   struct kvm_arch {
> >   	struct kvm_mem_aliases *aliases;
> >
> > @@ -415,6 +431,15 @@ struct kvm_arch {
> >   	/* fields used by HYPER-V emulation */
> >   	u64 hv_guest_os_id;
> >   	u64 hv_hypercall;
> > +
> > +	/*
> > +	 * fields used by PARAVIRT perf interface:
> > +	 * Used to organize all host perf_events representing guest
> > +	 * perf_event on a specific kvm instance
> > +	 */
> > +	atomic_t kvm_pv_event_num;
> > +	spinlock_t shadow_lock;
> > +	struct list_head *shadow_hash_table;
> >    
> 
> Need to be per-vcpu.  Also wrap in a kvm_vcpu_perf structure, the names 
> are very generic.
Originally, I did so, but changed it to per kvm instance wide when considering
perf_event moving around vcpu threads.

> 
> Why do we need the hash table?  Use the index directly?
See above explanation.

> 
> >   /*
> >    * hypercalls use architecture specific
> > --- linux-2.6_tip0620/arch/x86/kvm/vmx.c	2010-06-21 15:19:39.322999849 +0800
> > +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/vmx.c	2010-06-21 15:21:39.310999849 +0800
> > @@ -3647,6 +3647,7 @@ static int vmx_handle_exit(struct kvm_vc
> >   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >   	u32 exit_reason = vmx->exit_reason;
> >   	u32 vectoring_info = vmx->idt_vectoring_info;
> > +	int ret;
> >
> >   	trace_kvm_exit(exit_reason, vcpu);
> >
> > @@ -3694,12 +3695,17 @@ static int vmx_handle_exit(struct kvm_vc
> >
> >   	if (exit_reason<  kvm_vmx_max_exit_handlers
> >   	&&  kvm_vmx_exit_handlers[exit_reason])
> > -		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> > +		ret = kvm_vmx_exit_handlers[exit_reason](vcpu);
> >   	else {
> >   		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> >   		vcpu->run->hw.hardware_exit_reason = exit_reason;
> > +		ret = 0;
> >   	}
> > -	return 0;
> > +
> > +	/* sync paravirt perf event to guest */
> > +	kvm_sync_events_to_guest(vcpu);
> >    
> 
> Why do that every exit?
> Why in vmx specific code?
I could move it to the tail of vcpu_enter_guest. kvm_sync_events_to_guest
might go to sleep when going through guest os page tables, so we couldn't call it
by NMI handler.


> 
> > @@ -1618,6 +1620,7 @@ int kvm_dev_ioctl_check_extension(long e
> >   	case KVM_CAP_PCI_SEGMENT:
> >   	case KVM_CAP_DEBUGREGS:
> >   	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> > +	case KVM_CAP_PV_PERF:
> >   		r = 1;
> >   		break;
> >   	case KVM_CAP_COALESCED_MMIO:
> >    
> 
> You can use KVM_CAP_PV_PERF to report the number of supported events to 
> userspace.
Thanks for the good pointer!

> 
> >
> > --- linux-2.6_tip0620/arch/x86/kvm/kvmperf_event.c	1970-01-01 08:00:00.000000000 +0800
> > +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/kvmperf_event.c	2010-06-21 16:49:29.509999849 +0800
> >    
> 
> No need for kvm prefix, we're in the kvm directory.
> > +
> > +#define KVM_MAX_PARAVIRT_PERF_EVENT		(1024)
> >    
> 
> This is really high.  I don't think it's necessary, or useful since the 
> underlying hardware has much fewer events, and since the guest can 
> multiplex events itself.
This limitation is different from hardware PMU counter imitation. When any application or
guest os vcpu thread creates perf_event, host kernel has no limitation. Kernel just arranges
all perf_event in a list (not considering group case) and schedules them to PMU hardware
by a round-robin method.
KVM_MAX_PARAVIRT_PERF_EVENT is to restrict guest os instance not to create too many
perf_event at host side which consumes too much memory of host kernel and slow the perf_event
schedule.

> 
> > +static void kvm_copy_event_to_guest(struct kvm_vcpu *vcpu,
> > +			struct perf_event *host_event)
> > +{
> > +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> > +	struct guest_perf_event counter;
> > +	int ret;
> > +	s32 overflows;
> > +
> > +	ret = kvm_read_guest(vcpu->kvm, shadow->guest_event_addr,
> > +				&counter, sizeof(counter));
> > +	if (ret<  0)
> > +		return;
> >    
> 
> Need better error handling.
As host kernel saves/accumulate data in perf_event->host_perf_shadow.counter,
it doesn't matter to have one failure. next time when overflowing again, it will
copy all data back to guest os.

> 
> > +
> > +again:
> > +	overflows = atomic_read(&shadow->counter.overflows);
> > +	if (atomic_cmpxchg(&shadow->counter.overflows, overflows, 0) !=
> > +			overflows)
> > +		goto again;
> >    
> 
> Can just use atomic_xchg() here.
Definitely can. Thanks.

> 
> > +
> > +	counter.count = shadow->counter.count;
> > +	atomic_add(overflows,&counter.overflows);
> > +
> > +	kvm_write_guest(vcpu->kvm,
> > +			shadow->guest_event_addr,
> > +			&counter,
> > +			sizeof(counter));
> >    
> 
> kvm_write_guest() is _very_ nonatomic...
It doesn't matter. There is only one potential race between host kernel and
guest kernel. When guest vmexits to host, it wouldn't access data pointed by
shadow->guest_event_addr. Above kvm_write_guest happens with the same vpcu.
So we just need make sure guest os vcpu accesses guest_perf_shadow->counter.overflows
atomically.

> 
> Need error handling.
Above explanation about data accumulation.

> 
> > +
> > +/* Just copy perf_event->count to guest. Don't copy overflows to guest */
> > +static void
> > +kvm_copy_count_to_guest(struct kvm_vcpu *vcpu, struct perf_event *host_event)
> > +{
> > +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> > +
> > +	shadow->counter.count = local64_read(&host_event->count);
> > +	kvm_write_guest(vcpu->kvm,
> > +			shadow->guest_event_addr,
> > +			&shadow->counter.count,
> > +			sizeof(shadow->counter.count));
> >    
> 
> Error handling.
Same thing.

> 
> > +	return;
> > +}
> > +
> > +static int
> > +kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
> > +{
> > +	int ret = 0;
> > +	struct perf_event *host_event = NULL;
> > +	struct host_perf_shadow *shadow = NULL;
> > +	struct guest_perf_event_param param;
> > +	struct guest_perf_attr *guest_attr = NULL;
> > +	struct perf_event_attr *attr = NULL;
> > +	int next_count;
> > +
> > +	next_count = atomic_read(&vcpu->kvm->arch.kvm_pv_event_num);
> > +	if (next_count>= KVM_MAX_PARAVIRT_PERF_EVENT) {
> > +		WARN_ONCE(1, "guest os wants to open more than %d events\n",
> > +			KVM_MAX_PARAVIRT_PERF_EVENT);
> > +		return -ENOENT;
> >    
> 
> Need to distinguish between guest errors (bad parameters) or host errors 
> (-ENOMEM) here.  Guest errors need to be returned to the guest, while 
> host errors need to be propagated to userspace (which called 
> ioctl(KVM_VCPU_RUN) some time ago).
I will double-check it. Thanks. Now I can understand why kvm_pv_mmu_op has
a special *ret parameter.

> 
> > +	}
> > +	atomic_inc(&vcpu->kvm->arch.kvm_pv_event_num);
> > +
> > +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> > +	if (!attr) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +	guest_attr = kzalloc(sizeof(*guest_attr), GFP_KERNEL);
> > +	if (!attr) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	ret = kvm_read_guest(vcpu->kvm, addr,&param, sizeof(param));
> > +	if (ret<  0)
> > +		goto out;
> > +
> > +	host_event = kvm_find_get_host_event(vcpu, param.id, 0);
> > +	if (host_event) {
> > +		kvm_put_host_event(host_event);
> > +		return -EEXIST;
> > +	}
> >    
> 
> > +	ret = kvm_read_guest(vcpu->kvm, param.attr_addr,
> > +			     guest_attr, sizeof(*guest_attr));
> > +	if (ret<  0)
> > +		goto out;
> > +
> > +	attr->type = guest_attr->type;
> > +	attr->config = guest_attr->config;
> > +	attr->sample_period = guest_attr->sample_period;
> > +	attr->read_format = guest_attr->read_format;
> > +	attr->flags = guest_attr->flags;
> > +	attr->bp_type = guest_attr->bp_type;
> > +	attr->bp_addr = guest_attr->bp_addr;
> > +	attr->bp_len = guest_attr->bp_len;
> >    
> 
> Needs tons of parameter validation.
The idea is we let generic perf codes to check the parameter.
We might add some simple checking here.

> 
> > +	/*
> > +	 * By default, we disable the host event. Later on, guets os
> > +	 * triggers a perf_event_attach to enable it
> > +	 */
> > +	attr->disabled = 1;
> > +	attr->inherit = 0;
> > +	attr->enable_on_exec = 0;
> > +	/*
> > +	 * We don't support exclude mode of user and kernel for guest os,
> > +	 * which mean we always collect both user and kernel for guest os
> > +	 */
> > +	attr->exclude_user = 0;
> > +	attr->exclude_kernel = 0;
> >    
> 
> First, if we don't support it, we should error out when the guest 
> specifies it.  Don't lie to the guest.
> 
> Second, why can't we support it?  should work for the guest just as it 
> does for us.
exclude_user and exclude_kernel are just hardware capability. Current PMU hardware
doesn't support virtualization. So when a counter is at exclude_user mode, we couldn't
collect any event happens in guest os. That's my direct thinking without architect
confirmation.

> 
> > +
> > +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
> > +	if (!shadow) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +	shadow->id = param.id;
> > +	shadow->guest_event_addr = param.guest_event_addr;
> > +	shadow->vcpu = vcpu;
> > +	INIT_LIST_HEAD(&shadow->shadow_entry);
> > +
> > +	/* We always create a cpu context host perf event */
> > +	host_event = perf_event_create_kernel_counter(attr, -1,
> > +				current->pid, kvm_perf_event_overflow);
> >    
> 
> What does 'cpu context' mean in this context?
Sorry, above comments are bad. Right one is:
/* We always create a process context host perf event */

perf event generic has 2 context, process context and per cpu context. process
context event is to collect statistics of a specific thread (process), while
cpu context event is to collect statistics of this cpu.

> 
> > +
> > +	if (IS_ERR(host_event)) {
> > +		host_event = NULL;
> > +		ret = -1;
> > +		goto out;
> > +	}
> > +	host_event->host_perf_shadow = shadow;
> > +	shadow->host_event = host_event;
> > +	atomic_set(&shadow->ref_counter, 1);
> > +	kvm_add_host_event(vcpu, shadow);
> > +
> > +out:
> > +	if (!host_event)
> > +		kfree(shadow);
> > +
> > +	kfree(attr);
> > +	kfree(guest_attr);
> > +
> > +	if (ret)
> > +		atomic_dec(&vcpu->kvm->arch.kvm_pv_event_num);
> > +
> > +	return ret;
> > +}
> > +
> >
> >    
> 


