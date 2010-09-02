Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab0IBIMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:12:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0IBIMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:12:41 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
 (un)registration and exception handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1283377414.2059.1729.camel@laptop>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
	 <1283377414.2059.1729.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 02 Sep 2010 10:12:26 +0200
Message-ID: <1283415146.2059.1810.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 23:43 +0200, Peter Zijlstra wrote:
> > +void uprobe_notify_resume(struct pt_regs *regs)
> > +{
> > +     struct uprobe_process *uproc;
> > +     struct uprobe_probept *ppt;
> > +     struct uprobe_task *utask;
> > +     struct uprobe *u;
> > +     unsigned long probept;
> > +
> > +     utask = current->utask;
> > +     uproc = current->mm->uproc;
> > +     if (unlikely(!utask)) {
> > +             utask = add_utask(uproc);
> > +
> > +             /* Failed to allocate utask for the current task. */
> > +             BUG_ON(!utask);
> > +             probept = uprobes_get_bkpt_addr(regs);
> > +             ppt = find_probept(uproc, probept);
> > +
> > +             /*
> > +              * The probept was refcounted in uprobe_bkpt_notifier;
> > +              * Hence it would be mysterious to miss ppt now
> > +              */
> > +             WARN_ON(!ppt);
> > +             utask->active_ppt = ppt;
> > +             utask->state = UTASK_BP_HIT;
> > +     } else
> > +             ppt = utask->active_ppt;
> 
> You can replace this with:
> 
>  addr = instruction_pointer(task_pt_regs(current)) -
> ip_advancement_by_brkpt_insn;
> 
> and then proceed from there like described below to obtain the struct
> uprobe.
> 
> You can infer the SS/HIT state by checking if the user-addr is in the
> XOL area or not.

Right, so one problem I overlooked is that you need to have the actual
probe to compute the jump address, but that could be fixed by
implementing boosted probes.

> > +     if (utask->state == UTASK_BP_HIT) {
> > +             utask->state = UTASK_SSTEP;
> > +             u = ppt->uprobe;
> > +             if (u && u->handler)
> > +                     u->handler(u, regs);
> > +
> > +             if (!pre_ssout(ppt, regs))
> > +                     arch_uprobe_enable_sstep(regs);
> > +     } else if (utask->state == UTASK_SSTEP) {
> > +             if (sstep_complete(regs, ppt)) {
> > +                     put_probept(ppt);
> > +                     utask->active_ppt = NULL;
> > +                     utask->state = UTASK_RUNNING;
> > +                     arch_uprobe_disable_sstep(regs);
> > +             }
> > +     }
> > +}
> > +
> > +/*
> > + * uprobe_bkpt_notifier gets called from interrupt context
> > + * it gets a reference to the ppt and sets TIF_UPROBE flag,
> > + */
> > +int uprobe_bkpt_notifier(struct pt_regs *regs)
> > +{
> > +     struct uprobe_process *uproc;
> > +     struct uprobe_probept *ppt;
> > +     struct uprobe_task *utask;
> > +     unsigned long probept;
> > +
> > +     if (!current->mm || !current->mm->uproc)
> > +             /* task is currently not uprobed */
> > +             return 0;
> > +
> > +     uproc = current->mm->uproc;
> > +     utask = current->utask;
> > +     probept = uprobes_get_bkpt_addr(regs);
> 
> Its an address, not a struct uprobe_probept * so call it addr if
> anything.
> 
> > +     ppt = find_probept(uproc, probept);
> > +     if (!ppt)
> > +             return 0;
> > +     get_probept(ppt);
> > +     if (utask) {
> > +             utask->active_ppt = ppt;
> > +             utask->state = UTASK_BP_HIT;
> > +     }
> 
> Right, so all this should die..
> 
> Obtain the address, lookup the vma, get the file, compute the offset
> inside that file -> {inode,offset}

Except we need to stabilize the vma tree to do the lookup and that
currently requires mmap_sem, I guess until we get Nick's per-pte
vma-tree we could fudge that by adding a spinlock around the rb_tree
modifications -- I've got a patch for that somewhere I think.

> Do the lookup in the global tree to obtain the uprobe, and possibly
> execute the probe handler right here in interrupt context, if it fails
> with -EFAULT, continue with the below:
> 
> > +#ifdef CONFIG_ARCH_SUPPORTS_UPROBES
> > +     set_thread_flag(TIF_UPROBE);
> > +#endif
> 
> How can we ever get here if the architecture doesn't support uprobes?
> 
> > +     return 1;
> > +} 
