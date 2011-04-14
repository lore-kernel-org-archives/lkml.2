Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab1DNRwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:52:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:38545 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428Ab1DNRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Mahoney <jeffm@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 101/209] net sched: fix kernel leak in act_police
Date: Thu, 14 Apr 2011 13:42:11 -0400
Message-Id: <1302803039-9400-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 0f04cfd098fb81fded74e78ea1a1b86cc6c6c31e upstream.

While reviewing commit 1c40be12f7d8ca1d387510d39787b12e512a7ce8, I
 audited other users of tc_action_ops->dump for information leaks.

 That commit covered almost all of them but act_police still had a leak.

 opt.limit and opt.capab aren't zeroed out before the structure is
 passed out.

 This patch uses the C99 initializers to zero everything unused out.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/act_police.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 654f73d..bf93162 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -341,22 +341,19 @@ tcf_act_police_dump(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_police *police = a->priv;
-	struct tc_police opt;
-
-	opt.index = police->tcf_index;
-	opt.action = police->tcf_action;
-	opt.mtu = police->tcfp_mtu;
-	opt.burst = police->tcfp_burst;
-	opt.refcnt = police->tcf_refcnt - ref;
-	opt.bindcnt = police->tcf_bindcnt - bind;
+	struct tc_police opt = {
+		.index = police->tcf_index,
+		.action = police->tcf_action,
+		.mtu = police->tcfp_mtu,
+		.burst = police->tcfp_burst,
+		.refcnt = police->tcf_refcnt - ref,
+		.bindcnt = police->tcf_bindcnt - bind,
+	};
+
 	if (police->tcfp_R_tab)
 		opt.rate = police->tcfp_R_tab->rate;
-	else
-		memset(&opt.rate, 0, sizeof(opt.rate));
 	if (police->tcfp_P_tab)
 		opt.peakrate = police->tcfp_P_tab->rate;
-	else
-		memset(&opt.peakrate, 0, sizeof(opt.peakrate));
 	NLA_PUT(skb, TCA_POLICE_TBF, sizeof(opt), &opt);
 	if (police->tcfp_result)
 		NLA_PUT_U32(skb, TCA_POLICE_RESULT, police->tcfp_result);
-- 
1.7.4.4

