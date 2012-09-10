Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2IJTpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:45:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53787 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab2IJTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:45:12 -0400
Message-ID: <504E4343.5070004@linaro.org>
Date: Mon, 10 Sep 2012 21:45:07 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: prarit@redhat.com, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-pm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        richardcochran@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@kernel.org,
        lenb@kernel.org
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <201209062204.11288.rjw@sisk.pl> <50490920.9070204@linaro.org> <201209062318.42874.rjw@sisk.pl> <504A02BD.4000805@linaro.org> <504A2D73.3010702@linaro.org> <504A68A0.7010907@linaro.org> <504E1FE5.6090502@linaro.org>
In-Reply-To: <504E1FE5.6090502@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 07:14 PM, John Stultz wrote:
> On 09/07/2012 02:35 PM, Daniel Lezcano wrote:
>> On 09/07/2012 07:22 PM, John Stultz wrote:
>>> On 09/07/2012 07:20 AM, Daniel Lezcano wrote:
>>>> On 09/06/2012 11:18 PM, Rafael J. Wysocki wrote:
>>>>> On Thursday, September 06, 2012, Daniel Lezcano wrote:
>>>>>> On 09/06/2012 10:04 PM, Rafael J. Wysocki wrote:
>>>>>>> On Thursday, September 06, 2012, Daniel Lezcano wrote:
>>>>>>>> On 09/06/2012 09:54 AM, Daniel Lezcano wrote:
>>>>>>>> I fall into this issue because NETCONSOLE is set, disabling it
>>>>>>>> allowed
>>>>>>>> me to go further.
>>>>>>>>
>>>>>>>> Unfortunately I am facing to some random freeze on the system
>>>>>>>> which
>>>>>>>> seems to be related to CONFIG_NO_HZ=y and CONFIG_CPU_IDLE=y.
>>>>>>>>
>>>>>>>> Disabling one of them, make the freezes to disappear.
>>>>>>>>
>>>>>>>> Is it a known issue ?
>>>>>>> Well, there are systems having problems with this configuration,
>>>>>>> but they
>>>>>>> should be exceptional. What system is that?
>>>>>> It is a laptop T61p with a Core 2 Duo T9500. Nothing exceptional I
>>>>>> believe. Maybe someone got the same issue ?
>>>>> Is it a regression for you?
>>>> Yes, I think so. The issue appears between v3.5 and v3.6-rc1.
>>>>
>>>> It is not easy to reproduce but after taking some time to dig, it
>>>> seems
>>>> to appear with this commit:
>>>>
>>>> 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 is the first bad commit
>>>> commit 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
>>>> Author: John Stultz <john.stultz@linaro.org>
>>>> Date: Fri Jul 13 01:21:53 2012 -0400
>>>>
>>>> time: Condense timekeeper.xtime into xtime_sec
>>>>
>>>> The timekeeper struct has a xtime_nsec, which keeps the
>>>> sub-nanosecond remainder. This ends up being somewhat
>>>> duplicative of the timekeeper.xtime.tv_nsec value, and we
>>>> have to do extra work to keep them apart, copying the full
>>>> nsec portion out and back in over and over.
>>>>
>>>> This patch simplifies some of the logic by taking the timekeeper
>>>> xtime value and splitting it into timekeeper.xtime_sec and
>>>> reuses the timekeeper.xtime_nsec for the sub-second portion
>>>> (stored in higher res shifted nanoseconds).
>>>>
>>>> This simplifies some of the accumulation logic. And will
>>>> allow for more accurate timekeeping once the vsyscall code
>>>> is updated to use the shifted nanosecond remainder.
>>>>
>>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>>> Reviewed-by: Ingo Molnar <mingo@kernel.org>
>>>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>> Cc: Richard Cochran <richardcochran@gmail.com>
>>>> Cc: Prarit Bhargava <prarit@redhat.com>
>>>> Link:
>>>> http://lkml.kernel.org/r/1342156917-25092-5-git-send-email-john.stultz@linaro.org
>>>>
>>>>
>>>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>>>
>>>> :040000 040000 4d6541ac1f6075d7adee1eef494b31a0cbda0934
>>>> dc5708bc738af695f092bf822809b13a1da104b6 M kernel
>>>>
>>>> How to reproduce: with a laptop T61p, with a Core 2 Duo. I boot the
>>>> kernel in busybox and wait some minutes before writing something in
>>>> the
>>>> console. At this moment, nothing appears to the console but the
>>>> characters are echo'ed several seconds later (could be 1, 5, or 10
>>>> secs
>>>> or more).
>>>>
>>>> That happens when CONFIG_CPU_IDLE and CONFIG_NO_HZ are set. Disabling
>>>> one of them, the issue does not appear.
>>> Thanks for bisecting this down and the heads up!
>>>
>>> Right off I can't see what might be causing this. Bunch of questions:
>>>
>>> Is this a 32 or 64 bit kernel?
>> It is a 32 bit kernel.
>
> Thanks for your answers! Has this has been seen on 3.6-rc4+ kernels?
> There were a few casting fixes that landed in 3.6-rc4 that would
> affect 32bit systems.

Ok, I have to check that. Unfortunately not before Wednesday.

>
> In the meantime, I'll try to reproduce on my T61. If you could send me
> your .config, I'd appreciate it.

http://pastebin.com/qSxqfdDK

The header of the config file shows for a v3.5-rc7 because it is the
result of the git-bisect. If you keep this config file for the latest
kernel that should reproduce the problem.

Let me know if you were able to reproduce the problem.

Thanks
-- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


