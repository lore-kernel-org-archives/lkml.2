Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1IHEzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 00:55:04 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41000 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1IHEzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 00:55:02 -0400
Message-ID: <4E684A6B.6030205@parallels.com>
Date: Thu, 8 Sep 2011 01:54:03 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        <containers@lists.osdl.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 3/9] socket: initial cgroup code.
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-4-git-send-email-glommer@parallels.com> <20110907221710.GA7845@shutemov.name>
In-Reply-To: <20110907221710.GA7845@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [189.121.42.206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 07:17 PM, Kirill A. Shutemov wrote:
> On Wed, Sep 07, 2011 at 01:23:13AM -0300, Glauber Costa wrote:
>> We aim to control the amount of kernel memory pinned at any
>> time by tcp sockets. To lay the foundations for this work,
>> this patch adds a pointer to the kmem_cgroup to the socket
>> structure.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>> ---
>>   include/linux/kmem_cgroup.h |   29 +++++++++++++++++++++++++++++
>>   include/net/sock.h          |    2 ++
>>   net/core/sock.c             |    5 ++---
>>   3 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/kmem_cgroup.h b/include/linux/kmem_cgroup.h
>> index 0e4a74b..77076d8 100644
>> --- a/include/linux/kmem_cgroup.h
>> +++ b/include/linux/kmem_cgroup.h
>> @@ -49,5 +49,34 @@ static inline struct kmem_cgroup *kcg_from_task(struct task_struct *tsk)
>>   	return NULL;
>>   }
>>   #endif /* CONFIG_CGROUP_KMEM */
>> +
>> +#ifdef CONFIG_INET
>
> Will it break something if you define the helpers even if CONFIG_INET
> is not defined?
> It will be much cleaner. You can reuse ifdef CONFIG_CGROUP_KMEM in this
> case.

The helpers inside CONFIG_INET are needed for the network code, 
regardless of kmem cgroup is defined or not, not the other way around.

So I could remove CONFIG_INET, but I can't possibly move it inside
CONFIG_CGROUP_KMEM. So this buy us nothing.

>> +#include<net/sock.h>
>> +static inline void sock_update_kmem_cgrp(struct sock *sk)
>> +{
>> +#ifdef CONFIG_CGROUP_KMEM
>> +	sk->sk_cgrp = kcg_from_task(current);
>> +
>> +	/*
>> +	 * We don't need to protect against anything task-related, because
>> +	 * we are basically stuck with the sock pointer that won't change,
>> +	 * even if the task that originated the socket changes cgroups.
>> +	 *
>> +	 * What we do have to guarantee, is that the chain leading us to
>> +	 * the top level won't change under our noses. Incrementing the
>> +	 * reference count via cgroup_exclude_rmdir guarantees that.
>> +	 */
>> +	cgroup_exclude_rmdir(&sk->sk_cgrp->css);
>> +#endif
>> +}
>> +
>> +static inline void sock_release_kmem_cgrp(struct sock *sk)
>> +{
>> +#ifdef CONFIG_CGROUP_KMEM
>> +	cgroup_release_and_wakeup_rmdir(&sk->sk_cgrp->css);
>> +#endif
>> +}
>> +
>> +#endif /* CONFIG_INET */
>>   #endif /* _LINUX_KMEM_CGROUP_H */
>
>> @@ -2252,9 +2254,6 @@ void sk_common_release(struct sock *sk)
>>   }
>>   EXPORT_SYMBOL(sk_common_release);
>>
>> -static DEFINE_RWLOCK(proto_list_lock);
>> -static LIST_HEAD(proto_list);
>> -
>
> Wrong patch?
Yes, it is. Thanks for noticing.


