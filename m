Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1I1PWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:22:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:32948 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1I1PWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:22:34 -0400
Message-ID: <4E833B8A.6020708@parallels.com>
Date: Wed, 28 Sep 2011 12:21:46 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [RFD 0/9] per-cgroup /proc/stat statistics
References: <1316816432-9237-1-git-send-email-glommer@parallels.com> <1317161513.21836.28.camel@twins>
In-Reply-To: <1317161513.21836.28.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 07:11 PM, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>> Hi,
>>
>> Since I've sent already a RFC about it, I am sending now a RFD.
>> If you eager for meaning, this can then be a "Request for Doctors",
>> since Peter is likely to have a heart attack now.
>
> :-)
>
> All we need is to ensure the case of cgroups enabled but not used isn't
> actually more expensive that what we have now, after that, if people
> create a 100 deep cgroup hierarchy they get what they asked.
>
>  From a conceptual pov this patch-set is a lot saner than the previous
> one, doesn't duplicate nearly as much and actually tries to improve the
> code (although I suspect simply killing off cputime64_t as a whole will
> get us even more).

Are you actually planning to do that by yourself ?

>
>> So here's the deal:
>>
>> * My main goal here was to demonstrate that we can avoid double accounting
>>    in a lot of places. So what I did was getting rid of the original and first
>>    kstat mechanism, and use only cgroups accounting for that. Since the parent
>>    is always updated, the original stats are the one for the root cgroup.
>
> Right, current patch-set won't compile for those who have CGROUP=n

yet.

> kernels though, need to find something for that. Shouldn't be too hard
> though. It looks like you only need to provide static per-cpu storage
> and a custom version of task_cgroup_account_field().
Precisely. I was more worried about getting acceptance of the whole 
thing first...

>
>> * I believe that all those cpu cgroups are confusing and should be unified. Not
>>    that we can simply get rid of it, but my goal here is to provide all the
>>    information they do, in cpu cgroup. If the set of tasks needed for accounting
>>    is not independent of the ones in cpu cgroup, we can avoid double accounting
>>    for that. I default cpuacct to n, but leave it to people that wants to use it
>>    alone.
>
> Amen! Ideally we place cpuacct on the deprecated list or somesuch..
If no one opposes, I can actually include that in the official 
submission, that should be the next one.

>
>> * Well, I'm also doing what I was doing originally: Providing a per-cgroup version
>>    of the /proc/stat file.
>
> Right, so how much sense does it make to keep calling it proc.stat?

For the root cgroup, it doesn't. But I don't see why we need to special 
case it.

For all others, it is pretty much the whole point of the series... We 
could of course automatically display it, and I considered that for 
simplicity. For my use case, it would even work flawlessly, but in the 
general case of people using cgroups for resource control only, they 
might be interested in seeing whole system usage when they poll 
/proc/stat. So /proc/stat shows system-wide information, proc.stat, 
cgroup's. In containers, we want to tie those together, but it is a 
different story.
