Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2I1QhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:37:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39794 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab2I1QhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:37:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120928151407.GA14215@somewhere.redhat.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	<87pq5awvgp.fsf@sejong.aot.lge.com>
	<20120927230138.GA10660@somewhere.redhat.com>
	<874nmivgqk.fsf@sejong.aot.lge.com>
	<CABPqkBQbaDdGwyOK-qcheqyTzrr505undnFae8BQGEx+r0hKyg@mail.gmail.com>
	<20120928151407.GA14215@somewhere.redhat.com>
Date: Fri, 28 Sep 2012 18:36:59 +0200
Message-ID: <CABPqkBQMRRw=sc1+DQ2gbHgT7zGD4qhGQKkArsre5VwgtNPGAA@mail.gmail.com>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 5:14 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Sep 28, 2012 at 09:07:57AM +0200, Stephane Eranian wrote:
>> On Fri, Sep 28, 2012 at 7:49 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> > Hi Frederic,
>> >
>> > On Fri, 28 Sep 2012 01:01:48 +0200, Frederic Weisbecker wrote:
>> >> When Arun was working on this, I asked him to explore if it could make sense to reuse
>> >> the "-b, --branch-stack"  perf report option. Because after all, this feature is doing
>> >> about the same than "-b" except it's using callchains instead of full branch tracing.
>> >> But callchains are branches. Just a limited subset of all branches taken on excecution.
>> >> So you can probably reuse some interface and even ground code there.
>> >>
>> >> What do you think?
>> >
>> > Umm.. first of all, I'm not familiar with the branch stack thing.  It's
>> > intel-specific, right?
>> >
>> The kernel API is NOT specific to Intel. It is abstracted to be portable
>> across architecture. The implementation only exists on certain Intel
>> X86 processors.
>>
>> > Also I don't understand what exactly you want here.  What kind of
>> > interface did you say?  Can you elaborate it bit more?
>> >
>> Not clear to me either.
>>
>> > And AFAIK branch stack can collect much more branch information than
>> > just callstacks.  Can we differentiate which is which easily?  Is there
>> > any limitation on using it?  What if callstacks are not sync'ed with
>> > branch stacks - is it possible though?
>> >
>> First of all branch stack is not a branch tracing mechanism. This is a
>> branch sampling mechanism. Not all branches are captured. Only the
>> last N consecutive branches leading to a PMU interrupt are captured
>> in each sample.
>>
>> Yes, the branch stack mechanism as it exists on Intel processors
>> can capture more then call branches. It is HW based and provides
>> a branch type filter. Filtering capability is exposed at the API level
>> in a generic fashion. The hw filter is based on opcodes. Call branches
>> all cover call, syscall instructions. As such, the branch stack mechanism
>> cannot be used to capture callstacks to shared libraries, simply because
>> there a a non call instruction in the trampoline. To obtain a better quality
>> callstack you have instead to sample return branches. So yes, callstacks
>> are not sync'ed with branch stack even if limited to call branches.
>>
>
> You're right. One doesn't simply sample callchains on top of branch tracing. Not easily at least.
> But that's not what we want here. We want the other way round: use callchains as branch sampling.
> And a callchain _is_ a branch sampling. Just a specialized one.
>
> PERF_SAMPLE_BRANCH_STACK either records only calls, only ret, or everything, or....
> You can define the filter with "-j" option. Now callchains can be considered as the result
> of a specific "-j" filter option. It's just a high level filtering. ie: not just based on opcode
> types but on semantic post-processing. As if we applied a specific filter on a pure branch tracing
> that cancelled calls that had matching ret.
>
A callstack mode will be added to PERF_SAMPLE_BRANCH_STACK geneirc
filter because this becomes
available in HW starting with Haswell (see Vol3b August 2012, section
17.8). This will still be a statistical
approach and not a complete callstack trace (only the last 16 calls).

So yes, you could piggyback your callstack on top of that. You could
return the full trace with the existing
perf_branch_entry data structure. You'd have to fill in the prediction
flags as N/A.

But now with Haswell, one would have to decide whether to use the 'SW
callstack' or the 'HW callstack'.
It all depends on the quality of the data returned by HW callstack.


> But in the end, what we have is just branches. Some branch layout that is biased, that already passed
> through a semantic wheel, still it's just _branches_.
>
> Note I'm not arguing about adding a "-j callchain" option, just trying to show you that callchains
> are not really different from other filtered source of branch sampling.
>
>
>> > But I think it'd be good if the branch stack can be changed to call
>> > stack in general.  Did you mean this?
>> >
>> That's not going to happen. The mechanism is much more generic than
>> that.
>>
>> Quite frankly, I don't understand Frederic's motivation here. The mechanism
>> are not quite the same.
>
> So, considering that callchains are just "branches", why can't we use them as
> a branch source, just like PERF_SAMPLE_BRANCH_STACK data samples, that we
> can reuse in "perf report -b".
>
> Look at commit b50311dc2ac1c04ad19163c2359910b25e16caf6
> "perf report: Add support for taken branch sampling". It's doing (except for a few details
> like the period weight of branch samples) the same than in Namhyung patch, just with
> PERF_SAMPLE_BRANCH_STACK instead of callchains.
>
> I don't understand what justifies this duplication.
