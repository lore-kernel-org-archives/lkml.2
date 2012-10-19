Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2JSCre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:51468 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab2JSCrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oliver Smith <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 35/62] netfilter: nf_conntrack: fix racy timer handling with reliable events
Date: Thu, 18 Oct 2012 19:45:03 -0700
Message-Id: <20121019024301.660559712@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 5b423f6a40a0327f9d40bc8b97ce9be266f74368 upstream.

Existing code assumes that del_timer returns true for alive conntrack
entries. However, this is not true if reliable events are enabled.
In that case, del_timer may return true for entries that were
just inserted in the dying list. Note that packets / ctnetlink may
hold references to conntrack entries that were just inserted to such
list.

This patch fixes the issue by adding an independent timer for
event delivery. This increases the size of the ecache extension.
Still we can revisit this later and use variable size extensions
to allocate this area on demand.

Tested-by: Oliver Smith <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_conntrack_ecache.h |    1 +
 net/netfilter/nf_conntrack_core.c           |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,6 +18,7 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 pid;		/* netlink pid of destroyer */
+	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -249,12 +249,15 @@ static void death_by_event(unsigned long
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
 		/* bad luck, let's retry again */
-		ct->timeout.expires = jiffies +
+		ecache->timeout.expires = jiffies +
 			(random32() % net->ct.sysctl_events_retry_timeout);
-		add_timer(&ct->timeout);
+		add_timer(&ecache->timeout);
 		return;
 	}
 	/* we've got the event delivered, now it's dying */
@@ -268,6 +271,9 @@ static void death_by_event(unsigned long
 void nf_ct_insert_dying_list(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	/* add this conntrack to the dying list */
 	spin_lock_bh(&nf_conntrack_lock);
@@ -275,10 +281,10 @@ void nf_ct_insert_dying_list(struct nf_c
 			     &net->ct.dying);
 	spin_unlock_bh(&nf_conntrack_lock);
 	/* set a new timer to retry event delivery */
-	setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
-	ct->timeout.expires = jiffies +
+	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
+	ecache->timeout.expires = jiffies +
 		(random32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ct->timeout);
+	add_timer(&ecache->timeout);
 }
 EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
 


