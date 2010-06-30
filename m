Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0F3I5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:57:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62896 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab0F3I5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PK5iPhO550tSNzm9TsZ42xblPd5capwmnXG485BBxAFNaFABvuqE64acZOsUdezCy9
         PetCAb+gH/igoK6j5NHzGS02/Jrp1F8ARfwFvAMK7pDQyicc2DssbWoQ7ZJfzuKRjwx4
         YD9efoSd/DoZHFlJ3SR3ujQ2JSdk4+P/v4Ug4=
From: Changli Gao <xiaosuo@gmail.com>
To: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] act_mirred: combine duplicate code
Date: Wed, 30 Jun 2010 16:54:58 +0800
Message-Id: <1277888098-27632-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

act_mirred: combine duplicate code

tcf_bstats is updated in any way, so we can do it earlier to reduce the size of
the code.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/sched/act_mirred.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 2e9a7b9..a16b017 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -160,6 +160,8 @@ static int tcf_mirred(struct sk_buff *skb, struct tc_action *a,
 
 	spin_lock(&m->tcf_lock);
 	m->tcf_tm.lastuse = jiffies;
+	m->tcf_bstats.bytes += qdisc_pkt_len(skb);
+	m->tcf_bstats.packets++;
 
 	dev = m->tcfm_dev;
 	if (!(dev->flags & IFF_UP)) {
@@ -174,8 +176,6 @@ static int tcf_mirred(struct sk_buff *skb, struct tc_action *a,
 	if (skb2 == NULL)
 		goto out;
 
-	m->tcf_bstats.bytes += qdisc_pkt_len(skb2);
-	m->tcf_bstats.packets++;
 	if (!(at & AT_EGRESS)) {
 		if (m->tcfm_ok_push)
 			skb_push(skb2, skb2->dev->hard_header_len);
@@ -193,8 +193,6 @@ static int tcf_mirred(struct sk_buff *skb, struct tc_action *a,
 out:
 	if (err) {
 		m->tcf_qstats.overlimits++;
-		m->tcf_bstats.bytes += qdisc_pkt_len(skb);
-		m->tcf_bstats.packets++;
 		/* should we be asking for packet to be dropped?
 		 * may make sense for redirect case only
 		 */
