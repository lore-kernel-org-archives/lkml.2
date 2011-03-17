Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1CQJ1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:27:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab1CQJ1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:27:09 -0400
Message-ID: <4D81D451.4020203@cn.fujitsu.com>
Date: Thu, 17 Mar 2011 17:28:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
References: <4D7F356C.8020903@cn.fujitsu.com> <1300194693.10062.15.camel@edumazet-laptop> <20110316040308.GC2273@linux.vnet.ibm.com>
In-Reply-To: <20110316040308.GC2273@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-17 17:25:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-17 17:25:44
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2011 12:03 PM, Paul E. McKenney wrote:
> On Tue, Mar 15, 2011 at 02:11:33PM +0100, Eric Dumazet wrote:
>> Le mardi 15 mars 2011 à 17:46 +0800, Lai Jiangshan a écrit :
>>
>>
>>> --- a/kernel/rcutiny.c
>>> +++ b/kernel/rcutiny.c
>>> @@ -167,7 +167,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
>>>  		prefetch(next);
>>>  		debug_rcu_head_unqueue(list);
>>>  		local_bh_disable();
>>> -		list->func(list);
>>> +		__rcu_reclaim(list);
>>>  		local_bh_enable();
>>>  		list = next;
>>>  		RCU_TRACE(cb_count++);
>>
>> Paul, I am just wondering why we disable BH before calling list->func()
>>
>> This should be done in callbacks that really need it ?
>>
>> At least the disable/enable pair is not necessary before calling kfree()
> 
> Good point, we could bury the enable/disable pair in __rcu_reclaim().
> 
> Lai, am I forgetting any reason why we disable BH?
> 
> 							Thanx, Paul
> 

For many years, rcu callbacks are called on BH since rcu is added to kernel,
and someone assume they always called in BH. So we have to disable BH before
calling list->func() to avoid bad result. It's a *historical* reason.

I greed the disable/enable pair is not necessary before calling kfree(), but
__rcu_reclaim() is also called in rcutree which rcu_process_callbacks()
is in BH currently, I don't want to write 2 different version of
__rcu_reclaim()s (one for rcutree, another for rcutiny).

rcutree's rcu_process_callbacks() will be moved to process context, we may
remove disable/enable BH pair for kfree() then.

Thanks,
Lai.
