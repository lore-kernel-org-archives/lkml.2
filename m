Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2BXQyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:54:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:62470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757875Ab2BXQye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:54:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110431652"
From: "Latif, Faisal" <faisal.latif@intel.com>
To: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Roland Dreier <roland@kernel.org>
Subject: RE: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
Thread-Topic: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
Thread-Index: AQHM8BH3wtzmA4YdoEu+lrLhChpf+pZMSDxg
Date: Fri, 24 Feb 2012 16:54:31 +0000
Message-ID: <1EEBC91386407A4A8D1EBE1DD5AA5212D36E22@FMSMSX105.amr.corp.intel.com>
References: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not approve this patch. 

The type field is always set to either NES_TIMER_TYPE_SEND or NES_TIMER_TYPE_CLOSE when schedule_nes_timer() is called. Even if we wanted to make sure the value of type is one or the other, proper patch can be just a if stmt to check the type before new_send allocation.

Thanks
Faisal


> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Jesper Juhl
> Sent: Monday, February 20, 2012 2:56 PM
> To: linux-kernel@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org; Hal Rosenstock; Hefty, Sean; Roland
> Dreier; Latif, Faisal
> Subject: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
> 
> In drivers/infiniband/hw/nes/nes_cm.c::schedule_nes_timer(), if we do
> not take the true branch of either the
>   (type == NES_TIMER_TYPE_SEND)
> or
>   (type == NES_TIMER_TYPE_SEND)
> 'if' statements (which it looks like we potentially could since that
> enum can have other values), then we'll leak the memory allocated to
> 'new_send'.
> 
> This (admittedly, rather clumsy) patch addresses that issue by turning
> the two 'if's into 'if' 'else if' and then adding a 'else' branch
> where we note that we need to free the mem and then later, when we are
> done with it, does a conditional kfree() based on the bool we set in
> the 'else' branch.
> 
> I also removed a redundant variable ('was_timer_set').
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/infiniband/hw/nes/nes_cm.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
>  Compile tested only.
> 
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c
> b/drivers/infiniband/hw/nes/nes_cm.c
> index a4972ab..434a25b 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -663,8 +663,8 @@ int schedule_nes_timer(struct nes_cm_node *cm_node,
> struct sk_buff *skb,
>  	unsigned long flags;
>  	struct nes_cm_core *cm_core = cm_node->cm_core;
>  	struct nes_timer_entry *new_send;
> +	bool free_new_send = false;
>  	int ret = 0;
> -	u32 was_timer_set;
> 
>  	new_send = kzalloc(sizeof(*new_send), GFP_ATOMIC);
>  	if (!new_send)
> @@ -688,9 +688,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node,
> struct sk_buff *skb,
>  			return -EINVAL;
>  		}
>  		cm_node->recv_entry = new_send;
> -	}
> -
> -	if (type == NES_TIMER_TYPE_SEND) {
> +	} else if (type == NES_TIMER_TYPE_SEND) {
>  		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
>  		atomic_inc(&new_send->skb->users);
>  		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
> @@ -714,15 +712,18 @@ int schedule_nes_timer(struct nes_cm_node
> *cm_node, struct sk_buff *skb,
>  				return ret;
>  			}
>  		}
> +	} else {
> +		free_new_send = true;
>  	}
> 
> -	was_timer_set = timer_pending(&cm_core->tcp_timer);
> -
> -	if (!was_timer_set) {
> +	if (!timer_pending(&cm_core->tcp_timer)) {
>  		cm_core->tcp_timer.expires = new_send->timetosend;
>  		add_timer(&cm_core->tcp_timer);
>  	}
> 
> +	if (free_new_send)
> +		kfree(new_send);
> +
>  	return ret;
>  }
> 
> --
> 1.7.9.1
> 
> 
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
