Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab0ICRcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:32:19 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50886 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab0ICRcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:32:16 -0400
Date: Fri, 3 Sep 2010 22:56:20 +0530
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
Message-ID: <20100903172620.GA32733@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
 <1283372009.2059.1557.camel@laptop>
 <20100903164010.GA1904@linux.vnet.ibm.com>
 <1283532714.2050.244.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1283532714.2050.244.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-09-03 18:51:54]:

> On Fri, 2010-09-03 at 22:10 +0530, Srikar Dronamraju wrote:
> > > > +   mb();
> > > 
> > > Where is the matching barrier?
> > 
> > I dont want the compiler to reorder the instructions and do the
> > assignment for user_bkpt to be done before we complete the copy above.
> > 
> > If the assignment happens before we copy the content into the slot,
> > someother thread that might hit the same probe actually things the slot
> > is ready and tries to jump to that slot even before the slot is
> > initialized.
> > 
> > Please let me know if I could have done it differently. 
> 
> 
> If you want a compiler barrier, use barrier(), but here you seem to
> describe a multi-threaded situation, in which case the observer thread
> needs at least a rmb() in order for that mb() to mean anything other
> than the compiler barrier it implies.
> 
> Also, use smp_* barriers.
> 
> 
> 

Okay,  would something like this suffice?


static unsigned long xol_get_insn_slot(struct user_bkpt *user_bkpt,
				struct uprobes_xol_area *xol_area)
{
	unsigned long flags, xol_vaddr = 0;
	int len;

	if (unlikely(!xol_area))
		return 0;

	smp_rmb();
	if (user_bkpt->xol_vaddr)
		return user_bkpt->xol_vaddr;

	spin_lock_irqsave(&xol_area->lock, flags);
	xol_vaddr = xol_take_insn_slot(xol_area);
	spin_unlock_irqrestore(&xol_area->lock, flags);

	/*
	 * Initialize the slot if user_bkpt->vaddr points to valid
	 * instruction slot.
	 */
	if (!xol_vaddr)
		return 0;

	len = access_process_vm(current, xol_vaddr, user_bkpt->insn,
					UPROBES_XOL_SLOT_BYTES, 1);
	if (unlikely(len < UPROBES_XOL_SLOT_BYTES))
		printk(KERN_ERR "Failed to copy instruction at %#lx "
				"len = %d\n", user_bkpt->vaddr, len);

	/*
	 * Update user_bkpt->xol_vaddr after giving a chance for the slot to
	 * be initialized.
	 */
	smp_mb();
	user_bkpt->xol_vaddr = xol_vaddr;
	return user_bkpt->xol_vaddr;
}

-- 
Thanks and Regards
Srikar
