Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1CMVLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 17:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab1CMVLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 17:11:47 -0400
Date: Sun, 13 Mar 2011 23:11:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.osdl.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
Message-ID: <20110313211129.GA10235@redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20110313150646.GA30494@redhat.com>
 <1300031570.2761.22.camel@edumazet-laptop>
 <20110313161915.GB30642@redhat.com>
 <1300033927.2761.26.camel@edumazet-laptop>
 <20110313164359.GA32562@redhat.com>
 <1300038092.2761.41.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300038092.2761.41.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 06:41:32PM +0100, Eric Dumazet wrote:
> Le dimanche 13 mars 2011 à 18:43 +0200, Michael S. Tsirkin a écrit :
> > On Sun, Mar 13, 2011 at 05:32:07PM +0100, Eric Dumazet wrote:
> > > Le dimanche 13 mars 2011 à 18:19 +0200, Michael S. Tsirkin a écrit :
> > > 
> > > > Other side is in drivers/net/tun.c and net/packet/af_packet.c
> > > > At least wrt tun it seems clear socket is not locked.
> > > 
> > > Yes (assuming you refer to tun_net_xmit())
> > > 
> > > > Besides queue, dequeue seems to be done without socket locked.
> > > > 
> > > 
> > > It seems this code (assuming you speak of drivers/vhost/net.c ?) has
> > > some races indeed.
> > > 
> > 
> > Hmm. Any more besides the one fixed here?
> > 
> 
> If writers and readers dont share a common lock, how can they reliably
> synchronize states ?

They are all supposed to use sk_receive_queue.lock I think.

> For example, the check at line 420 seems unsafe or useless.
> 
> skb_queue_empty(&sock->sk->sk_receive_queue)
> 

It's mostly useless: code that is called after this
 does skb_peek and checks the result under the spinlock.
This was supposed to be an optimization: quickly check
that queue is not empty before we bother disabling notifications
etc, but I dont' remember at this point whether it actually gives any gain.
Thanks for pointing this out, I'll take it out I think (below).
Note: there are two places of this call in upstream: handle_rx_bug and
handle_rx_mergeable, but they are merged into a single
handle_rx by a patch by Jason Wang.
The below patch is on top.
If you like to look at the latest code,
it's here master.kernel.org:/home/mst/pub/vhost.git
branch vhost-net-next has it all.

Eric, thanks very much for pointing out these.
Is there anything else that you see in this driver?


Thanks!


    vhost-net: remove unlocked use of receive_queue
    
    Use of skb_queue_empty(&sock->sk->sk_receive_queue)
    without taking the sk_receive_queue.lock is unsafe
    or useless. Take it out.
    
    Reported-by:  Eric Dumazet <eric.dumazet@gmail.com>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 5720301..2f7c76a 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -311,7 +311,7 @@ static void handle_rx(struct vhost_net *net)
 	/* TODO: check that we are running from vhost_worker? */
 	struct socket *sock = rcu_dereference_check(vq->private_data, 1);
 
-	if (!sock || skb_queue_empty(&sock->sk->sk_receive_queue))
+	if (!sock)
 		return;
 
 	mutex_lock(&vq->mutex);
