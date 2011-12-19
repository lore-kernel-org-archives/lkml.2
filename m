Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1LSJMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:12:39 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25026 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1LSJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:12:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6564"; a="145666841"
Message-ID: <4EEF0003.3010800@codeaurora.org>
Date: Mon, 19 Dec 2011 01:12:35 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: mc@linux.vnet.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong> <4EEEE866.2000203@linux.vnet.ibm.com>
In-Reply-To: <4EEEE866.2000203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2011 11:31 PM, Srivatsa S. Bhat wrote:
> Hi,
>
> I feel the following patch is a better fix for 2 reasons:
>
> 1. As Al Viro pointed out, if we do for_each_possible_cpus() then we might
> encounter unnecessary performance hit in some scenarios. So working with
> only online cpus, safely(a.k.a race-free), if possible, would be a good
> solution (which this patch implements).
>
> 2. *_global_lock_online() and *_global_unlock_online() needs fixing as well
> because, the names suggest that they lock/unlock per-CPU locks of only the
> currently online CPUs, but unfortunately they do not have any synchronization
> to prevent offlining those CPUs in between, if it happens to race with a CPU
> hotplug operation.
>
> And if we solve issue 2 above "carefully" (as mentioned in the changelog below),
> it solves this whole thing!

We started seeing this same problem last week. I've come up with almost 
the same solution but you beat me to the list!

> diff --git a/include/linux/lglock.h b/include/linux/lglock.h
> index f549056..583d1a8 100644
> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -126,6 +127,7 @@
>   	int i;								\
>   	preempt_disable();						\
>   	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
> +	get_online_cpus();						\
>   	for_each_online_cpu(i) {					\
>   		arch_spinlock_t *lock;					\
>   		lock =&per_cpu(name##_lock, i);			\
> @@ -142,6 +144,7 @@
>   		lock =&per_cpu(name##_lock, i);			\
>   		arch_spin_unlock(lock);					\
>   	}								\
> +	put_online_cpus();						\
>   	preempt_enable();						\
>    }									\
>    EXPORT_SYMBOL(name##_global_unlock_online);				\

Don't you want to call {get,put}_online_cpus() outside the 
preempt_{disable,enable}()? Otherwise you are scheduling while atomic?

With that fixed

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

but I wonder if taking the hotplug mutex even for a short time reduces 
the effectiveness of these locks? Or is it more about fast readers and 
slow writers?
