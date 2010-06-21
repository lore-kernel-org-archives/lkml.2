Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0FULpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:45:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab0FULpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:45:47 -0400
Message-ID: <4C1F50D0.70205@redhat.com>
Date: Mon, 21 Jun 2010 14:45:20 +0300
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
Subject: Re: [PATCH V2 1/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 12:31 PM, Zhang, Yanmin wrote:
> Here is the version 2.
>
> ChangeLog since V1: Mostly changes based on Avi's suggestions.
> 	1) Use a id to identify the perf_event between host and guest;
> 	2) Changes lots of codes to deal with malicious guest os;
> 	3) Add a perf_event number limitation per gust os instance;
> 	4) Support guest os on the top of another guest os scenario. But
> 	I didn't test it yet as there is no environment. The design is to
> 	add 2 pointers in struct perf_event. One is used by host and the
> 	other is used by guest.
> 	5) Fix the bug to support 'perf stat'. The key is sync count data
> 	back to guest when guest tries to disable the perf_event at host
> 	side.
> 	6) Add a clear ABI of PV perf.
>
>    

Please use meaningful subject lines for individual patches.

> I don't implement live migration feature.
>
> Avi,
> Is live migration necessary on pv perf support?
>    

Yes.

> --- linux-2.6_tip0620/Documentation/kvm/paravirt-perf.txt	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6_tip0620perfkvm/Documentation/kvm/paravirt-perf.txt	2010-06-21 15:21:39.312999849 +0800
> @@ -0,0 +1,133 @@
> +The x86 kvm paravirt perf event interface
> +===================================
> +
> +This paravirt interface is responsible for supporting guest os perf event
> +collections. If guest os supports this interface, users could run command
> +perf in guest os directly.
> +
> +Design
> +========
> +
> +Guest os calls a series of hypercalls to communicate with host kernel to
> +create/enable/disable/close perf events. Host kernel notifies guest os
> +by injecting an NMI to guest os when an event overflows. Guets os need
> +go through all its active events to check if they overflow, and output
> +performance statistics if they do.
> +
> +ABI
> +=====
> +
> +1) Detect if host kernel supports paravirt perf interface:
> +#define KVM_FEATURE_PV_PERF       4
> +Host kernel defines above cpuid bit. Guest os calls cpuid to check if host
> +os retuns this bit. If it does, it mean host kernel supports paravirt perf
> +interface.
> +
> +2) Open a new event at host side:
> +kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, param_addr_low32bit,
> +param_addr_high32bit);
> +
> +#define KVM_PERF_OP                    3
> +/* Operations for KVM_PERF_OP */
> +#define KVM_PERF_OP_OPEN                1
> +#define KVM_PERF_OP_CLOSE               2
> +#define KVM_PERF_OP_ENABLE              3
> +#define KVM_PERF_OP_DISABLE             4
> +#define KVM_PERF_OP_READ                5
>    

> +/*
> + * guest_perf_attr is used when guest calls hypercall to
> + * open a new perf_event at host side. Mostly, it's a copy of
> + * perf_event_attr and deletes something not used by host kernel.
> + */
> +struct guest_perf_attr {
> +        __u32                   type;
>    

Need padding here, otherwise the structure is different on 32-bit and 
64-bit guests.

> +        __u64                   config;
> +        __u64                   sample_period;
> +        __u64                   sample_type;
> +        __u64                   read_format;
> +        __u64                   flags;
>    

and here.

> +        __u32                   bp_type;
> +        __u64                   bp_addr;
> +        __u64                   bp_len;
>    

Do we actually support breakpoints on the guest?  Note the hardware 
breakpoints are also usable by the guest, so if the host uses them, we 
won't be able to emulate them correctly.  We can let the guest to 
breakpoint perf monitoring itself and drop this feature.

> +};
>    

What about documentation for individual fields?  Esp. type, config, and 
flags, but also the others.

> +/*
> + * data communication area about perf_event between
> + * Host kernel and guest kernel
> + */
> +struct guest_perf_event {
> +        u64 count;
> +        atomic_t overflows;
>    

Please use __u64 and __u32, assume guests don't have Linux internal 
types (though of course the first guest _is_ Linux).

Add padding to 64-bit.

> +};
> +struct guest_perf_event_param {
> +        __u64 attr_addr;
> +        __u64 guest_event_addr;
> +        /* In case there is an alignment issue, we put id as the last one */
> +        int id;
>    

Add explicit padding to be sure.

Also makes sense to add a flags field for future expansion.

> +};
> +
> +param_addr_low32bit and param_addr_high32bit compose a u64 integer which means
> +the physical address of parameter struct guest_perf_event_param.
> +struct guest_perf_event_param consists of 3 members. attr_addr has the
> +physical address of parameter struct guest_perf_attr. guest_event_addr has the
> +physical address of a parameter whose type is struct guest_perf_eventi which
> +has to be aligned with 4 bytes.
> +guest os need allocate an exclusive id per event in this guest os instance, and save it to
> +guest_perf_event_param->id. Later on, the id is the only method to notify host
> +kernel about on what event guest os wants host kernel to operate.
>    

Need a way to expose the maximum number of events available to the 
guest.  I suggest exposing it in cpuid, and requiring 0 <= id < MAX_EVENTS.

> +guest_perf_event->count saves the latest count of the event.
> +guest_perf_event->overflows means how many times this event has overflowed
> +since guest os processes it. Host kernel just inc guest_perf_event->overflows
> +when the event overflows. Guest kernel should use a atomic_cmpxchg to reset
> +guest_perf_event->overflows to 0 in case there is a race between its reset by
> +guest os and host kernel data update.
>    

Is overflows really needed?  Since the guest can use NMI to read the 
counter, it should have the highest possible priority, and thus it 
shouldn't see any overflow unless it configured the threshold really low.

If we drop overflow, we can use the RDPMC instruction instead of 
KVM_PERF_OP_READ.  This allows the guest to allow userspace to read a 
counter, or prevent userspace from reading the counter, by setting cr4.pce.

> +Host kernel saves count and overflow update information into guest_perf_event
> +pointed by guest_perf_event_param->guest_event_addr.
> +
> +After host kernel creates the event, this event is at disabled mode.
> +
> +This hypercall3 return 0 when host kernel creates the event successfully. Or
> +other value if it fails.
> +
> +3) Enable event at host side:
> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_ENABLE, id);
> +
> +Parameter id means the event id allocated by guest os. Guest os need call this
> +hypercall to enable the event at host side. Then, host side will really start
> +to collect statistics by this event.
> +
> +This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
> +
> +
> +4) Disable event at host side:
> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_DISABLE, id);
> +
> +Parameter id means the event id allocated by guest os. Guest os need call this
> +hypercall to disable the event at host side. Then, host side will stop
> +statistics collection initiated by the event.
> +
> +This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
> +
> +
> +5) Close event at host side:
> +kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_CLOSE, id);
> +it will close and delete the event at host side.
>    

What about using MSRs to configure the counter like real hardware?  That 
takes care of live migration, since we already migrate MSRs.  At the end 
of the migration userspace will read all config and counter data from 
the source and transfer it to the destination.  This should work with 
existing userspace since we query the MSR index list from the host.


> +
> +8) NMI notification from host kernel:
> +When an event overflows at host side, host kernel injects an NMI to guest os.
> +Guest os has to check all its active events in guest os NMI handler.
>    

Item 8) -> 6) :)

Should be via the performance counter LVT.  Since we lack infrastructure 
for this at the moment, direct NMI delivery is fine.  I'm working on 
that infrastructure now.

> +
> +
> +Usage flow at guest side
> +=============
> +1) Guest os registers an NMI handler to prepare to process all active event
> +overflows.
> +2) Guest os calls hypercall3(..., KVM_PERF_OP_OPEN, ...) to create an event at
> +host side.
> +3) Guest os calls hypercall2 (..., KVM_PERF_OP_ENABLE, ...) to enable the
> +event.
> +4) Guest os calls hypercall2 (..., KVM_PERF_OP_DISABLE, ...) to disable the
> +event.
> +5) Guest os could repeat 3) and 4).
> +6) Guest os calls hypercall2 (..., KVM_PERF_OP_CLOSE, ...) to close the event.
> +
> +
>    

How does OP_READ work?  simply update the guest_perf structure?

-- 
error compiling committee.c: too many arguments to function

