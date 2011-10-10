Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1JJSzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:55:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30181 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1JJSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:55:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=nwxrEfPhmU4cllVVdTYRmha77rvGEFdPPyT+b2lO/nFqPFKLcxmuScDE4nqkAowWo
	VO2yLzmPHZsaq1/pSJFKQ==
From: Muraliraja Muniraju <muralira@google.com>
To: "David S. Miller\"" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Murali Raja <muralira@google.com>
Subject: [PATCH] net-netlink: Add a new attribute to expose TOS values via netlink
Date: Mon, 10 Oct 2011 11:54:26 -0700
Message-Id: <1318272866-18082-1-git-send-email-muralira@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Raja <muralira@google.com>

This patch exposes the tos value for the TCP sockets when the TOS flag
is requested in the ext_flags for the inet_diag request. This would mainly be
used to expose TOS values for both for TCP and UDP sockets. Currently it is
supported for TCP. When netlink support for UDP would be added the support
to expose the TOS values would alse be done.

Signed-off-by: Murali Raja <muralira@google.com>
---
 include/linux/inet_diag.h |   10 +++++++++-
 net/ipv4/inet_diag.c      |    7 +++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index bc8c490..f590a59 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -97,9 +97,10 @@ enum {
 	INET_DIAG_INFO,
 	INET_DIAG_VEGASINFO,
 	INET_DIAG_CONG,
+	INET_DIAG_TOS,
 };
 
-#define INET_DIAG_MAX INET_DIAG_CONG
+#define INET_DIAG_MAX INET_DIAG_TOS
 
 
 /* INET_DIAG_MEM */
@@ -120,6 +121,13 @@ struct tcpvegas_info {
 	__u32	tcpv_minrtt;
 };
 
+/* INET_DIAG_TOS */
+
+struct inet_diag_tos {
+	__u8	idiag_tos;
+	__u8	idiag_reserved[3];
+};
+
 #ifdef __KERNEL__
 struct sock;
 struct inet_hashinfo;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 389a2e6..6c52e29 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -82,6 +82,7 @@ static int inet_csk_diag_fill(struct sock *sk,
 	struct nlmsghdr  *nlh;
 	void *info = NULL;
 	struct inet_diag_meminfo  *minfo = NULL;
+	struct inet_diag_tos *tos = NULL;
 	unsigned char	 *b = skb_tail_pointer(skb);
 	const struct inet_diag_handler *handler;
 
@@ -108,6 +109,9 @@ static int inet_csk_diag_fill(struct sock *sk,
 		       icsk->icsk_ca_ops->name);
 	}
 
+	if (ext & (1 << (INET_DIAG_TOS - 1)))
+		tos = INET_DIAG_PUT(skb, INET_DIAG_TOS, sizeof(*tos));
+
 	r->idiag_family = sk->sk_family;
 	r->idiag_state = sk->sk_state;
 	r->idiag_timer = 0;
@@ -169,6 +173,9 @@ static int inet_csk_diag_fill(struct sock *sk,
 	    icsk->icsk_ca_ops && icsk->icsk_ca_ops->get_info)
 		icsk->icsk_ca_ops->get_info(sk, ext, skb);
 
+	if (tos)
+		tos->idiag_tos = inet->tos;
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 	return skb->len;
 
-- 
1.7.3.1

