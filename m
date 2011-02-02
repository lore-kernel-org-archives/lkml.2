Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1BBBHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:07:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:36336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1BBAnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028321"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: eric.dumazet@gmail.com, ak@linux.intel.com, opurdila@ixiacom.com,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [31/139] llc: fix a device refcount imbalance
Message-Id: <20110202004346.444503E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit 35d9b0c906ad92d32a0b8db5daa6fabfcc2f068d upstream.

Le dimanche 05 décembre 2010 à 12:23 +0100, Eric Dumazet a écrit :
> Le dimanche 05 décembre 2010 à 09:19 +0100, Eric Dumazet a écrit :
>
> > Hmm..
> >
> > If somebody can explain why RTNL is held in arp_ioctl() (and therefore
> > in arp_req_delete()), we might first remove RTNL use in arp_ioctl() so
> > that your patch can be applied.
> >
> > Right now it is not good, because RTNL wont be necessarly held when you
> > are going to call arp_invalidate() ?
>
> While doing this analysis, I found a refcount bug in llc, I'll send a
> patch for net-2.6

Oh well, of course I must first fix the bug in net-2.6, and wait David
pull the fix in net-next-2.6 before sending this rcu conversion.

Note: this patch should be sent to stable teams (2.6.34 and up)

[PATCH net-2.6] llc: fix a device refcount imbalance

commit abf9d537fea225 (llc: add support for SO_BINDTODEVICE) added one
refcount imbalance in llc_ui_bind(), because dev_getbyhwaddr() doesnt
take a reference on device, while dev_get_by_index() does.

Fix this using RCU locking. And since an RCU conversion will be done for
2.6.38 for dev_getbyhwaddr(), put the rcu_read_lock/unlock exactly at
their final place.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Octavian Purdila <opurdila@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/llc/af_llc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/net/llc/af_llc.c
===================================================================
--- linux-2.6.35.y.orig/net/llc/af_llc.c
+++ linux-2.6.35.y/net/llc/af_llc.c
@@ -317,8 +317,9 @@ static int llc_ui_bind(struct socket *so
 		goto out;
 	rc = -ENODEV;
 	rtnl_lock();
+	rcu_read_lock();
 	if (sk->sk_bound_dev_if) {
-		llc->dev = dev_get_by_index(&init_net, sk->sk_bound_dev_if);
+		llc->dev = dev_get_by_index_rcu(&init_net, sk->sk_bound_dev_if);
 		if (llc->dev) {
 			if (!addr->sllc_arphrd)
 				addr->sllc_arphrd = llc->dev->type;
@@ -329,13 +330,13 @@ static int llc_ui_bind(struct socket *so
 			    !llc_mac_match(addr->sllc_mac,
 					   llc->dev->dev_addr)) {
 				rc = -EINVAL;
-				dev_put(llc->dev);
 				llc->dev = NULL;
 			}
 		}
 	} else
 		llc->dev = dev_getbyhwaddr(&init_net, addr->sllc_arphrd,
 					   addr->sllc_mac);
+	rcu_read_unlock();
 	rtnl_unlock();
 	if (!llc->dev)
 		goto out;
