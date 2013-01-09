Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3AIVqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:46:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:41722 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933099Ab3AIUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/80] inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
Date: Wed,  9 Jan 2013 12:35:01 -0800
Message-Id: <20130109201501.594503714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 1c95df85ca49640576de2f0a850925957b547b84 ]

Fix inet_diag to be aware of the fact that AF_INET6 TCP connections
instantiated for IPv4 traffic and in the SYN-RECV state were actually
created with inet_reqsk_alloc(), instead of inet6_reqsk_alloc(). This
means that for such connections inet6_rsk(req) returns a pointer to a
random spot in memory up to roughly 64KB beyond the end of the
request_sock.

With this bug, for a server using AF_INET6 TCP sockets and serving
IPv4 traffic, an inet_diag user like `ss state SYN-RECV` would lead to
inet_diag_fill_req() causing an oops or the export to user space of 16
bytes of kernel memory as a garbage IPv6 address, depending on where
the garbage inet6_rsk(req) pointed.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |   53 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 14 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -44,6 +44,10 @@ struct inet_diag_entry {
 	u16 dport;
 	u16 family;
 	u16 userlocks;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr saddr_storage;	/* for IPv4-mapped-IPv6 addresses */
+	struct in6_addr daddr_storage;	/* for IPv4-mapped-IPv6 addresses */
+#endif
 };
 
 #define INET_DIAG_PUT(skb, attrtype, attrlen) \
@@ -586,6 +590,36 @@ static int inet_twsk_diag_dump(struct in
 				   cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh);
 }
 
+/* Get the IPv4, IPv6, or IPv4-mapped-IPv6 local and remote addresses
+ * from a request_sock. For IPv4-mapped-IPv6 we must map IPv4 to IPv6.
+ */
+static inline void inet_diag_req_addrs(const struct sock *sk,
+				       const struct request_sock *req,
+				       struct inet_diag_entry *entry)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6) {
+		if (req->rsk_ops->family == AF_INET6) {
+			entry->saddr = inet6_rsk(req)->loc_addr.s6_addr32;
+			entry->daddr = inet6_rsk(req)->rmt_addr.s6_addr32;
+		} else if (req->rsk_ops->family == AF_INET) {
+			ipv6_addr_set_v4mapped(ireq->loc_addr,
+					       &entry->saddr_storage);
+			ipv6_addr_set_v4mapped(ireq->rmt_addr,
+					       &entry->daddr_storage);
+			entry->saddr = entry->saddr_storage.s6_addr32;
+			entry->daddr = entry->daddr_storage.s6_addr32;
+		}
+	} else
+#endif
+	{
+		entry->saddr = &ireq->loc_addr;
+		entry->daddr = &ireq->rmt_addr;
+	}
+}
+
 static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 			      struct request_sock *req, u32 pid, u32 seq,
 			      const struct nlmsghdr *unlh)
@@ -624,8 +658,10 @@ static int inet_diag_fill_req(struct sk_
 	r->idiag_inode = 0;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (r->idiag_family == AF_INET6) {
-		*(struct in6_addr *)r->id.idiag_src = inet6_rsk(req)->loc_addr;
-		*(struct in6_addr *)r->id.idiag_dst = inet6_rsk(req)->rmt_addr;
+		struct inet_diag_entry entry;
+		inet_diag_req_addrs(sk, req, &entry);
+		memcpy(r->id.idiag_src, entry.saddr, sizeof(struct in6_addr));
+		memcpy(r->id.idiag_dst, entry.daddr, sizeof(struct in6_addr));
 	}
 #endif
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
@@ -683,18 +719,7 @@ static int inet_diag_dump_reqs(struct sk
 				continue;
 
 			if (bc) {
-				entry.saddr =
-#if IS_ENABLED(CONFIG_IPV6)
-					(entry.family == AF_INET6) ?
-					inet6_rsk(req)->loc_addr.s6_addr32 :
-#endif
-					&ireq->loc_addr;
-				entry.daddr =
-#if IS_ENABLED(CONFIG_IPV6)
-					(entry.family == AF_INET6) ?
-					inet6_rsk(req)->rmt_addr.s6_addr32 :
-#endif
-					&ireq->rmt_addr;
+				inet_diag_req_addrs(sk, req, &entry);
 				entry.dport = ntohs(ireq->rmt_port);
 
 				if (!inet_diag_bc_run(bc, &entry))


