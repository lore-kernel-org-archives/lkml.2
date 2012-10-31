Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab2JaCXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2JaCXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:23:05 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=gPGaiRUHczgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rQ8w98ZuNmwA:10 a=pGLkceISAAAA:8 a=BNs6mPIVAAAA:8 a=aTuGhnTbzQMOm22NJ_kA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=AhfHCeSdmIwA:10 a=ttSgrB6RVVE_zooR:21 a=YzxuzCstvrugMSRn:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351650181.4004.70.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: anish kumar <anish198519851985@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 22:23:01 -0400
In-Reply-To: <CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	 <1351622024.1504.13.camel@anish-Inspiron-N5050>
	 <CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 01:36 +0100, Frederic Weisbecker wrote:
> 2012/10/30 anish kumar <anish198519851985@gmail.com>:
> > As I understand without the memory barrier proposed by you the situation
> > would be as below:
> > CPU 0                                 CPU 1
> >
> > data = something                     flags = IRQ_WORK_BUSY
> > smp_mb() (implicit with cmpxchg      execute_work (sees data from CPU 0)
> >            on flags in claim)
> > _success_ in claiming and goes
> > ahead and execute the work(wrong?)
> >                                      cmpxchg cause flag to IRQ_WORK_BUSY
> >
> > Now knows the flag==IRQ_WORK_BUSY
> >
> > Am I right?
> 
> (Adding Paul in Cc because I'm again confused with memory barriers)
> 
> Actually what I had in mind is rather that CPU 0 fails its claim
> because it's not seeing the IRQ_WORK_BUSY flag as it should:
> 
> 
> CPU 0                                 CPU 1
> 
> data = something                  flags = IRQ_WORK_BUSY
> cmpxchg() for claim               execute_work (sees data from CPU 0)
> 
> CPU 0 should see IRQ_WORK_BUSY but it may not because CPU 1 sets this
> value in a non-atomic way.
> 
> Also, while browsing Paul's perfbook, I realize my changelog is buggy.
> It seems we can't reliably use memory barriers here because we would
> be in the following case:
> 
> CPU 0                                  CPU 1
> 
> store(work data)                    store(flags)
> smp_mb()                            smp_mb()
> load(flags)                            load(work data)
> 
> On top of this barrier pairing, we can't make the assumption that, for
> example, if CPU 1 sees the work data stored in CPU 0 then CPU 0 sees
> the flags stored in CPU 1.
> 
> So now I wonder if cmpxchg() can give us more confidence:

More confidence over what? The xchg()? They are equivalent (wrt memory
barriers).

Here's the issue that currently exists. Let's look at the code:


/*
 * Claim the entry so that no one else will poke at it.
 */
static bool irq_work_claim(struct irq_work *work)
{
	unsigned long flags, nflags;

	for (;;) {
		flags = work->flags;
		if (flags & IRQ_WORK_PENDING)
			return false;
		nflags = flags | IRQ_WORK_FLAGS;
		if (cmpxchg(&work->flags, flags, nflags) == flags)
			break;
		cpu_relax();
	}

	return true;
}

and

	llnode = llist_del_all(this_list);
	while (llnode != NULL) {
		work = llist_entry(llnode, struct irq_work, llnode);

		llnode = llist_next(llnode);

		/*
		 * Clear the PENDING bit, after this point the @work
		 * can be re-used.
		 */
		work->flags = IRQ_WORK_BUSY;
		work->func(work);
		/*
		 * Clear the BUSY bit and return to the free state if
		 * no-one else claimed it meanwhile.
		 */
		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
	}

The irq_work_claim() will only queue its work if it's not already
pending. If it is pending, then someone is going to process it anyway.
But once we start running the function, new work needs to be processed
again.

Thus we have:

	CPU 1					CPU 2
	-----					-----
	(flags = 0)
	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
	(flags = 3)
	[...]

						if (flags & IRQ_WORK_PENDING)
							return false
	flags = IRQ_WORK_BUSY
	(flags = 2)
	func()

The above shows the normal case were CPU 2 doesn't need to queue work,
because its going to be done for it by CPU 1. But...



	CPU 1					CPU 2
	-----					-----
	(flags = 0)
	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
	(flags = 3)
	[...]
	flags = IRQ_WORK_BUSY
	(flags = 2)
	func()
						(sees flags = 3)
						if (flags & IRQ_WORK_PENDING)
							return false
	cmpxchg(flags, 2, 0);
	(flags = 0)


Here, because we did not do a memory barrier after 
flags = IRQ_WORK_BUSY, CPU 2 saw stale data and did not queue its work,
and missed the opportunity. Now if you had this fix with the xchg() as
you have in your patch, then CPU 2 would not see the stale flags.
Except, with the code I showed above it still can!

	CPU 1					CPU 2
	-----					-----
	(flags = 0)
	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
	(flags = 3)
	[...]
						(fetch flags)
	xchg(&flags, IRQ_WORK_BUSY)
	(flags = 2)
	func()
						(sees flags = 3)
						if (flags & IRQ_WORK_PENDING)
							return false
	cmpxchg(flags, 2, 0);
	(flags = 0)


Even with the update of xchg(), if CPU2 fetched the flags before CPU1
did the xchg, then it would still lose out. But that's where your
previous patch comes in that does:

       flags = work->flags & ~IRQ_WORK_PENDING;
       for (;;) {
               nflags = flags | IRQ_WORK_FLAGS;
               oflags = cmpxchg(&work->flags, flags, nflags);
               if (oflags == flags)
                       break;
               if (oflags & IRQ_WORK_PENDING)
                       return false;
               flags = oflags;
               cpu_relax();
       }


This now does:

	CPU 1					CPU 2
	-----					-----
	(flags = 0)
	cmpxchg(flags, 0, IRQ_WORK_FLAGS)
	(flags = 3)
	[...]
	xchg(&flags, IRQ_WORK_BUSY)
	(flags = 2)
	func()
						oflags = cmpxchg(&flags, flags, nflags);
						(sees flags = 2)
						if (flags & IRQ_WORK_PENDING)
							(not true)
						(loop)						
	cmpxchg(flags, 2, 0);
	(flags = 2)
						flags = 3



With both patch 1 and 2 you fixed the bug.

I guess you suffer from...

 http://weknowmemes.com/wp-content/uploads/2012/09/my-code-doesnt-work-i-have-no-idea-why.jpg

;-)


> 
> 
> CPU 0                                                CPU 1
> 
> store(work data)                                  xchg(flags, IRQ_WORK_BUSY)
> cmpxchg(flags, IRQ_WORK_FLAGS)    load(work data)
> 
> Can I make this assumption?
> 
> - If CPU 0 fails the cmpxchg() (which means CPU 1 has not yet xchg())
> then CPU 1 will execute the work and see our data.
> 
> At least cmpxchg / xchg pair orders correctly to ensure somebody will
> execute our work. Now probably some locking is needed from the work
> function itself if it's not per cpu.

Yeah, there's nothing stopping the work->func() from executing from two
different CPUs. The protection is just for the internal use of llist
that is used. We don't need to worry about it being queued twice and
corrupting the work->llnode.

But the synchronization of the func() should be up to the func() code
itself, not a guarantee of the irq_work.

-- Steve


