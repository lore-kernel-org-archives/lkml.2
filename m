Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab0E3A15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 20:27:57 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50969 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0E3A1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 20:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s8D8kn9AfBZGtee2qUaG+XoaFFh5oYn3mCMhy8It2a8eWvPWaRi56HzYl1lJ2Jha1Q
         dfPkQW5eWZPSMU1CSh+Lk0EmMFfgmD2XnzfR5ysxI6Kjh5bHlziBR0bn0i8p4QynUMVx
         IZO1oS4ki8uRMbpg41oJhE2LSEhKi6DySp2w8=
From: Changli Gao <xiaosuo@gmail.com>
To: Jamal Hadi Salim <hadi@cyberus.ca>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] act_nat: fix the wrong checksum when addr isn't in old_addr/mask
Date: Sun, 30 May 2010 08:26:59 +0800
Message-Id: <1275179219-10424-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the wrong checksum when addr isn't in old_addr/mask

For TCP and UDP packets, when addr isn't in old_addr/mask we don't do SNAT or
DNAT, and we should not update layer 4 checksum.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 net/sched/act_nat.c |    4 ++++
 1 file changed, 4 insertions(+)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index d885ba3..5709494 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -159,6 +159,9 @@ static int tcf_nat(struct sk_buff *skb, struct tc_action *a,
 			iph->daddr = new_addr;
 
 		csum_replace4(&iph->check, addr, new_addr);
+	} else if ((iph->frag_off & htons(IP_OFFSET)) ||
+		   iph->protocol != IPPROTO_ICMP) {
+		goto out;
 	}
 
 	ihl = iph->ihl * 4;
@@ -247,6 +250,7 @@ static int tcf_nat(struct sk_buff *skb, struct tc_action *a,
 		break;
 	}
 
+out:
 	return action;
 
 drop:
