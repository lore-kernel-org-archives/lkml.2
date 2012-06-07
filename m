Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab2FGE2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:28:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54880 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616Ab2FGEZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:25:25 -0400
Message-Id: <20120607041403.468747729@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vlad Yaseivch <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/47] sctp: check cached dst before using it
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e0268868ba064980488fc8c194db3d8e9fb2959c ]

dst_check() will take care of SA (and obsolete field), hence
IPsec rekeying scenario is taken into account.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Vlad Yaseivch <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/sctp.h |   13 +++++++++++++
 net/sctp/output.c       |    4 +---
 net/sctp/transport.c    |   17 -----------------
 3 files changed, 14 insertions(+), 20 deletions(-)

--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -700,4 +700,17 @@ static inline void sctp_v4_map_v6(union
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
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -377,9 +377,7 @@ int sctp_packet_transmit(struct sctp_pac
 	 */
 	skb_set_owner_w(nskb, sk);
 
-	/* The 'obsolete' field of dst is set to 2 when a dst is freed. */
-	if (!dst || (dst->obsolete > 1)) {
-		dst_release(dst);
+	if (!sctp_transport_dst_check(tp)) {
 		sctp_transport_route(tp, NULL, sctp_sk(sk));
 		if (asoc && (asoc->param_flags & SPP_PMTUD_ENABLE)) {
 			sctp_assoc_sync_pmtu(asoc);
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -226,23 +226,6 @@ void sctp_transport_pmtu(struct sctp_tra
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


