Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1G0ROG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:14:06 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:30944 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755184Ab1G0ROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:14:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ab3t7XUVM1nydc.dHBm8ipJ4LwjXeNcMOn7eOtbwIRIMc7W
 6waqrXKT9Oq22e5Ik1hoU1uZmoWK7xx7bncApGa8U0lUJiv1h7mADnhIAC0R
 iA0t8aJRAA3d6kCYRnClZ.aIXlWb3EnwydbVuKdnjNy0VhDZpQ_id..9ehaU
 DlUuj4mA3agb_248vbmlns339I_I.TygIbqGlBfCEd7Wnemvgt8Urbe6I73Q
 kZtEG9EIpkA31A8Dxsid7L5Zqn45EU1Gx2aJs_VmxuIJAfU2P6_7tnZy7hpK
 KAQuAtoQiAiYJnqOJwa_r_M0QrXxFdjgJPVpn77jxGy4eIAI5MjnLW5buF9u
 v_o4x5WnLCbP05vCQFnRMjEOp
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 12:13:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311783616.5890.178.camel@twins>
Message-ID: <alpine.DEB.2.00.1107271204260.13058@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins>  <alpine.DEB.2.00.1107270904290.9418@router.home> <1311783616.5890.178.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Peter Zijlstra wrote:

> On Wed, 2011-07-27 at 09:16 -0500, Christoph Lameter wrote:
>
> > Well yes these are multiple operations that have a sort of atomicity
> > requirement together. You want both variables to be updated together and
> > therefore the individual RMV operations wont do the trick. The algorithm
> > would have to be changed to take advantage of the this_cpu ops or you will
> > have to take the penalty of higher synchronization costs.
>
> You're still not getting it, synchronization cost isn't the point.

It is for me.

> > What you can do is what the slub fastpath does in order to allow updates
> > without caring about preemption or interrupts.
>
> > 1. You get a reference to the current per cpu data.
> > 2. You obtain a transaction id that is cpu specific and operation specifc.
> > 3. Speculatively access an object and work with the information of that
> > object. Do not change anything.
>
> Pretty hard when the whole point if changing stuff.

Essentially you have a pointer to play with. Not unlike a special form of
RCU.

> > 4. Calculate the next transaction id
> > 4. Replace pointer and transaction id with a new object pointer and new
> > tranaction id. If there is no match restart at 1.
>
> Which is utter crap, ease up on the the drugs. That mandates a
> read-copy-update like approach to all per-cpu data.

If one wants performance you can get it that way.

> > So now you have a per cpu access that is fully immunte from interrupt and
> > preemption issues.
>
> And suffers from allocation issues.. allocating a new piece of data,
> copying over the old one, modifying it, installing the new pointer,
> managing references to the old pointer etc.. You're on crack, that's
> often way too much trouble for nearly no gain.

Maybe you just do not know how to handle it? The allocators (even the page
allocator) have been playing tricks with per cpu data for a very long
time.

> > percpu sections are very performance critical components of the kernel.
> > Taking locks could be avoided with serialization through transaction ids
> > f.e.
>
> Not the fucking point! This isn't about making things go faster, this is
> about breaking up the horrid implicit preempt/bh/irq assumptions all
> over the place. It really is no different from killing the BKL.

There is no breaking of anything. These assumptions already exist
throughout the kernel and the issues with access to variables in
different preemption context/interrupt context already exist. Nothing was
changed there.

> You'll need this even if you're going to rewrite the kernel with your
> cmpxchg_double wankery simply because you need to know how stuff is
> supposed to work.
>
> All this is simply about de-obfuscating all per-cpu assumptions. This is
> about verification and traceability/debuggability.

Ok verification  and traceability are good but they should not
be in the way of making core functionality high performance and low
latency.

The key issue is that the -rt kernel has always had grave issues with
performance when it comes to per cpu data access. Solving that by forcing
the kernel to go slow it not the right approach.
