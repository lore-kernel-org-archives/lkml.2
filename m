Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab1L0VVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:21:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1L0VU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:20:58 -0500
Date: Tue, 27 Dec 2011 13:20:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111227132056.44ee9281.akpm@linux-foundation.org>
In-Reply-To: <20111227183402.GF17712@google.com>
References: <20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
	<20111222154138.d6c583e3.akpm@linux-foundation.org>
	<20111222235455.GT17084@google.com>
	<20111222171432.e429c041.akpm@linux-foundation.org>
	<20111227183402.GF17712@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 10:34:02 -0800 Tejun Heo <tj@kernel.org> wrote:

> > Separately...
> > 
> > Mixing mempools and percpu_alloc() in the proposed fashion seems a
> > pretty poor fit.  mempools are for high-frequency low-level allocations
> > which have key characteristics: there are typically a finite number of
> > elements in flight and we *know* that elements are being freed in a
> > timely manner.
> 
> mempool is a pool of memory allocations.  Nothing more, nothing less.

No, there is more.  An important concept in mempool is that it is safe
to indefinitely wait for items because it is guaranteed that the
in-flight ones will be returned in a timely fashion.

> > More significantly, it's pretty unreliable: if the allocations outpace
> > the kernel thread's ability to refill the pool, all we can do is to
> > wait for the kernel thread to do some work.  But we're holding
> > low-level locks while doing that wait, which will block the kernel
> > thread.  Deadlock.
> 
> Ummm... if you try to allocate with GFP_KERNEL from IO path, deadlock
> of course is possible.

It is deadlockable when used with GFP_NOFS, or GFP_NOIO.  Anything with
__GFP_WAIT.

The only "safe" usage of the proposed interface is when the caller
performs the per-cpu allocation with !__GFP_WAIT (ie: GFP_ATOMIC) and
when the caller is prepared to repeatedly poll until the allocation
succeeds.

That's a narrow and rare calling pattern which doesn't merit being
formalised into a core kernel API.  It is one which encourages poor
code in callers, which should instead be reworked to use GFP_KERNEL, in
which case the interface isn't needed.

It's also a dangerous API because people could call it with GFP_NOIO
(for example) and risk deadlocks.  Waiting for a kernel thread to
perform a GFP_KERNEL allocation is equivalent to directly performing
that allocation, with GFP_KERNEL.  The only real effect of handing over
to a kernel thread to do the work is to hide your bug from lockdep.

>  That's the *whole* reason why allocation
> buffering is used there.  It's filled from GFP_KERNEL context and
> consumed from GFO_NOIO and as pointed out multiple times the allocaion
> there is infrequent and can be opportunistic.  Sans the use of small
> buffering items, this isn't any different from deferring allocation to
> different context.  There's no guarantee when that allocation would
> happen but in practice both will be reliable enough for the given use
> case.

"reliable enough" is not the standard to which we aspire.

Look, the core problem here is that this block code is trying to
allocate from an inappropriate context.  Rather than hacking around
adding stuff to make this work most-of-the-time, how about fixing the
block code to perform the allocation from the correct context?

> I don't necessarily insist on using mempool here but all the given
> objections seem bogus to me.  The amount of code added is minimal and
> straight-forward.  It doesn't change what mempool is or what it does
> at all and the usage fits the problem to be solved.  I can't really
> understand what the objection is about.

It's adding complexity to core kernel.  It's adding a weak and
dangerous interface which will encourage poor code in callers.

And why are we doing all of this?  So we can continue to use what is
now poor code at one particular site in the block layer!  If the block
code wants to run alloc_percpu() (which requires GFP_KERNEL context)
then it should be reworked to do so from GFP_KERNEL context.  For that
is the *best* solution, no?

