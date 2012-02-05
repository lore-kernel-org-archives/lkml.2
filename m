Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2BEW0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:42 -0500
Received: from 1wt.eu ([62.212.114.60]:61969 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2BEW0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:33 -0500
Message-Id: <20120205220951.673569857@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 52/91] net_sched: Fix qdisc_notify()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
 1 files changed, 7 insertions(+), 7 deletions(-)

Index: longterm-2.6.27/net/sched/sch_api.c
===================================================================
--- longterm-2.6.27.orig/net/sched/sch_api.c	2012-02-05 22:34:33.439915080 +0100
+++ longterm-2.6.27/net/sched/sch_api.c	2012-02-05 22:34:42.275915891 +0100
@@ -1193,6 +1193,11 @@
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
@@ -1203,11 +1208,11 @@
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
@@ -1220,11 +1225,6 @@
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


