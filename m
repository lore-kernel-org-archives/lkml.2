Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1G0QUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:20:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:39502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1G0QUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:20:47 -0400
Subject: Re: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.1107270916240.9418@router.home>
References: <1311714410.24752.404.camel@twins>
	 <alpine.DEB.2.00.1107261624210.10273@router.home>
	 <1311768693.24752.488.camel@twins> <1311771677.24752.495.camel@twins>
	 <alpine.DEB.2.00.1107270916240.9418@router.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 18:20:17 +0200
Message-ID: <1311783617.5890.179.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 09:20 -0500, Christoph Lameter wrote:
> On Wed, 27 Jul 2011, Peter Zijlstra wrote:
> 
> > > Possibly we could reduce all this percpu madness back to one form
> > > (__this_cpu_*) and require that when used a lock of the percpu_lock_t is
> > > taken.
> >
> > get_cpu_var()/put_cpu_var() were supposed to provide such delineation as
> > well, but you've been actively destroying things like that with the
> > recent per-cpu work.
> 
> The per cpu work is *not* focused on sections that access per cpu data, so
> how could it destroy that? Nothing is changed there so far. The this_cpu
> ops are introducing per cpu atomic operations that are safe and cheap
> regardless of the execution context. The primary initial motivation was
> incrementing per cpu counters without having to disabling interrupts
> and/or preemption and it grew from there.

I think you need to look at 20b876918c065818b3574a426d418f68b4f8ad19 and
try again. You removed get_cpu_var()/put_cpu_var() and replaced it with
naked preempt_disable()/preempt_enable(). That's loosing information
right there.

Also, I think if you do s/__this_cpu/this_cpu/ on that function you can
simply drop the preempt_enable/disable things.

> The atomic per cpu operations (like the this_cpu_cmpxchg) allow the
> construction of cheap sections that would satisfy your goals too (with
> some work and the use of transaction ids instead of locking). See the slub
> fastpath f.e.

The slub fastpath is a shining example of crap. Its horrid code and
there was nothing wrong with actually disabling preemption over it, even
for -rt. Sure you made it go faster, but thats not the point.

Most of the slub problems with -rt are in the slow path where you still
have per-cpu assumptions and keep preempt/irqs disabled.

I don't think it is possible, nor desirable, to wreck all per-cpu usage
in the kernel that way.
