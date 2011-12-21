Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1LUMgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:36:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1LUMgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:36:41 -0500
Date: Wed, 21 Dec 2011 13:34:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221123442.GB6071@elte.hu>
References: <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <4EF05996.8030807@redhat.com>
 <20111220100916.GA20788@elte.hu>
 <20111220152758.GA30127@8bytes.org>
 <20111220184004.GE8408@elte.hu>
 <20111221000716.GB30127@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221000716.GB30127@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> On Tue, Dec 20, 2011 at 07:40:04PM +0100, Ingo Molnar wrote:
> 
> > > I am fine with integrating LWP into perf as long as it makes 
> > > sense and does not break the intended usage scenario for LWP.
> > 
> > That's the wrong way around - in reality we'll integrate LWP 
> > upstream only once it makes sense and works well with the 
> > primary instrumentation abstraction we have in the kernel.
> 
> I still don't see why you want an abstraction for a hardware 
> feature [...]

Because if done properly then Linux users and developers will be 
able to utilize the hardware feature well beyond the limited 
scope these patches are giving it.

A couple of examples:

1) This command:

      perf record -e lwp:instructions ./myapp

   will be possible and will be able to do skid-less profiling.

2) In the long run apps might be able to insert lightweight 
   trace entries without entering the kernel, using the LWPINS 
   instruction.

3) Maybe LWP will be enhanced with the ability to profile system 
   mode execution as well - which we'll be able to support very 
   easily.

These features are *far* more interesting than some limited 
self-monitoring use of LWP.

I don't mind niches per se, so i don't mind the self-monitoring 
usecase either, as long as they are not trying to be the *only* 
feature, at the expense of more interesting features.

I think it can all be supported in a consistent way (see my 
previous mails) - but the feature as presented today just does 
not look useful enough to me if only supports that niche 
self-monitoring usecase.

> > > [...] It also destroys the intended use-case for LWP 
> > > because it disturbs any process that is doing 
> > > self-profiling with LWP.
> > 
> > Why would it destroy that? Self-profiling can install events 
> > just fine, the kernel will arbitrate the resource.
> 
> Because you can't reliably hand over the LWPCB management to 
> the kernel. The instruction to load a new LWPCB is executable 
> in ring-3. Any kernel-use of LWP will never be reliable.

It will be reliable for all tasks that don't intentionally 
modify their own LWPCB's but stay with the defined APIs and no 
task will be able to destroy *another* task's LWPCB (be it in or 
outside of any APIs), if properly implemented.

So a task can mess with itself - and it can already do that 
today.

So what's your point?

> > > So what you are saying is (not just here, also in other 
> > > emails in this thread) that every hardware not designed 
> > > for perf is crap?
> > 
> > No - PMU hardware designed to not allow the profiling of the 
> > kernel is obviously a crappy aspect of it. Also, PMU 
> > hardware that does not allow 100% encapsulation by the 
> > kernel is obviously not very wisely done either.
> 
> Why? Whats wrong with user-space having control over its own 
> PMU in a safe way? This is what the feature was designed for.

Read what i've written: 'PMU hardware designed to not allow the 
profiling of the kernel is obviously a crappy aspect of it'.

There is no reason why LWP could not allow profiling of kernel 
execution as well, with a simple security model to make sure 
unprivileged user-space does not profile kernel execution: such 
as a LWP-load-time check whether the LWPCB lies on a system pte 
or not.

This would allow everything that is possible today - and more.

Allowing user-space access to the PMU does not preclude a proper 
PMU abstraction.

Thanks,

	Ingo
