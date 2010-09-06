Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0IFFoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 01:44:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45822 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab0IFFox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 01:44:53 -0400
Date: Mon, 6 Sep 2010 11:08:47 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
Message-ID: <20100906053847.GE14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
 <1283372009.2059.1557.camel@laptop>
 <20100903164010.GA1904@linux.vnet.ibm.com>
 <1283532714.2050.244.camel@laptop>
 <20100903172620.GA32733@linux.vnet.ibm.com>
 <1283535692.2050.325.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283535692.2050.325.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > static unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
> >                                 struct uprobes_xol_area *xol_area)
> > {
> >         unsigned long flags, xol_vaddr = 0;
> >         int len;
> > 
> >         if (unlikely(!xol_area))
> >                 return 0;
> > 
> >         smp_rmb();
> >         if (user_bkpt->xol_vaddr)
> >                 return user_bkpt->xol_vaddr;
> > 
> >         spin_lock_irqsave(&xol_area->lock, flags);
> >         xol_vaddr = xol_take_insn_slot(xol_area);
> >         spin_unlock_irqrestore(&xol_area->lock, flags);
> > 
> >         /*
> >          * Initialize the slot if user_bkpt->vaddr points to valid
> >          * instruction slot.
> >          */
> >         if (!xol_vaddr)
> >                 return 0;
> > 
> >         len = access_process_vm(current, xol_vaddr, user_bkpt->insn,
> >                                         UPROBES_XOL_SLOT_BYTES, 1);
> >         if (unlikely(len < UPROBES_XOL_SLOT_BYTES))
> >                 printk(KERN_ERR "Failed to copy instruction at %#lx "
> >                                 "len = %d\n", user_bkpt->vaddr, len);
> > 
> >         /*
> >          * Update user_bkpt->xol_vaddr after giving a chance for the slot to
> >          * be initialized.
> >          */
> >         smp_mb();
> >         user_bkpt->xol_vaddr = xol_vaddr;
> >         return user_bkpt->xol_vaddr;
> > } 
> 
> Racy like you won't believe..
> 
> Suppose multiple threads hitting the trap at the same time, every thread
> will end up failing the check and allocating a new slot for it, at the
> end the slowest thread will end up setting the value.
> 

Agree, I shall fix this up.
Since set_bit and clear_bit are atomic, I shall change the
area->lock from a spinlock to a mutex, and have the mutex released
after the slot has been updated with the "single-stepping
instruction".

--
Thanks and Regards
Srikar
