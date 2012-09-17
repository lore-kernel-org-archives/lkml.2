Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2IQAve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33843 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754480Ab2IQAvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:16 -0400
Message-Id: <20120917003633.325679064@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 051/135] net_sched: gact: Fix potential panic in tcf_gact().
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

[ Upstream commit 696ecdc10622d86541f2e35cc16e15b6b3b1b67e ]

gact_rand array is accessed by gact->tcfg_ptype whose value
is assumed to less than MAX_RAND, but any range checks are
not performed.

So add a check in tcf_gact_init(). And in tcf_gact(), we can
reduce a branch.

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/act_gact.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index b77f5a0..bdacd8d 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -67,6 +67,9 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 	struct tcf_common *pc;
 	int ret = 0;
 	int err;
+#ifdef CONFIG_GACT_PROB
+	struct tc_gact_p *p_parm = NULL;
+#endif
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -82,6 +85,12 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 #ifndef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] != NULL)
 		return -EOPNOTSUPP;
+#else
+	if (tb[TCA_GACT_PROB]) {
+		p_parm = nla_data(tb[TCA_GACT_PROB]);
+		if (p_parm->ptype >= MAX_RAND)
+			return -EINVAL;
+	}
 #endif
 
 	pc = tcf_hash_check(parm->index, a, bind, &gact_hash_info);
@@ -103,8 +112,7 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 	spin_lock_bh(&gact->tcf_lock);
 	gact->tcf_action = parm->action;
 #ifdef CONFIG_GACT_PROB
-	if (tb[TCA_GACT_PROB] != NULL) {
-		struct tc_gact_p *p_parm = nla_data(tb[TCA_GACT_PROB]);
+	if (p_parm) {
 		gact->tcfg_paction = p_parm->paction;
 		gact->tcfg_pval    = p_parm->pval;
 		gact->tcfg_ptype   = p_parm->ptype;
@@ -133,7 +141,7 @@ static int tcf_gact(struct sk_buff *skb, const struct tc_action *a,
 
 	spin_lock(&gact->tcf_lock);
 #ifdef CONFIG_GACT_PROB
-	if (gact->tcfg_ptype && gact_rand[gact->tcfg_ptype] != NULL)
+	if (gact->tcfg_ptype)
 		action = gact_rand[gact->tcfg_ptype](gact);
 	else
 		action = gact->tcf_action;


