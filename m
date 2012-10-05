Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2JEG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:57:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55777 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2JEG5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:57:03 -0400
Subject: Re: [PATCH] net: Fix skb_under_panic oops in neigh_resolve_output
From: Eric Dumazet <eric.dumazet@gmail.com>
To: ramesh.nagappa@gmail.com
Cc: bnramesh@yahoo.com, davem@davemloft.net, edumazet@google.com,
        ebiederm@xmission.com, xemul@parallels.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ramesh Nagappa <ramesh.nagappa@ericsson.com>
In-Reply-To: <1349406325-3157-1-git-send-email-ramesh.nagappa@gmail.com>
References: <1349406325-3157-1-git-send-email-ramesh.nagappa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 08:27:25 +0200
Message-ID: <1349418445.21172.11.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 20:05 -0700, ramesh.nagappa@gmail.com wrote:
> From: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
> 
> The retry loop in neigh_resolve_output() and neigh_connected_output()
> call dev_hard_header() with out reseting the skb to network_header.
> This causes the retry to fail with skb_under_panic. The fix is to
> reset the network_header within the retry loop.
> 
> Signed-off-by: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
> Reviewed-by: Shawn Lu <shawn.lu@ericsson.com>
> Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
> Reviewed-by: Billie Alsup <billie.alsup@ericsson.com>
> ---
>  net/core/neighbour.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 117afaf..f50c542 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1313,6 +1313,7 @@ int neigh_resolve_output(struct neighbour *neigh, struct sk_buff *skb)
>  
>  		do {
>  			seq = read_seqbegin(&neigh->ha_lock);
> +			__skb_pull(skb, skb_network_offset(skb));

This __skb_pull() could be done before the read_seqbegin() to keep the
protected section short.

>  			err = dev_hard_header(skb, dev, ntohs(skb->protocol),
>  					      neigh->ha, NULL, skb->len);
>  		} while (read_seqretry(&neigh->ha_lock, seq));
> @@ -1342,10 +1343,9 @@ int neigh_connected_output(struct neighbour *neigh, struct sk_buff *skb)
>  	unsigned int seq;
>  	int err;
>  
> -	__skb_pull(skb, skb_network_offset(skb));
> -
>  	do {
>  		seq = read_seqbegin(&neigh->ha_lock);
> +		__skb_pull(skb, skb_network_offset(skb));

This __skb_pull() could be done before the read_seqbegin() to keep the
protected section short.

>  		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
>  				      neigh->ha, NULL, skb->len);
>  	} while (read_seqretry(&neigh->ha_lock, seq));

Thanks


