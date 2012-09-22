Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2IVCMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 22:12:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54729 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab2IVCLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 22:11:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: JP Abgrall <jpa@google.com>, netdev@vger.kernel.org,
        Ashish Sharma <ashishsharma@google.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/7][RFC] netfilter: xt_qtaguid: fix ipv6 protocol lookup
Date: Fri, 21 Sep 2012 22:10:50 -0400
Message-Id: <1348279853-44499-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
References: <1348279853-44499-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092202-7408-0000-0000-000008B477CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JP Abgrall <jpa@google.com>

When updating the stats for a given uid it would incorrectly assume
IPV4 and pick up the wrong protocol when IPV6.

Cc: netdev@vger.kernel.org
Cc: JP Abgrall <jpa@google.com>
Cc: Ashish Sharma <ashishsharma@google.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Signed-off-by: JP Abgrall <jpa@google.com>
[Small compile fix for ipv6_find_hdr() -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 net/netfilter/xt_qtaguid.c |   39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_qtaguid.c b/net/netfilter/xt_qtaguid.c
index 214a990..47dfb9e 100644
--- a/net/netfilter/xt_qtaguid.c
+++ b/net/netfilter/xt_qtaguid.c
@@ -26,6 +26,10 @@
 #include <net/tcp.h>
 #include <net/udp.h>
 
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#endif
+
 #include <linux/netfilter/xt_socket.h>
 #include "xt_qtaguid_internal.h"
 #include "xt_qtaguid_print.h"
@@ -1536,6 +1540,27 @@ static struct sock *qtaguid_find_sk(const struct sk_buff *skb,
 	return sk;
 }
 
+static int ipx_proto(const struct sk_buff *skb,
+		     struct xt_action_param *par)
+{
+	int thoff, tproto;
+
+	switch (par->family) {
+	case NFPROTO_IPV6:
+		tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
+		if (tproto < 0)
+			MT_DEBUG("%s(): transport header not found in ipv6"
+				 " skb=%p\n", __func__, skb);
+		break;
+	case NFPROTO_IPV4:
+		tproto = ip_hdr(skb)->protocol;
+		break;
+	default:
+		tproto = IPPROTO_RAW;
+	}
+	return tproto;
+}
+
 static void account_for_uid(const struct sk_buff *skb,
 			    const struct sock *alternate_sk, uid_t uid,
 			    struct xt_action_param *par)
@@ -1562,15 +1587,15 @@ static void account_for_uid(const struct sk_buff *skb,
 	} else if (unlikely(!el_dev->name)) {
 		pr_info("qtaguid[%d]: no dev->name?!!\n", par->hooknum);
 	} else {
-		MT_DEBUG("qtaguid[%d]: dev name=%s type=%d\n",
-			 par->hooknum,
-			 el_dev->name,
-			 el_dev->type);
+		int proto = ipx_proto(skb, par);
+		MT_DEBUG("qtaguid[%d]: dev name=%s type=%d fam=%d proto=%d\n",
+			 par->hooknum, el_dev->name, el_dev->type,
+			 par->family, proto);
 
 		if_tag_stat_update(el_dev->name, uid,
 				skb->sk ? skb->sk : alternate_sk,
 				par->in ? IFS_RX : IFS_TX,
-				ip_hdr(skb)->protocol, skb->len);
+				proto, skb->len);
 	}
 }
 
@@ -1615,8 +1640,8 @@ static bool qtaguid_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	} else {
 		atomic64_inc(&qtu_events.match_found_sk);
 	}
-	MT_DEBUG("qtaguid[%d]: sk=%p got_sock=%d proto=%d\n",
-		par->hooknum, sk, got_sock, ip_hdr(skb)->protocol);
+	MT_DEBUG("qtaguid[%d]: sk=%p got_sock=%d fam=%d proto=%d\n",
+		 par->hooknum, sk, got_sock, par->family, ipx_proto(skb, par));
 	if (sk != NULL) {
 		MT_DEBUG("qtaguid[%d]: sk=%p->sk_socket=%p->file=%p\n",
 			par->hooknum, sk, sk->sk_socket,
-- 
1.7.9.5

