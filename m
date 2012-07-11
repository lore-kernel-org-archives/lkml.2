Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2GLAwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:52:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36931 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2GLAwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:52:37 -0400
Message-ID: <4FFDBF31.4010508@landley.net>
Date: Wed, 11 Jul 2012 13:00:17 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
CC: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        ltc-kernel@ml.yrl.intra.hitachi.co.jp
Subject: Re: [RFC PATCH -tip ] tracing: make a snapshot feature available
 from userspace.
References: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp> <4FF41F37.6040908@hitachi.com> <4FF4E75D.1050507@landley.net> <4FFD11AD.1080107@hitachi.com>
In-Reply-To: <4FFD11AD.1080107@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 12:39 AM, Hiraku Toyooka wrote:
> Hello, Rob,
> 
> Thank you very much for your advice.
> 
> (2012/07/05 10:01), Rob Landley wrote:
>> On 07/04/2012 05:47 AM, Hiraku Toyooka wrote:
>>> Hello, Steven,
>>>
>>> I've sent below RFC patch, but still have no responses. This patch can
>>> be applied to current tip tree.
>>>
>>> If you have time, could you give any comment about this patch?
>>
>> My familiarity with ftrace is "I saw a presentation on it at a
>> conference a couple years ago", so I'm not the guy to comment on the
>> advisability of the patch itself.
>>
>> As for the documentation: seems reasonable, could use some english
>> polishing.
>>
>>>> +Snapshot
>>>> +--------
>>>> +If CONFIG_TRACER_MAX_TRACE is set, the (generic) snapshot
>>>> +feature is available in all tracers except for the special
>>>> +tracers which use a snapshot inside themselves(such as "irqsoff"
>>>> +or "wakeup").
>>
>> This is confusing, I'm guessing irqsoff and wakeup already have
>> persistent buffers without CONFIG_TRACER_MAX_TRACE? (So there is a
>> generic snapshot feature, but some tracers have their own internal
>> buffer and don't use the generic one?)
>>
> 
> No, CONFIG_TRACER_MAX_TRACE is originally for making the spare buffer
> available. Both some special tracers (such as irqsoff) and generic
> snapshot uses the common spare buffer. But purpose of each snapshot is
> different. In the special tracers, snapshot is used for recording
> information related to max latency of something (such as longest
> interrupt-disabled area). This is automatically updated only when the
> max latency is detected. In other words, those special tracers use the
> same spare buffer in the different way. Thus, we can not enable generic
> snapshot for those tracers.

Ok, those tracers are not _compatible_ with snapshot.

Good to know.

>> Is the fact that some tracers don't use this feature an important part
>> of the description of the feature? Is making them use common code a todo
>> item, or just a comment?
>>
> 
> Anyway, the fact is not important here.
> 
> 
>> How about:
>>
>> CONFIG_TRACER_MAX_TRACE makes a generic snapshot feature available to
>> all tracers. (Some tracers, such as "irqsoff" or "wakeup", use their own
>> internal snapshot implementation.)
>>
> 
> Thanks, but I think the following one is more suitable.
> 
> (Some tracers, such as "irqsoff" or "wakeup", already use the snapshot
> implementation internally)

This implies that setting flag is a NOP for them, rather than "if you
take a snapshot, they'll stomp all over the buffer".

>>>> +This enables to preserve trace buffer at a particular point in
>>>> +time without stopping tracing. When a snapshot is taken, ftrace
>>>> +swaps the current buffer with a spare buffer which is prepared
>>>> +in advance. This means that the tracing itself continues on the
>>>> +spare buffer.
>>
>> Snapshots preserve a trace buffer at a particular point in time without
>> stopping tracing; ftrace swaps the current buffer with a spare buffer,
>> and tracking continues in the spare buffer.
>>
>>>> +Following debugfs files in "tracing" directory are related with
>>>> +this feature.
>>
>> The following debugfs files in "tracing" are related to this feature:
>>
>>>> +  snapshot_enabled:
>>>> +
>>>> +    This is used to set or display whether the snapshot is
>>>> +    enabled. Echo 1 into this file to prepare a spare buffer
>>>> +    or 0 to shrink it. So, the memory for the spare buffer
>>>> +    will be consumed only when this knob is set.
>>
>> Write 1 to this file to allocate a snapshot buffer, 0 to free it.
>>
> 
> I'll fix them.
> 
> 
>> (Query: do you have to free the buffer after taking a snapshot below?)
>>
> 
> No, we don't always need to free the buffer, although we can free it
> when the snapshot becomes unnecessary. We can also reuse the buffer if
> we'd like to take the next snapshot.
> (I'll add this description.)

Actually I was worried about the lifetime rules for the buffer (when
does it need to be disposed of, and who is responsible for doing so?)
but it looks like ftrace only allows one trace to be going on in the
entire system at any given time, so all this context is kernel global
anyway...

>>>> +  snapshot_pipe:
>>>> +
>>>> +    This is used to take a snapshot and to read the output
>>>> +    of the snapshot. Echo 1 into this file to take a
>>>> +    snapshot. Reads from this file is the same as the
>>>> +    "trace_pipe" file (described above "The File System"
>>>> +    section), so that both reads from the snapshot and
>>>> +    tracing are executable in parallel.
>>
>> Echo 1 into this file to take a snapshot, then read the snapshot from
>> the file in the same format as "trace_pipe" (described above in the
>> section "The File System").
>>
> 
> I'll fix that.
> 
>> Design questions left for the reader: why are allocating a snapshot
>> buffer and taking a snapshot separate actions?
> 
> I'll add following description:
> Allocating a spare buffer and taking a snapshot are separated because
> latter one should be done successfully and immediately. If they are not
> separated, we may fail to take a snapshot because of memory allocation
> failure or we may lose older trace data while allocating memory.

Buffer allocation is a separate action because taking a snapshot is a
low-latency operation that should never fail. Got it.

But again, why couldn't open() do one and read() (from position 0) do
the other? And then if you wanted to take another snapshot you could
lseek() back to 0...

*shrug* I suppose the way you have it works. Just curious.

>> Why is there only _one_ snapshot buffer?
>>
> 
> Because of easy reviewing, I've decided to implement step by step. So
> this patch just provide "only one" spare buffer. However, I got some
> feedback for multiple snapshot at LinuxCon Japan 2012. So I may extend
> this feature.

The implementation can change all you like after the code goes in, but
you really have to get the API right because you're going to be stuck
supporting it <pinkypie>FOREVER</pinkypie>.

(The <tag> is a cultural reference from a local anime. Don't worry about
it.)

>>>> +Here is an example of using the snapshot feature.
>>>> +
>>>> + # echo nop > current_tracer
>>>> + # echo 1 > snapshot_enabled
>>>> + # echo 1 > events/sched/enable
>>>> + [...]
>>>> + # echo 1 > snapshot_pipe
>>
>> Is the order significant here? 
> 
> If the current_tracer is a special tracer such as irqsoff,
> snapshot_enabled can't be set to 1. So current_tracer has to be
> configured to appropriate tracer in the first place.

But they aren't compatible anyway? (So presumably this call failing is
part of the enforcement mechanism by which the incompatible combination
is disallowed?)

What happens if you do it the other way around? (echo 1 >
snapshot_enabled and then echo irqsoff > current_tracer)?

>> Do you have to set up a snapshot buffer before you start tracing? 
> 
> No. We can enable trace events or start tracing any time.
>
>> When you switch buffers, does the new buffer
>> start empty, or with a copy of the previous trace data?
>>
> 
> Yes, after taking a snapshot, current buffer starts empty.
> 
> 
>> I'm guessing the reason buffer switching was described above is to
>> explain that taking a snapshot blanks the current trace history since
>> you switch to an empty buffer?
>>
> 
> Yes. Actually, this snapshot feature only swaps the current buffer and
> the spare buffer. Now I'm considering to call it "swap" instead of
> "snapshot"...

I'm all for clarifying what it does, but we already have a subsystem
called "swap" (swap partitions, swapon/swapoff) so that name isn't
necessarily less confusing.

>>>> + # cat snapshot_pipe
>>>> +            bash-3352  [001] dN.. 18440.883932: sched_wakeup:
>>>> comm=migration/6 pid=28 prio=0 success=1 target_cpu=006
>>>> +            bash-3352  [001] dN.. 18440.883933: sched_wakeup:
>>>> comm=migration/7 pid=32 prio=0 success=1 target_cpu=007
>>>> +            bash-3352  [001] d... 18440.883935: sched_switch:
>>>> prev_comm=bash prev_pid=3352 prev_prio=120 prev_state=R ==>
>>>> next_comm=migration/1 next_pid=8 next_prio=0
>>>> +[...]
>>
>> How big is one of these buffers, anyway?  I take it the reason opening
>> snapshot_pipe doesn't just allocate a snapshot buffer and take the
>> snapshot then (to persist for the duration of the filehandle) is to
>> avoid pinning too much kernel memory?
>>
> 
> The size of two buffers is same because this is swap.

So the new one is also buffer_size_kb?

Out of curiosity, what happens if you go:

  echo nop > current_tracer
  echo 1 > snapshot_enabled
  echo 64 > buffer_size_kb

(Techncially current_tracer is still nop...)

> The reason of the separated operations is to swap two buffers
> immediately without fail. if opening snapshot_pipe allocates a buffer,
> we need a special userspace command to realize that.

Um, cat can open a file? I don't understand.

If you need a delay between open and read, you can do that from the
command line with something like:

  (read -n 1 < /dev/tty; cat > ~/walrus.txt) < /path/to/thingy

I dunno if that's a good idea, I'm just trying to understand the design
here...

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
