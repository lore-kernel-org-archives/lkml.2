Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GTF1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 01:27:40 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:54852 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2GTF1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 01:27:38 -0400
X-AuditID: b753bd60-a1c87ba000000655-e2-5008ebafc25c
X-AuditID: b753bd60-a1c87ba000000655-e2-5008ebafc25c
Message-ID: <5008EBE2.4040909@hitachi.com>
Date: Fri, 20 Jul 2012 14:25:54 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip ] tracing: make a snapshot feature available
 from userspace.
References: <20120605120637.16419.43353.stgit@jirocho.sdl.hitachi.co.jp> <4FF41F37.6040908@hitachi.com> <4FF4E75D.1050507@landley.net> <4FFD11AD.1080107@hitachi.com> <4FFDBF31.4010508@landley.net>
In-Reply-To: <4FFDBF31.4010508@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Sorry for the late reply.

(2012/07/12 3:00), Rob Landley wrote:
>>> How about:
>>>
>>> CONFIG_TRACER_MAX_TRACE makes a generic snapshot feature available to
>>> all tracers. (Some tracers, such as "irqsoff" or "wakeup", use their own
>>> internal snapshot implementation.)
>>>
>> Thanks, but I think the following one is more suitable.
>>
>> (Some tracers, such as "irqsoff" or "wakeup", already use the snapshot
>> implementation internally)
> 
> This implies that setting flag is a NOP for them, rather than "if you
> take a snapshot, they'll stomp all over the buffer".
> 

How about:
(Some tracers which record max latency, such as "irqsoff" or "wakeup",
can't use this feature, since those are already using same buffer
internally.)

>>> (Query: do you have to free the buffer after taking a snapshot below?)
>>>
>> No, we don't always need to free the buffer, although we can free it
>> when the snapshot becomes unnecessary. We can also reuse the buffer if
>> we'd like to take the next snapshot.
>> (I'll add this description.)
> 
> Actually I was worried about the lifetime rules for the buffer (when
> does it need to be disposed of, and who is responsible for doing so?)
> but it looks like ftrace only allows one trace to be going on in the
> entire system at any given time, so all this context is kernel global
> anyway...
> 

Since current ftrace supposes single user, I think it's enough now.


> Buffer allocation is a separate action because taking a snapshot is a
> low-latency operation that should never fail. Got it.
> 
> But again, why couldn't open() do one and read() (from position 0) do
> the other? And then if you wanted to take another snapshot you could
> lseek() back to 0...
> 
> *shrug* I suppose the way you have it works. Just curious.
> 

Taking a snapshot by using read() will cause a problem. Users don't
always want to read a snapshot just after taking the snapshot. Users
may want to transfer the snapshot data to persistent storage after
usage of system resources(such as CPU or I/O) becomes low. So we should
separate taking a snapshot from reading data.


>>> Why is there only _one_ snapshot buffer?
>>>
>> Because of easy reviewing, I've decided to implement step by step. So
>> this patch just provide "only one" spare buffer. However, I got some
>> feedback for multiple snapshot at LinuxCon Japan 2012. So I may extend
>> this feature.
> 
> The implementation can change all you like after the code goes in, but
> you really have to get the API right because you're going to be stuck
> supporting it <pinkypie>FOREVER</pinkypie>.
> 

I see. I'm now thinking extensible API.


>>>>> +Here is an example of using the snapshot feature.
>>>>> +
>>>>> + # echo nop > current_tracer
>>>>> + # echo 1 > snapshot_enabled
>>>>> + # echo 1 > events/sched/enable
>>>>> + [...]
>>>>> + # echo 1 > snapshot_pipe
>>> Is the order significant here? 
>> If the current_tracer is a special tracer such as irqsoff,
>> snapshot_enabled can't be set to 1. So current_tracer has to be
>> configured to appropriate tracer in the first place.
> 
> But they aren't compatible anyway? (So presumably this call failing is
> part of the enforcement mechanism by which the incompatible combination
> is disallowed?)
> 

Yes, we should have the special tracers fail to allocate a spare buffer.

> What happens if you do it the other way around? (echo 1 >
> snapshot_enabled and then echo irqsoff > current_tracer)?
> 

Then, "echo irqsoff > current_tracer" succeed, and snapshot_enabled turn
into 0. (But in this patch, it remains 1. This is a bug.)

>>> I'm guessing the reason buffer switching was described above is to
>>> explain that taking a snapshot blanks the current trace history since
>>> you switch to an empty buffer?
>>>
>> Yes. Actually, this snapshot feature only swaps the current buffer and
>> the spare buffer. Now I'm considering to call it "swap" instead of
>> "snapshot"...
> 
> I'm all for clarifying what it does, but we already have a subsystem
> called "swap" (swap partitions, swapon/swapoff) so that name isn't
> necessarily less confusing.
> 

Hmm, a good name doesn't occur to me. I'll continue to call this feature
snapshot.

>> The size of two buffers is same because this is swap.
> 
> So the new one is also buffer_size_kb?
> 

Yes.

> Out of curiosity, what happens if you go:
> 
>   echo nop > current_tracer
>   echo 1 > snapshot_enabled
>   echo 64 > buffer_size_kb
> 
> (Techncially current_tracer is still nop...)
> 

Write to buffer_size_kb affects both buffers when the snapshot is
enabled. In that case, the spare buffer is allocated and becomes same
size as the current buffer after second line. The size of both buffers
becomes 64KB after third line.


>> The reason of the separated operations is to swap two buffers
>> immediately without fail. if opening snapshot_pipe allocates a buffer,
>> we need a special userspace command to realize that.
> 
> Um, cat can open a file? I don't understand.
> 
> If you need a delay between open and read, you can do that from the
> command line with something like:
> 
>   (read -n 1 < /dev/tty; cat > ~/walrus.txt) < /path/to/thingy
> 
> I dunno if that's a good idea, I'm just trying to understand the design
> here...

Your method may be possible, but I think that is somewhat complex...


Best regards,
Hiraku Toyooka



