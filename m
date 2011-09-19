Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1ISTPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:15:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59505 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1ISTPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:15:40 -0400
Message-ID: <4E7794B1.5030907@parallels.com>
Date: Mon, 19 Sep 2011 16:14:57 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>     <1316030695-19826-2-git-send-email-glommer@parallels.com>    <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>   <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>  <1316457343.6091.11.camel@twins> <4E778C0E.5060000@parallels.com> <1316457868.6091.20.camel@twins>
In-Reply-To: <1316457868.6091.20.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 03:44 PM, Peter Zijlstra wrote:
> On Mon, 2011-09-19 at 15:38 -0300, Glauber Costa wrote:
>> On 09/19/2011 03:35 PM, Peter Zijlstra wrote:
>>> On Mon, 2011-09-19 at 13:30 -0300, Glauber Costa wrote:
>>>> For cpuusage, I am not sure this optimization is a valid one
>>>
>>> I was talking about cpuusage, cpuacct_charge() is called for every
>>> ctxsw/tick.
>>
>> I am not touching it right now.
>
> See hunk #4 of this particular patch:
>
> @@ -9302,7 +9308,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
>
> That's cpuusage muck ;-)

Well, sure. But then, the only thing I am doing in this particular hunk 
is changing the definition of how to grab a parent... Can easily even be 
left aside.

>>> But even for cpuacct tick stuff, wouldn't you need to sum all your child
>>> cgroups to update the current cgroup? and that up the whole tree?
>>
>> Of course I would. But as I said, it does not need to be done every
>> tick, in case it poses such a cacheline mayhem as you fear.
>>
>> Since we'll only really need those values when someone reads it - which
>> is a far less frequent operation than the tick resolution - and when a
>> cgroup is destroyed - even less frequent operation - it should work well.
>
> Quite possible, yes. Although if you create a cgroup with 100 subgroups
> and poll very frequently.. it all depends on the avg use case etc.. and
> since I don't use any of this stuff someone needs to tell me about how
> the trade-offs work out in practice.
>
> So explicit changelogs with numbers and agreements from multiple users
> go a long way to make me feel good ;-)

Well, thinking again about that, maybe it is not that much of a good 
idea. systemd is already starting to span a lot of cgroups... and if we 
update the tree bottom-up, we actually do have a much larger cost, since 
we need to touch all its breath...
