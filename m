Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2FGTpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:45:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34919 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2FGTpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:45:19 -0400
Date: Thu, 7 Jun 2012 21:45:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>, Rus <rus@sfinxsoft.com>,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: Re: lockdep and kmemcheck
Message-ID: <20120607194516.GB20723@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Rus <rus@sfinxsoft.com>,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com>
 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
 <20120607151352.GA8261@x1.osrc.amd.com>
 <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
 <20120607193331.GA20723@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120607193331.GA20723@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 09:33:31PM +0200, Borislav Petkov wrote:
> Peter, does it ring a bell?
> 
> This is LOCKDEP with CONFIG_KMEMCHECK.
> 
> On Thu, Jun 07, 2012 at 10:02:33PM +0300, Rus wrote:
> > > Do you have CONFIG_DETECT_HUNG_TASK enabled? Also CONFIG_PROVE_LOCKING,
> > > CONFIG_KMEMCHECK, CONFIG_DEBUG_PREEMPT. These are just a couple of debug
> > > options to enable right now which could tell us more.
> > 
> > Kmemcheck setting is prevented the booting of the 3.5-rc1 with the
> > following messages :
> > 
> > kmemcheck: Limiting number of CPUs to 1.
> > kmemcheck: Initialized
> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0xcd/0xd0()

This is

        /*
	 * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
         */
        if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
	                return;


> > Hardware name: To be filled by O.E.M.
> > Modules linked in:
> > Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc1 #3
> > Call Trace:
> >  [<ffffffff8104123a>] warn_slowpath_common+0x7a/0xb0
> >  [<ffffffff81041285>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff81096f2d>] lockdep_trace_alloc+0xcd/0xd0
> >  [<ffffffff810ee48e>] __alloc_pages_nodemask+0x7e/0x890
> >  [<ffffffff810ee599>] ? __alloc_pages_nodemask+0x189/0x890
> >  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> >  [<ffffffff81278f3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> >  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
> >  [<ffffffff811260c9>] kmemcheck_alloc_shadow+0x29/0xb0
> >  [<ffffffff8112409a>] new_slab+0x1fa/0x2e0
> >  [<ffffffff815b70ec>] __slab_alloc.isra.51.constprop.55+0x3e8/0x40e
> >  [<ffffffff815c07d0>] ? error_exit+0x30/0xb0
> >  [<ffffffff811251f7>] kmem_cache_alloc+0x87/0xb0
> >  [<ffffffff8126d7c0>] idr_pre_get+0x60/0x90
> >  [<ffffffff8126dd8b>] ida_pre_get+0x1b/0x90
> >  [<ffffffff810593b2>] create_worker+0x42/0x170

This has to be

static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
{
        bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
        struct worker *worker = NULL;
        int id = -1;

        spin_lock_irq(&gcwq->lock);
        while (ida_get_new(&gcwq->worker_ida, &id)) {
                spin_unlock_irq(&gcwq->lock);
                if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))

and GFP_KERNEL has __GFP_FS.

> >  [<ffffffff81ae441d>] init_workqueues+0x1f2/0x393
> >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> >  [<ffffffff81002122>] do_one_initcall+0x122/0x180
> >  [<ffffffff81acbc7a>] kernel_init+0x9b/0x1f6
> >  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
> >  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
> >  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
> >  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> > ---[ end trace 6d450e935ee1897c ]---
> > MCE: In-kernel MCE decoding enabled.
> > NMI watchdog: enabled, takes one hw-pmu counter.

Let's add some more people to CC.

Tejun, this create_worker() uses ida_pre_get() with GFP_KERNEL mask
but lockdep complains about __GFP_FS allocations with IRQs off in
__lockdep_trace_alloc. What's up?

Hmmm...

-- 
Regards/Gruss,
    Boris.
