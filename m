Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab2KZRAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2KZRA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 012/270] netfilter: nf_nat_sip: fix via header translation with multiple parameters
Date: Mon, 26 Nov 2012 14:55:02 -0200
Message-Id: <1353949160-26803-13-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit f22eb25cf5b1157b29ef88c793b71972efc47143 upstream.

Via-headers are parsed beginning at the first character after the Via-address.
When the address is translated first and its length decreases, the offset to
start parsing at is incorrect and header parameters might be missed.

Update the offset after translating the Via-address to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/netfilter/nf_nat_sip.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index bb71caa..6dbcdb1 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -148,7 +148,7 @@ static unsigned int ip_nat_sip(struct sk_buff *skb, unsigned int dataoff,
 	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				    hdr, NULL, &matchoff, &matchlen,
 				    &addr, &port) > 0) {
-		unsigned int matchend, poff, plen, buflen, n;
+		unsigned int olen, matchend, poff, plen, buflen, n;
 		char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
 
 		/* We're only interested in headers related to this
@@ -163,11 +163,12 @@ static unsigned int ip_nat_sip(struct sk_buff *skb, unsigned int dataoff,
 				goto next;
 		}
 
+		olen = *datalen;
 		if (!map_addr(skb, dataoff, dptr, datalen, matchoff, matchlen,
 			      &addr, port))
 			return NF_DROP;
 
-		matchend = matchoff + matchlen;
+		matchend = matchoff + matchlen + *datalen - olen;
 
 		/* The maddr= parameter (RFC 2361) specifies where to send
 		 * the reply. */
-- 
1.7.9.5

