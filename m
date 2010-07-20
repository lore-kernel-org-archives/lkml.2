Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0GTEyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 00:54:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50033 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0GTEyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 00:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cTj/1PC4gqW7IXcNUeydWJshBsqhqiflT360wdkvlGNETQoX8r0fL0KxGirvojP/BQ
         GLW20FRTjqWPJ5oe7fssj+fEQ/74sJEJyuzGN+/Ogmt1UdkSGBt+RfQySTH7dcecT5wy
         nIvCJ6Pf0ixWW9JDdJC/+DM42+InGIyQYImns=
Subject: Re: [RFC PATCH v3 4/5] skb: add tracepoints to freeing skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca
In-Reply-To: <4C44F286.1050907@jp.fujitsu.com>
References: <4C44F12F.5090908@jp.fujitsu.com>
	 <4C44F286.1050907@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 06:54:03 +0200
Message-ID: <1279601643.2458.64.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 20 juillet 2010 à 09:49 +0900, Koki Sanagi a écrit :
> [RFC PATCH v3 4/5] skb: add tracepoints to freeing skb
> This patch adds tracepoint to consume_skb, dev_kfree_skb_irq and
> skb_free_datagram_locked. Combinating with tracepoint on dev_hard_start_xmit,
> we can check how long it takes to free transmited packets. And using it, we can
> calculate how many packets driver had at that time. It is useful when a drop of
> transmited packet is a problem.
> 
>           <idle>-0     [001] 241409.218333: consume_skb: skbaddr=dd6b2fb8
>           <idle>-0     [001] 241409.490555: dev_kfree_skb_irq: skbaddr=f5e29840
> 
>         udp-recv-302   [001] 515031.206008: skb_free_datagram_locked: skbaddr=f5b1d900
> 
> 
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> ---
>  include/trace/events/skb.h |   42 ++++++++++++++++++++++++++++++++++++++++++
>  net/core/datagram.c        |    1 +
>  net/core/dev.c             |    2 ++
>  net/core/skbuff.c          |    1 +
>  4 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 4b2be6d..84c9041 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -35,6 +35,48 @@ TRACE_EVENT(kfree_skb,
>  		__entry->skbaddr, __entry->protocol, __entry->location)
>  );
>  
> +DECLARE_EVENT_CLASS(free_skb,
> +
> +	TP_PROTO(struct sk_buff *skb),
> +
> +	TP_ARGS(skb),
> +
> +	TP_STRUCT__entry(
> +		__field(	void *,	skbaddr	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->skbaddr = skb;
> +	),
> +
> +	TP_printk("skbaddr=%p", __entry->skbaddr)
> +
> +);
> +
> +DEFINE_EVENT(free_skb, consume_skb,
> +
> +	TP_PROTO(struct sk_buff *skb),
> +
> +	TP_ARGS(skb)
> +
> +);
> +
> +DEFINE_EVENT(free_skb, dev_kfree_skb_irq,
> +
> +	TP_PROTO(struct sk_buff *skb),
> +
> +	TP_ARGS(skb)
> +
> +);
> +
> +DEFINE_EVENT(free_skb, skb_free_datagram_locked,
> +
> +	TP_PROTO(struct sk_buff *skb),
> +
> +	TP_ARGS(skb)
> +
> +);
> +
>  TRACE_EVENT(skb_copy_datagram_iovec,
>  
>  	TP_PROTO(const struct sk_buff *skb, int len),
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index f5b6f43..1ea32a0 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -231,6 +231,7 @@ void skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb)
>  {
>  	bool slow;
>  
> +	trace_skb_free_datagram_locked(skb);

Here you unconditionally trace before the test on skb->users

>  	if (likely(atomic_read(&skb->users) == 1))
>  		smp_rmb();
>  	else if (likely(!atomic_dec_and_test(&skb->users)))
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4acfec6..d979847 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -131,6 +131,7 @@
>  #include <linux/random.h>
>  #include <trace/events/napi.h>
>  #include <trace/events/net.h>
> +#include <trace/events/skb.h>
>  #include <linux/pci.h>
>  
>  #include "net-sysfs.h"
> @@ -1581,6 +1582,7 @@ void dev_kfree_skb_irq(struct sk_buff *skb)
>  		struct softnet_data *sd;
>  		unsigned long flags;
>  
> +		trace_dev_kfree_skb_irq(skb);
>  		local_irq_save(flags);
>  		sd = &__get_cpu_var(softnet_data);
>  		skb->next = sd->completion_queue;
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 34432b4..a7b4036 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -466,6 +466,7 @@ void consume_skb(struct sk_buff *skb)
>  		smp_rmb();
>  	else if (likely(!atomic_dec_and_test(&skb->users)))
>  		return;

While here you trace _after_ the test on skb->users - and a "return;" ,
so you miss some consume_skb() calls


> +	trace_consume_skb(skb);
>  	__kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(consume_skb);
> 


