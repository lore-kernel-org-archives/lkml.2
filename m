Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab0ELC0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:26:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37027 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0ELC0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:26:23 -0400
Date: Wed, 12 May 2010 12:26:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andreas Meissner <andreas.meissner@sphairon.com>,
       Patrick McHardy <kaber@trash.net>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100512122619.be64cea0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/ipv4/ipmr.c between commit bbd725435ddb1cac732f7a8c23c21ff67f24c60f
("IPv4: unresolved multicast route cleanup") from Linus' tree and commits
e258beb22f4d3ea3dc88586ffc9c990d0eb03380 ("ipv4: ipmr: move unres_queue
and timer to per-namespace data") and
0c12295a741d3186987f96f518cfbdaf01abb087 ("ipv4: ipmr: move mroute data
into seperate structure") from the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/ipv4/ipmr.c
index ec19a89,f3f1c6b..0000000
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@@ -750,12 -995,10 +995,11 @@@ ipmr_cache_unresolved(struct mr_table *
  			return err;
  		}
  
- 		atomic_inc(&net->ipv4.cache_resolve_queue_len);
- 		c->next = mfc_unres_queue;
- 		mfc_unres_queue = c;
+ 		atomic_inc(&mrt->cache_resolve_queue_len);
+ 		list_add(&c->list, &mrt->mfc_unres_queue);
  
 -		mod_timer(&mrt->ipmr_expire_timer, c->mfc_un.unres.expires);
 +		if (atomic_read(&net->ipv4.cache_resolve_queue_len) == 1)
- 			mod_timer(&ipmr_expire_timer, c->mfc_un.unres.expires);
++			mod_timer(&mrt->ipmr_expire_timer, c->mfc_un.unres.expires);
  	}
  
  	/*
