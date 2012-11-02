Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2KBRqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:46:50 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:6237 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932849Ab2KBRqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:46:03 -0400
Date: Fri, 2 Nov 2012 17:46:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
In-Reply-To: <5093EE59.8010609@gmail.com>
Message-ID: <0000013ac23ac528-19a0dd1b-3144-45df-9d6e-471999d6ae31-000000@email.amazonses.com>
References: <5093EE59.8010609@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

> +++ b/net/openvswitch/datapath.c
> @@ -208,7 +208,7 @@ void ovs_dp_process_received_packet(struct vport *p, struct sk_buff *skb)
>  	int error;
>  	int key_len;
>
> -	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
> +	stats = this_cpu_ptr(dp->stats_percpu);
>
>  	/* Extract flow from 'skb' into 'key'. */
>  	error = ovs_flow_extract(skb, p->port_no, &key, &key_len);
> @@ -282,7 +282,7 @@ int ovs_dp_upcall(struct datapath *dp, struct sk_buff *skb,
>  	return 0;
>
>  err:
> -	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
> +	stats = this_cpu_ptr(dp->stats_percpu);
>
>  	u64_stats_update_begin(&stats->sync);
>  	stats->n_lost++;
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 03779e8..70af0be 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -333,8 +333,7 @@ void ovs_vport_receive(struct vport *vport, struct sk_buff *skb)
>  {
>  	struct vport_percpu_stats *stats;
>
> -	stats = per_cpu_ptr(vport->percpu_stats, smp_processor_id());
> -
> +	stats = this_cpu_ptr(vport->percpu_stats);
>  	u64_stats_update_begin(&stats->sync);
>  	stats->rx_packets++;
>  	stats->rx_bytes += skb->len;
> @@ -359,7 +358,7 @@ int ovs_vport_send(struct vport *vport, struct sk_buff *skb)
>  	if (likely(sent)) {
>  		struct vport_percpu_stats *stats;
>
> -		stats = per_cpu_ptr(vport->percpu_stats, smp_processor_id());
> +		stats = this_cpu_ptr(vport->percpu_stats);
>
>  		u64_stats_update_begin(&stats->sync);
>  		stats->tx_packets++;

Use this_cpu_inc(vport->percpu_stats->packets) here?


