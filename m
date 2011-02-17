Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1BQMJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:09:50 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:59117 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445Ab1BQMJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:09:46 -0500
Message-ID: <4D5D0FFC.40509@free.fr>
Date: Thu, 17 Feb 2011 13:09:32 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Yong Zhang <yong.zhang0@gmail.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: WARNING: at kernel/lockdep.c:2323 trace_hardirqs_on_caller+0xb9/0x16c()
References: <4D5A90D0.9040403@free.fr> <AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com> <20110216.180347.71107177.davem@davemloft.net> <AANLkTim4NnyyFqprBoGpimquLP=6fjAanCrbqX=RXwC9@mail.gmail.com> <20110217112842.GS19830@htj.dyndns.org>
In-Reply-To: <20110217112842.GS19830@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 12:28 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Feb 17, 2011 at 10:43:57AM +0800, Yong Zhang wrote:
>> On Thu, Feb 17, 2011 at 10:03 AM, David Miller<davem@davemloft.net>  wrote:
>>> From: Yong Zhang<yong.zhang0@gmail.com>
>>> Date: Thu, 17 Feb 2011 09:37:30 +0800
>>>
>>>> On Tue, Feb 15, 2011 at 10:42 PM, Daniel Lezcano<daniel.lezcano@free.fr>  wrote:
>>>>> Hi All,
>>>>>
>>>>> I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the
>>>>> following traces appear in the console:
>>>>>
>>>>> Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
>>>>> Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323
>>>>> trace_hardirqs_on_caller+0xb9/0x16c()
>>>>> Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
>>>>> Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted
>>>>> 2.6.38-rc4-next-20110215+ #74
>>>>> Feb 15 15:00:24 lucid kernel: Call Trace:
>>>>> Feb 15 15:00:24 lucid kernel:<IRQ>    [<ffffffff8102b8a5>] ?
>>>>> warn_slowpath_common+0x7b/0x93
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>>>>> _raw_spin_unlock_irq+0x2b/0x30
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ?
>>>>> warn_slowpath_null+0x15/0x17
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ?
>>>>> trace_hardirqs_on_caller+0xb9/0x16c
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ?
>>>>> trace_hardirqs_on+0xd/0xf
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
>>>>> _raw_spin_unlock_irq+0x2b/0x30
>>>>> Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ?
>>>>> do_ide_request+0x32/0x590
>>>> Seems related to IDE SUBSYSTEM
>>> Which hasn't had any changes in the past release.
>> OK.
>>
>> Cc'ing Tejun Heo
>>
>> For the back trace, I think __blk_run_queue() is the ligament.
>> As from the comment of __blk_run_queue(), it must be called
>> with the queue lock and interrupts disabled. And the lock
>> is hold through spin_lock_irqsave(q->queue_lock, flags); at
>> blk_end_bidi_request().
>>
>> But in do_ide_request(), it realse the lock through
>> spin_unlock_irq(q->queue_lock); which make the state
>> inconsistent.
>>
>> BTW, do_ide_request() also say it might_sleep(), this warning
>> also trigger in Daniel's log.
> This seems to be the same problem Jan reported and fixed by the
> following patches.
>
>    http://article.gmane.org/gmane.linux.kernel/1101766/raw
>    http://article.gmane.org/gmane.linux.ide/48819/raw
>
> Can you please test whether these two patches fix the problem?

Thanks Tejun !

I applied these patches to linux-next and I blindly fixed some minors 
conflicts. AFAICT, the problem does no longer occur and it seems the 
patches fix the problem. I am not sure I resolved the conflict correctly 
as I know nothing about this subsystem. Shall I resend these patches for 
inclusion and you check they are correct ?

   -- Daniel

