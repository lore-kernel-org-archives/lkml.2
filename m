Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3AJRdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:33:39 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:37542 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab3AJRdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:33:38 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: [RFC][PATCH v7 0/2]trace,x86: irq vector tracepoint support
Thread-Topic: [RFC][PATCH v7 0/2]trace,x86: irq vector tracepoint support
Thread-Index: Ac3vV1mL8i3mSwBQRw+edh4jLezwfg==
Date: Thu, 10 Jan 2013 17:32:41 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D260@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-10_08:2013-01-10,2013-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301100141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log 

 v6 -> v7
 - Divide into two patches to make a code review easier.
   Summery of each patch is as follows.
    - Patch 1/2
      - Add an irq_vector tracing infrastructure.
      - Create idt_table for tracing. It is refactored to avoid duplicating
        existing logic.
      - Duplicate new irq handlers inserted tracepoints.

    - Patch 2/2
      - Share a common logic among irq handlers to make them
        manageable and readable.

 v5 -> v6
 - Rebased to 3.7

 v4 -> v5
 - Rebased to 3.6.0

 - Introduce a logic switching IDT at enabling/disabling TP time 
   so that a time penalty makes a zero when tracepoints are disabled.
   This IDT is created only when CONFIG_TRACEPOINTS is enabled.

 - Remove arch_irq_vector_entry/exit and add followings again
   so that we can add each tracepoint in a generic way.
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

 - Drop nmi tracepoints to begin with apic interrupts and discuss a logic switching
   IDT first.

 - Move irq_vectors.h in the directory of arch/x86/include/asm/trace because
   I'm not sure if a logic switching IDT is sharable with other architectures.

 v3 -> v4
 - Add a latency measurement of each tracepoint
 - Rebased to 3.6-rc6

 v2 -> v3
 - Remove an invalidate_tlb_vector event because it was replaced by a call function vector
   in a following commit.
   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=52aec3308db85f4e9f5c8b9f5dc4fbd0138c6fa4

 v1 -> v2
 - Modify variable name from irq to vector.
 - Merge arch-specific tracepoints below to an arch_irq_vector_entry/exit.
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

[Purpose of this patch]

As Vaibhav explained in the thread below, tracepoints for irq vectors
are useful.

http://www.spinics.net/lists/mm-commits/msg85707.html

<snip>
The current interrupt traces from irq_handler_entry and irq_handler_exit
provide when an interrupt is handled.  They provide good data about when
the system has switched to kernel space and how it affects the currently
running processes.

There are some IRQ vectors which trigger the system into kernel space,
which are not handled in generic IRQ handlers.  Tracing such events gives
us the information about IRQ interaction with other system events.

The trace also tells where the system is spending its time.  We want to
know which cores are handling interrupts and how they are affecting other
processes in the system.  Also, the trace provides information about when
the cores are idle and which interrupts are changing that state.
<snip>

On the other hand, my usecase is tracing just local timer event and 
getting a value of instruction pointer.

I suggested to add an argument local timer event to get instruction pointer before.
But there is another way to get it with external module like systemtap.
So, I don't need to add any argument to irq vector tracepoints now.

[Patch Description]

Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
But there is an above use case to trace specific irq_vector rather than tracing all events.
In this case, we are concerned about overhead due to unwanted events.

This patch adds following tracepoints instead of introducing irq_vector_entry/exit.
so that we can enable them independently.
   - local_timer_vector
   - reschedule_vector
   - call_function_vector
   - call_function_single_vector 
   - irq_work_entry_vector
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

Please see descriptions in each patch.

Seiji Aguchi (2):
  [RFC][PATCH v7 1/2] trace,x86: add x86 irq vector tracepoints
  [RFC][PATCH v7 2/2] trace,x86: code-sharing between non-trace and trace irq handlers

 arch/x86/include/asm/desc.h              |   31 ++++++-
 arch/x86/include/asm/entry_arch.h        |    5 +-
 arch/x86/include/asm/hw_irq.h            |   16 +++
 arch/x86/include/asm/trace/irq_vectors.h |  154 ++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile                 |    1 +
 arch/x86/kernel/apic/apic.c              |   71 +++++++++++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   24 ++++-
 arch/x86/kernel/cpu/mcheck/threshold.c   |   24 ++++-
 arch/x86/kernel/entry_32.S               |   12 ++-
 arch/x86/kernel/entry_64.S               |   27 ++++-
 arch/x86/kernel/head_64.S                |    6 +
 arch/x86/kernel/irq.c                    |   31 ++++--
 arch/x86/kernel/irq_work.c               |   24 ++++-
 arch/x86/kernel/smp.c                    |   65 +++++++++++--
 arch/x86/kernel/tracepoint.c             |   61 ++++++++++++
 include/linux/hardirq.h                  |   25 +++++
 include/xen/events.h                     |    3 +
 17 files changed, 526 insertions(+), 54 deletions(-)

