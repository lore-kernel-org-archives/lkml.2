Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1G0NBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:01:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44144 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab1G0NBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:01:42 -0400
Subject: Re: per-cpu operation madness vs validation
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1311768693.24752.488.camel@twins>
References: <1311714410.24752.404.camel@twins>
	 <alpine.DEB.2.00.1107261624210.10273@router.home>
	 <1311768693.24752.488.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 15:01:17 +0200
Message-ID: <1311771677.24752.495.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 14:11 +0200, Peter Zijlstra wrote:

> Hence my suggestion to do something like:
> 
> struct foo {
> 	percpu_lock_t lock;
> 	int a;
> 	int b;
> }
> 
> DEFINE_PER_CPU(struct foo, foo);
> 
> percpu_lock(&foo.lock);
> __this_cpu_inc(foo.a);
> __this_cpu_inc(foo.b);
> percpu_unlock(&foo.lock);
> 
> That would get us (aside from a shitload of work to make it so):
> 
>  - clear boundaries of where the data structure atomicy lie
>  - validation, for if the above piece of code was also ran from IRQ
>    context we could get lockdep complaining about IRQ unsafe locks used
>    from IRQ context.
> 
> Now for !-rt percpu_lock will not emit more than
> preempt_disable/local_bh_disable/local_irq_disable, depending on what
> variant is used, and the data type percpu_lock_t would be empty (except
> when enabling lockdep of course).
> 
> Possibly we could reduce all this percpu madness back to one form
> (__this_cpu_*) and require that when used a lock of the percpu_lock_t is
> taken.

get_cpu_var()/put_cpu_var() were supposed to provide such delineation as
well, but you've been actively destroying things like that with the
recent per-cpu work.

Also, I think we can mostly deprecate preempt_disable, local_bh_disable
and local_irq_disable when we have percpu_lock_t, or is local_lock_t a
better name?
