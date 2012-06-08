Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab2FHFOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:14:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43333 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760087Ab2FHFH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:28 -0400
Message-Id: <20120608041850.539990060@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:52 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yaseivch <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 72/82] sctp: check cached dst before using it
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e0268868ba064980488fc8c194db3d8e9fb2959c ]

dst_check() will take care of SA (and obsolete field), hence
IPsec rekeying scenario is taken into account.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Vlad Yaseivch <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/sctp/sctp.h |   13 +++++++++++++
 net/sctp/output.c       |    4 +---
 net/sctp/transport.c    |   17 -----------------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 6a72a58..ad03988 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -703,4 +703,17 @@ static inline void sctp_v4_map_v6(union sctp_addr *addr)
 	addr->v6.sin6_addr.s6_addr32[2] = htonl(0x0000ffff);
 }
 
+/* The cookie is always 0 since this is how it's used in the
+ * pmtu code.
+ */
+static inline struct dst_entry *sctp_transport_dst_check(struct sctp_transport *t)
+{
+	if (t->dst && !dst_check(t->dst, 0)) {
+		dst_release(t->dst);
+		t->dst = NULL;
+	}
+
+	return t->dst;
+}
+
 #endif /* __net_sctp_h__ */
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 817174e..8fc4dcd 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -377,9 +377,7 @@ int sctp_packet_transmit(struct sctp_packet *packet)
 	 */
 	skb_set_owner_w(nskb, sk);
 
-	/* The 'obsolete' field of dst is set to 2 when a dst is freed. */
-	if (!dst || (dst->obsolete > 1)) {
-		dst_release(dst);
+	if (!sctp_transport_dst_check(tp)) {
 		sctp_transport_route(tp, NULL, sctp_sk(sk));
 		if (asoc && (asoc->param_flags & SPP_PMTUD_ENABLE)) {
 			sctp_assoc_sync_pmtu(asoc);
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index 394c57c..8da4481 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -226,23 +226,6 @@ void sctp_transport_pmtu(struct sctp_transport *transport, struct sock *sk)
 		transport->pathmtu = SCTP_DEFAULT_MAXSEGMENT;
 }
 
-/* this is a complete rip-off from __sk_dst_check
- * the cookie is always 0 since this is how it's used in the
- * pmtu code
- */
-static struct dst_entry *sctp_transport_dst_check(struct sctp_transport *t)
-{
-	struct dst_entry *dst = t->dst;
-
-	if (dst && dst->obsolete && dst->ops->check(dst, 0) == NULL) {
-		dst_release(t->dst);
-		t->dst = NULL;
-		return NULL;
-	}
-
-	return dst;
-}
-
 void sctp_transport_update_pmtu(struct sctp_transport *t, u32 pmtu)
 {
 	struct dst_entry *dst;


