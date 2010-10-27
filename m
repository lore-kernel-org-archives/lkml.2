Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab0J0A7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:59:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57341 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760748Ab0J0A7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j6RKNqpU1ovbVKMCE4pZBID3ZyttQs73Ad4Xx+/JR9FLgbTCiGhHNf8LLQEoS6GE0g
         XROOMzfRbuKWZvXTh4uJlF/VdwtuS4DPttc5jb5odxzdXecrOjeIkwfi+Upbdt6sCahF
         b+SWSmTk17YceUA3b4MTaj6t+/QVmSuMVgdew=
Message-ID: <4CC779AE.1040506@polymtl.ca>
Date: Tue, 26 Oct 2010 21:00:30 -0400
From: Benjamin Poirier <benjamin.poirier@polymtl.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RELEASE] LTTng 0.234 for kernel 2.6.36
References: <20101026020544.GA26701@Krystal>
In-Reply-To: <20101026020544.GA26701@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/10 10:05 PM, Mathieu Desnoyers wrote:
> LTTng, the Linux Trace Toolkit Next Generation, is a project that aims at
> producing a highly efficient full system tracing solution.  It is composed of
> several components to allow tracing of the kernel, of userspace, trace viewing
> and analysis and trace streaming.  LTTng is open source software. It is being
> actively developed with the community.
> 
> Changelog:
> 
> * Remove duplicated old-napi duplicated device instrumentation.

There's a tracepoint that went MIA compared to 0.232. Here's what
lttng-instrumentation-net-move-network-tracepoints should look like:

LTTng instrumentation net: move network tracepoints

One of the objectives when tracing the network subsystems is to trace packet
emission as late as possible and packet arrival as soon as possible in order
to have more accurate timing measurements.

This patch moves the xmit tracepoint to the dev_hard_start_xmit() function,
the last function called that is not network interface specific but is called
for every frame. The tracepoint is also duplicated to trace each segmented
packet when GSO is in effect.

The receive tracepoint is moved earlier in the netif_receive_skb() function.
The tracepoint is also duplicated in the netif_rx() function. This enables
more precise measurements for pre-NAPI drivers.

Signed-off-by: Benjamin Poirier <benjamin.poirier@polymtl.ca>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 net/core/dev.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d601639..ff30e1b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1985,6 +1985,8 @@ int dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 
+		trace_net_dev_xmit(skb);
+
 		rc = ops->ndo_start_xmit(skb, dev);
 		if (rc == NETDEV_TX_OK)
 			txq_trans_update(txq);
@@ -2005,6 +2007,7 @@ gso:
 		if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
 			skb_dst_drop(nskb);
 
+		trace_net_dev_xmit(nskb);
 		rc = ops->ndo_start_xmit(nskb, dev);
 		if (unlikely(rc != NETDEV_TX_OK)) {
 			if (rc & ~NETDEV_TX_MASK)
@@ -2183,7 +2186,6 @@ int dev_queue_xmit(struct sk_buff *skb)
 	struct Qdisc *q;
 	int rc = -ENOMEM;
 
-	trace_net_dev_xmit(skb);
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
 	 */
@@ -2518,6 +2520,8 @@ int netif_rx(struct sk_buff *skb)
 	if (netpoll_rx(skb))
 		return NET_RX_DROP;
 
+	trace_net_dev_receive(skb);
+
 	if (netdev_tstamp_prequeue)
 		net_timestamp_check(skb);
 
@@ -2869,7 +2873,6 @@ static int __netif_receive_skb(struct sk_buff *skb)
 	}
 
 	__this_cpu_inc(softnet_data.processed);
-	trace_net_dev_receive(skb);
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
 	skb->mac_len = skb->network_header - skb->mac_header;
@@ -2975,6 +2978,8 @@ int netif_receive_skb(struct sk_buff *skb)
 	if (skb_defer_rx_timestamp(skb))
 		return NET_RX_SUCCESS;
 
+	trace_net_dev_receive(skb);
+
 #ifdef CONFIG_RPS
 	{
 		struct rps_dev_flow voidflow, *rflow = &voidflow;
-- 
1.7.1


> 
> Project website: http://lttng.org
> Download link: http://lttng.org/content/download
> (please refer to the LTTng Manual for installation instructions)
> 

