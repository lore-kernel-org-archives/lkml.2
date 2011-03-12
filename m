Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1CLO7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 09:59:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1CLO7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 09:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hLX5LpU7bRT7Mkcilj5wfoCDaz9mew7btOgZCTLMeSGpvnrRen9S/cAv3l5WUvrgQv
         CNrqQa1MOz92XeOzjGLzQ/+DChQGWODlFQYs4DDG6cnqyk3/GmDp5HU+dvRovZiDF1jJ
         RXxnJswSorYpRWpTrsgPnGEFMiAOrUocxFOSM=
MIME-Version: 1.0
In-Reply-To: <20110311115657.GB1826@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
	<20110307180619.GG1873@nowhere>
	<AANLkTi=rabeXE6m0wRo029jgqHLBaUGQcXYJriLewZeJ@mail.gmail.com>
	<20110310024355.GG2533@nowhere>
	<AANLkTikZxDyL-SW7FFbEd4skMNTVWeh7mGDTXfWkvEMR@mail.gmail.com>
	<20110311115657.GB1826@nowhere>
Date: Sat, 12 Mar 2011 22:59:08 +0800
Message-ID: <AANLkTimaxPJCkA3TuDQKCvDXtqTrUb8vyrNqRRSzvYwb@mail.gmail.com>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
From: Sam Liao <phyomh@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 7:57 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Mar 10, 2011 at 10:32:43PM +0800, Sam Liao wrote:
>> On Thu, Mar 10, 2011 at 10:43 AM, Frederic Weisbecker
>> <fweisbec@gmail.com> wrote:
>> > On Tue, Mar 08, 2011 at 04:59:30PM +0800, Sam Liao wrote:
>> >> On Tue, Mar 8, 2011 at 2:06 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >> > So, instead of having such temporary copy, could you rather feed the callchain
>> >> > into the cursor in reverse from perf_session__resolve_callchain() ?
>> >> >
>> >> > You can keep the common part inside the loop into a seperate helper
>> >> > but have two different kinds of loops.
>> >>
>> >> In perf_session__resolve_callchain, only the callchain itself can be reversed,
>> >> which means the root of report will still be the ip of the event with a reversed
>> >> call chain sub tree. But what is more impressive to user is to make "main" like
>> >> function to be the root of the report, and this means that both the ip
>> >> and call chain is
>> >> involved to the reversion process.
>> >>
>> >> Since the ip of event is resolved in event__preprocess_sample, so it is kind
>> >> hard to do such reversion in a better way.
>> >
>> > You are making an interesting point.
>> >
>> > My view of this feature was limited to the current per hist area: having
>> > the callchains on top of hists that can be sorted per ip, dso, pid, etc...
>> > like we have today basically. So my view was for this reverse callchain
>> > to show us one callers profiling for each hist entry.
>> >
>> > But your idea of turning the callee into the caller would show us a very global
>> > profiling. With reverse callchains it can be a very nice overview of the big picture.
>> >
>> > IMO both workflow can be interesting:
>> >
>> > 1) Have a big reversed callchain overview, with one root per entrypoint. This
>> > what you wanted.
>> > 2) Have a per hist 1)  which means a per hist per entrypoint callchain
>> >
>> > 1) involves reverting both callchains and ip <->caller whereas 2) only involves
>> > reverting the callchain.
>>
>> Having both workflow included would be more helpful.
>
> That's the point, we should be able to do both. But only 1) is possible with
> your initial proposition.
>
>> >
>> > In order to get both features with a maximum flexibility and keep that extendable, I
>> > would suggest to decouple that in two independant parts:
>> >
>> >        - an option to get reversed callchains. Using the -g option and caller/callee
>> >        as a third argument.
>> >
>>
>> This could be easily extended by reversing the callchain symbols as
>> you mentioned.
>
> Yeah. -g caller only requires to iterate the callchain in reverse.
>
>> >        - a new "caller" sort entry. What defines a hist entry is a set of sort
>> >        entries: dso, symbol, pid, comm, ... That we use with the -s option in perf report.
>> >        If you want one hist per entrypoint, we could add a new "caller" sort entry.
>> >        Then perf report -s caller will (roughly) produce one hist for main(), one hist
>> >        for kernel_thread(), etc...
>> >
>>
>> I'm not sure adding a "caller" sort entry can get things done. As for
>> my limited understanding,
>> "sort" is kind way to group events
>
> This is actually _what_ group events. This defines how hist entries are
> built.
>
> If you do "perf report -s sym", events will be grouped by symbols.
> Thus if you had thousands events but all of them only hit sym1 and sym2
> then you'll see two groups in your histogram.
>
> Look:
>
> # ./perf report -s sym --stdio
> # Events: 4  cycles
> #
> # Overhead             Symbol
> # ........  .................
> #
>    36.72%  [.] hex2u64
>    31.21%  [k] __lock_acquire
>    18.03%  [k] lock_acquire
>    14.04%  [k] sub_preempt_count
>
> We may have got thousand events for the above profile. But only 4 symbols
> were hit in amongst these thousand events. As we asked for, events have been
> grouped per symbol target.
>
> Callchains follow this grouping scheme. Below the __lock_acquire hist,
> you would only get callchains for which the root (deepest callee) was __lock_acquire.
>
> If you have several grouping, like -s sym, dso, pid
> then it computes an intersection. Events will be grouped when their
> sym, dso and pid are equal. Moreoever they will be sorted, first dimension
> per sym, second dimension per dso, third dimension per pid.
>
> You should play a bit with different combinations to get the whole picture
> and how it works.
>
> Callchains still follow the grouping, as elaborated as it can be. For the hist
> that has sym1, dso2 and pid 3, you'll find only callchains that start from sym1
> for events that happened on dso2 and pid3.
>
>
> , after we group all the events
>> under "main" or "kernel_thread",
>> the sub-trees will still rooted as ip entry points with a reversed
>> call-chain sub-trees which seems
>> just the same as the previous workflow. Am I right? If so, here we
>> still have to revert the ip and
>> callchain.
>
> No. The callchain will follow that grouping. If you group only per caller
> (-s caller) you may have one hist entry for main and another for kernel_thread.
> Then below the main entry, you'll have only callchains starting
> from main. And below the kernel_thread, only callchains starting from kernel_thread.
>
> It depends if you select reverse callchain or not:
>
> $ perf report -s caller
>
> That will report main and kernel_thread as hists, and regular callee -> caller callchains.
> Hence under main hist, you'll a lot of callchain starting from random points and all
> ending in main!
>
> $ perf report -s caller -g caller
>
> That will report main and kernel_thread as hists, with callchains starting from
> main under main.
>
> It becomes interesting when you want more granularity with -s caller,dso if we bring a way
> to push forward the entrypoint one day. I suspect even more sorting combinations are
> going to be interesting.
>

Thanks for clarification. I'll try to come up with patches as you talked.

-Sam
