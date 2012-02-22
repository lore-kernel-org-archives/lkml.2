Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2BVO4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:56:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab2BVO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:56:38 -0500
Date: Wed, 22 Feb 2012 15:56:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222145614.GA2491@elte.hu>
References: <20120222065016.GA16923@elte.hu>
 <4F44934B.2000808@zytor.com>
 <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
 <20120222080659.GA25318@elte.hu>
 <1329916920.25686.79.camel@gandalf.stny.rr.com>
 <20120222133404.GA14085@elte.hu>
 <1329918881.25686.92.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329918881.25686.92.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2012-02-22 at 14:34 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > I like the blue shed, but anyway...
> > > 
> > > On Wed, 2012-02-22 at 09:06 +0100, Ingo Molnar wrote:
> > > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > > 
> > > > > Not arguing that, but the static aspect is still key... or 
> > > > > people will read it as another version of likely/unlikely.  
> > > > 
> > > > They can *read* it as such, that as is very much intentional! 
> > > 
> > > I mentioned this thread on irc and the first comment I received was:
> > > 
> > > "is that a new attempt at trying to guide the compiler?"
> > 
> > It essentially is, implemented partly via compiler help, 
> > combined with runtime code patching, as an extended run-time 
> > arm of the compiler in essence, to make out of line 
> > slowpaths even cheaper to have around - to make the 
> > fast-path even faster.
> 
> Actually, I was partly under the impression that we didn't 
> care if it was in the fast path. Maybe we need three versions. 
> Let me explain.
> 
> We have cases where we want it default disabled and the code 
> called when enabled should be as out of line as possible. 
> Tracing definitely falls in this pattern. But we could push a 
> "unlikely(static_branch())" for such a case (or keep it as 
> very_unlikely()).
> 
> Then we have cases where it is default enabled, where we can 
> insert the code in the fast path. Or do we even care how the 
> compiler places it? Because this leads us to the third use...

These two variants cover all current uses of jump labels.

> The third use is the case were we don't know the branch should 
> be taken or not until boot. We don't want the compiler to 
> optimize the paths at all. This example is for things like CPU 
> features or types (as HPA explained the "if 
> (very_unlikely(cpu_vendor_amd))". This is the category that we 
> want to have an efficient system for the running hardware. We 
> can't bias one way or the other at compile time because 
> frankly, we don't know the answer until run time. This could 
> also be used by modules that are drivers for several types of 
> hardware, and it can dynamically change itself to suit the 
> hardware it is driving.
>
> > > I personally find the very_unlikely() confusing, but then 
> > > again I like the blue shed over the pink one.
> > 
> > Confusing in what way?
> 
> Because it really just looks like a stronger "unlikely()" and 
> fundamentally it really isn't. [...]

Well, the fact is that right now it *is* a stronger unlikely() 
on architectures that have jump-labels and it's mapped to 
unlikely() on others.

> [...] For tracing, sure that can be the way we look at it, but 
> for the more general case, it is a "We don't know which way 
> this branch should go most of the time, lets just pick one 
> then optimize later".

That's not how it's used by the scheduler or by perf - and by 
the looks of it that's not how the networking code uses it 
either.

I tend to concentrate on the common case.

> Again, maybe we need a "very_unlikely()" for the tracing case,

... and that's the usecase for the scheduler, for events and for 
networking. I.e. all current usecases in the kernel.

> maybe even a "very_likely()", but then keep a static_branch() 
> or whatever for those cases you do not want to optimize at 
> compile time.

Once such uses arise maybe we could add such an 'unbiased' 
variant.

But the reality is that today jump labels are used for critical 
codepaths that don't want to slow themselves down due to some 
rare feature that is commonly off: this is how tracing, the 
scheduler, perf events and networking uses jump labels.

Thanks,

	Ingo
