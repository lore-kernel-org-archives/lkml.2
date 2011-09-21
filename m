Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1IUPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:16:59 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:42820 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752257Ab1IUPQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:16:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wmt7F0UVM1l1.c5ZbqiguBKrBrAdvJPLoclDWfqTRHe1iF3
 WC3u7B88hl1FBWq6Qari2G5Vbu2J8T_ukdDdtO8H0uI2yzsmOkI8lkg4W89d
 xR1I9JuLy6REHnHClnd4aQ0oP3uYcPbHVoSPAmNIchtUG6EyN3b4B24W_f5Y
 UZKzVS3NAx5xztUkK2.CRg6k9JRXu7vRv91NQyqvWJwyXfAJeJ_mib8gyfMz
 1UwP5yF_EOSbLi4D2KhIh6CH138a3T0golNtrxpOtKuBVzEIP3HfNjDXawr3
 2yBvjUmgDdiSuBdTDMsDEVhvopUdCPOjpYroizvw8ZNnXjT4pJ18s0QZELDI
 6VmAgr3ibe6tFZnSGNkKuljH29F48jjuJGYdG1hYq.OVxg6U-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Sep 2011 10:16:51 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
In-Reply-To: <1316544841.29966.121.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109211007450.12914@router.home>
References: <20110919212040.745370781@goodmis.org>  <alpine.DEB.2.00.1109191644190.19059@router.home>  <1316487977.29966.32.camel@gandalf.stny.rr.com>  <20110920154610.GB28952@Krystal>  <1316534441.29966.79.camel@gandalf.stny.rr.com> 
 <alpine.DEB.2.00.1109201109470.8056@router.home> <1316544841.29966.121.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> BTW, Can you explain to me where the this_cpu_*() ops were designed to
> be used? The only places where "this_cpu_*()" is used in slub.c and
> page_alloc.c have irqs disabled on their use. I thought this was for
> slub and page_alloc?

Initially these were used for statistics that used per cpu counters. The
slub thing was an outgrow of this.

> Is this_cpu() made just for statistics? I see it used in the inode code
> for that, and some accounting in the namespace.c code.

That is the main use case yes.

> Note and there's places all over the kernel that uses this_cpu_read()
> and thinks preemption should be disabled. Just look at
> arch/x86/mm/tlb.c:
>
> 	/* Caller has disabled preemption */
> 	sender = this_cpu_read(tlb_vector_offset);
>
> Why the comment?
>
> My argument is that this_cpu_* is just confusing. Rename your use case
> and keep this_cpu_*() as what you want __this_cpu_*() to be.

Thought about this a bit last night. I think the main issue are these
this_cpu_read() and this_cpu_write() operations since people use those
irresponsibly. It usually does not make sense to read a value from a
random cpu nor does writing make sense. The situation is different for
per cpu counter increments where it does not matter which cpus counter is
incremented since we sum them up later anyways.

How about getting rid of this_cpu_read() and this_cpu_write() entirely?

Only allow __this_cpu_read and __this_cpu_write. There we check that the
caller has disabled preemption.

For the rare special cases (are there any?) that are legitimate use cases
for this_cpu_read/write we can use manual determination of per cpu
pointers and then just do a load via the pointer?

Or alternatively give this_cpu_read and write special names that make
their dangerousness clear.

In the case of slub there are only some this_cpu_write() things that can
be __this_cpu_write without a problem.

The __this_cpu_ptr() can become this_cpu_ptr as far as I can tell. This
should make it consistent so that we can check for disabled preemption for
all __this_cpu thingies.
