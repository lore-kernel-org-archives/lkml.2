Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0IGWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:43:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab0IGWna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:43:30 -0400
Date: Wed, 8 Sep 2010 00:43:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100907224301.GC11605@elte.hu>
References: <1283774045.1930.341.camel@laptop>
 <4C84D77B.6040600@redhat.com>
 <20100906124330.GA22314@elte.hu>
 <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <4C852B2A.2030103@redhat.com>
 <20100907034417.GA14046@elte.hu>
 <AANLkTik0d=d4VfWy0WFDpsQttbZ9cFTVjqmRjgY4+7v1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik0d=d4VfWy0WFDpsQttbZ9cFTVjqmRjgY4+7v1@mail.gmail.com>
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


* Stefan Hajnoczi <stefanha@gmail.com> wrote:

> >> Can you point me to any research?
> >
> > Nope, havent seen this 'safe native x86 bytecode' idea 
> > mentioned/researched anywhere yet.
> 
> Native Client: A Sandbox for Portable, Untrusted x86 Native Code, IEEE 
> Symposium on Security and Privacy, May 2009 
> http://nativeclient.googlecode.com/svn/data/docs_tarball/nacl/googleclient/native_client/documentation/nacl_paper.pdf
> 
> The "Inner Sandbox" they talk about verifies a subset of x86 code. For 
> indirect control flow (computed jumps), they introduce a new 
> instruction that can do run-time checking of the destination address.
> 
> IIRC they have a patched gcc toolchain that can compile to this subset 
> of x86.

Btw., the first time i mentioned this idea publicly was in early 2006, 3 
years before the above 2009 paper, in a CONFIG_SECCOMP discussion on 
cpushare-discuss.

I've attached a few of those emails below, which outlines the idea.

Thanks,

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Tue, 10 Jan 2006 12:52:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Andrea Arcangeli <andrea@cpushare.com>,
	Ed Suominen <general@eepatents.com>,
	Linus Torvalds <torvalds@osdl.org>, cpushare-discuss@cpushare.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] make CONFIG_SECCOMP default=n


* Andi Kleen <ak@suse.de> wrote:

> The beauty of using seccomp for the special case of data 
> transformation in a pipe is that it is very simple and likely quite 
> secure and it looks actually practical to me.

well a more generic method could be _more_ practical and still as safe: 
enable bytecode to be uploaded into the kernel, and allow kernel 
components to rely on them. [Add some trivial timeout mechanism to 
detect infinite loops, and abort such instances safely and disable that 
code from that point on]. Seccomp would be just one user of such a 
mechanism.

that 'bytecode' could be "limited x86 code, verified by the kernel at 
upload time, and executed natively afterwards". E.g. pure arithmetical 
code with relative jumps into kernel-validated instruction boundaries 
within that byte code would be an obvious correct first step.

even memory ops could be allowed, as long as the kernel's bytecode 
loading mechanism can automatically prove it's safe: e.g. only stack ops 
are allowed, and the stack segment is limited into a 
per-bytecode-instance small and safe memory range.

yes, the kernel would have to do some (rather simple) disassembly at 
load time to validate things, but that's not a big issue, as it only 
happens once, and is only as complex as complex we allow it to become.

vioala: complex network-filtering decisions done straight in interrupt 
context, defined by the user, compiled into native x86 code and uploaded 
into the kernel.

you could also attach such byte code between pipes, achieving much of 
the seccomp model. At a better performance: no context-switching to the 
'safe seccomp context' is needed.

it could also become _safer_ than seccomp: seccomp does not protect 
against hardware/CPU level attacks, while an in-kernel bytecode loader 
could/would restrict the instruction stream too. E.g. the f00f lockup 
could not be triggered, because the loader does not allow LOCK-ed memory 
ops for example.

so i really think SECCOMP is pretty ad-hoc, poorly thought out and 
apparently not that hot with application writers.

	Ingo

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

Date: Tue, 10 Jan 2006 13:35:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Arcangeli <andrea@cpushare.com>
Cc: Andi Kleen <ak@suse.de>, Ed Suominen <general@eepatents.com>,
	Linus Torvalds <torvalds@osdl.org>, cpushare-discuss@cpushare.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] make CONFIG_SECCOMP default=n


* Andrea Arcangeli <andrea@cpushare.com> wrote:

> > the seccomp model. At a better performance: no context-switching to the
> > 'safe seccomp context' is needed.
> 
> No need of context switching, I already said you can safely attach shm 
> to do the inter process communication, as far as I can tell, you can 
> mmap hard the framebuffer where to decompress the jpeg in the seccomp 
> task and use mmap to get the data in, zerocopy (modulo decompression 
> costs).

you still need to context-switch to the seccomp task (and away from it)! 
With the 'bytecode in the kernel' approach the bytecode could be run via
a syscall, which is an order of magnitude faster than a context-switch.

> > it could also become _safer_ than seccomp: seccomp does not protect 
> > against hardware/CPU level attacks, while an in-kernel bytecode loader 
> > could/would restrict the instruction stream too. E.g. the f00f lockup 
> > could not be triggered, because the loader does not allow LOCK-ed memory 
> > ops for example.
> 
> The same filtering can be done much more simply in userland before 
> firing up the untrusted bytecode, so that can't be more secure, it can 
> only be more complicated and less secure because of the ring 0.

sure, you could do the same filtering in userspace, but the current 
seccomp model does not do filtering. Also, via in-kernel bytecode we 
could embedd user-defined functionality at almost arbitrary places in 
the kernel. Think 'user-defined plugins' for the kernel. Yes, since it 
runs at ring 0 it _has_ to have filtering, mandatorily, but once done, 
it can do much more than seccomp.

> Furthermore in the decompression case, there's no need of filtering 
> the bytecode, the bytecode is trusted (but perhaps you mean to use 
> this new mechanism like kprobes to load seccomp into the kernel, still 
> it's unclear how can you run sys_read/sys_write that way if you said 
> it has to be pure arithmetical bytecode).

details :-) 'x86 bytecode' could include a placeholder for a callout to 
some kernel function. Also, the results could be defined on the safe 
stack as well.

> I see the point of doing the packet filtering decision in irq context, 
> something that cannot be done in userland easily, but that's a very 
> different problem than the one I was trying to address with seccomp. I 
> wasn't even dreaming of executing untrusted bytecode in kernel mode. I 
> would never do that in ring 0. It has to be ring 3 and in the future 
> guest ring 3.

well, lets go step by step. You would trust a trivial untrusted bytecode 
in the kernel, if it was defined as:

	up to 16 instructions of NOP.

correct? It doesnt do anything, but is a first step, and you'd trust it 
even on ring 0, right?

Then, lets extend this a little bit with trivial linear arithmetic ops 
[no divisions or multiplications for now] done to %eax and %ebx:

	movl %eax, %ebx
	addl %eax, %ebx

at most 100 instructions, no jumps allowed, and the bytecode interpreter 
running this code will saves/restores eax/ebx. We can still trust it, 
even on ring 0, and it's provably correct, right?

using similar steps, we can build a pretty usable virtual machine out of 
trivial x86 ops that are 'obviously correct' and easily provable.

branches and jumps need a little bit of care from the validator: they 
may only be relative, non-indirect and may only point to a validated 
instruction. [i.e. no jumping back to in 'between' two instructions, and 
no "jmp (%eax)", etc.  A timeout mechanism [e.g. driven from the timer 
interrupt] ensures that no bytecode can ever run longer than a 
pre-specified amount of time, and if it does, it's disabled and the 
admin is notified.]

again, our pick of instructions was opt-in all along, and the result is 
obviously safe and provable, even though it runs at ring 0, correct?

so if you walk this thought-experiment a bit, you'll quickly arrive to a 
virtual machine that is actually pretty useful already, and is fully 
provable. You should not dismiss this as "I dont trust it because it's 
at ring 0", unless you can show some fatal flaw in my thinking.

> > so i really think SECCOMP is pretty ad-hoc, poorly thought out and 
> > apparently not that hot with application writers.
> 
> I don't think it has received enough attention, your code injection 
> that can't execute syscalls will have the same issues as seccomp as 
> far as application writers are concerned.  [...]

correct. But there will be one crutial difference: it allows untrusted 
code to be run at ring 0! _That_ makes a performance (and feature) 
difference that some application writers might go the trouble of APIs 
for! The possibilities are quite interesting:

- e.g. a webserver protocol stack in the kernel. (Tux done right)

- webserver dynamic pages generated from the kernel.

- complex DoS avoidance filters natively executed in the kernel.

- filesystem plugins executed in kernel-space

- complex security decisions done at native speed. (ok, selinux has a
  pretty good language for this already, which it interprets runtime.)

_that_ is something application writers (or kernel coders) might get 
excited about.

but more importantly, such an approach could generally ease some of the 
"how much functionality should go into the kernel" pressure.

	Ingo
