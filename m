Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0IGDov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:44:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34928 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0IGDop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:44:45 -0400
Date: Tue, 7 Sep 2010 05:44:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100907034417.GA14046@elte.hu>
References: <1283772256.1930.303.camel@laptop>
 <4C84D1CE.3070205@redhat.com>
 <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <4C852B2A.2030103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C852B2A.2030103@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2124]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>  On 09/06/2010 06:47 PM, Ingo Molnar wrote:
> >
> >>The actual language doesn't really matter.
> >There are 3 basic categories:
> >
> >  1- Most (least abstract) specific code: a block of bytecode in the form
> >     of a simplified, executable, kernel-checked x86 machine code block -
> >     this is also the fastest form. [yes, this is actually possible.]
> 
> Do you then recompile it? [...]

No, it's machine code. It's 'safe x86 bytecode executed natively by the 
kernel as a function'.

It needs a verification pass (because the code can come from untrusted 
apps) so that we can copy, verify and trust it (so obviously it's not 
_arbitrary_ x86 machine code - a safe subset of x86) - maybe with a sha1 
based cache for already-verified snippets (or a fast verifier).

> x86 is quite unpleasant.

Any machine code that is fast and compact is unpleasant almost by 
definition: it's a rather non-obvious Huffman encoding embedded in an 
instruction architecture.

But that's the life of kernel hackers, we deal with difficult things. 
(We could have made a carreer choice of selling icecream instead, but 
it's too late i suspect.)

> >  2- Least specific (most abstract) code: A subset/sideset of C - as it's
> >     the most kernel-developer-trustable/debuggable form.
> >
> >  3- Everything else little more than a dot on the spectrum between the
> >     first two points.
> >
> > I lean towards #2 - but #1 looks interesting too. #3 is distinctly 
> > uninteresting as it cannot be as fast as #1 and cannot be as 
> > convenient as #2.
> 
> Curious - how do you guarantee safety of #1 or even #2? [...]

Safety of #1 (x86 bytecode passed in by untrusted user-space, verified 
and saved by the kernel and executed natively as an x86 function if it 
passes the security checks) is trivial but obviously needs quite a bit 
of work.

We start with trivial (and useless) special case of something like:

#define MAX_BYTECODE_SIZE 256

int x86_bytecode_verify(char *opcodes, unsigned int len)
{

	if (len-1 > MAX_BYTECODE_SIZE-1)
		return -EINVAL;

	if (opcodes[0] != 0xc3) /* RET instruction */
		return -EINVAL;

	return 0;
}

... and then we add checks for accepted/safe x86 patterns of 
instructions step by step - always keeping it 100% correct.

Initially it would only allow general register operations with some 
input and output parameters in registers, and a wrapper would 
save/restore those general registers - later on stack operands and 
globals could be added too.

That's not yet Turing complete but already quite functional: an amazing 
amount of logic can be expressed via generic register ops only - i think 
the filter engine could be implemented via that for example.

We'd eventually make it Turing complete in the operations space we care 
about: a fixed-size stack sandbox and a virtual memory window sandbox 
area, allow conditional jumps (only to instruction boundaries).

The code itself is copied into kernel-space and immutable after it has 
been verified.

The point is to decode only safe instructions we know, and to always 
have a 'safe' core of checking code we can extend safely and 
iteratively.

Safety of #2 (C code) is like the filter engine: it's safe right now, as 
it parses the ASCII expression in-kernel, compiles it into predicaments 
and executes those predicament (which are baby instructions really) 
safely.

Every extension needs to be done safely, of course - and more complex 
language constructs will complicate matters for sure.

Note that we have (small) bits of #1 done already in the kernel: the x86 
disassembler. Any instruction pattern we dont know or dont trust we punt 
on.

( Also note that beyond native execution this 'x86 bytecode' approach 
  would still allow JIT techniques, if we are so inclined: x86 bytecode, 
  because we fully verify it and fully know its structure (and exclude 
  nasties like self-modifying code) can be re-JIT-ed just fine.

  Common sequences might even be pre-JIT-ed and cached in a hash. That 
  way we could make sequences faster post facto, via a kernel change 
  only, without impacting any user-space which only passes in the 'old' 
  sequence. Lots of flexibility. )

> Can you point me to any research?

Nope, havent seen this 'safe native x86 bytecode' idea 
mentioned/researched anywhere yet.

> Everything I'm aware of is bytecode with explicit measures to prevent 
> forged pointers, but I admit I've spent no time on it.  It's 
> interesting stuff, though.

I think some Java-like bytecode is roughly the same amount of conceptual 
work as an x86 bytecode verifier, with the big disadvantage that even 
with a JIT it's much slower [and a JIT is far from simple] - not to 
mention the non-technical complications of Java.

> I have a truly marvellous patch that fixes the bug which this 
> signature is too narrow to contain.

Make sure you write down a short but buggy version of the patch on the 
margin of a book. Pass on the book to your heirs and enjoy the centuries 
long confusion from the heavens.

Thanks,

	Ingo
