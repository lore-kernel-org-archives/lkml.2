Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab1DNSTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:19:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:41516 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688Ab1DNR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Changli Gao <xiaosuo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 129/209] act_nat: use stack variable
Date: Thu, 14 Apr 2011 13:54:47 -0400
Message-Id: <1302803767-9715-16-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Changli Gao <xiaosuo@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 504f85c9d05f7c605306e808f0d835fe11bfd18d upstream.

act_nat: use stack variable

structure tc_nat isn't too big for stack, so we can put it in stack.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/act_nat.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 37e198c..3e593a8 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -261,40 +261,29 @@ static int tcf_nat_dump(struct sk_buff *skb, struct tc_action *a,
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_nat *p = a->priv;
-	struct tc_nat *opt;
+	struct tc_nat opt;
 	struct tcf_t t;
-	int s;
 
-	s = sizeof(*opt);
+	opt.old_addr = p->old_addr;
+	opt.new_addr = p->new_addr;
+	opt.mask = p->mask;
+	opt.flags = p->flags;
 
-	/* netlink spinlocks held above us - must use ATOMIC */
-	opt = kzalloc(s, GFP_ATOMIC);
-	if (unlikely(!opt))
-		return -ENOBUFS;
+	opt.index = p->tcf_index;
+	opt.action = p->tcf_action;
+	opt.refcnt = p->tcf_refcnt - ref;
+	opt.bindcnt = p->tcf_bindcnt - bind;
 
-	opt->old_addr = p->old_addr;
-	opt->new_addr = p->new_addr;
-	opt->mask = p->mask;
-	opt->flags = p->flags;
-
-	opt->index = p->tcf_index;
-	opt->action = p->tcf_action;
-	opt->refcnt = p->tcf_refcnt - ref;
-	opt->bindcnt = p->tcf_bindcnt - bind;
-
-	NLA_PUT(skb, TCA_NAT_PARMS, s, opt);
+	NLA_PUT(skb, TCA_NAT_PARMS, sizeof(opt), &opt);
 	t.install = jiffies_to_clock_t(jiffies - p->tcf_tm.install);
 	t.lastuse = jiffies_to_clock_t(jiffies - p->tcf_tm.lastuse);
 	t.expires = jiffies_to_clock_t(p->tcf_tm.expires);
 	NLA_PUT(skb, TCA_NAT_TM, sizeof(t), &t);
 
-	kfree(opt);
-
 	return skb->len;
 
 nla_put_failure:
 	nlmsg_trim(skb, b);
-	kfree(opt);
 	return -1;
 }
 
-- 
1.7.4.4

