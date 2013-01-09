Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab3AIVCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:02:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:43450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853Ab3AIUkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Duan Jiong <djduanjiong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 086/123] ipv6: Change skb->data before using icmpv6_notify() to propagate redirect
Date: Wed,  9 Jan 2013 12:35:25 -0800
Message-Id: <20130109201509.644094471@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Duan Jiong <djduanjiong@gmail.com>

[ Upstream commit 093d04d42fa094f6740bb188f0ad0c215ff61e2c ]

In function ndisc_redirect_rcv(), the skb->data points to the transport
header, but function icmpv6_notify() need the skb->data points to the
inner IP packet. So before using icmpv6_notify() to propagate redirect,
change skb->data to point the inner IP packet that triggered the sending
of the Redirect, and introduce struct rd_msg to make it easy.

Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ndisc.h |    7 +++++++
 net/ipv6/ndisc.c    |   17 +++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -78,6 +78,13 @@ struct ra_msg {
 	__be32			retrans_timer;
 };
 
+struct rd_msg {
+	struct icmp6hdr icmph;
+	struct in6_addr	target;
+	struct in6_addr	dest;
+	__u8		opt[0];
+};
+
 struct nd_opt_hdr {
 	__u8		nd_opt_type;
 	__u8		nd_opt_len;
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1333,6 +1333,12 @@ out:
 
 static void ndisc_redirect_rcv(struct sk_buff *skb)
 {
+	u8 *hdr;
+	struct ndisc_options ndopts;
+	struct rd_msg *msg = (struct rd_msg *)skb_transport_header(skb);
+	u32 ndoptlen = skb->tail - (skb->transport_header +
+				    offsetof(struct rd_msg, opt));
+
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	switch (skb->ndisc_nodetype) {
 	case NDISC_NODETYPE_HOST:
@@ -1349,6 +1355,17 @@ static void ndisc_redirect_rcv(struct sk
 		return;
 	}
 
+	if (!ndisc_parse_options(msg->opt, ndoptlen, &ndopts))
+		return;
+
+	if (!ndopts.nd_opts_rh)
+		return;
+
+	hdr = (u8 *)ndopts.nd_opts_rh;
+	hdr += 8;
+	if (!pskb_pull(skb, hdr - skb_transport_header(skb)))
+		return;
+
 	icmpv6_notify(skb, NDISC_REDIRECT, 0, 0);
 }
 


