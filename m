Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2BVPry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:47:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2BVPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:47:51 -0500
Date: Wed, 22 Feb 2012 16:47:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222154733.GA28314@elte.hu>
References: <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
 <20120222133404.GA14085@elte.hu>
 <1329918881.25686.92.camel@gandalf.stny.rr.com>
 <20120222145614.GA2491@elte.hu>
 <1329923493.24994.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329923493.24994.19.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-02-22 at 15:56 +0100, Ingo Molnar wrote:
> > > Again, maybe we need a "very_unlikely()" for the tracing case,
> > 
> > ... and that's the usecase for the scheduler, for events and for 
> > networking. I.e. all current usecases in the kernel 
> 
> The scheduler also really wants the very_likely() variant. We 
> have less use for the unbiased one though.

Yeah, it wants a fastpath and a slowpath and whether it's likely 
or unlikely is situational. So thus it uses both variants in my 
tree:

kernel/sched/core.c:    if (very_unlikely((&paravirt_steal_rq_enabled))) {
kernel/sched/core.c:    if (very_unlikely(&paravirt_steal_enabled)) {
kernel/sched/fair.c:    return very_unlikely(&__cfs_bandwidth_used);
kernel/sched/sched.h:   return very_likely(key); /* Not out of line branch. */
kernel/sched/sched.h:   return very_unlikely(key); /* Out of line branch. */

With no need for an 'unbiased' method.

Let me push out what I have in tip:perf/jump-labels (just 
finished testing it) so that we are all looking at the same 
code.

Thanks,

	Ingo
