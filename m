Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0DMPhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 11:37:01 -0400
Received: from thoth.sbs.de ([192.35.17.2]:22884 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab0DMPg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 11:36:59 -0400
Message-ID: <4BC48F79.5090409@siemens.com>
Date: Tue, 13 Apr 2010 17:36:25 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] tun: orphan an skb on tx
References: <20100413145944.GA7716@redhat.com>
In-Reply-To: <20100413145944.GA7716@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> The following situation was observed in the field:
> tap1 sends packets, tap2 does not consume them, as a result
> tap1 can not be closed.

And before that, tap1 may not be able to send further packets to anyone
else on the bridge as its TX resources were blocked by tap2 - that's
what we saw in the field.

> This happens because
> tun/tap devices can hang on to skbs undefinitely.
> 
> As noted by Herbert, possible solutions include a timeout followed by a
> copy/change of ownership of the skb, or always copying/changing
> ownership if we're going into a hostile device.
> 
> This patch implements the second approach.
> 
> Note: one issue still remaining is that since skbs
> keep reference to tun socket and tun socket has a
> reference to tun device, we won't flush backlog,
> instead simply waiting for all skbs to get transmitted.
> At least this is not user-triggerable, and
> this was not reported in practice, my assumption is
> other devices besides tap complete an skb
> within finite time after it has been queued.
> 
> A possible solution for the second issue
> would not to have socket reference the device,
> instead, implement dev->destructor for tun, and
> wait for all skbs to complete there, but this
> needs some thought, probably too risky for 2.6.34.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Tested-by: Yan Vugenfirer <yvugenfi@redhat.com>
> 
> ---
> 
> Please review the below, and consider for 2.6.34,
> and stable trees.
> 
>  drivers/net/tun.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 96c39bd..4326520 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -387,6 +387,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  		}
>  	}
>  
> +	/* Orphan the skb - required as we might hang on to it
> +	 * for indefinite time. */
> +	skb_orphan(skb);
> +
>  	/* Enqueue packet */
>  	skb_queue_tail(&tun->socket.sk->sk_receive_queue, skb);
>  	dev->trans_start = jiffies;

Nice solution, thanks!

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
