Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1IUQc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:32:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:50535 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1IUQc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:32:27 -0400
Date: Wed, 21 Sep 2011 18:32:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@gentwo.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <alpine.DEB.2.00.1109211007450.12914@router.home>
Message-ID: <alpine.LFD.2.02.1109211828080.2723@ionos>
References: <20110919212040.745370781@goodmis.org>  <alpine.DEB.2.00.1109191644190.19059@router.home>  <1316487977.29966.32.camel@gandalf.stny.rr.com>  <20110920154610.GB28952@Krystal>  <1316534441.29966.79.camel@gandalf.stny.rr.com> 
 <alpine.DEB.2.00.1109201109470.8056@router.home> <1316544841.29966.121.camel@gandalf.stny.rr.com> <alpine.DEB.2.00.1109211007450.12914@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Steven Rostedt wrote:
> 
> > BTW, Can you explain to me where the this_cpu_*() ops were designed to
> > be used? The only places where "this_cpu_*()" is used in slub.c and
> > page_alloc.c have irqs disabled on their use. I thought this was for
> > slub and page_alloc?
> 
> Initially these were used for statistics that used per cpu counters. The
> slub thing was an outgrow of this.
> 
> > Is this_cpu() made just for statistics? I see it used in the inode code
> > for that, and some accounting in the namespace.c code.
> 
> That is the main use case yes.
> 
> > Note and there's places all over the kernel that uses this_cpu_read()
> > and thinks preemption should be disabled. Just look at
> > arch/x86/mm/tlb.c:
> >
> > 	/* Caller has disabled preemption */
> > 	sender = this_cpu_read(tlb_vector_offset);
> >
> > Why the comment?
> >
> > My argument is that this_cpu_* is just confusing. Rename your use case
> > and keep this_cpu_*() as what you want __this_cpu_*() to be.
> 
> Thought about this a bit last night. I think the main issue are these
> this_cpu_read() and this_cpu_write() operations since people use those
> irresponsibly. It usually does not make sense to read a value from a
> random cpu nor does writing make sense. The situation is different for
> per cpu counter increments where it does not matter which cpus counter is
> incremented since we sum them up later anyways.
> 
> How about getting rid of this_cpu_read() and this_cpu_write() entirely?
> 
> Only allow __this_cpu_read and __this_cpu_write. There we check that the
> caller has disabled preemption.
> 
> For the rare special cases (are there any?) that are legitimate use cases
> for this_cpu_read/write we can use manual determination of per cpu
> pointers and then just do a load via the pointer?
> 
> Or alternatively give this_cpu_read and write special names that make
> their dangerousness clear.
> 
> In the case of slub there are only some this_cpu_write() things that can
> be __this_cpu_write without a problem.
> 
> The __this_cpu_ptr() can become this_cpu_ptr as far as I can tell. This
> should make it consistent so that we can check for disabled preemption for
> all __this_cpu thingies.
 
The problem I have with that approach is that this_cpu_inc/dec still
look too close to __this_cpu_*.

It would really be nice to rename this_cpu_inc/dec to something which
makes it clear that this is statistics and does not care a whit about
the actual cpu on which this happens.

Thanks,

	tglx
