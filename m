Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031Ab2JSDVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:21:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:54588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758055Ab2JSDRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 25/37] netfilter: nf_nat_sip: fix via header translation with multiple parameters
Date: Thu, 18 Oct 2012 20:16:48 -0700
Message-Id: <20121019031306.903770211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit f22eb25cf5b1157b29ef88c793b71972efc47143 upstream.

Via-headers are parsed beginning at the first character after the Via-address.
When the address is translated first and its length decreases, the offset to
start parsing at is incorrect and header parameters might be missed.

Update the offset after translating the Via-address to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/nf_nat_sip.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -148,7 +148,7 @@ static unsigned int ip_nat_sip(struct sk
 	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
 				    hdr, NULL, &matchoff, &matchlen,
 				    &addr, &port) > 0) {
-		unsigned int matchend, poff, plen, buflen, n;
+		unsigned int olen, matchend, poff, plen, buflen, n;
 		char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
 
 		/* We're only interested in headers related to this
@@ -163,11 +163,12 @@ static unsigned int ip_nat_sip(struct sk
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


