Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab2HMXgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:36:54 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60021 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab2HMXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:36:52 -0400
Date: Mon, 13 Aug 2012 16:36:41 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] [NETFILTER] bridge: rcu_deref outside read-lock section
Message-ID: <20120813163641.69a8388a@nehalam.linuxnetplumber.net>
In-Reply-To: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
References: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 02:47:42 +0400
Denis Efremov <yefremov.denis@gmail.com> wrote:

> As it noted in the comment before the br_handle_frame_finish
> function, this function should be called under rcu_read_lock.
> 
> The problem callgraph:
> br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
> -> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference
> 
> And in this case there is no read-lock section.
> I have put lock/unlock in br_nf_pre_routing_finish_bridge_slow,
> as the only function that calls it(for now) - is br_dev_xmit.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  include/linux/netfilter_bridge.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> index 31d2844..ceb048e 100644
> --- a/include/linux/netfilter_bridge.h
> +++ b/include/linux/netfilter_bridge.h
> @@ -79,6 +79,7 @@ extern int br_handle_frame_finish(struct sk_buff *skb);
>  /* Only used in br_device.c */
>  static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
>  {
> +	int res;
>  	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>  
>  	skb_pull(skb, ETH_HLEN);
> @@ -86,7 +87,10 @@ static inline int br_nf_pre_routing_finish_bridge_slow(struct sk_buff *skb)
>  	skb_copy_to_linear_data_offset(skb, -(ETH_HLEN-ETH_ALEN),
>  				       skb->nf_bridge->data, ETH_HLEN-ETH_ALEN);
>  	skb->dev = nf_bridge->physindev;
> -	return br_handle_frame_finish(skb);
> +	rcu_read_lock();
> +	res = br_handle_frame_finish(skb);
> +	rcu_read_unlock();
> +	return res;
>  }
>  
>  /* This is called by the IP fragmenting code and it ensures there is

Why not just move the rcu_read_lock() in br_dev_xmit earlier?
