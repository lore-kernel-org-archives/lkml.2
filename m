Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab1BAOhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:37:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:46505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab1BAOhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:37:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xph7oWpiokGvfKdlx8lDUeM0ftbz28L8YePYDZTBHk6As71OgY7zqtVzvpvTW1oq1i
         JwbiseaU+GqgkaSPb3qg==
MIME-Version: 1.0
In-Reply-To: <20110126135801.GA30064@elte.hu>
References: <201101062000.p06K0ESw011195@hera.kernel.org>
	<20110126113740.GA13911@elte.hu>
	<AANLkTintgqOkwo=WRH_9vGwGgXf0XrfU2e++daUOOG=i@mail.gmail.com>
	<20110126120646.GA20064@elte.hu>
	<AANLkTikjEGMV=ZwiUmFxmQaELG525ntd=Xi8_EXFT9J7@mail.gmail.com>
	<20110126135801.GA30064@elte.hu>
Date: Tue, 1 Feb 2011 15:36:55 +0100
Message-ID: <AANLkTimah1bWYiC=jo9XTWdB-61mOOKxxw4PSL7tB16R@mail.gmail.com>
Subject: Re: perf, x86: Provide a PEBS capable cycle event
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 2:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Wed, Jan 26, 2011 at 1:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Stephane Eranian <eranian@google.com> wrote:
>> >
>> >> On Wed, Jan 26, 2011 at 12:37 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >
>> >> > * Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>> >> >
>> >> >> Gitweb:     http://git.kernel.org/linus/7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> >> >> Commit:     7639dae0ca11038286bbbcda05f2bef601c1eb8d
>> >> >> Parent:     abe43400579d5de0078c2d3a760e6598e183f871
>> >> >> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> >> AuthorDate: Tue Dec 14 21:26:40 2010 +0100
>> >> >> Committer:  Ingo Molnar <mingo@elte.hu>
>> >> >> CommitDate: Thu Dec 16 11:36:44 2010 +0100
>> >> >>
>> >> >>     perf, x86: Provide a PEBS capable cycle event
>> >> >>
>> >> >>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> >>     LKML-Reference: <new-submission>
>> >> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> >> >> ---
>> >> >>  arch/x86/kernel/cpu/perf_event_intel.c |   26 ++++++++++++++++++++++++++
>> >> >>  1 files changed, 26 insertions(+), 0 deletions(-)
>> >> >
>> >> > btw., precise profiling via PEBS:
>> >> >
>> >> >  perf record -e cycles:p ...
>> >> >
>> >> > works pretty nicely now on Nehalem CPUs and later.
>> >> >
>> >> The problem is that cycles:p is not equivalent to cycles in terms of how
>> >> cycles are counted. cycles counts only unhalted cycles. cycles:p counts
>> >> ALL cycles, event when the CPU is in halted state.
>> >
>> > That's not really an issue in practice: it at most can cause a bit larger value for:
>> >
>> >     2.38%       swapper  [kernel.kallsyms]      [k] mwait_idle_with_hints                             ▮
>> >
>> > Which entry exists with regular cycles event _anyway_, because every irq entry ends
>> > up there.
>> >
>>
>> There is a difference in interpretation. Because now when you get samples in those
>> idle routines, you cannot tell whether it is because you actually execute code
>> there or because you were halted (not executing) and now sampling has altered the
>> behavior of the system in that you wake up from halted state to service a PMU
>> interrupt.
>
> The thing is, most people are not interested in seeing the idle routine entry
> anyway, so we already exclude it in say 'perf top' output, see the skip_symbols[]
> array in builtin-top.c.
>
> So utility seems rather low.
>
> If we contrast it to the utility of having precise PEBS sampling, which dramatically
> improves *all* profiling data and which improves the reading of annotated profiling
> output beyond measure, the default path to go here seems rather obvious. Agreed?
>
I don't agree.

PEBS does not operate the same way as regular interrupt-based sampling. You
need to understand what you are doing when you use it. It cannot really be used
transparently, that's unfortunate.

There is more than just halted vs. unhalted. In fact, even that is
more complicated
than it seems. What cycles:pp (inst_retired:cmask=16:i) measures is not clearly
defined. In system-wide mode, where you can go idle, it varies depending on the
system you're on and the idle implementation, i.e., what mwait() does. If you
try varying idle= from default (intel_idle), you'll see different
results, just by counting.

I don't have a good definition for the 'cycles' that are actually measured by
this event.

But there are other key differences.

To get a sample, you need a PEBS sample and that requires an instruction or
uop to retire. PEBS records the machine state at retirement of an instruction or
uop. Sometimes, you do not retire instructions for a long time and thus the
sample distribution is skewed.

For instance, PEBS does not work well with rep-prefixed instructions.
It is fairly
easy to see the problem with a rep mov on a buffer. I have appended the
test program at the end for reference.

Here we're copy a 25MB buffer with rep mov. First let's do the regular
cycles with target average frequency of 1000Hz (default).

$ perf record -e cycles:pp -c 229579021  ./repmov
a=0x7f55a96b3010 a_e=0x7f55aafb3010 total_size=25MB
b=0x7f55a7db2010 b_e=0x7f55a96b2010 total_size=25MB

$ perf report
# Events: 94K cycles
#
# Overhead  Command      Shared Object                       Symbol
# ........  .......  .................  ...........................
#
    98.96%   repmov  repmov             [.] main
     0.08%   repmov  [kernel.kallsyms]  [k] perf_ctx_adjust_freq
     0.06%   repmov  [kernel.kallsyms]  [k] perf_event_task_tick

The rep mov function was inlined in main(), obviously. If you were
to use perf annotate, it would show for function main():

100.00 : 40058a: f3 a5  rep movsl %ds:(%rsi),%es:(%rdi)

Which is expected.


Now, let's use cycles:pp (which gets converted automagically by the
kernel into inst_retired:cmask=16:i):

$ perf record -e cycles:pp   ./repmov
a=0x7f55a96b3010 a_e=0x7f55aafb3010 total_size=25MB
b=0x7f55a7db2010 b_e=0x7f55a96b2010 total_size=25MB

$ perf report
# Events: 90K cycles
#
# Overhead  Command      Shared Object                     Symbol
# ........  .......  .................  .........................
#
    97.21%   repmov  [kernel.kallsyms]  [k] apic_timer_interrupt
     1.43%   repmov  repmov             [.] main
     0.10%   repmov  [kernel.kallsyms]  [k] perf_ctx_adjust_freq


We get about the same number of samples, but the distribution
is completely different.

How is that possible?

Which of the two modes is more precise, then?

Is there one mode that is always more precise?

There are other side effects of PEBS, including some bias in the
sample distribution due to the PEBS shadow effect.

In summary, I don't think allowing this trick on-the-fly without the
user knowing what is going is a good idea.

I think the trick is cool and could be useful. We need to ensure we
can setup the PMU for this mode but users have to be aware of what
is going on to correctly interpret the profiles.

I would drop that trick from the kernel. It would still be accessible
by explicitly passing inst_retired:cmask=16:i to the perf tool.


#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <err.h>

int
doit(void *a, void *b, size_t sz)
{
	asm volatile ("cld\n\t"
			"rep\n\t"
			"movsl"
			: "=c" (sz), "=S" (b), "=D" (a)
			: "0" (sz), "1" (b), "2" (a)
			: "memory"
	    );
}

int
main(int argc, char **argv)
{
	uint32_t *a, *b;
	uint64_t i, nloop = 20000;
	size_t sz, count = 6553600;

	if (argc > 1)
		count = strtoull(argv[1], NULL, 0);
	if (argc > 2)
		nloop = strtoull(argv[2], NULL, 0);

	sz = count * sizeof(*a);

	a = malloc(sz);
	if (!a)
		err(1, "cannot allocate");

	b = malloc(sz);
	if (!b)
		err(1, "cannot allocate");

	printf("a=%p a_e=%p total_size=%zuMB\n", a, a + count, sz >>20);
	printf("b=%p b_e=%p total_size=%zuMB\n", b, b + count, sz >>20);

	for (i=0; i < nloop; i++)
		doit(a, b, count);

	free(a);
	free(b);
	return 0;
}
