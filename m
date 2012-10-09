Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2JINqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:46:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:38450 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2JINqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:46:48 -0400
Date: Tue, 9 Oct 2012 15:46:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.1-rt1
Message-ID: <alpine.LFD.2.02.1210091535140.10988@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.1-rt1 release.

This is a pretty straight forward move from the 3.4-rt series which
includes a few significant updates which need to be backported to the
3.x-rt stable series:

   * Make interrupt randomness work again on RT. Based on the 3.x.y
     stable updates in that area. Should be applicable to all 3.x-rt
     series with almost no modifications.

   * RT softirq initialization sequence fix (Steven Rostedt)

   * Fix for a potential deadlock in mm/slab.c. This had been reported
     as lockdep splats several times and stupidly ignored as a false
     positive, but in fact it's a real (though almost impossible to
     trigger) deadlock lurking.

   * Use the proper local_lock primitives in mm/page_alloc.c. That's
     not a real bug, but this fixes an inconsistency which helps
     debugability and therefore is worthwhile to be backported.

   * RT-rwlock/rwsem annotations:

     RT does not allow multiple readers on rwlocks and rwsems. The
     lockdep annotations did not yet consider that fact. One might
     think that this is a complete RT specific issue, but it's
     not. The FIFO fair rwsem/lock modifications in mainline made
     reader/writer primitives prone to very subtle deadlock problems
     which cannot be detected by the current lockdep annotations in
     mainline. The reason is that if a writer interleaves with two
     readers it will block the second reader from proceeding in order
     not to allow writer starvation. The restricted RWlocks semantics
     of RT allow an easy detection of that problem. We already
     triggered a real deadlock in RT (see:
     peterz-srcu-crypto-chain.patch) which could result in a hard to
     trigger, but mainline relevant deadlock. Wait for more
     interesting problems in that area.

   * The output of might_sleep debugging is silent about the possible
     causes vs. the preempt count. Contrary to interrupt disabling
     there is zero information about what disabled preemption
     last. Again, not strictly a bugfix, but debuggability is key.

   * Fix a potentially deadly sto(m)p_machine deadlock. A CPU which
     calls that code from its inactive state (don't ask me for the
     ghastly deatils why this is necessary) can run into a contended
     state of the stomp machine mutex which would cause a rather
     awkward issue of idle scheduling itself away to idle as the only
     possible task on that upcoming cpu. Not pretty ....


There is also a worth to mention fundamental change in this release:

   * Split softirq locks

     In the pre 3,x-RT versions we spawned a separate thread for each
     softirq on each CPU. This served the PER_CPUness requirements,
     but did not provide any means against priority inversions
     vs. softirqs.

     With the start of the 3.0-rt series I decided to drop the per
     softirq threads for simplicity reasons as I had to deal with all
     the fallout of the migration disabling design I had taken course
     to.

     I got several complaints about the missing softirq thread split
     since then and a few patches to reestablish them. I refused to
     take those patches for a simple reason: configuration. It's
     extremly hard to get the parameters right for a RT system in
     general. Adding something which is obscure as soft interrupts to
     the system designers todo list is a bad idea.

     Now I spent quite some time on analysing the most urgent issues
     on RT:

     	  throughpout  versus  deterministism

     The interested observer may have noticed that deterministic
     behaviour and throughput are mutually exclusive properties, but
     in the 2.6 based RT series the split softirq implementation at
     least allowed some mitigation of this problem by adjusting the
     priorities, while the 3.x RT series did not provide a user
     tunable knob at all. Though the untunable behaviour of the 3.x RT
     series behaved in general better than the untuned 2.6 RT at least
     in terms of throughput.

     The reason is that 3.x RT put a big focus on dealing with the
     increasing PER_CPUness of data in the mainline kernel. The
     migrate_disable based ability of executing pending soft
     interrupts in any thread context which had raised a soft
     interrupt made RT a bit more similar to the mainline behaviour,
     but did not provide any serious means of controlling that
     behaviour.

     My new approach of split softirq locks is another (sigh) futile
     attempt to deal with the current (non)existing softirq semantics
     of the mainline kernel.

     What's the meaning of soft interrupt processing in Linux today?

     First of all, it's a conglomorate of mostly unrelated jobs, which
     run in the context of a randomly chosen victim w/o the ability to
     put any control on them. Softirq processing happens in three
     contexts:

     - Return from hard interrupt context. Basically the same as the
       hard interrupt context except that interrupts are enabled.

     - In the context of a thread which reenables softirq processing
       via local_bh_enable or *_unlock_bh. Interestingly enough
       reenabling interrupts does not have the same effect, though
       disabling interrupts prevents softirq processing as well and
       there are places which raise soft interrupt in interrupt
       disabled regions which delegates them to ksoftirqd or to the
       next random context which happens to reach a softirq processing
       context before ksoftirqd.

     - ksoftirqd. The invocation of ksoftirqd is not well defined. It
       happens when the above two contexts looped extensivly in the
       softirq processing or if a softirq gets raised outside of a
       hard interrupt context in a bottom half enabled region. Now
       even in the case that ksoftirqd has been woken up there is no
       guarantee, that it will actually process softinterrupts at all
       because the other two contexts can be invoked (again) before
       ksoftirqd gets scheduled in.

     Quite a set of imprecise rules and unclear semantics which
     explain the pain RT has with softirq processing.

     The pre 3.0-RT approach of delegating all softirq processing to
     separate per softirq threads is only a partial solution to the
     problem and introduces a hard to configure set of softirq thread
     scheduling policy and priority questions. Aside of that it does
     not allow to process soft interrupts from the tail of the
     interrupt threads or softirq enabling code.

     The 3.x-RT approach of allowing the softirq processing from the
     tail of interrupt threads or softirq enabling code gave us a
     throughput enhancement and got rid of the configuration
     complexity, but we lost the ability to optimize for specific use
     cases (e.g. deterministic networking).
     
     After studying the softirq behaviour I came to the conclusion
     that it might be interesting to try a different approach.
     Especially networking handles the softirq processing either in
     the interrupt tail or from bh enabling thread contexts.

     So instead of splitting the softirq threads I split the softirq
     locks so different softirqs can be handled seperately. If a
     softirq is raised in the context of a thread, then its noted in
     the task struct and when the thread leaves the bh disabled
     section it handles this particular soft interrupt in its own
     context. This removes the burden of running completely unrelated
     softirqs like timers, tasklets etc. from a context which raised a
     network soft interrupt. That way the softirq processing is
     coupled to the originating thread and its scheduling properties,
     so the need for finding optimal parameters should be gone.

     Now this only works for soft interrupts which are raised in the
     context of a thread. Unfortunately there is no way to do the same
     for soft interrupts which are raised in hard interrupt context
     (e.g. RCU, timers). They have no thread associated and are
     therefor delegated to ksoftirqd. This is ok, except that it does
     not help people who want to use signal based timers, but that
     problem needs to be solved by moving the complex handling into
     the context of the thread which is going to receive the signal
     and should vanish from the softirq processing completely.
     
     In principle we should have even in mainline a clear separation
     of which soft interrupts are disabled by a particular code region
     instead of disabling them wholesale. Though the nicest solution
     would be to get rid of them completely :)
 
     Give it proper testing and lemme know whether this solves your
     particular problems which arised from giving up the separate
     softirq threads. Don't complain about signal based timers - see
     above!

The RT patch against 3.6.1 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.1-rt1.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.6.1-rt1.tar.xz

Enjoy,

	tglx
