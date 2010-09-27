Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab0I0Mq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 08:46:57 -0400
Received: from www.tglx.de ([62.245.132.106]:48935 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995Ab0I0Mqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 08:46:55 -0400
Message-Id: <20100927121651.904100669@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 27 Sep 2010 12:44:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Julia Lawall <julia@diku.dk>
Subject: [patch 00/19] genirq: Cleanup and irq_chip functions overhaul
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a large scale overhaul of the generic irq code. One of
the goals is to sanitize the sparse irq code, which is pretty much
impossible right now as there are too many sites accessing and
fiddling with irq_desc directly (And I'm not even talking about the
__do_IRQ() cadavers).

Some of these accesses have legacy reasons, some grew out of laziness
and some are just due to shortcomings in the generic code, which need
to be addressed.

The long term plan is to make irq desc private to the generic irq code
to allow freeing of unused irq descriptors, moving the irq descriptor
to a different node when the irq affinity changes and to allow
internal optimizations.

Following problems need to be addressed:

 - irq chips, which need to access irq_desc->chip_data, msi_desc etc.
  
    This is a problem already today when sparse irq is enabled. We
    need to lookup the irq desc for the interrupt to gain access to
    the data. With sparse this requires a redundant radix tree lookup
    as the core code already has a pointer to irq desc when the low
    level chip functions are called.

    It was proposed to simply hand down irq_desc in the functions, but
    low level code should not know about the details of irq_desc at
    all.

    The solution to this is to switch to a new set of irq_chip
    functions which have as single argument a pointer to a new
    irq_data structure which holds the irq number, desc->handler_data,
    desc->chip_data, desc->msi_desc, desc->affinity and a reference to
    the chip itself. The structure is embedded into irq_desc for now,
    but that's going to change, when the first cleanup round is done.

    AFAICT, that should be sufficient to satisfy the requirements of
    all low level implementations.

    For a transition phase both the old and the new functions are
    handled with wrappers in the core code.

    The new functions are implemented in:
    [Patch 3/19] genirq: Provide advanced irq chip functions
    
    Note: chip->end() will be dropped as it is just related to the old
    __do_IRQ() function and not used in the flow based handler code.


 - direct access to irq desc in architecture / drivers code.

    That's mostly related to sparse, irq affinity settings,
    show_interrupts() and fixup of irqs on cpu hot unplug.

    sparse just needs access to the irq desc due to a massive design
    failure. Most arch implementations are easy to fix except for the
    x86 one which is an utter nightmare.

    affinity settings are easy to fix with the new chip functions

    show_interrupts() should be made generic code with an arch callback
    for the extra irq related statistics (NMI, direct vectors, etc.)

    The cpu hot unplug fixup functions which handle the move of
    interrupts from a hotplug CPU do not need access to irq_desc when
    the cpu unplug code calls into the genirq core code and let it
    migrate the interrupts before calling into the architecture
    specific cpu down function. That needs some more thought, but I
    think it's a solvable problem.

    Some private irq flow handlers in arch/ can be generalized and
    moved to the generic code.

    The remaining few cases where architecture or irq chip code
    fiddles with irq_desc->status are relatively easy to cleanup.

This is going to be a major surgery in some places so I need all the
help I can get, but parts of the cleanups can be done scripted. I hope
Julia can come up with a solution to go through the irq_chip functions
and convert most of them with spatch.

The transition phase is definitly going to be short and I'm not going
to keep the old chip functions around for years like we did with
__do_IRQ().

Comments ?

Thanks,

	tglx

