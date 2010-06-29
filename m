Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0F2A1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:27:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49375 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0F2A1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:27:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C293E09.6010402@jp.fujitsu.com>
Date: Tue, 29 Jun 2010 09:27:53 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com
Subject: Re: [RFC PATCH v2 3/5] netdev: add tracepoints to netdev layer
References: <4C2312A8.9060903@jp.fujitsu.com>	 <4C23FF3E.1080503@jp.fujitsu.com> <1277748598.9181.71.camel@gandalf.stny.rr.com>
In-Reply-To: <1277748598.9181.71.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/29 3:09), Steven Rostedt wrote:
> On Fri, 2010-06-25 at 09:58 +0900, Koki Sanagi wrote:
>> This patch adds tracepoint to dev_queue_xmit, dev_hard_start_xmit and
>> netif_receive_skb. These tracepints help you to monitor network driver's
>> input/output.
>>
>>             sshd-4445  [001] 241367.066046: net_dev_queue: dev=eth3 skbaddr=dd6b2538 len=114
>>             sshd-4445  [001] 241367.066047: net_dev_xmit: dev=eth3 skbaddr=dd6b2538 len=114 rc=0
>>           <idle>-0     [001] 241367.067472: net_dev_receive: dev=eth3 skbaddr=f5e59000 len=52
>>
>> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
>> ---
>>  include/trace/events/net.h |   83 ++++++++++++++++++++++++++++++++++++++++++++
>>  net/core/dev.c             |    5 +++
>>  net/core/net-traces.c      |    1 +
>>  3 files changed, 89 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
>> new file mode 100644
>> index 0000000..ee10970
>> --- /dev/null
>> +++ b/include/trace/events/net.h
>> @@ -0,0 +1,83 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM net
>> +
>> +#if !defined(_TRACE_NET_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_NET_H
>> +
>> +#include <linux/skbuff.h>
>> +#include <linux/netdevice.h>
>> +#include <linux/ip.h>
>> +#include <linux/tracepoint.h>
>> +
>> +TRACE_EVENT(net_dev_xmit,
>> +
>> +	TP_PROTO(struct sk_buff *skb,
>> +		 int rc),
>> +
>> +	TP_ARGS(skb, rc),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	void *,		skbaddr		)
>> +		__field(	unsigned int,	len		)
>> +		__field(	int,		rc		)
>> +		__string(	name,		skb->dev->name	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->skbaddr = skb;
>> +		__entry->len = skb->len;
>> +		__entry->rc = rc;
>> +		__assign_str(name, skb->dev->name);
>> +	),
>> +
>> +	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
>> +		__get_str(name), __entry->skbaddr, __entry->len, __entry->rc)
>> +);
>> +
>> +TRACE_EVENT(net_dev_queue,
>> +
>> +	TP_PROTO(struct sk_buff *skb),
>> +
>> +	TP_ARGS(skb),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	void *,		skbaddr		)
>> +		__field(	unsigned int,	len		)
>> +		__string(	name,		skb->dev->name	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->skbaddr = skb;
>> +		__entry->len = skb->len;
>> +		__assign_str(name, skb->dev->name);
>> +	),
>> +
>> +	TP_printk("dev=%s skbaddr=%p len=%u",
>> +		__get_str(name), __entry->skbaddr, __entry->len)
>> +);
>> +
>> +TRACE_EVENT(net_dev_receive,
> 
> This and net_dev_queue are identical. Please use DECLARE_EVENT_CLASS()
> and DEFINE_EVENT() to create these, otherwise it bloats the kernel.
> 
> -- Steve

OK, I'll do that.

Thanks,
Koki Sanagi.
> 
>> +
>> +	TP_PROTO(struct sk_buff *skb),
>> +
>> +	TP_ARGS(skb),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	void *,		skbaddr		)
>> +		__field(	unsigned int,	len		)
>> +		__string(	name,		skb->dev->name	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->skbaddr = skb;
>> +		__entry->len = skb->len;
>> +		__assign_str(name, skb->dev->name);
>> +	),
>> +
>> +	TP_printk("dev=%s skbaddr=%p len=%u",
>> +		__get_str(name), __entry->skbaddr, __entry->len)
>> +);
>> +#endif /* _TRACE_NET_H */
>> +
> 
> 
> 
> 


