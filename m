Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2KNFu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55034 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab2KNFuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:22 -0500
Message-Id: <20121114053944.174312334@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:48 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Leblond <eric@regit.org>, "David S. Miller" <davem@davemloft.net>
Subject: [ 75/82] af-packet: fix oops when socket is not present
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Leblond <eric@regit.org>

[ Upstream commit a3d744e995d2b936c500585ae39d99ee251c89b4 ]

Due to a NULL dereference, the following patch is causing oops
in normal trafic condition:

commit c0de08d04215031d68fa13af36f347a6cfa252ca
Author: Eric Leblond <eric@regit.org>
Date:   Thu Aug 16 22:02:58 2012 +0000

    af_packet: don't emit packet on orig fanout group

This buggy patch was a feature fix and has reached most stable
branches.

When skb->sk is NULL and when packet fanout is used, there is a
crash in match_fanout_group where skb->sk is accessed.
This patch fixes the issue by returning false as soon as the
socket is NULL: this correspond to the wanted behavior because
the kernel as to resend the skb to all the listening socket in
this case.

Signed-off-by: Eric Leblond <eric@regit.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f500a69..480be72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1633,7 +1633,7 @@ static inline int deliver_skb(struct sk_buff *skb,
 
 static inline bool skb_loop_sk(struct packet_type *ptype, struct sk_buff *skb)
 {
-	if (ptype->af_packet_priv == NULL)
+	if (!ptype->af_packet_priv || !skb->sk)
 		return false;
 
 	if (ptype->id_match)


