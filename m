Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1I1P1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:27:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55239 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab1I1P1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:27:37 -0400
Message-ID: <4E833CAF.7010208@parallels.com>
Date: Wed, 28 Sep 2011 12:26:39 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
References: <1316816432-9237-1-git-send-email-glommer@parallels.com> <1316816432-9237-5-git-send-email-glommer@parallels.com> <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>
In-Reply-To: <20110928101357.5a90c2ab@de.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 05:13 AM, Martin Schwidefsky wrote:
> On Wed, 28 Sep 2011 00:00:37 +0200
> Peter Zijlstra<a.p.zijlstra@chello.nl>  wrote:
>
>> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>>> @@ -1039,6 +1035,8 @@ static void posix_cpu_timers_init(struct task_struct *tsk)
>>>          INIT_LIST_HEAD(&tsk->cpu_timers[2]);
>>>   }
>>>
>>> +struct task_group *task_group(struct task_struct *p);
>>
>> That doesn't appear to be actually used in this file..
>>
>> Also, since there's already a for_each_possible_cpu() loop in that
>> proc/stat function, would it yield some code improvement to make
>> total_forks a cpu_usage_stat?
>>
>> I guess the whole cputime64_t crap gets in the way of that being
>> natural...
>>
>> We could of course kill off the cputime64_t thing, its pretty pointless
>> and its a u64 all over the board. I think Martin or Heiko created this
>> stuff (although I might be wrong, my git tree doesn't go back that far).
>
> The reason to introduce cputime_t has been that different architecture
> needed differently sized integers for their respective representation
> of cputime. On x86-32 the number of ticks is recorded in a u32, on s390
> we needed a u64 for the cpu timer values. cputime64_t is needed for
> cpustat and other sums of cputime that would overflow a cputime_t
> (in particular on x86-32 with the u32 cputime_t and the u64 cputime64_t).
>
> Now we would convert everything to u64 but that would cause x86-32 to
> use 64-bit arithmetic for the tick counter. If that is acceptable I
> can't say.
>
If we get rid of cputime64_t, it doesn't mean we need to get rid of 
cputime_t. Or am I missing the point here?

We would still have to call an analogous of cputime_to_cputime64 before 
using it, but I get that where it matters, gcc can even make it void.
And for all the rest, we do u64 math and typing and just get happy.

