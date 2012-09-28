Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031567Ab2I1ULB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:11:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab2I1Sx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:53:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 005/262] net_sched: gact: Fix potential panic in tcf_gact().
Date: Fri, 28 Sep 2012 11:48:54 -0700
Message-Id: <20120928182958.617442351@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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


