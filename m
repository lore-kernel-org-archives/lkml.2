Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab0FUJbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:31:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:59369 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab0FUJbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="528717307"
Subject: [PATCH V2 1/5] ara virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 21 Jun 2010 17:31:20 +0800
Message-Id: <1277112680.2096.509.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the version 2.

ChangeLog since V1: Mostly changes based on Avi's suggestions.
	1) Use a id to identify the perf_event between host and guest;
	2) Changes lots of codes to deal with malicious guest os;
	3) Add a perf_event number limitation per gust os instance;
	4) Support guest os on the top of another guest os scenario. But
	I didn't test it yet as there is no environment. The design is to
	add 2 pointers in struct perf_event. One is used by host and the
	other is used by guest.
	5) Fix the bug to support 'perf stat'. The key is sync count data
	back to guest when guest tries to disable the perf_event at host
	side.
	6) Add a clear ABI of PV perf.

I don't implement live migration feature.

Avi,
Is live migration necessary on pv perf support?


Based on Ingo's idea, I implement a para virt interface for perf to support
statistics collection in guest os. That means we could run tool perf in guest
os directly.

Great thanks to Peter Zijlstra. He is really the architect and gave me architecture
design suggestions. I also want to thank Yangsheng and LinMing for their generous
help.

The design is:

1) Add a kvm_pmu whose callbacks mostly just calls hypercall to vmexit to host kernel;
2) Create a host perf_event per guest perf_event;
3) Host kernel syncs perf_event count/overflows data changes to guest perf_event
when processing perf_event overflows after NMI arrives. Host kernel inject NMI to guest
kernel if a guest event overflows.
4) Guest kernel goes through all enabled event on current cpu and output data when they
overflows.
5) No change in user space.

Below is an example.

#perf top
--------------------------------------------------------------------------------------------------------------------------
   PerfTop:    7954 irqs/sec  kernel:79.5%  exact:  0.0% [1000Hz cycles],  (all, 8 CPUs)
--------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________ _________________________________________________________

             5315.00  4.9% copy_user_generic_string /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             3342.00  3.1% add_preempt_count        /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             3338.00  3.1% sub_preempt_count        /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2454.00  2.3% pvclock_clocksource_read /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2434.00  2.3% tcp_sendmsg              /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2090.00  1.9% child_run                /bm/tmp/benchmarks/run_bmtbench/dbench/dbench-3.03/tbench
             2081.00  1.9% debug_smp_processor_id   /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2003.00  1.9% __GI_strstr              /lib64/libc-2.11.so                                      
             1999.00  1.9% __strchr_sse2            /lib64/libc-2.11.so                                      
             1983.00  1.8% tcp_ack                  /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1800.00  1.7% tcp_transmit_skb         /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1727.00  1.6% schedule                 /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1706.00  1.6% __libc_recv              /lib64/libc-2.11.so                                      
             1702.00  1.6% __GI_memchr              /lib64/libc-2.11.so                                      
             1580.00  1.5% tcp_recvmsg              /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      

The patch is against tip/master tree of June 20st.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6_tip0620/Documentation/kvm/paravirt-perf.txt	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6_tip0620perfkvm/Documentation/kvm/paravirt-perf.txt	2010-06-21 15:21:39.312999849 +0800
@@ -0,0 +1,133 @@
+The x86 kvm paravirt perf event interface
+===================================
+
+This paravirt interface is responsible for supporting guest os perf event
+collections. If guest os supports this interface, users could run command
+perf in guest os directly.
+
+Design
+========
+
+Guest os calls a series of hypercalls to communicate with host kernel to
+create/enable/disable/close perf events. Host kernel notifies guest os
+by injecting an NMI to guest os when an event overflows. Guets os need
+go through all its active events to check if they overflow, and output
+performance statistics if they do.
+
+ABI
+=====
+
+1) Detect if host kernel supports paravirt perf interface:
+#define KVM_FEATURE_PV_PERF       4
+Host kernel defines above cpuid bit. Guest os calls cpuid to check if host
+os retuns this bit. If it does, it mean host kernel supports paravirt perf
+interface.
+
+2) Open a new event at host side:
+kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, param_addr_low32bit,
+param_addr_high32bit);
+
+#define KVM_PERF_OP                    3
+/* Operations for KVM_PERF_OP */
+#define KVM_PERF_OP_OPEN                1
+#define KVM_PERF_OP_CLOSE               2
+#define KVM_PERF_OP_ENABLE              3
+#define KVM_PERF_OP_DISABLE             4
+#define KVM_PERF_OP_READ                5
+/*
+ * guest_perf_attr is used when guest calls hypercall to
+ * open a new perf_event at host side. Mostly, it's a copy of
+ * perf_event_attr and deletes something not used by host kernel.
+ */
+struct guest_perf_attr {
+        __u32                   type;
+        __u64                   config;
+        __u64                   sample_period;
+        __u64                   sample_type;
+        __u64                   read_format;
+        __u64                   flags;
+        __u32                   bp_type;
+        __u64                   bp_addr;
+        __u64                   bp_len;
+};
+/*
+ * data communication area about perf_event between
+ * Host kernel and guest kernel
+ */
+struct guest_perf_event {
+        u64 count;
+        atomic_t overflows;
+};
+struct guest_perf_event_param {
+        __u64 attr_addr;
+        __u64 guest_event_addr;
+        /* In case there is an alignment issue, we put id as the last one */
+        int id;
+};
+
+param_addr_low32bit and param_addr_high32bit compose a u64 integer which means
+the physical address of parameter struct guest_perf_event_param.
+struct guest_perf_event_param consists of 3 members. attr_addr has the
+physical address of parameter struct guest_perf_attr. guest_event_addr has the
+physical address of a parameter whose type is struct guest_perf_eventi which
+has to be aligned with 4 bytes.
+guest os need allocate an exclusive id per event in this guest os instance, and save it to
+guest_perf_event_param->id. Later on, the id is the only method to notify host
+kernel about on what event guest os wants host kernel to operate.
+guest_perf_event->count saves the latest count of the event.
+guest_perf_event->overflows means how many times this event has overflowed
+since guest os processes it. Host kernel just inc guest_perf_event->overflows
+when the event overflows. Guest kernel should use a atomic_cmpxchg to reset
+guest_perf_event->overflows to 0 in case there is a race between its reset by
+guest os and host kernel data update.
+Host kernel saves count and overflow update information into guest_perf_event
+pointed by guest_perf_event_param->guest_event_addr.
+
+After host kernel creates the event, this event is at disabled mode.
+
+This hypercall3 return 0 when host kernel creates the event successfully. Or
+other value if it fails.
+
+3) Enable event at host side:
+kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_ENABLE, id);
+
+Parameter id means the event id allocated by guest os. Guest os need call this
+hypercall to enable the event at host side. Then, host side will really start
+to collect statistics by this event.
+
+This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
+
+
+4) Disable event at host side:
+kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_DISABLE, id);
+
+Parameter id means the event id allocated by guest os. Guest os need call this
+hypercall to disable the event at host side. Then, host side will stop
+statistics collection initiated by the event.
+
+This hypercall3 return 0 if host kernel succeds. Or other value if it fails.
+
+
+5) Close event at host side:
+kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_CLOSE, id);
+it will close and delete the event at host side.
+
+8) NMI notification from host kernel:
+When an event overflows at host side, host kernel injects an NMI to guest os.
+Guest os has to check all its active events in guest os NMI handler.
+
+
+Usage flow at guest side
+=============
+1) Guest os registers an NMI handler to prepare to process all active event
+overflows.
+2) Guest os calls hypercall3(..., KVM_PERF_OP_OPEN, ...) to create an event at
+host side.
+3) Guest os calls hypercall2 (..., KVM_PERF_OP_ENABLE, ...) to enable the
+event.
+4) Guest os calls hypercall2 (..., KVM_PERF_OP_DISABLE, ...) to disable the
+event.
+5) Guest os could repeat 3) and 4).
+6) Guest os calls hypercall2 (..., KVM_PERF_OP_CLOSE, ...) to close the event.
+
+


