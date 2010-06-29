Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab0F2A2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:28:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49399 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0F2A2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:28:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C293E37.1000201@jp.fujitsu.com>
Date: Tue, 29 Jun 2010 09:28:39 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com
Subject: Re: [RFC PATCH v2 4/5] skb: add tracepoints to freeing skb
References: <4C2312A8.9060903@jp.fujitsu.com>	 <4C23FF55.3090604@jp.fujitsu.com> <1277748779.9181.72.camel@gandalf.stny.rr.com>
In-Reply-To: <1277748779.9181.72.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/29 3:12), Steven Rostedt wrote:
> On Fri, 2010-06-25 at 09:59 +0900, Koki Sanagi wrote:
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
> 
> These two tracepoints are also identical in body. Please use
> DECLARE_EVENT_CLASS() and DEFINE_EVENT() instead.
> 
> -- Steve
> 

OK, I'll do that.

Thanks,
Koki Sanagi.

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
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> 


