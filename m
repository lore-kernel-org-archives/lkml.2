Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760823Ab2IGOU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:20:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55247 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760672Ab2IGOUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:20:50 -0400
Message-ID: <504A02BD.4000805@linaro.org>
Date: Fri, 07 Sep 2012 16:20:45 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: xen-devel@lists.xensource.com, linaro-dev@lists.linaro.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        john.stultz@linaro.org, mingo@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, richardcochran@gmail.com,
        prarit@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <201209062204.11288.rjw@sisk.pl> <50490920.9070204@linaro.org> <201209062318.42874.rjw@sisk.pl>
In-Reply-To: <201209062318.42874.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 11:18 PM, Rafael J. Wysocki wrote:
> On Thursday, September 06, 2012, Daniel Lezcano wrote:
>> On 09/06/2012 10:04 PM, Rafael J. Wysocki wrote:
>>> On Thursday, September 06, 2012, Daniel Lezcano wrote:
>>>> On 09/06/2012 09:54 AM, Daniel Lezcano wrote:
>>>>> On 09/05/2012 03:41 PM, Rafael J. Wysocki wrote:
>>>>>> On Saturday, September 01, 2012, Rafael J. Wysocki wrote:
>>>>>>> On Friday, August 31, 2012, Daniel Lezcano wrote:
>>>>>>>> On 07/24/2012 11:06 PM, Konrad Rzeszutek Wilk wrote:
>>>>>>>>> On Tue, Jul 24, 2012 at 11:12:29PM +0200, Daniel Lezcano wrote:
>>>>>>>>>> Remove the power field as it is not used.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>>>>>>>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>>>>>>> Acked.
>>>>>>>> Hi Rafael,
>>>>>>>>
>>>>>>>> I did not see this patch going in. Is it possible to merge it ?
>>>>>>> I think so.  I'll take care of it when I get back from LinuxCon/Plumbers Conf.
>>>>>>> (early next week).
>>>>>> Applied to the linux-next branch of the linux-pm.git tree as v3.7 material.
>>>>> Thanks Rafael.
>>>>>
>>>>>> Are there any other patches you want me to consider for v3.7?
>>>>> Yes please, I have the per cpu latencies ready to be submitted but I
>>>>> want to do extra testing before. Unfortunately, the linux-pm-next hangs
>>>>> at boot time on my intel dual core (not related to the patchset).
>>>>>
>>>>> I am git bisecting right now.
>>>>
>>>> I found the culprit. This is not related to the linux-pm tree but with
>>>> net-next.
>>>> The following patch introduced the issue.
>>>>
>>>> commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d
>>>> Author: Amerigo Wang <amwang@redhat.com>
>>>> Date:   Fri Aug 10 01:24:50 2012 +0000
>>>>
>>>>     netpoll: re-enable irq in poll_napi()
>>>>    
>>>>     napi->poll() needs IRQ enabled, so we have to re-enable IRQ before
>>>>     calling it.
>>>>    
>>>>     Cc: David Miller <davem@davemloft.net>
>>>>     Signed-off-by: Cong Wang <amwang@redhat.com>
>>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>>
>>>> AFAICS, it has been fixed by commit
>>>> 072a9c48600409d72aeb0d5b29fbb75861a06631 which is not yet in linux-pm-next.
>>>
>>> If it is present in the current Linus' tree, you can just pull this one
>>> and merge linux-pm-next into it.  It should merge without conflicts.
>>
>> Ok, thanks.
>>
>>>> I fall into this issue because NETCONSOLE is set, disabling it allowed
>>>> me to go further.
>>>>
>>>> Unfortunately I am facing to some random freeze on the system which
>>>> seems to be related to CONFIG_NO_HZ=y and CONFIG_CPU_IDLE=y.
>>>>
>>>> Disabling one of them, make the freezes to disappear.
>>>>
>>>> Is it a known issue ?
>>>
>>> Well, there are systems having problems with this configuration, but they
>>> should be exceptional.  What system is that?
>>
>> It is a laptop T61p with a Core 2 Duo T9500. Nothing exceptional I
>> believe. Maybe someone got the same issue ?
> 
> Is it a regression for you?

Yes, I think so. The issue appears between v3.5 and v3.6-rc1.

It is not easy to reproduce but after taking some time to dig, it seems
to appear with this commit:

1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 is the first bad commit
commit 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
Author: John Stultz <john.stultz@linaro.org>
Date:   Fri Jul 13 01:21:53 2012 -0400

    time: Condense timekeeper.xtime into xtime_sec

    The timekeeper struct has a xtime_nsec, which keeps the
    sub-nanosecond remainder.  This ends up being somewhat
    duplicative of the timekeeper.xtime.tv_nsec value, and we
    have to do extra work to keep them apart, copying the full
    nsec portion out and back in over and over.

    This patch simplifies some of the logic by taking the timekeeper
    xtime value and splitting it into timekeeper.xtime_sec and
    reuses the timekeeper.xtime_nsec for the sub-second portion
    (stored in higher res shifted nanoseconds).

    This simplifies some of the accumulation logic. And will
    allow for more accurate timekeeping once the vsyscall code
    is updated to use the shifted nanosecond remainder.

    Signed-off-by: John Stultz <john.stultz@linaro.org>
    Reviewed-by: Ingo Molnar <mingo@kernel.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Richard Cochran <richardcochran@gmail.com>
    Cc: Prarit Bhargava <prarit@redhat.com>
    Link:
http://lkml.kernel.org/r/1342156917-25092-5-git-send-email-john.stultz@linaro.org
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 4d6541ac1f6075d7adee1eef494b31a0cbda0934
dc5708bc738af695f092bf822809b13a1da104b6 M	kernel

How to reproduce: with a laptop T61p, with a Core 2 Duo. I boot the
kernel in busybox and wait some minutes before writing something in the
console. At this moment, nothing appears to the console but the
characters are echo'ed several seconds later (could be 1, 5, or 10 secs
or more).

That happens when CONFIG_CPU_IDLE and CONFIG_NO_HZ are set. Disabling
one of them, the issue does not appear.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

