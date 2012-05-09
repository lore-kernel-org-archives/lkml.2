Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2EIE6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:58:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36395 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754393Ab2EIE6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:58:30 -0400
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 07/13] bluetooth: Convert compare_ether_addr to ether_addr_equal
Date: Tue,  8 May 2012 21:56:51 -0700
Message-Id: <81fc602aa661c0919a9864a40c950ce8a3b72275.1336538938.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1336538937.git.joe@perches.com>
References: <cover.1336538937.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new bool function ether_addr_equal to add
some clarity and reduce the likelihood for misuse
of compare_ether_addr for sorting.

Done via cocci script:

$ cat compare_ether_addr.cocci
@@
expression a,b;
@@
-	!compare_ether_addr(a, b)
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	compare_ether_addr(a, b)
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) == 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!ether_addr_equal(a, b) != 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) == 0
+	!ether_addr_equal(a, b)

@@
expression a,b;
@@
-	ether_addr_equal(a, b) != 0
+	ether_addr_equal(a, b)

@@
expression a,b;
@@
-	!!ether_addr_equal(a, b)
+	ether_addr_equal(a, b)

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/bluetooth/bnep/core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index a779ec7..88884d1 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -69,7 +69,7 @@ static struct bnep_session *__bnep_get_session(u8 *dst)
 	BT_DBG("");
 
 	list_for_each_entry(s, &bnep_session_list, list)
-		if (!compare_ether_addr(dst, s->eh.h_source))
+		if (ether_addr_equal(dst, s->eh.h_source))
 			return s;
 
 	return NULL;
@@ -422,10 +422,10 @@ static inline int bnep_tx_frame(struct bnep_session *s, struct sk_buff *skb)
 	iv[il++] = (struct kvec) { &type, 1 };
 	len++;
 
-	if (compress_src && !compare_ether_addr(eh->h_dest, s->eh.h_source))
+	if (compress_src && ether_addr_equal(eh->h_dest, s->eh.h_source))
 		type |= 0x01;
 
-	if (compress_dst && !compare_ether_addr(eh->h_source, s->eh.h_dest))
+	if (compress_dst && ether_addr_equal(eh->h_source, s->eh.h_dest))
 		type |= 0x02;
 
 	if (type)
-- 
1.7.8.111.gad25c.dirty

