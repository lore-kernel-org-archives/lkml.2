Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2EQUU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:20:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab2EQUU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:20:58 -0400
Message-ID: <1337286040.4281.85.camel@twins>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Thu, 17 May 2012 22:20:40 +0200
In-Reply-To: <20120517200838.GL2567@linux.vnet.ibm.com>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	 <20120517151838.GA8692@linux.vnet.ibm.com> <1337268779.4281.38.camel@twins>
	 <20120517154755.GG2567@linux.vnet.ibm.com> <1337271467.4281.43.camel@twins>
	 <20120517200838.GL2567@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 13:08 -0700, Paul E. McKenney wrote:
> I don't claim to understand all of the code, but I am also unafraid to
> ask stupid questions.  ;-)
> 
> So, is it possible to do something like the following?
> 
> 1.      Schedule a workqueue from an RCU callback, and to have that
>         workqueue do the fput.

Possible yes, but also undesirable, fput() can do a lot of work. Viro
very much didn't want this.

> 2.      Make things like unmount() do rcu_barrier() followed by
>         flush_workqueue(), or probably multiple flush_workqueue()s.

For unmount() we could get away with this, unmount() isn't usually
(ever?) a critical path. However, as noted by viro the fput() which is
still required can itself cause a tremendous amount of work, even if
only synced against an unmount, having this work done from an async
context isn't desired.

> 3.      If someone concurrently does munmap() and a write to the
>         to-be-unmapped region, then the write can legally happen.

Not entirely different from the current situation -- the timing changes
between the RCU and current implementation, but imagine the write
happens while the unmap() is in progress but hasn't quite reached the
range we write to.

Anyway, this is all firmly in 'undefined' territory so anybody breaking
from this change deserves all the pain (and probably more) they get.

As already stated, any fault in a region that's being unmapped is the
result of an ill-formed program.

> 4.      Acquire mmap_sem in the fault path, but only if the fault
>         requires blocking, and recheck the situation under
>         mmap_sem -- the hope being to prevent long-lived page
>         faults from messing things up.

Not relevant, a fault might not need to block but could still extend the
refcount lifetime of the file object beyond unmap and thus bear the
responsibility of the final fput, which we cannot know a-priori.

Its all made much more complex by the fact that we're avoiding taking
the refcount from the speculative fault in order to avoid the 'global'
synchronization on that cacheline -- which is the real problem
really :-)
