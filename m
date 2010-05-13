Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0EMBHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:07:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63749 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0EMBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vZRFXnwGcnWoeANMcwl6F7T6G0+1u0qyW8RhBltXaS0gZGSna3M8g91uKRKU6i3Cii
         yjopprNsQzVy6cl9MHh372Rj6tDfBufd9k69OeY+I/pyhsBUKmC3TTHM+1IulrvL44V2
         jAZJN3suOVyCfIsyBs0X+OheE2Gx6tn+CdwdU=
Message-ID: <4BEB50C7.4080808@gmail.com>
Date: Wed, 12 May 2010 19:07:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xianghua Xiao <xiaoxianghua@gmail.com>
CC: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Issue with SCHED_FIFO app
References: <k2j54a292881005092139u7e120250hf530f8b688abdd22@mail.gmail.com>	 <t2s54a292881005092142h58ccae9ch2ecec665d06a7601@mail.gmail.com> <AANLkTillkVE9Mmz3CiQyIF5yiZfpp13g18UCyMQSuZ_K@mail.gmail.com>
In-Reply-To: <AANLkTillkVE9Mmz3CiQyIF5yiZfpp13g18UCyMQSuZ_K@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 08:46 PM, Xianghua Xiao wrote:
> On Sun, May 9, 2010 at 11:42 PM, Suresh Rajashekara
> <suresh.raj+linuxomap@gmail.com>  wrote:
>> Hi All,
>>
>> I had a couple of application (with real time priority SCHED_FIFO)
>> which were working fine on 2.6.16. They have started behaving
>> differently on 2.6.29.
>>
>> I will explain my problem briefly.
>>
>> Application A (my main application) is scheduled with SCHED_FIFO and priority 5.
>> Application B (watchdog application) is also scheduled with SCHED_FIFO
>> but with priority 54.
>>
>> A keeps putting the OMAP to sleep and wake up every 4 seconds and
>> again puts it to sleep.
>> B is supposed to be running every 1.25 seconds to kick watchdog, but
>> since A keeps OMAP in sleep for 4 seconds, it should run as soon as
>> OMAP wakes up.
>>
>> Since B is of a higher priority, its supposed to run whenever the OMAP
>> wakes up and then A should again put it back to sleep. This happens
>> perfectly on 2.6.16
>>
>> On 2.6.29, B fails to run when OMAP wakes up and before A puts it back
>> to sleep. B only runs if there is atleast 1.5 seconds of delay between
>> the awake-sleep cycle.
>>
>> On searching the internet, I figured out that CFS (completely fair
>> scheduler) was introduced in 2.6.23, which makes some changes to the
>> RT bandwidth (and many users started facing issues with they
>> applications with SCHED_FIFO). Somewhere on the web I found that
>> issuing
>>
>> echo -1>  /proc/sys/kernel/sched_rt_runtime_us
>>
>> should disable the changes which affects the RT bandwidth. It actually
>> did help to an extent in solving some other problem (not described
>> above. A's IOCTL call return was getting delayed), but this problem
>> still persists.
>>
>> Any pointers to where I should look for the solution.
>>
>> Is there a way I can revert back to the scheduler behavior as it was on 2.6.16?
>>
>> I have disabled CONFIG_GROUP_SCHED and also CONFIG_CGROUPS. I am using
>> 2.6.29 on an OMAP1 platform.
>>
>> Thanks in advance,
>> Suresh
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I have seen similar things while upgrading a 2.6.18 RT kernel to
> 2.6.33 RT, actually exactly when CFS was introduced we found
> performance issues, in that, our main application(a multi-thread
> SCHED_FIFO / SCHED_RR mixed) runs with much higher overhead under CFS.
> In 2.6.18RT, the cpu usage is close to 0% and on newer kernel with
> CFS, the cpu usage is 12% when the application runs idle(i.e. sleeping
> and waiting for input, WCHAN shows sched_timeout or futex_wait). When
> the main application runs with real load, cpu usage gets much worse
> with CFS.
>
> I tried various methods, including the one you described above, and
> made sure no sched_yield is used, etc, still the main application
> spends 6% cpu in user space and 6% in kernel space while at idle. I
> tried BFS schedule and it's actually better, about 8% in user space
> and 0.6% in kernel space while the application runs idle. Again with
> 2.6.18 RT it's nearly 0% cpu usage.

If it's using 6% of CPU in userspace, then it sounds to me like it's not 
really idle. Could be some kind of timing issue that the scheduler 
change exposes?
