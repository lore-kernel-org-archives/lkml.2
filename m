Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2BNSO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:14:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2BNSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:14:25 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6620"; a="163098801"
X-IronPort-AV: E=Sophos;i="4.73,417,1325491200"; 
   d="scan'208";a="196189113"
Message-ID: <4F3AA481.6040707@qualcomm.com>
Date: Tue, 14 Feb 2012 10:14:25 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120203 Thunderbird/11.0
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: NoHZ and CPU isolation patches
References: <4F39DB3D.10805@qualcomm.com> <CAOtvUMdta6RNvaHNRDbsUTA5tTEK01bwW_wpZkZOeNNL+podTA@mail.gmail.com>
In-Reply-To: <CAOtvUMdta6RNvaHNRDbsUTA5tTEK01bwW_wpZkZOeNNL+podTA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 01:44 AM, Gilad Ben-Yossef wrote:
> Hi Max,
>
> Any specific reason not to CC the LKML list? I know it is sometime
> noisy and I understand
> you are not subscribed, but it is the Right Thing (tm) to do...

No reason really. I was just going to keep it short and basically just ask
for CCs on future discussions :).
Looks like this might turn into a useful discussion. Added to the CC.

> On Tue, Feb 14, 2012 at 5:55 AM, Max Krasnyansky<maxk@qualcomm.com>  wrote:
>> Gilad, Frederic,
>>
>> At the time a lot of people
>> were totally opposed to that
>> from the recent threads it looks like things have changed quite a bit.
>
> I think people like the idea of CPU isolation, there is just the
> question of what CPU
> isolation means :-)
>
> At least my personal approach is that if a task is running on an
> isolated CPU has caused
> the kernel to need to do work on that CPU, that is fair game.
Yep. My definition is the same. ie If a task wants to avoid interference from the
kernel it better not use any syscalls() or at least not the syscalls that trigger
IO, mem allocations, etc.


> As a special exception,  work required by the kernel to do on the CPU
> by a previous task
> running on the  isolated CPU (cleanups) is also a fair game. (We may
> consider later adding
>   a "clean me"  API so that  tasks can ask the kernel to block them
> until all previous cleanups
> have been  completed).
That's what I used CPU hotplug for. I still think it's practically perfect for doing
this cleanup stuff. CPU hotplug code provides logic for migrating stuff off of the CPU
that is going offline. So as part of the "isolation" prep work I setup cpusets, irq
affinity masks, etc and bring the CPU offline. Then once we bring it online it nice and
clean with no pending work, timers, etc.


> What we're trying to do, IMHO, is only to keep the kernel from
> interfering with the user
> application due to no action of the application - either because of
> activity of a task
> on another CPU which is not directly related to our task or due to
> kernel normal routine.
>
> As a special exception, interference caused by specific, well defined,
> rare user actions
> are OK as well, so long as the user has a very clear expectation that
> this action will cause interference. Thus, stop_machine during module unload is
> fine (user controlled and rare), but stop_machine for RCU expedited sync is not (not user
> controlled, not rare enough).
>
> I think that makes life easier for us :-)
As far as I remember there are other stop_machine uses that were not as obvious to
the user as module unload. ftrace for example calls stop_machine to patch text segments.
For now I've simply disabled dynamic ftrace in my kernels.


>> In the mean time I'm going to start playing with your trees. I'm curious for
>> example if you found solutions for stop_machine and things.
>
> Frederic's patch set deals with the scheduler timer tick and related
> functionality.
> I took to IPI causes first.
>
> stop_machine is not dealt with and as I explained, it is not always a problem.
>
> I keep a tracking list of interference sources and remedies here:
> https://github.com/gby/linux/wiki
>
> I'd love to get feedback for it.
Sounds good. I'll take a look and get back to you.


Max
