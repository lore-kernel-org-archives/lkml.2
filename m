Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab2BVNyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:54:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26790 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2BVNyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:54:43 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8 a=Gio3QgBLUeKJXW4iFD0A:9 a=BafehgOhFkvXC2QuPQYA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=CY6gl2JlH4YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329918881.25686.92.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 08:54:41 -0500
In-Reply-To: <20120222133404.GA14085@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
	 <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu>
	 <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu>
	 <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
	 <1329916920.25686.79.camel@gandalf.stny.rr.com>
	 <20120222133404.GA14085@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 14:34 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I like the blue shed, but anyway...
> > 
> > On Wed, 2012-02-22 at 09:06 +0100, Ingo Molnar wrote:
> > > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > 
> > > > Not arguing that, but the static aspect is still key... or 
> > > > people will read it as another version of likely/unlikely.  
> > > 
> > > They can *read* it as such, that as is very much intentional! 
> > 
> > I mentioned this thread on irc and the first comment I received was:
> > 
> > "is that a new attempt at trying to guide the compiler?"
> 
> It essentially is, implemented partly via compiler help, 
> combined with runtime code patching, as an extended run-time arm 
> of the compiler in essence, to make out of line slowpaths even 
> cheaper to have around - to make the fast-path even faster.

Actually, I was partly under the impression that we didn't care if it
was in the fast path. Maybe we need three versions. Let me explain.

We have cases where we want it default disabled and the code called when
enabled should be as out of line as possible. Tracing definitely falls
in this pattern. But we could push a "unlikely(static_branch())" for
such a case (or keep it as very_unlikely()).

Then we have cases where it is default enabled, where we can insert the
code in the fast path. Or do we even care how the compiler places it?
Because this leads us to the third use...

The third use is the case were we don't know the branch should be taken
or not until boot. We don't want the compiler to optimize the paths at
all. This example is for things like CPU features or types (as HPA
explained the "if (very_unlikely(cpu_vendor_amd))". This is the category
that we want to have an efficient system for the running hardware. We
can't bias one way or the other at compile time because frankly, we
don't know the answer until run time. This could also be used by modules
that are drivers for several types of hardware, and it can dynamically
change itself to suit the hardware it is driving.

> 
> > I personally find the very_unlikely() confusing, but then 
> > again I like the blue shed over the pink one.
> 
> Confusing in what way?

Because it really just looks like a stronger "unlikely()" and
fundamentally it really isn't. For tracing, sure that can be the way we
look at it, but for the more general case, it is a "We don't know which
way this branch should go most of the time, lets just pick one then
optimize later".

Again, maybe we need a "very_unlikely()" for the tracing case, maybe
even a "very_likely()", but then keep a static_branch() or whatever for
those cases you do not want to optimize at compile time.

-- Steve


