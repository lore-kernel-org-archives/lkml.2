Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0LHAsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:00 -0500
Received: from kroah.org ([198.145.64.141]:58560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab0LHArz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:55 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:33 2010
Message-Id: <20101208004433.592679317@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>, "David S. Miller" <davem@davemloft.net>
Subject: [093/127] net sched: fix kernel leak in act_police
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/act_police.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -340,22 +340,19 @@ tcf_act_police_dump(struct sk_buff *skb,
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_police *police = a->priv;
-	struct tc_police opt;
+	struct tc_police opt = {
+		.index = police->tcf_index,
+		.action = police->tcf_action,
+		.mtu = police->tcfp_mtu,
+		.burst = police->tcfp_burst,
+		.refcnt = police->tcf_refcnt - ref,
+		.bindcnt = police->tcf_bindcnt - bind,
+	};
 
-	opt.index = police->tcf_index;
-	opt.action = police->tcf_action;
-	opt.mtu = police->tcfp_mtu;
-	opt.burst = police->tcfp_burst;
-	opt.refcnt = police->tcf_refcnt - ref;
-	opt.bindcnt = police->tcf_bindcnt - bind;
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


