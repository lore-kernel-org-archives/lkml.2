Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694Ab0JGBbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:31:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43063 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612Ab0JGBbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:31:09 -0400
Date: Thu, 7 Oct 2010 12:31:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20101007123104.bf7a9808.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/caif/caif_socket.c between commit
79315068f4560f3f7bd6e9790190dcb43059770c ("caif: fix two caif_connect()
bugs") from the net-current tree and commit
b31fa5bad576cd8180a5ad70c648333b44320d44 ("net/caif: Use pr_fmt") from
the net tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/caif/caif_socket.c
index 4bf28f2,abcba53..0000000
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@@ -897,23 -888,14 +889,22 @@@ static int caif_connect(struct socket *
  		cf_sk->sk.sk_state = CAIF_DISCONNECTED;
  		goto out;
  	}
 -	dev = dev_get_by_index(sock_net(sk), ifindex);
 +
 +	err = -ENODEV;
 +	rcu_read_lock();
 +	dev = dev_get_by_index_rcu(sock_net(sk), ifindex);
 +	if (!dev) {
 +		rcu_read_unlock();
 +		goto out;
 +	}
  	cf_sk->headroom = LL_RESERVED_SPACE_EXTRA(dev, headroom);
 +	mtu = dev->mtu;
 +	rcu_read_unlock();
 +
  	cf_sk->tailroom = tailroom;
 -	cf_sk->maxframe = dev->mtu - (headroom + tailroom);
 -	dev_put(dev);
 +	cf_sk->maxframe = mtu - (headroom + tailroom);
  	if (cf_sk->maxframe < 1) {
- 		pr_warning("CAIF: %s(): CAIF Interface MTU too small (%u)\n",
- 			   __func__, mtu);
 -		pr_warn("CAIF Interface MTU too small (%d)\n", dev->mtu);
 -		err = -ENODEV;
++		pr_warn("CAIF Interface MTU too small (%d)\n", mtu);
  		goto out;
  	}
  
