Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1LIMni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 07:43:38 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50920 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab1LIMnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:43:35 -0500
Message-ID: <4EE20254.6000308@parallels.com>
Date: Fri, 9 Dec 2011 10:43:00 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <lizf@cn.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <eric.dumazet@gmail.com>,
        <cgroups@vger.kernel.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@fujtsu.com>
Subject: Re: [PATCH v8 3/9] socket: initial cgroup code.
References: <1323120903-2831-1-git-send-email-glommer@parallels.com> <1323120903-2831-4-git-send-email-glommer@parallels.com> <20111209110550.fc740b81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111209110550.fc740b81.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 12:05 AM, KAMEZAWA Hiroyuki wrote:
> On Mon,  5 Dec 2011 19:34:57 -0200
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> The goal of this work is to move the memory pressure tcp
>> controls to a cgroup, instead of just relying on global
>> conditions.
>>
>> To avoid excessive overhead in the network fast paths,
>> the code that accounts allocated memory to a cgroup is
>> hidden inside a static_branch(). This branch is patched out
>> until the first non-root cgroup is created. So when nobody
>> is using cgroups, even if it is mounted, no significant performance
>> penalty should be seen.
>>
>> This patch handles the generic part of the code, and has nothing
>> tcp-specific.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Kirill A. Shutemov<kirill@shutemov.name>
>> CC: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujtsu.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>
> I already replied Reviewed-by: but...
Feel free. Reviews, the more, the merrier.

>
>
>> +/* Writing them here to avoid exposing memcg's inner layout */
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +#ifdef CONFIG_INET
>> +#include<net/sock.h>
>> +
>> +static bool mem_cgroup_is_root(struct mem_cgroup *memcg);
>> +void sock_update_memcg(struct sock *sk)
>> +{
>> +	/* A socket spends its whole life in the same cgroup */
>> +	if (sk->sk_cgrp) {
>> +		WARN_ON(1);
>> +		return;
>> +	}
>> +	if (static_branch(&memcg_socket_limit_enabled)) {
>> +		struct mem_cgroup *memcg;
>> +
>> +		BUG_ON(!sk->sk_prot->proto_cgroup);
>> +
>> +		rcu_read_lock();
>> +		memcg = mem_cgroup_from_task(current);
>> +		if (!mem_cgroup_is_root(memcg)) {
>> +			mem_cgroup_get(memcg);
>> +			sk->sk_cgrp = sk->sk_prot->proto_cgroup(memcg);
>> +		}
>> +		rcu_read_unlock();
>> +	}
>> +}
>
> Here, you do mem_cgroup_get() if !mem_cgroup_is_root().
>
>
>> +EXPORT_SYMBOL(sock_update_memcg);
>> +
>> +void sock_release_memcg(struct sock *sk)
>> +{
>> +	if (static_branch(&memcg_socket_limit_enabled)&&  sk->sk_cgrp) {
>> +		struct mem_cgroup *memcg;
>> +		WARN_ON(!sk->sk_cgrp->memcg);
>> +		memcg = sk->sk_cgrp->memcg;
>> +		mem_cgroup_put(memcg);
>> +	}
>> +}
>>
>
> You don't check !mem_cgroup_is_root(). Hm, root memcg will not be freed
> by this ?
>
No, I don't. But I check if sk->sk_cgrp is filled. So it is implied, 
because we only fill in this value if !mem_cgroup_is_root().
