Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033431Ab2I1WA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:00:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031161Ab2I1UVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:21:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 004/218] net_sched: gact: Fix potential panic in tcf_gact().
Date: Fri, 28 Sep 2012 13:13:41 -0700
Message-Id: <20120928201501.765871996@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_gact.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -67,6 +67,9 @@ static int tcf_gact_init(struct nlattr *
 	struct tcf_common *pc;
 	int ret = 0;
 	int err;
+#ifdef CONFIG_GACT_PROB
+	struct tc_gact_p *p_parm = NULL;
+#endif
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -82,6 +85,12 @@ static int tcf_gact_init(struct nlattr *
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
@@ -103,8 +112,7 @@ static int tcf_gact_init(struct nlattr *
 	spin_lock_bh(&gact->tcf_lock);
 	gact->tcf_action = parm->action;
 #ifdef CONFIG_GACT_PROB
-	if (tb[TCA_GACT_PROB] != NULL) {
-		struct tc_gact_p *p_parm = nla_data(tb[TCA_GACT_PROB]);
+	if (p_parm) {
 		gact->tcfg_paction = p_parm->paction;
 		gact->tcfg_pval    = p_parm->pval;
 		gact->tcfg_ptype   = p_parm->ptype;
@@ -133,7 +141,7 @@ static int tcf_gact(struct sk_buff *skb,
 
 	spin_lock(&gact->tcf_lock);
 #ifdef CONFIG_GACT_PROB
-	if (gact->tcfg_ptype && gact_rand[gact->tcfg_ptype] != NULL)
+	if (gact->tcfg_ptype)
 		action = gact_rand[gact->tcfg_ptype](gact);
 	else
 		action = gact->tcf_action;


