Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933672Ab2FHGKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:10:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51283 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2FHGKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:10:48 -0400
Date: Fri, 8 Jun 2012 15:10:37 +0900
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Rus <rus@sfinxsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: lockdep and kmemcheck
Message-ID: <20120608061037.GJ21357@google.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com>
 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
 <20120607151352.GA8261@x1.osrc.amd.com>
 <CAKgfjTn67KwR7-+icNZm7e5ZRfjqt1159kWMYD6S83WuhNfprQ@mail.gmail.com>
 <20120607193331.GA20723@liondog.tnic>
 <20120607194516.GB20723@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607194516.GB20723@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 09:45:16PM +0200, Borislav Petkov wrote:
> static struct worker *create_worker(struct global_cwq *gcwq, bool bind)
> {
>         bool on_unbound_cpu = gcwq->cpu == WORK_CPU_UNBOUND;
>         struct worker *worker = NULL;
>         int id = -1;
> 
>         spin_lock_irq(&gcwq->lock);
>         while (ida_get_new(&gcwq->worker_ida, &id)) {
>                 spin_unlock_irq(&gcwq->lock);
>                 if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
> 
> and GFP_KERNEL has __GFP_FS.
> 
> > >  [<ffffffff81ae441d>] init_workqueues+0x1f2/0x393
> > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > >  [<ffffffff81ae422b>] ? usermodehelper_init+0x36/0x36
> > >  [<ffffffff81002122>] do_one_initcall+0x122/0x180
> > >  [<ffffffff81acbc7a>] kernel_init+0x9b/0x1f6
> > >  [<ffffffff815c1f74>] kernel_thread_helper+0x4/0x10
> > >  [<ffffffff815c0274>] ? retint_restore_args+0x13/0x13
> > >  [<ffffffff81acbbdf>] ? start_kernel+0x3d2/0x3d2
> > >  [<ffffffff815c1f70>] ? gs_change+0x13/0x13
> > > ---[ end trace 6d450e935ee1897c ]---
> > > MCE: In-kernel MCE decoding enabled.
> > > NMI watchdog: enabled, takes one hw-pmu counter.
> 
> Let's add some more people to CC.
> 
> Tejun, this create_worker() uses ida_pre_get() with GFP_KERNEL mask
> but lockdep complains about __GFP_FS allocations with IRQs off in
> __lockdep_trace_alloc. What's up?

The GFP_KERNEL allocation is right after spin_unlock_irq().  I suppose
this is from early boot before IRQs are brought online, right?  My
memory is very fuzzy now but ISTR irq debug code and lockdep having
workarounds for early boot.  Peter?

Thanks.

-- 
tejun
