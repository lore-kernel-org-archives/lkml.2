Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1CBCpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:45:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab1CBCpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:45:23 -0500
Message-ID: <4D6DAF86.2000407@cn.fujitsu.com>
Date: Wed, 02 Mar 2011 10:46:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu,
        paulmck@linux.vnet.ibm.com, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4 V2] net,rcu: don't assume the size of struct rcu_head
References: <4D6CA860.3020409@cn.fujitsu.com>	 <20110301.001638.104075130.davem@davemloft.net>	 <4D6CB414.8050107@cn.fujitsu.com> <1298971213.3284.4.camel@edumazet-laptop>
In-Reply-To: <1298971213.3284.4.camel@edumazet-laptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 10:44:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 10:44:12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 05:20 PM, Eric Dumazet wrote:
> Le mardi 01 mars 2011 à 16:53 +0800, Lai Jiangshan a écrit :
>> On 03/01/2011 04:16 PM, David Miller wrote:
>>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
>>> Date: Tue, 01 Mar 2011 16:03:44 +0800
>>>
>>>>
>>>> struct dst_entry assumes the size of struct rcu_head as 2 * sizeof(long)
>>>> and manually adds pads for aligning for "__refcnt".
>>>>
>>>> When the size of struct rcu_head is changed, these manual padding
>>>> is wrong. Use __attribute__((aligned (64))) instead.
>>>>
>>>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>>
>>> We don't want to use the align if it's going to waste lots of space.
>>>
>>> Instead we want to rearrange the structure so that the alignment comes
>>> more cheaply.
>>
>> Subject: [PATCH 4/4 V2] net,rcu: don't assume the size of struct rcu_head
>>
>> struct dst_entry assumes the size of struct rcu_head as 2 * sizeof(long)
>> and manually adds pads for aligning for "__refcnt".
>>
>> When the size of struct rcu_head is changed, these manual padding
>> are hardly suit for the changes. So we rearrange the structure,
>> and move the seldom access rcu_head to the end of the structure.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>>
>> diff --git a/include/net/dst.h b/include/net/dst.h
>> index 93b0310..d8c5296 100644
>> --- a/include/net/dst.h
>> +++ b/include/net/dst.h
>> @@ -37,7 +37,6 @@
>>  struct sk_buff;
>>  
>>  struct dst_entry {
>> -	struct rcu_head		rcu_head;
>>  	struct dst_entry	*child;
>>  	struct net_device       *dev;
>>  	short			error;
>> @@ -78,6 +77,13 @@ struct dst_entry {
>>  	__u32			__pad2;
>>  #endif
>>  
>> +	unsigned long		lastuse;
>> +	union {
>> +		struct dst_entry	*next;
>> +		struct rtable __rcu	*rt_next;
>> +		struct rt6_info		*rt6_next;
>> +		struct dn_route __rcu	*dn_next;
>> +	};
>>  
>>  	/*
>>  	 * Align __refcnt to a 64 bytes alignment
>> @@ -92,13 +98,7 @@ struct dst_entry {
>>  	 */
>>  	atomic_t		__refcnt;	/* client references	*/
>>  	int			__use;
>> -	unsigned long		lastuse;
>> -	union {
>> -		struct dst_entry	*next;
>> -		struct rtable __rcu	*rt_next;
>> -		struct rt6_info		*rt6_next;
>> -		struct dn_route __rcu	*dn_next;
>> -	};
>> +	struct rcu_head		rcu_head;
>>  };
>>  
>>  #ifdef __KERNEL__
> 
> Nope...
> 
> "lastuse" and "next" must be in this place, or this introduce false
> sharing we wanted to avoid in the past.
> 
> I suggest you leave this code as is, we will address the problem when
> rcu_head changes (assuming we can test a CONFIG_RCU_HEAD_DEBUG or
> something)
> 
> First part of "struct dst_entry" is mostly read, while part beginning
> after refcnt is often written.
> 

Is it the cause of false sharing? I thought that all are rare write(except __refcnt)
since it is protected by RCU.

Do you allow me just move the seldom access rcu_head to the end of the structure
and add pads before __refcnt? I guess it increases about 3% the size of dst_entry.

I accept that I leave this code as is, when I change rcu_head I will notify you.

Thanks,
Lai

