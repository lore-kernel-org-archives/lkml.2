Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1AFA5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:57:22 -0500
Received: from kroah.org ([198.145.64.141]:35566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1AFA3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:24 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002300.033149124@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Octavian Purdila <opurdila@ixiacom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [036/152] llc: fix a device refcount imbalance
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Octavian Purdila <opurdila@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/llc/af_llc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
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


