Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1ISQbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:31:32 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56569 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab1ISQbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:31:31 -0400
Message-ID: <4E776E36.6040906@parallels.com>
Date: Mon, 19 Sep 2011 13:30:46 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>   <1316030695-19826-2-git-send-email-glommer@parallels.com>  <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com> <1316449160.6091.5.camel@twins>
In-Reply-To: <1316449160.6091.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 01:19 PM, Peter Zijlstra wrote:
> On Mon, 2011-09-19 at 13:09 -0300, Glauber Costa wrote:
>> On 09/19/2011 01:03 PM, Peter Zijlstra wrote:
>>> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>>>> +       for (; ca; ca = parent_ca(ca)) {
>>>
>>> It might be good to check that the loop condition and null condition in
>>> the parent_ca() function get folded. Otherwise there's a double branch
>>> in that loop.
>>>
>>> Note that this function is one of the reasons I dislike cpuacct, it adds
>>> a second cgroup hierarchy traversal to every context switch.
>>>
>> Well, it is not that hard to optimize this.
>>
>> Those values are always updated, but they don't really need to, unless
>> they are read.
>>
>> So what we can do, is introduce a marker in the cgroup, representing the
>> last read value. Parent is untouched. We then update parent when 1)
>> reading this value, 2) cgroup destroy, 3) cpu hotplug. (humm, and maybe
>> we don't even need to do it in cpu hotplug, since the per-cpu variables
>> will still be accessible... )
>>
>> How about it ?
>
> Updating that value would involve iterating all tasks in the entire
> cgroup subtree nested at whatever cgroup you're wanting to read.

No, it would not. Because nothing is stored in the task, all is stored 
in the cgroup. So it is O(h(n)), where n is the number of cgroups and 
h(n) the height of the cgroups tree.

> The delayed update would be an entire subtree walk, that can be quite
> expensive.
But the subtrees are small, because we are talking about the cgroup 
subtree, wich can grow quite a lot in breadth, but rarely in depth.

> Who wants these numbers and what for and at what frequency?
> Does that really make sense?

Whoever wants /proc/stat numbers. Once, or maybe twice a sec would be 
the normal interval here for most use cases, I guess (top inside a 
container, for instance).

Even people doing much more frequent updates here, would not come as 
close as doing it every tick, therefore making this option cheaper than 
transversing the tree at each tick.

Btw, this works for cpuacct. For cpuusage, I am not sure this 
optimization is a valid one. Since this value is at least intended to 
provide a basis for cpu capping in the near future (Well, it is not 
there, but I think it is), it is expected to be used much more 
frequently by the kernel itself.
