Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018Ab0IGEHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:07:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0IGEG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:06:57 -0400
Date: Tue, 7 Sep 2010 06:03:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100907040331.GB14046@elte.hu>
References: <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> Hi Ingo,
> 
> On Mon, Sep 6, 2010 at 6:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> The actual language doesn't really matter.
> >
> > There are 3 basic categories:
> >
> >  1- Most (least abstract) specific code: a block of bytecode in the form
> >    of a simplified, executable, kernel-checked x86 machine code block -
> >    this is also the fastest form. [yes, this is actually possible.]
> >
> >  2- Least specific (most abstract) code: A subset/sideset of C - as it's
> >    the most kernel-developer-trustable/debuggable form.
> >
> >  3- Everything else little more than a dot on the spectrum between the
> >    first two points.
> >
> > I lean towards #2 - but #1 looks interesting too. #3 is distinctly
> > uninteresting as it cannot be as fast as #1 and cannot be as convenient
> > as #2.
> 
> It's a question where you want to push the complexity of parsing the 
> language and verifying the executed code. I'd image it's easier to 
> evolve an ABI if we use an intermediate form ("bytecode") on the 
> kernel side. Supporting multiple versions of a C-like language is 
> probably going to be painful. [...]

Not really, as it's only extended. So there's really just one version to 
support for every kernel - it's just that user-space will initially only 
use 'older' elements of the language.

> [...] You also probably don't want to put heavy-weight compiler 
> optimization passes in the kernel so with an intermediate form, you 
> can do much of that in user-space.

The question of what can and cannot be done in the kernel is overrated. 
We sure can put a C compiler into the kernel - 10 years down the line we 
wont understand what the fuss was all about.

I still remember all the silly 'graphics code should never be in the 
kernel, it's way too complex and fragile' arguments from 1996.

What matters is that it's a hugely flexible and hugely useful feature. 
All our ad-hoc script engines in the kernel (trace-filter, selinux, 
netfilter), etc. could be implemented via it.

And it would allow fantastic feature beyond existing code.

For example a new category of filesystem could be created: with a 
'self-defining layout' - by storing the C code of the filesystem data 
structures _on-disk_.

A filesystem could have a new, more optimal layout by simply having new 
format routines defined in C, stored on disk (in the superblock, or in a 
block referred to by inodes). Old filesystem layouts would be compatible 
forever: the C code is on-disk and never lost as long as the data is 
there - etc.

New filesystem features could be created in a very flexible way, without 
risking old data.

Mixed mode filesystems would be possible: new files get the new logic, 
old files the old logic. This would allow the gradual migration to a new 
filesystem layout for example, without a reinstall.

etc.

Key is to have a kernel that can execute code as data and to embedd that 
code in data structures.

> I'm guessing this thing is expected to work on all architectures? If 
> that's true, I'd forget about JIT'ing for the time being and write an 
> interpreter first because it's much easier to port. There are 
> techniques in making an interpreter pretty fast too. Google for 
> "inlining interpreter" if you're interested.

Yeah, i dont think speed is a primary concern - if overhead matters it 
will be clearly measurable and people can iterate the optimizations ...

> As for the intermediate form, you might want to take a look at Dalvik:
> 
> http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
> 
> and probably ParrotVM bytecode too. The thing to avoid is stack-based 
> instructions like in Java bytecode because although it's easy to write 
> interpreters for them, it makes JIT'ing harder (which needs to convert 
> stack-based representation to register-based) and probably doesn't 
> lend itself well to stack-constrained kernel code.

_If_ we pass in any sort of machine code to the kernel (which bytecode 
really is), then we should do the right thing and pass in raw x86 
bytecode, and verify it in the kernel.

That way the compiler can be kept out of the kernel, and performance of 
the thing will be phenomenal from day 1 on.

For non-x86 in most cases we can use a simple translator that runs 
during the verification run - or of course they could have their own 
native 'assembly bytecode' verifier and their user-space could compile 
to those.

But i'd prefer C code really, as it's really 'abstract data' in the most 
generic sense. That's why the trace filter engine started with a subset 
of C.

Thanks,

	Ingo
