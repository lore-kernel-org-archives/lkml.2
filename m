Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab0FWDMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:12:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:64583 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0FWDMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:12:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,464,1272870000"; 
   d="scan'208";a="578964754"
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
       tim.c.chen@intel.com, Alexander Graf <agraf@suse.de>,
       Carsten Otte <carsteno@de.ibm.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4C207475.9010006@redhat.com>
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
	 <4C1F5C21.7070902@redhat.com>
	 <1277176333.2096.650.camel@ymzhang.sh.intel.com>
	 <4C207475.9010006@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 23 Jun 2010 11:12:54 +0800
Message-Id: <1277262774.2096.838.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 11:29 +0300, Avi Kivity wrote:
> On 06/22/2010 06:12 AM, Zhang, Yanmin wrote:
> > On Mon, 2010-06-21 at 15:33 +0300, Avi Kivity wrote:
> >    
> >> On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> >>      
> >>> The 3rd patch is to implement para virt perf at host kernel.
> >>>
> >>>
> >>> @@ -64,6 +73,85 @@ struct kvm_mmu_op_release_pt {
> >>>    #ifdef __KERNEL__
> >>>    #include<asm/processor.h>
> >>>
> >>>
> >>> +/*
> >>> + * In host kernel, perf_event->host_perf_shadow points to
> >>> + * host_perf_shadow which records some information
> >>> + * about the guest.
> >>> + */
> >>> +struct host_perf_shadow {
> >>> +	/* guest perf_event id passed from guest os */
> >>> +	int id;
> >>> +	/*
> >>> +	 * Host kernel saves data into data member counter firstly.
> >>> +	 * kvm will get data from this counter and calls kvm functions
> >>> +	 * to copy or add data back to guets os before entering guest os
> >>> +	 * next time
> >>> +	 */
> >>> +	struct guest_perf_event counter;
> >>> +	/* guest_event_addr is gpa_t pointing to guest os guest_perf_event*/
> >>> +	__u64 guest_event_addr;
> >>>
> >>>        
> >> So just use gpa_t as the type.
> >>      
> > host_perf_shadow->guest_event_addr is a copy of guest_event_addr->guest_event_addr.
> > As the latter's type is __u64 as the interface between guest os and host os, I use
> > __u64 as the type of host_perf_shadow->guest_event_addr.
> >    
> 
> Right.  Bug gpa_t is more descriptive.  We have a lot of address spaces 
> in kvm.
I change it to gpa_t.

> 
> >>> +
> >>> +	/*
> >>> +	 * Link to  of kvm.kvm_arch.shadow_hash_table
> >>> +	 */
> >>> +	struct list_head shadow_entry;
> >>> +	struct kvm_vcpu *vcpu;
> >>> +
> >>> +	struct perf_event *host_event;
> >>> +	/*
> >>> +	 * Below counter is to prevent malicious guest os to try to
> >>> +	 * close/enable event at the same time.
> >>> +	 */
> >>> +	atomic_t ref_counter;
> >>>
> >>>        
> >> If events are made per-vcpu (like real hardware), races become impossible.
> >>      
> > This design is to deal with a task context perf collection in guest os.
> > Scenario 1:
> > 1) guest os starts to collect statistics of process A on vcpu 0;
> > 2) process A is scheduled to vcpu 1. Then, the perf_event at host side need
> > to be moved to VCPU 1 's thread. With the per KVM instance design, we needn't
> > move host_perf_shadow among vcpus.
> >    
> 
> First, the guest already knows how to deal with per-cpu performance 
> monitors, since that's how most (all) hardware works.  So we aren't 
> making the guest more complex, and on the other hand we simplify the host.
I agree that we need keep things simple.

> 
> Second, if process A is migrated, and the guest uses per-process 
> counters, the guest will need to stop/start the counter during the 
> migration.  This will cause the host to migrate the counter,
Agree. My patches do so.

Question: Where does host migrate the counter?
The perf event at host side is bound to specific vcpu thread.

>  so while we 
> didn't move the counter to a different vcpu,
Disagree here. If process A on vcpu 0 in guest os is migrated to vcpu 1,
host has to move process A's perf_event to vcpu 1 thread.


>  we still have to move it to 
> a different cpu.
> 
> > Scenario 2:
> > 1) guest os creates a perf_event at host side on vcpu 0;
> > 2) malicious guest os calls close to delete the host perf_event on vcpu 1, but
> > enables the perf_event on vcpu0 at the same time. When close thread runs to get the
> > host_perf_shadow from the list, enable thread also gets it. Then, close thread
> > deletes the perf_event, and enable thread will cause host kernel panic when using
> > host_perf_shadow.
> >    
> 
> With per-vcpu events, this can't happen.  Each vcpu has its own set of 
> perf events in their own ID namespace.  vcpu 0 can't touch vcpu 1's 
> events even if it knows their IDs.
What does 'touch' mean here?

With the task (process) context event in guest os, we have to migrate the event
among vcpus when guest process scheduler balances processes among vcpus. So all
events in a guest os instance uses the same ID name space.

What you mentioned is really right when the event is cpu context event, but
not with task context event.

> 
> >> Please move this structure to include/linux/kvm_host.h.  No need to spam
> >> kvm_para.h.  Note it's not x86 specific (though you can leave arch
> >> enabling to arch maintainers).
> >>      
> > Ok. Originally, I wanted to do so, but I'm afraid other arch might be not happy.
> >    
> 
> Copying kvm arch maintainers.  Please keep an eye on this topic and 
> holler if something doesn't fit your arch.
> 
> 
> >>      
> >>> @@ -24,6 +24,7 @@
> >>>    #include<asm/desc.h>
> >>>    #include<asm/mtrr.h>
> >>>    #include<asm/msr-index.h>
> >>> +#include<asm/perf_event.h>
> >>>
> >>>    #define KVM_MAX_VCPUS 64
> >>>    #define KVM_MEMORY_SLOTS 32
> >>> @@ -360,6 +361,18 @@ struct kvm_vcpu_arch {
> >>>
> >>>    	/* fields used by HYPER-V emulation */
> >>>    	u64 hv_vapic;
> >>> +
> >>> +	/*
> >>> +	 * Fields used by PARAVIRT perf interface:
> >>> +	 *
> >>> +	 * kvm checks overflow_events before entering guest os,
> >>> +	 * and copy data back to guest os.
> >>> +	 * event_mutex is to avoid a race between NMI perf event overflow
> >>> +	 * handler, event close, and enable/disable.
> >>> +	 */
> >>> +	struct mutex event_mutex;
> >>>
> >>>        
> >> No race can exist.  The host NMI handler cannot take any mutex
> >>      
> > We use a mutex_trylock in NMI hanlder. If it can't get the lock, there is a NMI miss
> > happening, but host kernel still updates perf_event->host_perf_shadow.counter, so the
> > overflow data will be accumulated.
> >    
> 
> I see.  I don't think this is needed if we disable the counters during 
> guest->host switch,
We don't disable counters during guest->host switch. Generic perf codes will
disable it when:
1) host kernel process scheduler schedules the task out if the event is a task
context event.
2) guest os calls DISABLE hypercall.


>  we can just copy the data and set a bit in 
> vcpu->requests so that we can update the guest during next entry.
We can use a bit of vcpu->requests, but it has no far difference from a simple
checking (vcpu->arch.overflows == 0) in function kvm_sync_events_to_guest.

The key is how to save pending perf_event pointers, so kvm could update
their data to guest. vcpu->arch.overflow_events does so.

> 
> >>   so it
> >> must be immune to races.
If considering vcpu->arch.overflow_events, there will be a race if no locking.

>   The guest NMI handlers and callbacks are all
> >> serialized by the guest itself.
In guest NMI and callbacks are serialized on a specific perf event, but perf_close
isn't. perf generic codes have good consideration on it. Under guest/host environment,
we need new lock to coordinate it.

In addition, pls. consider a malicious guest os who might doesn't serialize
the operations to try to cause host kernel panic.

> >>      
> > This is to fight with malicious guest os kernel. Just like what I mention above,
> > the race might happen when:
> > 1) NMI handler accesses it;
> > 2) vmx_handle_exit codes access overflow_events to sync data to guest os;
> > 3) Another vcpu thread of the same guest os calls close to delete the perf_event;
> >    
> 
> This goes away with per-vcpu events.
Again, per-vcpu event couldn't work well with task context event in guest.

> 
> >>>    struct kvm_arch {
> >>>    	struct kvm_mem_aliases *aliases;
> >>>
> >>> @@ -415,6 +431,15 @@ struct kvm_arch {
> >>>    	/* fields used by HYPER-V emulation */
> >>>    	u64 hv_guest_os_id;
> >>>    	u64 hv_hypercall;
> >>> +
> >>> +	/*
> >>> +	 * fields used by PARAVIRT perf interface:
> >>> +	 * Used to organize all host perf_events representing guest
> >>> +	 * perf_event on a specific kvm instance
> >>> +	 */
> >>> +	atomic_t kvm_pv_event_num;
> >>> +	spinlock_t shadow_lock;
> >>> +	struct list_head *shadow_hash_table;
> >>>
> >>>        
> >> Need to be per-vcpu.  Also wrap in a kvm_vcpu_perf structure, the names
> >> are very generic.
If we move it to per-vcpu, host kernel need move the entry (struct host_perf_shadow)
among vcpu when an event be migrated to another vcpu. That causes codes a little complicated
and might introduce something like deadlock or new race. With my implementation, there is
only one potential performance issue as there are some lock contention on shadow_lock.
But the performance issue is not severe, because:
1) guest os doesn't support too many vcpu (usually no larger than 8);
2) host kernel doesn't lock shadow_lock when processing NMI and syncing data to guest;
3) if the event is per-cpu context, usually there is no much event disable/enable happening.

> >>      
> > Originally, I did so, but changed it to per kvm instance wide when considering
> > perf_event moving around vcpu threads.
> >    
> 
> I think this makes the code more complicated, needlessly.
Complicated mostly because host need to deal with malicious guest kernel.

It's often that it's easy to implement ordinary logic with fewer codes but add far more
codes to deal with error scenarios. For example, originally I sync data to guest os in host
NMI handler. With your suggestion to use kvm_read_guest/kvm_write_guest, I have to move them
to handle_exit or vcpu_enter_guest. To do so, I need save all pending event's pointers to
an array in vcpu struct. Then there would be new races, so I need add new lock to protect
or serialize some operations.

> 
> >>      
> >>>    /*
> >>>     * hypercalls use architecture specific
> >>> --- linux-2.6_tip0620/arch/x86/kvm/vmx.c	2010-06-21 15:19:39.322999849 +0800
> >>> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/vmx.c	2010-06-21 15:21:39.310999849 +0800
> >>> @@ -3647,6 +3647,7 @@ static int vmx_handle_exit(struct kvm_vc
> >>>    	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >>>    	u32 exit_reason = vmx->exit_reason;
> >>>    	u32 vectoring_info = vmx->idt_vectoring_info;
> >>> +	int ret;
> >>>
> >>>    	trace_kvm_exit(exit_reason, vcpu);
> >>>
> >>> @@ -3694,12 +3695,17 @@ static int vmx_handle_exit(struct kvm_vc
> >>>
> >>>    	if (exit_reason<   kvm_vmx_max_exit_handlers
> >>>    	&&   kvm_vmx_exit_handlers[exit_reason])
> >>> -		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> >>> +		ret = kvm_vmx_exit_handlers[exit_reason](vcpu);
> >>>    	else {
> >>>    		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> >>>    		vcpu->run->hw.hardware_exit_reason = exit_reason;
> >>> +		ret = 0;
> >>>    	}
> >>> -	return 0;
> >>> +
> >>> +	/* sync paravirt perf event to guest */
> >>> +	kvm_sync_events_to_guest(vcpu);
> >>>
> >>>        
> >> Why do that every exit?
> >> Why in vmx specific code?
> >>      
> > I could move it to the tail of vcpu_enter_guest. kvm_sync_events_to_guest
> > might go to sleep when going through guest os page tables, so we couldn't call it
> > by NMI handler.
> >    
> 
> But syncing every exit is expensive.  Use vcpu->requests to sync only 
> when the data has changed.
kvm_sync_events_to_guest has a checking. We sync data to guest only when:
1) an event overflows and host will sync _this_ event's data to guest;
2) sync data when guest calls DISABLE or READ hypercalls.

> 
> >>> +
> >>> +#define KVM_MAX_PARAVIRT_PERF_EVENT		(1024)
> >>>
> >>>        
> >> This is really high.  I don't think it's necessary, or useful since the
> >> underlying hardware has much fewer events, and since the guest can
> >> multiplex events itself.
> >>      
> > This limitation is different from hardware PMU counter imitation. When any application or
> > guest os vcpu thread creates perf_event, host kernel has no limitation. Kernel just arranges
> > all perf_event in a list (not considering group case) and schedules them to PMU hardware
> > by a round-robin method.
> >    
> 
> In practice, it will take such a long time to cycle through all events 
> that measurement quality will deteriorate.
There are 2 things.
1) We provide a good capability to support applications to submit more events;
2) Application just use a small group of event, typically one cpu context event per vcpu.

They are very different. As usual case about 2), the measurement quality wouldn't
deteriorate.


>   I prefer exposing a much 
> smaller number of events so that multiplexing on the host side will be 
> rare (for example, if both guest and host are monitoring at the same 
> time, or to accomodate hardware constraints).  If the guest needs 1024 
> events, it can schedule them itself (and then it knows the measurement 
> is very inaccurate due to sampling)
Guest os of linux does schedule them. By default, guest kernel enables
X86_PMC_IDX_MAX (64) events on a specific vpcu at the same time. See
function kvm_pmu_enable and kvm_add_event.

Exposing is different from disable/enable. If we expose/hide events when
enable/disable events, it consumes too much cpu resources as host kernel need to
create/delete the events frequently.

1024 is just the upper limitations that host could _create_ perf_event for
the guest os instance. If guest os is linux, most active events in host
for this guest os is VCPU_NUM*64.

> 
> > KVM_MAX_PARAVIRT_PERF_EVENT is to restrict guest os instance not to create too many
> > perf_event at host side which consumes too much memory of host kernel and slow the perf_event
> > schedule.
> >
> >    
> >>      
> >>> +static void kvm_copy_event_to_guest(struct kvm_vcpu *vcpu,
> >>> +			struct perf_event *host_event)
> >>> +{
> >>> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> >>> +	struct guest_perf_event counter;
> >>> +	int ret;
> >>> +	s32 overflows;
> >>> +
> >>> +	ret = kvm_read_guest(vcpu->kvm, shadow->guest_event_addr,
> >>> +				&counter, sizeof(counter));
> >>> +	if (ret<   0)
> >>> +		return;
> >>>
> >>>        
> >> Need better error handling.
> >>      
> > As host kernel saves/accumulate data in perf_event->host_perf_shadow.counter,
> > it doesn't matter to have one failure. next time when overflowing again, it will
> > copy all data back to guest os.
> >    
> 
> Next time we may fail too.  And next time as well.
How to process the failure? Kill the guest os? :)

> 
> 
> >>> +
> >>> +	counter.count = shadow->counter.count;
> >>> +	atomic_add(overflows,&counter.overflows);
> >>> +
> >>> +	kvm_write_guest(vcpu->kvm,
> >>> +			shadow->guest_event_addr,
> >>> +			&counter,
> >>> +			sizeof(counter));
> >>>
> >>>        
> >> kvm_write_guest() is _very_ nonatomic...
> >>      
> > It doesn't matter. There is only one potential race between host kernel and
> > guest kernel. When guest vmexits to host, it wouldn't access data pointed by
> > shadow->guest_event_addr. Above kvm_write_guest happens with the same vpcu.
> > So we just need make sure guest os vcpu accesses guest_perf_shadow->counter.overflows
> > atomically.
> >    
> 
> Well, without per-vcpu events, you can't guarantee this.
> 
> With per-vcpu events, I agree.
Frankly, I used per-vcpu in the beginning, but move to per-kvm after checking
every possible race issues.

> 
> 
> >>> +	/*
> >>> +	 * By default, we disable the host event. Later on, guets os
> >>> +	 * triggers a perf_event_attach to enable it
> >>> +	 */
> >>> +	attr->disabled = 1;
> >>> +	attr->inherit = 0;
> >>> +	attr->enable_on_exec = 0;
> >>> +	/*
> >>> +	 * We don't support exclude mode of user and kernel for guest os,
> >>> +	 * which mean we always collect both user and kernel for guest os
> >>> +	 */
> >>> +	attr->exclude_user = 0;
> >>> +	attr->exclude_kernel = 0;
> >>>
> >>>        
> >> First, if we don't support it, we should error out when the guest
> >> specifies it.  Don't lie to the guest.
> >>
> >> Second, why can't we support it?  should work for the guest just as it
> >> does for us.
> >>      
> > exclude_user and exclude_kernel are just hardware capability. Current PMU hardware
> > doesn't support virtualization. So when a counter is at exclude_user mode, we couldn't
> > collect any event happens in guest os. That's my direct thinking without architect
> > confirmation.
> >    
> 
> 1) IIUC exclude_user and exclude_kernel should just work.  They work by 
> counting only when the cpl matches, yes?  The hardware cpl is available 
> and valid in the guest.
Good pointer! Let me do some experiments to make sure it does work.

> 
> 2) We should atomically enable/disable the hardware performance counter 
> during guest entry/exit, like during ordinary context switch, so that 
> the guest doesn't measure host code (for example, ip would be 
> meaningless).
I once checked it. At least under the vcpu thread context after vmexit, host
code execution is for the guest. It's reasonable to count this part. If the
vcpu thread is scheduled out, host kernel disables all events binding to this vcpu
thread. ip is meaningless if NMI happens in host code path, but host kernel would
accumulate the overflow count into host_perf_shadow->counter.overflows. Next time
when NMI happens in guest os, host kernel inject NMI guest kernel, so guest uses
that pt_regs->ip.

>   Needs integration between perf core and kvm here.
> 
> >>> +
> >>> +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
> >>> +	if (!shadow) {
> >>> +		ret = -ENOMEM;
> >>> +		goto out;
> >>> +	}
> >>> +	shadow->id = param.id;
> >>> +	shadow->guest_event_addr = param.guest_event_addr;
> >>> +	shadow->vcpu = vcpu;
> >>> +	INIT_LIST_HEAD(&shadow->shadow_entry);
> >>> +
> >>> +	/* We always create a cpu context host perf event */
> >>> +	host_event = perf_event_create_kernel_counter(attr, -1,
> >>> +				current->pid, kvm_perf_event_overflow);
> >>>
> >>>        
> >> What does 'cpu context' mean in this context?
> >>      
> > Sorry, above comments are bad. Right one is:
> > /* We always create a process context host perf event */
> >
> > perf event generic has 2 context, process context and per cpu context. process
> > context event is to collect statistics of a specific thread (process), while
> > cpu context event is to collect statistics of this cpu.

Thanks for your detailed comments.
Yanmin


