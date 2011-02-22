Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1BVWWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:22 -0500
Received: from kroah.org ([198.145.64.141]:32942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1BVWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.225850338@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [52/70] netfilter: fix race in conntrack between dump_table and destroy
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@vyatta.com>

commit 13ee6ac579574a2a95e982b19920fd2495dce8cd upstream.

The netlink interface to dump the connection tracking table has a race
when entries are deleted at the same time. A customer reported a crash
and the backtrace showed thatctnetlink_dump_table was running while a
conntrack entry was being destroyed.
(see https://bugzilla.vyatta.com/show_bug.cgi?id=6402).

According to RCU documentation, when using hlist_nulls the reader
must handle the case of seeing a deleted entry and not proceed
further down the linked list.  The old code would continue
which caused the scan to walk into the free list.

This patch uses locking (rather than RCU) for this operation which
is guaranteed safe, and no longer requires getting reference while
doing dump operation.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_netlink.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -642,25 +642,23 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
-	rcu_read_lock();
+	spin_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < net->ct.htable_size; cb->args[0]++) {
 restart:
-		hlist_nulls_for_each_entry_rcu(h, n, &net->ct.hash[cb->args[0]],
+		hlist_nulls_for_each_entry(h, n, &net->ct.hash[cb->args[0]],
 					 hnnode) {
 			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
-			if (!atomic_inc_not_zero(&ct->ct_general.use))
-				continue;
 			/* Dump entries of a given L3 protocol number.
 			 * If it is not specified, ie. l3proto == 0,
 			 * then dump everything. */
 			if (l3proto && nf_ct_l3num(ct) != l3proto)
-				goto releasect;
+				continue;
 			if (cb->args[1]) {
 				if (ct != last)
-					goto releasect;
+					continue;
 				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -678,8 +676,6 @@ restart:
 				if (acct)
 					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
 			}
-releasect:
-		nf_ct_put(ct);
 		}
 		if (cb->args[1]) {
 			cb->args[1] = 0;
@@ -687,7 +683,7 @@ releasect:
 		}
 	}
 out:
-	rcu_read_unlock();
+	spin_unlock_bh(&nf_conntrack_lock);
 	if (last)
 		nf_ct_put(last);
 


