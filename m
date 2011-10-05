Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645Ab1JEMn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:43:58 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55609 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359Ab1JEMn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:43:57 -0400
Message-ID: <4E8C50E8.2030505@parallels.com>
Date: Wed, 5 Oct 2011 16:43:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [PATCH 04/10] Display /proc/stat information per cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>   <1317583287-18300-5-git-send-email-glommer@parallels.com>  <1317804965.6766.2.camel@twins> <4E8C494F.8020804@parallels.com> <1317818294.6766.16.camel@twins>
In-Reply-To: <1317818294.6766.16.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 04:38 PM, Peter Zijlstra wrote:
> On Wed, 2011-10-05 at 16:10 +0400, Glauber Costa wrote:
>> On 10/05/2011 12:56 PM, Peter Zijlstra wrote:
>>> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>>>> +struct kernel_stat *task_group_kstat(struct task_struct *p)
>>>> +{
>>>> +       struct task_group *tg;
>>>> +       struct kernel_stat *kstat;
>>>> +
>>>> +       rcu_read_lock();
>>>> +       tg = task_group(p);
>>>> +       kstat = tg->cpustat;
>>>> +       rcu_read_unlock();
>>>> +       return kstat;
>>>> +}
>>>
>>> Who keeps tg alive and kicking while you poke at its (cpustat) member?
>>
>> * All calls to this function currently pass current as a parameter
>> (Okay, maybe it is too generic and we should pass nothing at all, and
>> grab current within it)
>> * rcu_read_lock() guarantees that current will exist during this call,
>> and task_group won't change. (right?)
>
> The thing I worry about is:
>
> A (pid n)				B
>
> kstat = task_group_kstat()
> 					echo n>  /cgroup/something-else/pid
> 					rmdir /cgroup/group-that-had-A
> <timer interrupt>
>    RCU complete
>    <softirq>
>      kfree(tg) etc..
>
> kstat->foo++;<-- *BOOM*
>
>
> The only way to avoid someone moving you around is by holding some
> cgroup lock, task->alloc_lock, task->pi_lock or the rq->lock where task
> runs. Alternatively keep rcu_read_lock() around the entire kstat usage.
>
>
Well, if I understand it correctly, we'd have to hold the lock around 
the entire kstat usge as well, right?

Otherwise it can just explode. So rcu does seem the way to go. I do, 
however, see the problem you are describing.

Maybe we can remove the rcu_read_lock() call and replace with a rcu 
validation. Then patch all callers. (Including of course the current 
users of kstat_cpu() all over). What do you think?


