Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1G0OUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:20:07 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:31204 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751025Ab1G0OUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:20:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NNke70MVM1l4JkjiViPsIM1Yh.mKAf8Nq0tTsDCd7FsT7Rc
 .r7YLfsyZI06Ro6EfNvZ_VVudpLxNmRlKeR6QToK1WMktvij6xbUzcDqmq4i
 nH_r2P3jrFi6tdsEhdcMo.Uwo8JvBDDPP3TlvNv4WFbJv0JYGzwfEgIFvwJk
 d194Av.eJaSHNrQuwByKnCvtFKnfxjaclQTIoa1rf.yMjD6lbxNBIAA42DRd
 .kJQaMO9BZ.1BXJJAIJ967sFlDbDZPT49eVhPQXqZDz5F2zJWuF2.p1XSU9.
 J_.HE.kl2oF9_0BMZEhG4Yhv22QPQmbO6ew2SLywPBTVZHa0beyy7RwmWFH0
 u4bfVv_MjIN1s9PtxaO5cTIno
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 27 Jul 2011 09:20:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311771677.24752.495.camel@twins>
Message-ID: <alpine.DEB.2.00.1107270916240.9418@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins> <1311771677.24752.495.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Peter Zijlstra wrote:

> > Possibly we could reduce all this percpu madness back to one form
> > (__this_cpu_*) and require that when used a lock of the percpu_lock_t is
> > taken.
>
> get_cpu_var()/put_cpu_var() were supposed to provide such delineation as
> well, but you've been actively destroying things like that with the
> recent per-cpu work.

The per cpu work is *not* focused on sections that access per cpu data, so
how could it destroy that? Nothing is changed there so far. The this_cpu
ops are introducing per cpu atomic operations that are safe and cheap
regardless of the execution context. The primary initial motivation was
incrementing per cpu counters without having to disabling interrupts
and/or preemption and it grew from there.

The atomic per cpu operations (like the this_cpu_cmpxchg) allow the
construction of cheap sections that would satisfy your goals too (with
some work and the use of transaction ids instead of locking). See the slub
fastpath f.e.

