Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1C3HU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:20:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52053 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1C3HU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:20:26 -0400
Message-ID: <4D92DA32.2010809@cn.fujitsu.com>
Date: Wed, 30 Mar 2011 15:22:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: paulmck@linux.vnet.ibm.com, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
References: <4D8FF8AD.5080607@cn.fujitsu.com> <4D8FF9BC.7050609@cn.fujitsu.com> <4D90647902000078000389CB@vpn.id2.novell.com> <4D924BAF.1020906@linux.intel.com> <20110329213130.GK2261@linux.vnet.ibm.com> <4D924FEE.8040804@linux.intel.com> <20110329214704.GM2261@linux.vnet.ibm.com> <4D9256AF.5000308@linux.intel.com> <20110330004725.GO2261@linux.vnet.ibm.com> <4D92BECA.50802@cn.fujitsu.com>
In-Reply-To: <4D92BECA.50802@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 15:18:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-30 15:18:51,
	Serialize complete at 2011-03-30 15:18:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 01:25 PM, Lai Jiangshan wrote:
> On 03/30/2011 08:47 AM, Paul E. McKenney wrote:
>> On Tue, Mar 29, 2011 at 03:01:19PM -0700, H. Peter Anvin wrote:
>>> On 03/29/2011 02:47 PM, Paul E. McKenney wrote:
>>>> On Tue, Mar 29, 2011 at 02:32:30PM -0700, H. Peter Anvin wrote:
>>>>> On 03/29/2011 02:31 PM, Paul E. McKenney wrote:
>>>>>>>
>>>>>>> I have to say that if we have to use hardcoded offsets in C then we have
>>>>>>> bigger problems.
>>>>>>
>>>>>> In this case, the offsets are mechanically generated from the structure
>>>>>> definitions.
>>>>>>
>>>>>> Or am I missing your point?
>>>>>
>>>>> Yes.  The point is if we have to pull out these kinds of hacks in *C*
>>>>> code, we are doing it wrong.  Not just a little wrong, but completely
>>>>> and totally bonkers wrong.
>>>>
>>>> OK, maybe we are doing it wrong.
>>>>
>>>> But in that case, how do you suggest restructuring include/linux/sched.h
>>>> so that struct task_struct can be safely included everywhere
>>>> rcu_read_lock() and friends are invoked?  Or, on the other hand,
>>>> what should we be doing so that we don't need to include task_struct
>>>> everywhere?
>>>
>>> Lai's text doesn't give any hint as to the specific nature of the
>>> conflict, which makes it hard to come up with a better alternative
>>> without having to rediscover the problem from first principles.
>>> However, a somewhat logical assumption is that the problem is that
>>> struct task_struct includes struct rcu_head, in which case the easiest
>>> thing to do is almost certainly to move the definition of struct
>>> rcu_head to its own header file, <linux/rcuhead.h>, and include that in
>>> <linux/sched.h>, which should make it possible to include
>>> <linux/sched.h> in <linux/rcupdate.h>.
>>
>> I believe that there are other circular dependencies -- there certainly
>> were a few years back -- but I will defer to Lai.
>>
>> 							Thanx, Paul
>>
> 
> Yes, there are other circular dependencies, <linux/sched.h> includes
> many files which include or indirectly include <linux/rcupdate.h>
> for struct rcu_head or RCU apis. There are too many to be split all.
> 

<linux/rcupdate.h> is so generic that it is included in many headers.
<linux/sched.h> is so complex that it includes many headers.

How many files which include(or indirectly include) <linux/rcupdate.h>
are included(or indirectly included) by <linux/sched.h>?

714 files! So I can guess 100 files at least is needed to be touched if
we resolve this problem by splitting.

include/linux/sched.h
include/linux/kernel.h
include/linux/timex.h
include/linux/jiffies.h
include/linux/rbtree.h
include/linux/thread_info.h
include/linux/cpumask.h
include/linux/nodemask.h
include/linux/mm_types.h
arch/alpha/include/asm/system.h
arch/arm/include/asm/system.h
arch/avr32/include/asm/system.h
arch/blackfin/include/asm/system.h
arch/cris/include/asm/system.h
arch/frv/include/asm/system.h
arch/h8300/include/asm/system.h
arch/ia64/include/asm/system.h
arch/m32r/include/asm/system.h
arch/microblaze/include/asm/system.h
arch/mips/include/asm/system.h
arch/mn10300/include/asm/system.h
arch/parisc/include/asm/system.h
arch/powerpc/include/asm/system.h
arch/s390/include/asm/system.h
arch/score/include/asm/system.h
arch/sh/include/asm/system.h
arch/sparc/include/asm/system.h
arch/tile/include/asm/system.h
arch/unicore32/include/asm/system.h
arch/x86/include/asm/system.h
arch/xtensa/include/asm/system.h
arch/mips/include/asm/page.h
arch/sh/include/asm/page.h
arch/powerpc/include/asm/ptrace.h
arch/sh/include/asm/ptrace.h
arch/sparc/include/asm/ptrace.h
arch/alpha/include/asm/cputime.h
arch/arm/include/asm/cputime.h
arch/avr32/include/asm/cputime.h
arch/blackfin/include/asm/cputime.h
arch/cris/include/asm/cputime.h
arch/frv/include/asm/cputime.h
arch/h8300/include/asm/cputime.h
arch/ia64/include/asm/cputime.h
arch/m32r/include/asm/cputime.h
arch/m68k/include/asm/cputime.h
arch/microblaze/include/asm/cputime.h
arch/mips/include/asm/cputime.h
arch/mn10300/include/asm/cputime.h
arch/parisc/include/asm/cputime.h
arch/powerpc/include/asm/cputime.h
arch/s390/include/asm/cputime.h
arch/score/include/asm/cputime.h
arch/sh/include/asm/cputime.h
arch/sparc/include/asm/cputime.h
arch/tile/include/asm/cputime.h
arch/um/include/asm/cputime.h
arch/x86/include/asm/cputime.h
arch/xtensa/include/asm/cputime.h
include/linux/smp.h
include/linux/sem.h
include/linux/signal.h
include/linux/completion.h
include/linux/pid.h
include/linux/percpu.h
include/linux/topology.h
include/linux/proportions.h
include/linux/seccomp.h
include/linux/rculist.h
include/linux/rtmutex.h
include/linux/time.h
include/linux/resource.h
include/linux/timer.h
include/linux/hrtimer.h
include/linux/cred.h
arch/cris/include/asm/processor.h
arch/h8300/include/asm/processor.h
arch/ia64/include/asm/processor.h
arch/m32r/include/asm/processor.h
arch/m68k/include/asm/processor.h
arch/mips/include/asm/processor.h
arch/mn10300/include/asm/processor.h
arch/parisc/include/asm/processor.h
arch/powerpc/include/asm/processor.h
arch/score/include/asm/processor.h
arch/sparc/include/asm/processor.h
arch/x86/include/asm/processor.h
include/linux/spinlock.h
include/linux/aio.h
arch/alpha/include/asm/current.h
arch/arm/include/asm/current.h
arch/avr32/include/asm/current.h
arch/blackfin/include/asm/current.h
arch/cris/include/asm/current.h
arch/h8300/include/asm/current.h
arch/m32r/include/asm/current.h
arch/m68k/include/asm/current.h
arch/mips/include/asm/current.h
arch/mn10300/include/asm/current.h
arch/parisc/include/asm/current.h
arch/powerpc/include/asm/current.h
arch/score/include/asm/current.h
arch/sh/include/asm/current.h
arch/sparc/include/asm/current.h
arch/tile/include/asm/current.h
arch/x86/include/asm/current.h
arch/xtensa/include/asm/current.h
include/linux/bitops.h
include/linux/log2.h
arch/s390/include/asm/bug.h
arch/arm/include/asm/div64.h
arch/ia64/include/asm/timex.h
arch/mips/include/asm/timex.h
arch/mn10300/include/asm/timex.h
arch/parisc/include/asm/timex.h
arch/sparc/include/asm/timex.h
arch/x86/include/asm/timex.h
include/linux/math64.h
arch/cris/include/asm/thread_info.h
arch/ia64/include/asm/thread_info.h
arch/m32r/include/asm/thread_info.h
arch/m68k/include/asm/thread_info.h
arch/mips/include/asm/thread_info.h
arch/parisc/include/asm/thread_info.h
arch/powerpc/include/asm/thread_info.h
arch/score/include/asm/thread_info.h
arch/sh/include/asm/thread_info.h
arch/sparc/include/asm/thread_info.h
arch/x86/include/asm/thread_info.h
include/linux/bitmap.h
include/linux/list.h
include/linux/rwsem.h
arch/sh/include/asm/mmu.h
arch/x86/include/asm/mmu.h
include/linux/irqflags.h
include/asm-generic/cmpxchg-local.h
arch/blackfin/include/asm/irq.h
arch/mips/include/asm/cmpxchg.h
arch/mips/include/asm/dsp.h
arch/mips/include/asm/watch.h
arch/mn10300/include/asm/atomic.h
arch/powerpc/include/asm/hw_irq.h
arch/sh/include/asm/uncached.h
arch/sparc/include/asm/system_64.h
arch/sparc/include/asm/system_32.h
arch/x86/include/asm/cpufeature.h
arch/x86/include/asm/paravirt.h
arch/mips/include/asm/io.h
include/asm-generic/cputime.h
arch/powerpc/include/asm/time.h
include/linux/preempt.h
arch/alpha/include/asm/smp.h
arch/arm/include/asm/smp.h
arch/blackfin/include/asm/smp.h
arch/cris/include/asm/smp.h
arch/ia64/include/asm/smp.h
arch/m32r/include/asm/smp.h
arch/mips/include/asm/smp.h
arch/mn10300/include/asm/smp.h
arch/parisc/include/asm/smp.h
arch/powerpc/include/asm/smp.h
arch/s390/include/asm/smp.h
arch/sh/include/asm/smp.h
arch/sparc/include/asm/smp.h
arch/tile/include/asm/smp.h
arch/x86/include/asm/smp.h
include/linux/ipc.h
arch/alpha/include/asm/atomic.h
arch/arm/include/asm/atomic.h
arch/avr32/include/asm/atomic.h
arch/blackfin/include/asm/atomic.h
arch/cris/include/asm/atomic.h
arch/frv/include/asm/atomic.h
arch/h8300/include/asm/atomic.h
arch/ia64/include/asm/atomic.h
arch/m32r/include/asm/atomic.h
arch/microblaze/include/asm/atomic.h
arch/mips/include/asm/atomic.h
arch/parisc/include/asm/atomic.h
arch/powerpc/include/asm/atomic.h
arch/s390/include/asm/atomic.h
arch/score/include/asm/atomic.h
arch/sh/include/asm/atomic.h
arch/sparc/include/asm/atomic.h
arch/tile/include/asm/atomic.h
arch/x86/include/asm/atomic.h
arch/xtensa/include/asm/atomic.h
include/linux/cache.h
arch/blackfin/include/asm/signal.h
arch/frv/include/asm/signal.h
arch/m32r/include/asm/signal.h
arch/microblaze/include/asm/signal.h
arch/s390/include/asm/signal.h
arch/score/include/asm/signal.h
arch/sh/include/asm/signal.h
arch/sparc/include/asm/signal.h
arch/tile/include/asm/signal.h
arch/x86/include/asm/signal.h
arch/sparc/include/asm/siginfo.h
include/linux/wait.h
arch/powerpc/include/asm/percpu.h
arch/x86/include/asm/percpu.h
include/linux/mmzone.h
arch/alpha/include/asm/topology.h
arch/ia64/include/asm/topology.h
arch/powerpc/include/asm/topology.h
arch/s390/include/asm/topology.h
arch/sparc/include/asm/topology.h
arch/tile/include/asm/topology.h
arch/x86/include/asm/topology.h
include/linux/percpu_counter.h
include/linux/mutex.h
include/linux/plist.h
include/linux/spinlock_types.h
include/linux/seqlock.h
include/linux/ktime.h
include/linux/debugobjects.h
include/linux/timerqueue.h
include/linux/key.h
arch/mips/include/asm/mipsregs.h
arch/mn10300/include/asm/uaccess.h
arch/sparc/include/asm/processor_64.h
arch/sparc/include/asm/processor_32.h
arch/x86/include/asm/msr.h
arch/alpha/include/asm/spinlock.h
arch/blackfin/include/asm/spinlock.h
arch/ia64/include/asm/spinlock.h
arch/m32r/include/asm/spinlock.h
arch/mn10300/include/asm/spinlock.h
arch/parisc/include/asm/spinlock.h
arch/powerpc/include/asm/spinlock.h
arch/s390/include/asm/spinlock.h
arch/tile/include/asm/spinlock.h
arch/x86/include/asm/spinlock.h
arch/xtensa/include/asm/spinlock.h
include/linux/workqueue.h
include/asm-generic/current.h
arch/powerpc/include/asm/paca.h
arch/arm/include/asm/bitops.h
arch/avr32/include/asm/bitops.h
arch/blackfin/include/asm/bitops.h
arch/cris/include/asm/bitops.h
arch/h8300/include/asm/bitops.h
arch/m32r/include/asm/bitops.h
arch/microblaze/include/asm/bitops.h
arch/mips/include/asm/bitops.h
arch/parisc/include/asm/bitops.h
arch/score/include/asm/bitops.h
arch/sh/include/asm/bitops.h
arch/tile/include/asm/bitops.h
arch/unicore32/include/asm/bitops.h
arch/x86/include/asm/bitops.h
arch/xtensa/include/asm/bitops.h
arch/mn10300/include/asm/hardirq.h
arch/sparc/include/asm/timex_64.h
arch/x86/include/asm/tsc.h
arch/sparc/include/asm/thread_info_64.h
arch/sparc/include/asm/thread_info_32.h
include/linux/prefetch.h
arch/alpha/include/asm/irqflags.h
arch/m68k/include/asm/irqflags.h
arch/mn10300/include/asm/irqflags.h
arch/powerpc/include/asm/irqflags.h
arch/x86/include/asm/irqflags.h
include/asm-generic/atomic.h
include/linux/bug.h
arch/sparc/include/asm/visasm.h
arch/powerpc/include/asm/iseries/hv_call.h
arch/ia64/include/asm/io.h
arch/mips/include/asm/smp-ops.h
arch/s390/include/asm/sigp.h
arch/sparc/include/asm/smp_64.h
arch/sparc/include/asm/smp_32.h
arch/x86/include/asm/apic.h
arch/x86/include/asm/cpumask.h
arch/sparc/include/asm/atomic_64.h
arch/sparc/include/asm/atomic_32.h
arch/x86/include/asm/alternative.h
include/asm-generic/signal.h
arch/sparc/include/asm/sigcontext.h
include/linux/compat.h
include/linux/memory_hotplug.h
arch/alpha/include/asm/mmzone.h
arch/m32r/include/asm/mmzone.h
arch/mips/include/asm/mmzone.h
arch/powerpc/include/asm/mmzone.h
arch/sparc/include/asm/mmzone.h
arch/ia64/include/asm/acpi.h
arch/ia64/include/asm/numa.h
arch/sparc/include/asm/topology_64.h
include/linux/lockdep.h
include/linux/mutex-debug.h
include/linux/sysctl.h
arch/tile/include/asm/spinlock_32.h
arch/powerpc/include/asm/lppaca.h
include/asm-generic/bitops/atomic.h
include/asm-generic/bitops.h
arch/tile/include/asm/bitops_32.h
include/linux/irq.h
arch/sparc/include/asm/timer.h
include/linux/hardirq.h
arch/ia64/include/asm/unaligned.h
include/linux/delay.h
include/linux/pm.h
arch/x86/include/asm/fixmap.h
arch/powerpc/include/asm/sigcontext.h
include/linux/stat.h
arch/mips/include/asm/compat.h
arch/parisc/include/asm/compat.h
arch/powerpc/include/asm/compat.h
arch/s390/include/asm/compat.h
arch/tile/include/asm/compat.h
arch/x86/include/asm/compat.h
include/linux/notifier.h
include/linux/debug_locks.h
include/linux/gfp.h
include/linux/irqnr.h
arch/ia64/include/asm/irq.h
arch/m68k/include/asm/irq.h
arch/mips/include/asm/irq.h
arch/parisc/include/asm/irq.h
arch/powerpc/include/asm/irq.h
arch/s390/include/asm/irq.h
arch/sh/include/asm/irq.h
arch/sparc/include/asm/irq.h
arch/tile/include/asm/irq.h
arch/x86/include/asm/irq.h
arch/alpha/include/asm/irq_regs.h
arch/arm/include/asm/irq_regs.h
arch/avr32/include/asm/irq_regs.h
arch/blackfin/include/asm/irq_regs.h
arch/cris/include/asm/irq_regs.h
arch/h8300/include/asm/irq_regs.h
arch/ia64/include/asm/irq_regs.h
arch/m32r/include/asm/irq_regs.h
arch/m68k/include/asm/irq_regs.h
arch/microblaze/include/asm/irq_regs.h
arch/mips/include/asm/irq_regs.h
arch/parisc/include/asm/irq_regs.h
arch/powerpc/include/asm/irq_regs.h
arch/s390/include/asm/irq_regs.h
arch/score/include/asm/irq_regs.h
arch/sh/include/asm/irq_regs.h
arch/sparc/include/asm/irq_regs.h
arch/tile/include/asm/irq_regs.h
arch/um/include/asm/irq_regs.h
arch/x86/include/asm/irq_regs.h
arch/xtensa/include/asm/irq_regs.h
arch/ia64/include/asm/hw_irq.h
arch/mips/include/asm/hw_irq.h
arch/sh/include/asm/hw_irq.h
arch/x86/include/asm/hw_irq.h
arch/sparc/include/asm/timer_32.h
arch/alpha/include/asm/hardirq.h
arch/arm/include/asm/hardirq.h
arch/avr32/include/asm/hardirq.h
arch/blackfin/include/asm/hardirq.h
arch/cris/include/asm/hardirq.h
arch/frv/include/asm/hardirq.h
arch/h8300/include/asm/hardirq.h
arch/ia64/include/asm/hardirq.h
arch/m32r/include/asm/hardirq.h
arch/microblaze/include/asm/hardirq.h
arch/mips/include/asm/hardirq.h
arch/parisc/include/asm/hardirq.h
arch/powerpc/include/asm/hardirq.h
arch/score/include/asm/hardirq.h
arch/sh/include/asm/hardirq.h
arch/sparc/include/asm/hardirq.h
arch/tile/include/asm/hardirq.h
arch/um/include/asm/hardirq.h
arch/x86/include/asm/hardirq.h
arch/xtensa/include/asm/hardirq.h
include/linux/unaligned/le_struct.h
arch/ia64/include/asm/delay.h
arch/parisc/include/asm/delay.h
arch/powerpc/include/asm/delay.h
arch/sparc/include/asm/delay.h
arch/x86/include/asm/acpi.h
arch/x86/include/asm/vsyscall.h
arch/powerpc/include/asm/elf.h
include/linux/srcu.h
arch/mips/include/asm/mipsmtregs.h
include/linux/radix-tree.h
arch/sh/include/asm/machvec.h
arch/sparc/include/asm/irq_64.h
arch/sparc/include/asm/irq_32.h
include/asm-generic/irq_regs.h
include/linux/interrupt.h
include/linux/profile.h
arch/ia64/include/asm/paravirt.h
arch/x86/include/asm/sections.h
include/asm-generic/hardirq.h
arch/sparc/include/asm/hardirq_64.h
arch/sparc/include/asm/hardirq_32.h
include/linux/unaligned/packed_struct.h
arch/sparc/include/asm/delay_32.h
arch/x86/include/asm/numa.h
arch/x86/include/asm/trampoline.h
include/trace/events/irq.h
arch/x86/include/asm/uaccess.h
arch/sparc/include/asm/cpudata.h
arch/x86/include/asm/io.h
include/linux/tracepoint.h
include/trace/define_trace.h
arch/sparc/include/asm/cpudata_64.h
arch/sparc/include/asm/cpudata_32.h
include/xen/xen.h
include/linux/vmalloc.h
include/linux/module.h
include/trace/ftrace.h
arch/ia64/include/asm/xen/hypervisor.h
arch/x86/include/asm/xen/hypervisor.h
include/linux/kmod.h
include/linux/elf.h
include/linux/kobject.h
include/linux/moduleparam.h
arch/mips/include/asm/module.h
arch/powerpc/include/asm/module.h
arch/score/include/asm/module.h
include/trace/events/module.h
include/linux/ftrace_event.h
arch/mn10300/include/asm/elf.h
arch/s390/include/asm/elf.h
arch/score/include/asm/elf.h
arch/sh/include/asm/elf.h
arch/sparc/include/asm/elf.h
arch/tile/include/asm/elf.h
arch/x86/include/asm/elf.h
include/linux/sysfs.h
arch/mips/include/asm/uaccess.h
arch/score/include/asm/uaccess.h
include/linux/ring_buffer.h
include/linux/trace_seq.h
include/linux/perf_event.h
include/linux/utsname.h
arch/mn10300/include/asm/user.h
arch/s390/include/asm/mmu_context.h
include/linux/ptrace.h
arch/sh/include/asm/user.h
arch/sparc/include/asm/elf_64.h
arch/sparc/include/asm/elf_32.h
arch/x86/include/asm/desc.h
include/linux/kmemcheck.h
include/linux/mm.h
include/linux/seq_file.h
include/linux/fs.h
include/linux/cgroup.h
arch/powerpc/include/asm/perf_event.h
arch/sparc/include/asm/perf_event.h
arch/x86/include/asm/perf_event.h
arch/alpha/include/asm/local64.h
arch/arm/include/asm/local64.h
arch/avr32/include/asm/local64.h
arch/blackfin/include/asm/local64.h
arch/cris/include/asm/local64.h
arch/frv/include/asm/local64.h
arch/h8300/include/asm/local64.h
arch/ia64/include/asm/local64.h
arch/m32r/include/asm/local64.h
arch/m68k/include/asm/local64.h
arch/microblaze/include/asm/local64.h
arch/mips/include/asm/local64.h
arch/mn10300/include/asm/local64.h
arch/parisc/include/asm/local64.h
arch/powerpc/include/asm/local64.h
arch/s390/include/asm/local64.h
arch/score/include/asm/local64.h
arch/sh/include/asm/local64.h
arch/sparc/include/asm/local64.h
arch/x86/include/asm/local64.h
arch/xtensa/include/asm/local64.h
arch/powerpc/include/asm/hw_breakpoint.h
arch/sh/include/asm/hw_breakpoint.h
arch/x86/include/asm/hw_breakpoint.h
include/linux/pid_namespace.h
include/linux/ftrace.h
include/linux/cpu.h
include/linux/jump_label_ref.h
arch/alpha/include/asm/local.h
arch/arm/include/asm/local.h
arch/avr32/include/asm/local.h
arch/blackfin/include/asm/local.h
arch/cris/include/asm/local.h
arch/frv/include/asm/local.h
arch/h8300/include/asm/local.h
arch/ia64/include/asm/local.h
arch/m32r/include/asm/local.h
arch/m68k/include/asm/local.h
arch/microblaze/include/asm/local.h
arch/mips/include/asm/local.h
arch/mn10300/include/asm/local.h
arch/parisc/include/asm/local.h
arch/powerpc/include/asm/local.h
arch/s390/include/asm/local.h
arch/score/include/asm/local.h
arch/sh/include/asm/local.h
arch/sparc/include/asm/local.h
arch/tile/include/asm/local.h
arch/x86/include/asm/local.h
arch/xtensa/include/asm/local.h
include/linux/nsproxy.h
arch/s390/include/asm/pgalloc.h
arch/s390/include/asm/uaccess.h
arch/s390/include/asm/tlbflush.h
arch/sparc/include/asm/uaccess.h
arch/sparc/include/asm/mbus.h
include/linux/bit_spinlock.h
arch/alpha/include/asm/pgtable.h
arch/arm/include/asm/pgtable.h
arch/avr32/include/asm/pgtable.h
arch/blackfin/include/asm/pgtable.h
arch/cris/include/asm/pgtable.h
arch/frv/include/asm/pgtable.h
arch/h8300/include/asm/pgtable.h
arch/ia64/include/asm/pgtable.h
arch/m32r/include/asm/pgtable.h
arch/microblaze/include/asm/pgtable.h
arch/mips/include/asm/pgtable.h
arch/mn10300/include/asm/pgtable.h
arch/parisc/include/asm/pgtable.h
arch/powerpc/include/asm/pgtable.h
arch/s390/include/asm/pgtable.h
arch/score/include/asm/pgtable.h
arch/sh/include/asm/pgtable.h
arch/sparc/include/asm/pgtable.h
arch/tile/include/asm/pgtable.h
arch/um/include/asm/pgtable.h
arch/unicore32/include/asm/pgtable.h
arch/x86/include/asm/pgtable.h
arch/xtensa/include/asm/pgtable.h
include/linux/page-flags.h
include/linux/vmstat.h
include/linux/dcache.h
include/linux/semaphore.h
include/linux/rculist_bl.h
include/linux/quota.h
include/linux/nfs_fs_i.h
include/linux/prio_heap.h
include/linux/idr.h
arch/powerpc/include/asm/perf_event_server.h
arch/powerpc/include/asm/perf_event_fsl_emb.h
arch/x86/include/asm/stacktrace.h
include/asm-generic/local64.h
include/linux/kdebug.h
include/linux/kallsyms.h
arch/blackfin/include/asm/ftrace.h
include/linux/sysdev.h
include/linux/node.h
include/asm-generic/local.h
arch/sparc/include/asm/uaccess_64.h
arch/sparc/include/asm/uaccess_32.h
arch/sparc/include/asm/viking.h
include/asm-generic/pgtable.h
include/linux/slab.h
arch/ia64/include/asm/cacheflush.h
arch/ia64/include/asm/mmu_context.h
arch/mips/include/asm/pgtable-32.h
arch/mips/include/asm/pgtable-64.h
arch/powerpc/include/asm/pgtable-ppc64.h
arch/powerpc/include/asm/pgtable-ppc32.h
arch/sh/include/asm/fixmap.h
arch/sh/include/asm/pgtable_64.h
arch/sparc/include/asm/pgtable_64.h
arch/sparc/include/asm/pgtable_32.h
arch/tile/include/asm/fixmap.h
include/linux/list_bl.h
include/linux/uaccess.h
arch/mips/include/asm/kdebug.h
arch/sparc/include/asm/kdebug.h
arch/x86/include/asm/kdebug.h
arch/sparc/include/asm/pgtsrmmu.h
include/linux/slub_def.h
include/linux/slab_def.h
arch/mips/include/asm/fixmap.h
arch/powerpc/include/asm/tlbflush.h
arch/powerpc/include/asm/io.h
include/linux/swap.h
arch/sparc/include/asm/oplib.h
arch/alpha/include/asm/uaccess.h
arch/arm/include/asm/uaccess.h
arch/avr32/include/asm/uaccess.h
arch/blackfin/include/asm/uaccess.h
arch/cris/include/asm/uaccess.h
arch/frv/include/asm/uaccess.h
arch/h8300/include/asm/uaccess.h
arch/ia64/include/asm/uaccess.h
arch/m32r/include/asm/uaccess.h
arch/microblaze/include/asm/uaccess.h
arch/parisc/include/asm/uaccess.h
arch/powerpc/include/asm/uaccess.h
arch/sh/include/asm/uaccess.h
arch/tile/include/asm/uaccess.h
arch/unicore32/include/asm/uaccess.h
arch/xtensa/include/asm/uaccess.h
arch/sparc/include/asm/kdebug_32.h
include/trace/events/kmem.h
include/linux/device.h
include/linux/io.h
arch/powerpc/include/asm/eeh.h
include/linux/memcontrol.h
arch/sparc/include/asm/oplib_64.h
arch/sparc/include/asm/oplib_32.h
include/asm-generic/uaccess.h
arch/sparc/include/asm/openprom.h
include/linux/klist.h
arch/sparc/include/asm/device.h
arch/alpha/include/asm/io.h
arch/arm/include/asm/io.h
arch/avr32/include/asm/io.h
arch/blackfin/include/asm/io.h
arch/cris/include/asm/io.h
arch/frv/include/asm/io.h
arch/microblaze/include/asm/io.h
arch/mn10300/include/asm/io.h
arch/parisc/include/asm/io.h
arch/score/include/asm/io.h
arch/sh/include/asm/io.h
arch/sparc/include/asm/io.h
arch/tile/include/asm/io.h
arch/unicore32/include/asm/io.h
arch/xtensa/include/asm/io.h
arch/xtensa/include/asm/segment.h
include/linux/of.h
arch/alpha/include/asm/core_lca.h
arch/alpha/include/asm/core_marvel.h
arch/alpha/include/asm/core_t2.h
include/asm-generic/io.h
arch/mn10300/include/asm/cacheflush.h
arch/sh/include/asm/io_trapped.h
arch/sparc/include/asm/io_64.h
arch/sparc/include/asm/io_32.h
arch/microblaze/include/asm/prom.h
arch/powerpc/include/asm/prom.h
arch/sparc/include/asm/prom.h
arch/x86/include/asm/prom.h
arch/alpha/include/asm/cacheflush.h
arch/arm/include/asm/cacheflush.h
arch/avr32/include/asm/cacheflush.h
arch/blackfin/include/asm/cacheflush.h
arch/cris/include/asm/cacheflush.h
arch/frv/include/asm/cacheflush.h
arch/m32r/include/asm/cacheflush.h
arch/microblaze/include/asm/cacheflush.h
arch/mips/include/asm/cacheflush.h
arch/parisc/include/asm/cacheflush.h
arch/powerpc/include/asm/cacheflush.h
arch/s390/include/asm/cacheflush.h
arch/score/include/asm/cacheflush.h
arch/sh/include/asm/cacheflush.h
arch/sparc/include/asm/cacheflush.h
arch/tile/include/asm/cacheflush.h
arch/unicore32/include/asm/cacheflush.h
arch/x86/include/asm/cacheflush.h
arch/xtensa/include/asm/cacheflush.h
include/linux/of_irq.h
include/linux/platform_device.h
include/linux/of_address.h
include/linux/proc_fs.h
include/linux/pci.h
include/asm-generic/cacheflush.h
arch/sparc/include/asm/cacheflush_64.h
arch/sparc/include/asm/cacheflush_32.h
include/linux/dmapool.h
arch/alpha/include/asm/pci.h
arch/arm/include/asm/pci.h
arch/avr32/include/asm/pci.h
arch/blackfin/include/asm/pci.h
arch/cris/include/asm/pci.h
arch/frv/include/asm/pci.h
arch/ia64/include/asm/pci.h
arch/m68k/include/asm/pci.h
arch/microblaze/include/asm/pci.h
arch/mips/include/asm/pci.h
arch/mn10300/include/asm/pci.h
arch/parisc/include/asm/pci.h
arch/powerpc/include/asm/pci.h
arch/sh/include/asm/pci.h
arch/sparc/include/asm/pci.h
arch/tile/include/asm/pci.h
arch/unicore32/include/asm/pci.h
arch/x86/include/asm/pci.h
arch/xtensa/include/asm/pci.h
arch/powerpc/include/asm/scatterlist.h
include/linux/dma-mapping.h
include/asm-generic/pci-dma-compat.h
arch/microblaze/include/asm/pci-bridge.h
arch/powerpc/include/asm/machdep.h
arch/powerpc/include/asm/pci-bridge.h
arch/sparc/include/asm/pci_64.h
arch/sparc/include/asm/pci_32.h
arch/powerpc/include/asm/dma.h
include/linux/dma-attrs.h
include/linux/scatterlist.h
arch/alpha/include/asm/dma-mapping.h
arch/arm/include/asm/dma-mapping.h
arch/avr32/include/asm/dma-mapping.h
arch/blackfin/include/asm/dma-mapping.h
arch/cris/include/asm/dma-mapping.h
arch/frv/include/asm/dma-mapping.h
arch/ia64/include/asm/dma-mapping.h
arch/microblaze/include/asm/dma-mapping.h
arch/mips/include/asm/dma-mapping.h
arch/mn10300/include/asm/dma-mapping.h
arch/parisc/include/asm/dma-mapping.h
arch/powerpc/include/asm/dma-mapping.h
arch/sh/include/asm/dma-mapping.h
arch/sparc/include/asm/dma-mapping.h
arch/tile/include/asm/dma-mapping.h
arch/unicore32/include/asm/dma-mapping.h
arch/x86/include/asm/dma-mapping.h
arch/xtensa/include/asm/dma-mapping.h
include/asm-generic/dma-mapping-common.h
arch/ia64/include/asm/swiotlb.h


#!/bin/python

import re
include_re = re.compile(r'#\s*include\s*<([_\-\w]*)([/\._\-\w]*)>')
leaf_file = ('linux', '/rcupdate.h')
archs_dir = (
  'arch/alpha/',
  'arch/arm/',
  'arch/avr32/',
  'arch/blackfin/',
  'arch/cris/',
  'arch/frv/',
  'arch/h8300/',
  'arch/ia64/',
  'arch/m32r/',
  'arch/m68k/',
  'arch/m68knommu/',
  'arch/microblaze/',
  'arch/mips/',
  'arch/mn10300/',
  'arch/parisc/',
  'arch/powerpc/',
  'arch/s390/',
  'arch/score/',
  'arch/sh/',
  'arch/sparc/',
  'arch/tile/',
  'arch/um/',
  'arch/unicore32/',
  'arch/x86/',
  'arch/xtensa/',
)

generic_dir = 'include/'
searched = {('include/linux','/rcupdate.h'):1}
searchqueue = []

def add(f):
  if searched.has_key(f):
     return
  searched[f] = 0
  searchqueue.append(f)

def addall():
  i = 0
  while i < len(searchqueue):
    f=searchqueue[i]
    i=i+1
    try:
      ff = file(f[0]+f[1])
    except:
      continue
    for ch in include_re.findall(ff.read()):
      if ch[0] == 'asm':
        if f[0][0:4] == 'arch':
          add((f[0], ch[1]))
          continue
        for dir in archs_dir:
          add((dir+'include/asm', ch[1]))
      else:
        add((generic_dir+ch[0], ch[1]))

def markall():
  for f in searchqueue:
    res = 0
    try:
      ff = file(f[0]+f[1])
    except:
      continue
    for ch in include_re.findall(ff.read()):
      if ch[0] == 'asm':
        if f[0][0:4] == 'arch':
          res = res or searched[(f[0], ch[1])]
          continue
        for dir in archs_dir:
          res = res or searched[(dir+'include/asm', ch[1])]
      else:
        res = res or searched[(generic_dir+ch[0], ch[1])]
    searched[f]=res

add(('include/linux', '/sched.h'))
addall()
# I'm lazy to build a map and the reverse map..., thousands of headers is not
# too much for this. add enough markall() until the result output is not changed
markall()
markall()
markall()
markall()
markall()
markall()
markall()
markall()
markall()
markall()
markall()
#markall()
#print len(searchqueue)
for f in searchqueue:
  if searched[f]:
    print f[0]+f[1]

