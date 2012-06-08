Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365Ab2FHHzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:55:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab2FHHzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:55:37 -0400
Message-ID: <1339142120.23343.28.camel@twins>
Subject: Re: lockdep and kmemcheck
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Rus <rus@sfinxsoft.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 09:55:20 +0200
In-Reply-To: <20120608061037.GJ21357@google.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
	 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
	 <20120607142459.GB5053@x1.osrc.amd.com>
	 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
	 <20120607151352.GA8261@x1.osrc.amd.com>
	 <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
	 <20120607193331.GA20723@liondog.tnic> <20120607194516.GB20723@liondog.tnic>
	 <20120608061037.GJ21357@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 15:10 +0900, Tejun Heo wrote:
> On Thu, Jun 07, 2012 at 09:45:16PM +0200, Borislav Petkov wrote:
> > static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
> > {
> >         bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
> >         struct worker *worker = NULL;
> >         int id = -1;
> > 
> >         spin_lock_irq(&gcwq->lock);
> >         while (ida_get_new(&gcwq->worker_ida, &id)) {
> >                 spin_unlock_irq(&gcwq->lock);
> >                 if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
> > 
> > and GFP_KERNEL has __GFP_FS.
> > 
> > > >  [<ffffffff81ae441d>] init_workqueues+0x1f2/0x393
> > > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > > >  [<ffffffff81002122>] do_one_initcall+0x122/0x180
> > > >  [<ffffffff81acbc7a>] kernel_init+0x9b/0x1f6
> > > >  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
> > > >  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
> > > >  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
> > > >  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> > > > ---[ end trace 6d450e935ee1897c ]---
> > > > MCE: In-kernel MCE decoding enabled.
> > > > NMI watchdog: enabled, takes one hw-pmu counter.
> > 
> > Let's add some more people to CC.
> > 
> > Tejun, this create_worker() uses ida_pre_get() with GFP_KERNEL mask
> > but lockdep complains about __GFP_FS allocations with IRQs off in
> > __lockdep_trace_alloc. What's up?
> 
> The GFP_KERNEL allocation is right after spin_unlock_irq().  I suppose
> this is from early boot before IRQs are brought online, right?  My
> memory is very fuzzy now but ISTR irq debug code and lockdep having
> workarounds for early boot.  Peter?

early_boot_irqs_disabled, but kernel_init() is way past that, that's
where we've forked the first thread and are fully scheduling already.
