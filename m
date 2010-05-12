Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0ELN1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:27:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52466 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0ELN1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:27:34 -0400
Date: Wed, 12 May 2010 18:57:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 0/10] Uprobes v3
Message-ID: <20100512132708.GC13606@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6> <1273611585.1810.132.camel@laptop> <20100512102518.GA30767@linux.vnet.ibm.com> <1273666385.1626.96.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273666385.1626.96.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:13:05PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-12 at 15:55 +0530, Srikar Dronamraju wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2010-05-11 22:59:45]:
> > 
> > > On Thu, 2010-05-06 at 23:31 +0530, Srikar Dronamraju wrote:
> > > >   - Addressed comments from Oleg, including removal of interrupt context
> > > >     handlers, reverting background page replacement in favour of
> > > >     access_process_vm(). 
> > > 
> > > 
> > > > +static int write_opcode(struct task_struct *tsk, unsigned long vaddr,
> > > > +                                               user_bkpt_opcode_t opcode)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       if (!tsk)
> > > > +               return -EINVAL;
> > > > +
> > > > +       ret = access_process_vm(tsk, vaddr, &opcode, user_bkpt_opcode_sz, 1);
> > > > +       return (ret == user_bkpt_opcode_sz ? 0 : -EFAULT);
> > > > +}
> > > 
> > > Why!
> > > 
> > > That's not not the atomic sequence outlined.
> > > 
> > 
> > 
> > Yes, we had moved away from access_process_vm to background page
> > replacement in Version 1 and Version 2. 
> > 
> > One of the reasons being Mathieu suggesting to Jim in LFCS that 
> > for almost all architectures insertion of a breakpoint instruction on a
> > user page is an atomic operation, as far as the CPU is concerned.
> 
> That is true, however when restoring the old instruction you do need to
> take care, so your usage from set_orig_insn() is dubious.
> 
> > Can you and other VM experts tell me if access_process_vm isnt going to
> > be atomic with respect to inserting/deleting a breakpoint instruction? 
> 
> Well, clearly not, since it simply does a gup(.force=1), if whatever
> page is there is writable it will simply poke at it.
> 
> Now writing the INT3 is special, but restoring the old insn is not and
> might confuse another CPU that is currently trying to execute code near
> there.

Yes, this helps for breakpoint insertion, but...

The question is whether only INT3 special or single-byte changes are
also guaranteed to be atomic. In http://lkml.org/lkml/2010/1/27/275
Peter Anvin states 'specific case of a more generic rule'.

For restoring the old instruction, we technically need to put back just
one byte, irrespective of the actual length of the underlying
instruction. Now, as long as we have the housekeeping code to handle the
possibility of a thread hitting the said breakpoint when its being
removed, is it safe to assume atomicity for replacing one byte of
possibly a longer instruction?

Ananth
