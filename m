Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1EIXh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 19:37:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1EIXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 19:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=CVHWzDNv+4MpL1cqeKwYG6iXpa4Xm9Brih/9TxzpNotqJ9Z870ec1Cj9tQi8swp4z0
         dLlS5f3kOam9YnPcwHJw==
MIME-Version: 1.0
In-Reply-To: <1304788829.11129.57.camel@frodo>
References: <4DC45537.6070609@linux.intel.com> <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com> <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com> <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
From: David Sharp <dhsharp@google.com>
Date: Mon, 9 May 2011 16:37:33 -0700
Message-ID: <BANLkTik3CKw=tTtfqhDxR6f39_7kCLnUEA@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 10:20 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-05-07 at 16:44 +0200, Ingo Molnar wrote:
>
> <snip>
>
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>> > Here's the choices then:
>> >
>> > 1) we get libparsevent.so out into the world and all tools can use it, and
>> > the raw formats of the trace events will no longer be an issue as long as the
>> > names of events and fields stay the same.
>>
>> Firstly, such an event parser already exists in
>> tools/perf/util/parse-events.[ch], so if you want to librarize it please talk
>> to Arnaldo to create tools/perf/lib/ and a libperf.so.
>
> The pares-events.[ch] file in perf just parses the command line options
> to denote what events need to be recorded. The real work lies in
> trace-event-parse.c that does the real parsing, and that file was copied
> from libparsevent.so. I purposely wrote that as a library that perf
> could use (again, being open to other ideologies), but instead of using
> the library, the code was hard coded into perf, which guaranteed the
> forking of this code.

A small note that this has also created some minor frustration for me,
as I had to send patches to extend this parsing to two different trees
and maintainers. (I don't think the perf patch ever was applied... I
should follow up on that.)

I believe it's been suggested that trace-cmd should be part of the
kernel tree, just like the perf tool. This would be nice, and would
more easily allow them to share this parsing code. It would also give
them a common place to work on their unification.


>
> <snip>
>
>> Secondly, you are solving the wrong problem and you are not seeing the real
>> problems. We can keep and we *will* keep ABIs, it's not hard. 4 bytes padding
>> is not an issue and it never was for PowerTop nor for any other real person who
>> relies on tracing.
>
> I've Cc'd the Google folks that are very interested in tracing, to let
> them respond to that comment.

Thanks for raising it to my attention.

The size of events is a *huge* issue for us. Please look at the
patches we have been sending out for tracing: A lot of them are about
reducing the size of events. Most of the patches we carry internally
are about reducing the size of events. Memory is the most scarce
resource on our systems, so we *cannot* afford to use large trace
buffers. This means that with a 8MB/cpu buffer (this is about what we
can hope to allocate on a heavily loaded system), we can only get on
the order of 10 seconds of trace data at best when tracing
systemcalls, irqs, and sched_switch. This is not enough when we don't
know what exactly we're looking for.

We have gone so far as to add an entire second set of "_tiny" events
for syscalls that records only 16 bits of arg0, and for sched_switch
that records only next_pid. These alone have roughly doubled the trace
period, and it is still not enough.

I really can't stress enough how big an issue the size of events is
for us. It is our number one issue with tracing.

>
> Do you think that "other real person"s are only kernel developers or
> desktop users that are not using production systems?
>
> And it's not just 4 bytes, its the entire useless header. Who cares
> about preempt counts? I examine that field only 1% of the time. In most
> other cases its totally useless. Same with interrupt flags, although I
> do look at them more often than preempt count. We (Frederic and I) still
> want to get rid of the pid for every event.

Internally we have dropped all but event type and pid (and changed pid
to 16 bits), and we have plans and patches in development to drop pid.

>
>>
>> As i see it the problem is the thought-less ftrace churn and the fragility of
>> how TRACE_EVENT() can be changed.
>
> Now you are just insulting me. There has not been any "thought-less"
> churn.
>
> I *designed* TRACE_EVENT() to be changed. That's why I wrote all that
> code to export the event formats. If you think all raw data of events
> are to be an ABI, then lets rip out all the event formats and make
> everything hard-coded.

We have tools that rely on TRACE_EVENT formats being exported. This
was a factor in our choice to use ftrace, and I consider parsing the
formats to be part of the ABI.

It may be true that some fields of some events should not change
incompatibly, but having the formats exported allows a wide definition
of "compatible": mostly that the name should not change. Even changing
the width of an integer field works perfectly well.

>
> I'm sorry, but that mentality seems to encourage thoughtless churn.
>
>>
>> Really, ftrace and in particular you are showing a huge disconnect and i'm
>> increasingly unhappy about it. Look at this very thread: you fought tooth and
>> nail to even *acknowledge* that there is a problem...
>
> I agree there is a problem, but what each of us think the problem is, is
> different. I say there's a problem with tools depending on a layout of
> raw data that is internal to the kernel, especially when it was designed
> to allow robustness. If we make it easy for tools to extract the data
> properly, then there should not be any issues if the raw format changes.

Agreed. It also allows forward compatibility when new events or new
fields are added, or when an event changes.

I see tracing as primarily a debugging tool: It is about inspecting
kernel internals. You cannot expect kernel internals to change, and
not expect something that inspects those internals not to change the
format of the data it exports. Kernel variables, structures and
parameters will change, disappear, or become meaningless or useless
(eg, lock_depth); and they are supposed to as much as the kernel is
supposed to change improve. Luckily (or actually, by design), we have
a way to cope with this: the event formats are exported for tools to
read.

I think ftrace has an abi, although I'm not sure how recorded it is.
In my view it includes:
- the debugfs control files (events dir, buffer_size_kb, options,
set_event, etc)
- the format of the ring buffer pages and ring buffer event headers
- the format and meaning of the event format files.
- For a few select trace events, yet to be enumerated, the presence,
name, and wide-sense field type (integer, array, dyn. array) of some
select fields (eg "next_pid" in "sched_switch").

In my view it explicitly does *not* include:
- the exact content of the event format files, except as noted above.

>
> Linus said:
>
>> If you made an interface that can be used without parsing the
>> interface description, then we're stuck with the interface. Theory
>> simply doesn't matter.
>>
>> You could help fix the tools, and try to avoid the compatibility
>> issues that way. There aren't that many of them.
>
> To me this seems that we have a way to have the tools do the right
> thing. If a library can be used that allows a more robust interface,
> then why not use it? The library already exists, I talked to Arjan, and
> he's willing to use it. I'm willing to put the effort in fixing powerTop
> and pushing this library to distributions. What's the problem?
>
> You are entering a very dangerous precedence by stating that the raw
> format is now the ABI, end of story. This will bite us in the future. It
> just did, and it will just get worse.
>
>>
>> As things look like from my side it appears you want to keep ftrace a messy,
>> forked project with no regard to perf based tooling and this will fragment
>> Linux instrumentation, the many technical disadvantages be damned.
>
> ftrace is not a fork and never was. To be a fork, we need a common
> ancestor. Ftrace and perf do not have that. Perf was created (after
> Ftrace) to profile events, and did so very well. It just happened to
> expand into the tracing area, where you want me to abandon all my ftrace
> work and rewrite it on top of something that was not designed to do
> tracing.
>
> Now that perf has entered the tracing field, I would be happy to bring
> the two together. But we disagree on how to do that. I will not drop
> ftrace totally just to work on perf. There's too many users of ftrace
> that want enhancements, and I will still support that. The reason being
> is that I honestly do not believe that perf can do what these users want
> anytime in the near future (if at all). I will not abandon a successful
> project just because you feel that it is a fork.

We have invested heavily in using ftrace. We chose to use ftrace
because it was maintained upstream, fast, simple to use, and had all
the features we were already relying on from ktrace, and then some.
When we last measured (admittedly quite a while ago now), perf had
about 5x slower write latency than ftrace. This was probably the
biggest thing that stopped us from considering it.

Perf might improve its tracing story (I'm sure it already has, but
we've been playing ostrich a bit in order to get work done), and I'm
also in agreement that bringing them closer together is a Good Thing.
But if ftrace simply disappears, that would create a lot of work for
us. We are every day depending on ftrace and infrastructure built on
top of ftrace more and more to make Google faster. We can cope with
incremental improvements. Wholesale ripping would force us to fork
this part of the kernel, as we have too much invested in ftrace.

>
> <snip>
>
