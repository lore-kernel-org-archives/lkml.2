Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab0FYHMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:12:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36890 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0FYHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:12:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C2456DA.8030200@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 16:12:26 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com
Subject: Re: [RFC PATCH v2 4/5] skb: add tracepoints to freeing skb
References: <4C2312A8.9060903@jp.fujitsu.com>	 <4C23FF55.3090604@jp.fujitsu.com> <1277441711.2481.3.camel@edumazet-laptop>
In-Reply-To: <1277441711.2481.3.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/25 13:55), Eric Dumazet wrote:
> Le vendredi 25 juin 2010 à 09:59 +0900, Koki Sanagi a écrit :
>> This patch adds tracepoint to consume_skb and dev_kfree_skb_irq.
>> Combinating with tracepoint on dev_hard_start_xmit, we can check how long it
>> takes to free transmited packets. And using it, we can calculate how many
>> packets driver had at that time. It is useful when a drop of transmited packet
>> is a problem.
>>
>>           <idle>-0     [001] 241409.218333: consume_skb: skbaddr=dd6b2fb8
>>           <idle>-0     [001] 241409.490555: dev_kfree_skb_irq: skbaddr=f5e29840
>>
>> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
>> ---
>> include/trace/events/skb.h |   36 ++++++++++++++++++++++++++++++++++++
>>  net/core/dev.c             |    2 ++
>>  net/core/skbuff.c          |    1 +
>>  3 files changed, 39 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
>> index 4b2be6d..6ab5b34 100644
>> --- a/include/trace/events/skb.h
>> +++ b/include/trace/events/skb.h
>> @@ -35,6 +35,42 @@ TRACE_EVENT(kfree_skb,
>>  		__entry->skbaddr, __entry->protocol, __entry->location)
>>  );
>>  
>> +TRACE_EVENT(consume_skb,
>> +
>> +	TP_PROTO(struct sk_buff *skb),
>> +
>> +	TP_ARGS(skb),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	void *,	skbaddr	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->skbaddr = skb;
>> +	),
>> +
>> +	TP_printk("skbaddr=%p",
>> +		__entry->skbaddr)
>> +);
>> +
>> +TRACE_EVENT(dev_kfree_skb_irq,
>> +
>> +	TP_PROTO(struct sk_buff *skb),
>> +
>> +	TP_ARGS(skb),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	void *,	skbaddr	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->skbaddr = skb;
>> +	),
>> +
>> +	TP_printk("skbaddr=%p",
>> +		__entry->skbaddr)
>> +);
>> +
>>  TRACE_EVENT(skb_copy_datagram_iovec,
>>  
>>  	TP_PROTO(const struct sk_buff *skb, int len),
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 4b64b21..807b1ca 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -131,6 +131,7 @@
>>  #include <linux/random.h>
>>  #include <trace/events/napi.h>
>>  #include <trace/events/net.h>
>> +#include <trace/events/skb.h>
>>  #include <linux/pci.h>
>>  
>>  #include "net-sysfs.h"
>> @@ -1580,6 +1581,7 @@ void dev_kfree_skb_irq(struct sk_buff *skb)
>>  		struct softnet_data *sd;
>>  		unsigned long flags;
>>  
>> +		trace_dev_kfree_skb_irq(skb);
>>  		local_irq_save(flags);
>>  		sd = &__get_cpu_var(softnet_data);
>>  		skb->next = sd->completion_queue;
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 34432b4..a7b4036 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -466,6 +466,7 @@ void consume_skb(struct sk_buff *skb)
>>  		smp_rmb();
>>  	else if (likely(!atomic_dec_and_test(&skb->users)))
>>  		return;
>> +	trace_consume_skb(skb);
>>  	__kfree_skb(skb);
>>  }
>>  EXPORT_SYMBOL(consume_skb);
>>
> 
> 
> You might add a trace point to skb_free_datagram_locked() too, since it
> contains an inlined consume_skb()
> 

I think it is contrary.
skb_free_datagram_locked() contains consume_skb(), so tracepoint isn't needed.
Because skb_free_datagram_locked() can be traced by trace_consume_skb().



