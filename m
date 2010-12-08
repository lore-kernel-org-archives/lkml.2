Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0LHAth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:49:37 -0500
Received: from kroah.org ([198.145.64.141]:58748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab0LHAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:23 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.522362421@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>, dann frazier <dannf@debian.org>
Subject: [122/127] act_nat: use stack variable
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

commit 504f85c9d05f7c605306e808f0d835fe11bfd18d upstream.

act_nat: use stack variable

structure tc_nat isn't too big for stack, so we can put it in stack.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/act_nat.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -261,40 +261,29 @@ static int tcf_nat_dump(struct sk_buff *
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
+
+	opt.index = p->tcf_index;
+	opt.action = p->tcf_action;
+	opt.refcnt = p->tcf_refcnt - ref;
+	opt.bindcnt = p->tcf_bindcnt - bind;
 
-	/* netlink spinlocks held above us - must use ATOMIC */
-	opt = kzalloc(s, GFP_ATOMIC);
-	if (unlikely(!opt))
-		return -ENOBUFS;
-
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
 


