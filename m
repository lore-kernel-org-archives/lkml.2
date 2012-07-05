Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2GEBB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:01:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34896 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2GEBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:01:23 -0400
Message-ID: <4FF4E75D.1050507@landley.net>
Date: Wed, 04 Jul 2012 20:01:17 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip ] tracing: make a snapshot feature available
 from userspace.
References: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp> <4FF41F37.6040908@hitachi.com>
In-Reply-To: <4FF41F37.6040908@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 05:47 AM, Hiraku Toyooka wrote:
> Hello, Steven,
> 
> I've sent below RFC patch, but still have no responses. This patch can
> be applied to current tip tree.
> 
> If you have time, could you give any comment about this patch?

My familiarity with ftrace is "I saw a presentation on it at a
conference a couple years ago", so I'm not the guy to comment on the
advisability of the patch itself.

As for the documentation: seems reasonable, could use some english
polishing.

>> +Snapshot
>> +--------
>> +If CONFIG_TRACER_MAX_TRACE is set, the (generic) snapshot
>> +feature is available in all tracers except for the special
>> +tracers which use a snapshot inside themselves(such as "irqsoff"
>> +or "wakeup").

This is confusing, I'm guessing irqsoff and wakeup already have
persistent buffers without CONFIG_TRACER_MAX_TRACE? (So there is a
generic snapshot feature, but some tracers have their own internal
buffer and don't use the generic one?)

Is the fact that some tracers don't use this feature an important part
of the description of the feature? Is making them use common code a todo
item, or just a comment?

How about:

CONFIG_TRACER_MAX_TRACE makes a generic snapshot feature available to
all tracers. (Some tracers, such as "irqsoff" or "wakeup", use their own
internal snapshot implementation.)

>> +This enables to preserve trace buffer at a particular point in
>> +time without stopping tracing. When a snapshot is taken, ftrace
>> +swaps the current buffer with a spare buffer which is prepared
>> +in advance. This means that the tracing itself continues on the
>> +spare buffer.

Snapshots preserve a trace buffer at a particular point in time without
stopping tracing; ftrace swaps the current buffer with a spare buffer,
and tracking continues in the spare buffer.

>> +Following debugfs files in "tracing" directory are related with
>> +this feature.

The following debugfs files in "tracing" are related to this feature:

>> +  snapshot_enabled:
>> +
>> +    This is used to set or display whether the snapshot is
>> +    enabled. Echo 1 into this file to prepare a spare buffer
>> +    or 0 to shrink it. So, the memory for the spare buffer
>> +    will be consumed only when this knob is set.

Write 1 to this file to allocate a snapshot buffer, 0 to free it.

(Query: do you have to free the buffer after taking a snapshot below?)

>> +  snapshot_pipe:
>> +
>> +    This is used to take a snapshot and to read the output
>> +    of the snapshot. Echo 1 into this file to take a
>> +    snapshot. Reads from this file is the same as the
>> +    "trace_pipe" file (described above "The File System"
>> +    section), so that both reads from the snapshot and
>> +    tracing are executable in parallel.

Echo 1 into this file to take a snapshot, then read the snapshot from
the file in the same format as "trace_pipe" (described above in the
section "The File System").

Design questions left for the reader: why are allocating a snapshot
buffer and taking a snapshot separate actions? Why is there only _one_
snapshot buffer?

>> +Here is an example of using the snapshot feature.
>> +
>> + # echo nop > current_tracer
>> + # echo 1 > snapshot_enabled
>> + # echo 1 > events/sched/enable
>> + [...]
>> + # echo 1 > snapshot_pipe

Is the order significant here? Do you have to set up a snapshot buffer
before you start tracing? When you switch buffers, does the new buffer
start empty, or with a copy of the previous trace data?

I'm guessing the reason buffer switching was described above is to
explain that taking a snapshot blanks the current trace history since
you switch to an empty buffer?

>> + # cat snapshot_pipe
>> +            bash-3352  [001] dN.. 18440.883932: sched_wakeup:
>> comm=migration/6 pid=28 prio=0 success=1 target_cpu=006
>> +            bash-3352  [001] dN.. 18440.883933: sched_wakeup:
>> comm=migration/7 pid=32 prio=0 success=1 target_cpu=007
>> +            bash-3352  [001] d... 18440.883935: sched_switch:
>> prev_comm=bash prev_pid=3352 prev_prio=120 prev_state=R ==>
>> next_comm=migration/1 next_pid=8 next_prio=0
>> +[...]

How big is one of these buffers, anyway?  I take it the reason opening
snapshot_pipe doesn't just allocate a snapshot buffer and take the
snapshot then (to persist for the duration of the filehandle) is to
avoid pinning too much kernel memory?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
