Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab1ITNti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:49:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:37711 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1ITNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:49:37 -0400
Date: Tue, 20 Sep 2011 15:49:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@gentwo.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <alpine.DEB.2.00.1109191657150.19059@router.home>
Message-ID: <alpine.LFD.2.02.1109201334590.2723@ionos>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Christoph Lameter wrote:

> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > The code in mod_state() is already made to handle the raciness of
> > this_cpu_read(). Have the code use __this_cpu_read() instead so
> > the debug code does not trigger warnings about it.
> 
> Why would there be a warning triggered? this_cpu_read should take care of
> disabling preemption for the read if needed. In fact the fallback case
> does do exactly that.

And what exactly is the purpose of having a preempt_disable()/enable()
pair in this_cpu_read()?

Nothing, AFAICT. And looking at the usage:

arch/x86/lib/delay.c:124:               (this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));

Pointless, as we do not care about which loops_per_jiffy we access.

arch/x86/mm/tlb.c:179:  sender = this_cpu_read(tlb_vector_offset);

Pointless, as all callers have preemption disabled. 

drivers/acpi/processor_throttling.c:719:        if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||
drivers/acpi/processor_throttling.c:740:        if ((this_cpu_read(cpu_info.x86_vendor) != X86_VENDOR_INTEL) ||

The conversion was made in commit 9d42a53e with a lousy changelog and
this_cpu_read() with the given semantics is simply crap as this code
wants to run on a given cpu as we access msrs which we don't want to
do in a random fashion. In fact if you had used __this_cpu_read() and
that code would have contained a debug check then the callchain coming
up from thermal_cooling_device_cur_state_store() would have triggered
it AFAICT.

drivers/dma/dmaengine.c:331:    return this_cpu_read(channel_table[tx_type]->chan);

Blindly converted w/o noticing the obvious problem with this code
(even befor the conversion). We just blindly return a channel from the
cpu on which this happens to be called. Can all the calling code deal
with possibly being migrated away after that ? If yes, then this wants
to have a comment. If no, then the calling convention wants to be
documented.

drivers/input/gameport/gameport.c:124:  return (this_cpu_read(cpu_info.loops_per_jiffy) *

Harmless

include/linux/interrupt.h:462:  return this_cpu_read(ksoftirqd);

Pointless. This is called from account_system_vtime() and we already
use __this_cpu_read() in that very function.

kernel/irq_work.c:125:  if (this_cpu_read(irq_work_list) == NULL)

Pointless, called from interrupts disabled context

kernel/sched.c:2013:    latest_ns = this_cpu_read(cpu_hardirq_time);

Pointless, has interrupts disabled

kernel/sched.c:2028:    latest_ns = this_cpu_read(cpu_softirq_time);

Ditto

mm/memcontrol.c:686:    val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
mm/memcontrol.c:687:    next = this_cpu_read(mem->stat->targets[target]);

Completely broken as Steven pointed out already

mm/memcontrol.c:696:    val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);

Broken as well, as it writes back to the same per cpu var, unless
called from atomic contexts.

mm/memcontrol.c:1321:   return this_cpu_read(mem->stat->count[MEM_CGROUP_ON_MOVE]) > 0;

Either broken by returning random data or pointless when called from
atomic contexts.

mm/vmstat.c:331:                t = this_cpu_read(pcp->stat_threshold);
mm/vmstat.c:333:                o = this_cpu_read(*p);

Race known and dealt with.

So most of the this_cpu_read() sites are either pointless or broken. I
suspect that other this_cpu_* stuff has the same problems.

So what's the point of that interface again? Random access to random
cpu data protected with a preempt_disable/enable() pair to paper over
the real bugs?

The whole idea of having this_cpu_* which can be called from any
context is completely stupid as it is just a guarantee for misuse and
failure.

The best thing is to remove the this_cpu_* hackery alltogether and
just keep the __this_cpu_* versions (along with proper debugging) and
git rid of the silly underscores.

> I think it would make more sence if __this_cpu_read() could be made to
> trigger a warning if used in context where preemption could be off.

It should have had such a warning in the first place and the warning
needs to yell about preemptible (i.e. unprotected) context and not the
other way round.

But instead of just slapping smp_processor_id() checks into those
functions we should add a more sensible debug interface like:

  debug_check_percpu_access()

and the per cpu sections which require protection over a series (1
.. N) of this_cpu_* operations want to have

  this_cpu_start()
  this_cpu_end()

or similar annotations around them.

This allows us to do proper analysis of this_cpu usage and makes the
code understandable.

Thanks,

	tglx
