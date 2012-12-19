Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab2LSTVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:21:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab2LSTVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:21:00 -0500
Date: Wed, 19 Dec 2012 20:14:36 +0100
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
Message-ID: <20121219191436.GA25829@redhat.com>
References: <50C8C4A5.4080104@linux.vnet.ibm.com> <20121212180248.GA24882@redhat.com> <50C8CD52.8040808@linux.vnet.ibm.com> <20121212184849.GA26784@redhat.com> <50C8D739.6030903@linux.vnet.ibm.com> <50C9F38F.3020005@linux.vnet.ibm.com> <50D0CCB3.10105@linux.vnet.ibm.com> <20121219163900.GA18516@redhat.com> <50D2047A.1040606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D2047A.1040606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19, Srivatsa S. Bhat wrote:
>
> BTW, there is a small problem with the synchronize_sched() approach:
> We can't generalize the synchronization scheme as a generic percpu rwlock
> because the writer's role is split into 2, the first part (the one having
> synchronize_sched()) which should be run in process context, and the
> second part (the rest of it), which can be run in atomic context.

Yes,

> That is, needing the writer to be able to sleep (due to synchronize_sched())
> will make the locking scheme unusable (in other usecases) I think. And
> the split (blocking and non-blocking part) itself seems hard to express
> as a single writer API.

I do not think this is the problem.

We need 2 helpers for writer, the 1st one does synchronize_sched() and the
2nd one takes rwlock. A generic percpu_write_lock() simply calls them both.

In fact I think that the 1st helper should not do synchronize_sched(),
and (say) cpu_hotplug_begin() should call it itself. Because if we also
change cpu_hotplug_begin() to use percpu_rw_sem we do not want to do
synchronize_sched() twice. But lets ignore this for now.

But,

> Hmmm.. so what do we do? Shall we say "We anyway have to do smp_rmb() in the
> reader in the fast path. Instead let's do a full smp_mb() and get rid of
> the synchronize_sched() in the writer, and thereby expose this synchronization
> scheme as generic percpu rwlocks?" Or should we rather use synchronize_sched()
> and keep this synchronization scheme restricted to CPU hotplug only?

Oh, I do not know ;)

To me, the main question is: can we use synchronize_sched() in cpu_down?
It is slow.

Oleg.

