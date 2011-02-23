Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1BWPa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1BWPa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:30:57 -0500
Date: Wed, 23 Feb 2011 10:30:41 -0500
From: Neil Horman <nhorman@redhat.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [V4 PATCH 3/3] bond: service netpoll arp queue on master device
Message-ID: <20110223153041.GE11496@hmsreliant.think-freely.org>
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>
 <1298022215-21059-3-git-send-email-amwang@redhat.com>
 <4D6526BD.6030306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D6526BD.6030306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:24:45PM +0800, Cong Wang wrote:
> Neil, ping. :)
> 
> 于 2011年02月18日 17:43, Amerigo Wang 写道:
> >Neil pointed out that we can't send ARP reply on behalf of slaves,
> >we need to move the arp queue to their bond device.
> >
> >Signed-off-by: WANG Cong<amwang@redhat.com>
> >Cc: Neil Horman<nhorman@redhat.com>
> >
> >---
> >  net/core/netpoll.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >
> >diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> >index f68e694..013e04a 100644
> >--- a/net/core/netpoll.c
> >+++ b/net/core/netpoll.c
> >@@ -193,6 +193,15 @@ void netpoll_poll_dev(struct net_device *dev)
> >
> >  	poll_napi(dev);
> >
> >+	if (dev->priv_flags&  IFF_SLAVE) {
> >+		if (dev->npinfo) {
> >+			struct net_device *bond_dev = dev->master;
> >+			struct sk_buff *skb;
> >+			while ((skb = skb_dequeue(&dev->npinfo->arp_tx)))
> >+				skb_queue_tail(&bond_dev->npinfo->arp_tx, skb);
> >+		}
> >+	}
> >+
> >  	service_arp_queue(dev->npinfo);
> >
> >  	zap_completion_queue();
> 
> 
> -- 
> 我认识的人越多，我就越喜欢狗。

seems reasonable, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

