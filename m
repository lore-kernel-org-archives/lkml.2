Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2LTNmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:42:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2LTNma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:42:30 -0500
Date: Thu, 20 Dec 2012 14:42:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121220134203.GB10813@redhat.com>
References: <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com> <50D2047A.1040606@linux.vnet.ibm.com> <20121219191436.GA25829@redhat.com> <50D21A5F.4040604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D21A5F.4040604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Srivatsa S. Bhat wrote:
>
> On 12/20/2012 12:44 AM, Oleg Nesterov wrote:
> >
> > We need 2 helpers for writer, the 1st one does synchronize_sched() and the
> > 2nd one takes rwlock. A generic percpu_write_lock() simply calls them both.
> >
>
> Ah, that's the problem no? Users of reader-writer locks expect to run in
> atomic context (ie., they don't want to sleep).

Ah, I misunderstood.

Sure, percpu_write_lock() should be might_sleep(), and this is not
symmetric to percpu_read_lock().

> We can't expose an API that
> can make the task go to sleep under the covers!

Why? Just this should be documented. However I would not worry until we
find another user. Until then we do not even need to add percpu_write_lock
or try to generalize this code too much.

> > To me, the main question is: can we use synchronize_sched() in cpu_down?
> > It is slow.
> >
>
> Haha :-) So we don't want smp_mb() in the reader,

We need mb() + rmb(). Plust cli/sti unless this arch has optimized
this_cpu_add() like x86 (as you pointed out).

> *and* also don't want
> synchronize_sched() in the writer! Sounds like saying we want to have the cake
> and eat it too ;-) :P

Personally I'd vote for synchronize_sched() but I am not sure. And I do
not really understand the problem space.

> And moreover, since I'm still not convinced about the writer API part if use
> synchronize_sched(), I'd rather avoid synchronize_sched().)

Understand.

And yes, synchronize_sched() adds more problems. For example, where should
we call it? I do not this _cpu_down() should do this, in this case, say,
disable_nonboot_cpus() needs num_online_cpus() synchronize_sched's.

So probably cpu_down() should call it before cpu_maps_update_begin(), this
makes the locking even less obvious.

In short. What I am trying to say is, don't ask me I do not know ;)

Oleg.

