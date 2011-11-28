Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1K1LBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:01:07 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33259 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1K1LBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:01:05 -0500
Message-ID: <4ED369C8.9090101@parallels.com>
Date: Mon, 28 Nov 2011 09:00:24 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <paul@paulmenage.org>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>,
        <eric.dumazet@gmail.com>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] Disable task moving when using kernel memory
 accounting
References: <1322242696-27682-1-git-send-email-glommer@parallels.com> <1322242696-27682-11-git-send-email-glommer@parallels.com> <20111128133203.2d52ee28.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111128133203.2d52ee28.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 02:32 AM, KAMEZAWA Hiroyuki wrote:
> On Fri, 25 Nov 2011 15:38:16 -0200
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> Since this code is still experimental, we are leaving the exact
>> details of how to move tasks between cgroups when kernel memory
>> accounting is used as future work.
>>
>> For now, we simply disallow movement if there are any pending
>> accounted memory.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>   mm/memcontrol.c |   23 ++++++++++++++++++++++-
>>   1 files changed, 22 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2df5d3c..ab7e57b 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5451,10 +5451,19 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
>>   {
>>   	int ret = 0;
>>   	struct mem_cgroup *mem = mem_cgroup_from_cont(cgroup);
>> +	struct mem_cgroup *from = mem_cgroup_from_task(p);
>> +
>> +#if defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)&&  defined(CONFIG_INET)
>> +	if (from != mem&&  !mem_cgroup_is_root(from)&&
>> +	    res_counter_read_u64(&from->tcp_mem.tcp_memory_allocated, RES_USAGE)) {
>> +		printk(KERN_WARNING "Can't move tasks between cgroups: "
>> +			"Kernel memory held. task: %s\n", p->comm);
>> +		return 1;
>> +	}
>> +#endif
>
> Hmm, the kernel memory is not guaranteed as being held by the 'task' ?
>
> How about
> "Now, moving task between cgroup is disallowed while the source cgroup
>   containes kmem reference." ?
>
> Hmm.. we need to fix this task-move/rmdir issue before production use.
>
>
> Thanks,
> -Kame
>
Hi Kame,

Let me tell you the direction I am going wrt task movement: The only 
reasons I haven't included so far, is that I believe it needs more 
testing, and as you know, I am right now more interested in getting past 
the initial barriers for inclusion. I am committed to fix anything that 
needs to be fixed - stylish or non-stylish before we remove the 
experimental flag.

So what I intend to do, is to basically
* lock the task,
* scan through its file descriptors list,
* identify which of them are sockets,
* cast them to struct sock *,
* see if it has a cgrp associated
* see if cgrp == from

At this point we can decrement sockets allocated by 1 in from, and 
memory_allocated by sk_forward_alloc (increasing by equal quantities in 
the destination cgroup)

I belive it will work.


