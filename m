Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037Ab1KCBnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935005Ab1KCBnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:43:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:49 2011
Message-Id: <20111102222749.004933598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [101/101] net_sched: Fix qdisc_notify()
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 53b0f08042f04813cd1a7473dacd3edfacb28eb3 upstream.

Ben Pfaff reported a kernel oops and provided a test program to
reproduce it.

https://kerneltrap.org/mailarchive/linux-netdev/2010/5/21/6277805

tc_fill_qdisc() should not be called for builtin qdisc, or it
dereference a NULL pointer to get device ifindex.

Fix is to always use tc_qdisc_dump_ignore() before calling
tc_fill_qdisc().

Reported-by: Ben Pfaff <blp@nicira.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_api.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1195,6 +1195,11 @@ nla_put_failure:
 	return -1;
 }
 
+static bool tc_qdisc_dump_ignore(struct Qdisc *q)
+{
+	return (q->flags & TCQ_F_BUILTIN) ? true : false;
+}
+
 static int qdisc_notify(struct sk_buff *oskb, struct nlmsghdr *n,
 			u32 clid, struct Qdisc *old, struct Qdisc *new)
 {
@@ -1205,11 +1210,11 @@ static int qdisc_notify(struct sk_buff *
 	if (!skb)
 		return -ENOBUFS;
 
-	if (old && old->handle) {
+	if (old && !tc_qdisc_dump_ignore(old)) {
 		if (tc_fill_qdisc(skb, old, clid, pid, n->nlmsg_seq, 0, RTM_DELQDISC) < 0)
 			goto err_out;
 	}
-	if (new) {
+	if (new && !tc_qdisc_dump_ignore(new)) {
 		if (tc_fill_qdisc(skb, new, clid, pid, n->nlmsg_seq, old ? NLM_F_REPLACE : 0, RTM_NEWQDISC) < 0)
 			goto err_out;
 	}
@@ -1222,11 +1227,6 @@ err_out:
 	return -EINVAL;
 }
 
-static bool tc_qdisc_dump_ignore(struct Qdisc *q)
-{
-	return (q->flags & TCQ_F_BUILTIN) ? true : false;
-}
-
 static int tc_dump_qdisc_root(struct Qdisc *root, struct sk_buff *skb,
 			      struct netlink_callback *cb,
 			      int *q_idx_p, int s_q_idx)


