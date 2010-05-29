Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0E2KnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 06:43:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62016 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab0E2KnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 06:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D6/8sTkfTzla5/8p62ncY8ePPgQ0Q10PO85jMfoj+e1NirKYkiXiQCTqnbzxwW7OYR
         fJNj0yvpZxb6KYpSoGqgB/Nh4un+w/YJ5cPTQdTlvZyj+Kob+D2M0FjRkHSzC8uVWcOI
         a+16FSC/VFvsYaV0w5GjmfmxlZo1DeNPBgRbs=
From: Changli Gao <xiaosuo@gmail.com>
To: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] act_nat: fix the wrong checksum when addr isn't in old_addr/mask
Date: Sat, 29 May 2010 18:41:51 +0800
Message-Id: <1275129711-21486-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the wrong checksum when addr isn't in old_addr/mask

When addr isn't in old_addr/mask we don't do SNAT or DNAT, and we should not
update the checksum too.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/sched/act_nat.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index d885ba3..f9b12a9 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -142,24 +142,25 @@ static int tcf_nat(struct sk_buff *skb, struct tc_action *a,
 	else
 		addr = iph->daddr;
 
-	if (!((old_addr ^ addr) & mask)) {
-		if (skb_cloned(skb) &&
-		    !skb_clone_writable(skb, sizeof(*iph)) &&
-		    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
-			goto drop;
+	if ((old_addr ^ addr) & mask)
+		goto out;
 
-		new_addr &= mask;
-		new_addr |= addr & ~mask;
+	if (skb_cloned(skb) &&
+	    !skb_clone_writable(skb, sizeof(*iph)) &&
+	    pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
+		goto drop;
 
-		/* Rewrite IP header */
-		iph = ip_hdr(skb);
-		if (egress)
-			iph->saddr = new_addr;
-		else
-			iph->daddr = new_addr;
+	new_addr &= mask;
+	new_addr |= addr & ~mask;
 
-		csum_replace4(&iph->check, addr, new_addr);
-	}
+	/* Rewrite IP header */
+	iph = ip_hdr(skb);
+	if (egress)
+		iph->saddr = new_addr;
+	else
+		iph->daddr = new_addr;
+
+	csum_replace4(&iph->check, addr, new_addr);
 
 	ihl = iph->ihl * 4;
 
@@ -247,6 +248,7 @@ static int tcf_nat(struct sk_buff *skb, struct tc_action *a,
 		break;
 	}
 
+out:
 	return action;
 
 drop:
