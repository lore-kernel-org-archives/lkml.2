Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0LHAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:49:12 -0500
Received: from kroah.org ([198.145.64.141]:58756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0LHAsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:24 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:36 2010
Message-Id: <20101208004436.617959977@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:45:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        dann frazier <dannf@debian.org>
Subject: [123/127] net sched: fix some kernel memory leaks
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 1c40be12f7d8ca1d387510d39787b12e512a7ce8 upstream.

We leak at least 32bits of kernel memory to user land in tc dump,
because we dont init all fields (capab ?) of the dumped structure.

Use C99 initializers so that holes and non explicit fields are zeroed.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/act_gact.c    |   21 ++++++++++++---------
 net/sched/act_mirred.c  |   15 ++++++++-------
 net/sched/act_nat.c     |   22 +++++++++++-----------
 net/sched/act_simple.c  |   11 ++++++-----
 net/sched/act_skbedit.c |   11 ++++++-----
 5 files changed, 43 insertions(+), 37 deletions(-)

--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -152,21 +152,24 @@ static int tcf_gact(struct sk_buff *skb,
 static int tcf_gact_dump(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
 	unsigned char *b = skb_tail_pointer(skb);
-	struct tc_gact opt;
 	struct tcf_gact *gact = a->priv;
+	struct tc_gact opt = {
+		.index   = gact->tcf_index,
+		.refcnt  = gact->tcf_refcnt - ref,
+		.bindcnt = gact->tcf_bindcnt - bind,
+		.action  = gact->tcf_action,
+	};
 	struct tcf_t t;
 
-	opt.index = gact->tcf_index;
-	opt.refcnt = gact->tcf_refcnt - ref;
-	opt.bindcnt = gact->tcf_bindcnt - bind;
-	opt.action = gact->tcf_action;
 	NLA_PUT(skb, TCA_GACT_PARMS, sizeof(opt), &opt);
 #ifdef CONFIG_GACT_PROB
 	if (gact->tcfg_ptype) {
-		struct tc_gact_p p_opt;
-		p_opt.paction = gact->tcfg_paction;
-		p_opt.pval = gact->tcfg_pval;
-		p_opt.ptype = gact->tcfg_ptype;
+		struct tc_gact_p p_opt = {
+			.paction = gact->tcfg_paction,
+			.pval    = gact->tcfg_pval,
+			.ptype   = gact->tcfg_ptype,
+		};
+
 		NLA_PUT(skb, TCA_GACT_PROB, sizeof(p_opt), &p_opt);
 	}
 #endif
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -205,15 +205,16 @@ static int tcf_mirred_dump(struct sk_buf
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_mirred *m = a->priv;
-	struct tc_mirred opt;
+	struct tc_mirred opt = {
+		.index   = m->tcf_index,
+		.action  = m->tcf_action,
+		.refcnt  = m->tcf_refcnt - ref,
+		.bindcnt = m->tcf_bindcnt - bind,
+		.eaction = m->tcfm_eaction,
+		.ifindex = m->tcfm_ifindex,
+	};
 	struct tcf_t t;
 
-	opt.index = m->tcf_index;
-	opt.action = m->tcf_action;
-	opt.refcnt = m->tcf_refcnt - ref;
-	opt.bindcnt = m->tcf_bindcnt - bind;
-	opt.eaction = m->tcfm_eaction;
-	opt.ifindex = m->tcfm_ifindex;
 	NLA_PUT(skb, TCA_MIRRED_PARMS, sizeof(opt), &opt);
 	t.install = jiffies_to_clock_t(jiffies - m->tcf_tm.install);
 	t.lastuse = jiffies_to_clock_t(jiffies - m->tcf_tm.lastuse);
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -261,18 +261,18 @@ static int tcf_nat_dump(struct sk_buff *
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_nat *p = a->priv;
-	struct tc_nat opt;
-	struct tcf_t t;
-
-	opt.old_addr = p->old_addr;
-	opt.new_addr = p->new_addr;
-	opt.mask = p->mask;
-	opt.flags = p->flags;
+	struct tc_nat opt = {
+		.old_addr = p->old_addr,
+		.new_addr = p->new_addr,
+		.mask     = p->mask,
+		.flags    = p->flags,
 
-	opt.index = p->tcf_index;
-	opt.action = p->tcf_action;
-	opt.refcnt = p->tcf_refcnt - ref;
-	opt.bindcnt = p->tcf_bindcnt - bind;
+		.index    = p->tcf_index,
+		.action   = p->tcf_action,
+		.refcnt   = p->tcf_refcnt - ref,
+		.bindcnt  = p->tcf_bindcnt - bind,
+	};
+	struct tcf_t t;
 
 	NLA_PUT(skb, TCA_NAT_PARMS, sizeof(opt), &opt);
 	t.install = jiffies_to_clock_t(jiffies - p->tcf_tm.install);
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -163,13 +163,14 @@ static inline int tcf_simp_dump(struct s
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_defact *d = a->priv;
-	struct tc_defact opt;
+	struct tc_defact opt = {
+		.index   = d->tcf_index,
+		.refcnt  = d->tcf_refcnt - ref,
+		.bindcnt = d->tcf_bindcnt - bind,
+		.action  = d->tcf_action,
+	};
 	struct tcf_t t;
 
-	opt.index = d->tcf_index;
-	opt.refcnt = d->tcf_refcnt - ref;
-	opt.bindcnt = d->tcf_bindcnt - bind;
-	opt.action = d->tcf_action;
 	NLA_PUT(skb, TCA_DEF_PARMS, sizeof(opt), &opt);
 	NLA_PUT_STRING(skb, TCA_DEF_DATA, d->tcfd_defdata);
 	t.install = jiffies_to_clock_t(jiffies - d->tcf_tm.install);
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -147,13 +147,14 @@ static inline int tcf_skbedit_dump(struc
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_skbedit *d = a->priv;
-	struct tc_skbedit opt;
+	struct tc_skbedit opt = {
+		.index   = d->tcf_index,
+		.refcnt  = d->tcf_refcnt - ref,
+		.bindcnt = d->tcf_bindcnt - bind,
+		.action  = d->tcf_action,
+	};
 	struct tcf_t t;
 
-	opt.index = d->tcf_index;
-	opt.refcnt = d->tcf_refcnt - ref;
-	opt.bindcnt = d->tcf_bindcnt - bind;
-	opt.action = d->tcf_action;
 	NLA_PUT(skb, TCA_SKBEDIT_PARMS, sizeof(opt), &opt);
 	if (d->flags & SKBEDIT_F_PRIORITY)
 		NLA_PUT(skb, TCA_SKBEDIT_PRIORITY, sizeof(d->priority),


