Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1G0IZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:25:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:40148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1G0IZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:25:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="30596400"
Message-ID: <4E2FCB6E.4030307@linux.intel.com>
Date: Wed, 27 Jul 2011 01:25:18 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3 (futex_requeue bad spinlock magic)
References: <alpine.LFD.2.02.1107241223560.2702@ionos> <4E2C2ED6.4040904@gmail.com> <alpine.LFD.2.02.1107241807390.3136@ionos> <4E2DEC1A.5070109@linux.intel.com> <4E2E57FF.7030206@linux.intel.com> <4E2EA89A.2020007@gmail.com> <4E2EF304.30601@linux.intel.com> <4E2EF532.20407@gmail.com> <4E2F70A6.6070008@linux.intel.com>
In-Reply-To: <4E2F70A6.6070008@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 06:57 PM, Darren Hart wrote:
> 
> 
> On 07/26/2011 10:11 AM, Maarten Lankhorst wrote:
>> On 07/26/2011 07:01 PM, Darren Hart wrote:
>>>
>>> On 07/26/2011 04:44 AM, Maarten Lankhorst wrote:
>>>> On 07/26/2011 08:00 AM, Darren Hart wrote:
>>>>> On 07/25/2011 03:20 PM, Darren Hart wrote:
>>>>>> On 07/24/2011 09:12 AM, Thomas Gleixner wrote:
>>>>>>> On Sun, 24 Jul 2011, Maarten Lankhorst wrote:
>>>>>> ...
>>>>>>
>>>>>>>> Also not sure where this one came from:
>>>>>>>> [   37.456688] BUG: spinlock bad magic on CPU#3, threaded-ml/1619
>>>>>>>> [   37.456690]  lock: ffff8801fdc74d50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>>>>>>>> [   37.456692] Pid: 1619, comm: threaded-ml Tainted: G         C  3.0.0-rt3-patser+ #39
>>> Maarten, I'm finding fairly little out there on what threaded-ml might
>>> be. What I do find suggests 3D visualization and real-time audio
>>> playback. Are you working with something like this? If so, which
>>> libraries are you using? If not, any idea what this is?
>> threaded ml = from pulseaudio,
>> src/pulse/thread-mainloop.c to be exact. But like I said it occurs with the functional broadcast test too, on the waker thread.
>>>>>>>> [   37.456693] Call Trace:
>>>>>>>> [   37.456697]  [<ffffffff81607a78>] spin_bug+0xa0/0xa8
>>>>>>>> [   37.456699]  [<ffffffff8132b412>] do_raw_spin_lock+0xa2/0x170
>>>>>>>> [   37.456702]  [<ffffffff8104a201>] ? get_parent_ip+0x11/0x50
>>>>>>>> [   37.456704]  [<ffffffff8160d783>] _raw_spin_lock+0x23/0x30
>>>>>>>> [   37.456706]  [<ffffffff810931ce>] rt_mutex_start_proxy_lock+0x2e/0xd0
>>>>>>>> [   37.456708]  [<ffffffff8109093a>] futex_requeue+0x47a/0x850
>>>>>>>> [   37.456710]  [<ffffffff8109138e>] do_futex+0xae/0xb00
>>> Maarten, could you provide the addr2line of the addresses from do_futex
>>> to spin_bug ? This will help me trace the path.
>> decodes to:
>> linux/lib/spinlock_debug.c:72
>> linux/lib/spinlock_debug.c:79
>> linux/kernel/sched.c:4114
>> linux/kernel/spinlock.c:141
>> linux/kernel/rtmutex.c:100
>> linux/kernel/futex.c:1378
>> linux/kernel/futex.c:2662
> 
> 
> OK, so we're entering with a FUTEX_CMP_REQUEUE op (not FUTEX_CMP_REQUEUE_PI),
> and land inside an "if (requeue_pi)" block in the futex_requeue() function -
> that should never happen. The interesting thing about this is pulse is only
> using the non PI pthread_cond calls, and thus FUTEX_CMP_REQUEUE,
> (http://gitorious.org/~elmarco/pulseaudio/pa-work/blobs/1ca76031092ab07682843fd70607696f6af7216f/src/pulsecore/mutex-posix.c). I have not been able reproduce this path.
> 
> My best guess at the moment is that we are somehow stomping on the requeue_pi
> value causing the waker to enter the wrong code paths. A simple test would be to
> print the value of requeue_pi throughout futex_requeue() and see if it changes
> (it shouldn't) and if it is something other than 0 or 1 (which it should never
> be). Are you able to reliably reproduce the pulse audio failure?
> 
> The futex_requeue_pi test is of course using FUTEX_CMP_REQUEUE_PI, and it will
> reproduce a similar path (except via the FUTEX_CMP_REQUEUE_PI demux path as it
> should be) on the first time run, as Maarten observed. I have seen this with
> and without the -b (broadcast) option to the test.
> 
> I was able to reproduce this on my system by adding the following to my config:
> +CONFIG_DEBUG_RT_MUTEXES=y
> +CONFIG_DEBUG_PI_LIST=y
> +CONFIG_DEBUG_SPINLOCK=y
> 
> With a similar config, this does not occur on 2.6.33.9-rt31. Nothing jumps out
> as obviously wrong in the futex delta from 33-rt to now.
> 
> I tried with 3.0.0 (non rt) with a similar .config and the problem is not
> reproducible. I'll continue to try and isolate the problem, focusing mainly on
> the futex delta from 3.0.0. Right after I get the kids to bed...


I believe this is now fixed with:

https://lkml.org/lkml/2011/7/27/74


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
