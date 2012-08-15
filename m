Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HOTst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:48:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62712 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2HOTsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 001/165] net_sched: Fix qdisc_notify()
Date: Wed, 15 Aug 2012 15:45:45 -0400
Message-ID: <1345060109-9187-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/sch_api.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 145268c..df1dbf5 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1196,6 +1196,11 @@ nla_put_failure:
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
@@ -1206,11 +1211,11 @@ static int qdisc_notify(struct sk_buff *oskb, struct nlmsghdr *n,
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
@@ -1223,11 +1228,6 @@ err_out:
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
-- 
1.7.12.rc2

