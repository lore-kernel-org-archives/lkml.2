Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1ABHXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:35552 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1ABHX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:26 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 116/260] bridge: Clear IPCB before possible entry into IP stack
Date: Sun,  2 Jan 2011 02:16:52 -0500
Message-Id: <1293952756-15010-117-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:16.0665 (UTC) FILETIME=[C8B43C90:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 17762060c25590bfddd68cc1131f28ec720f405f upstream.

The bridge protocol lives dangerously by having incestuous relations
with the IP stack.  In this instance an abomination has been created
where a bogus IPCB area from a bridged packet leads to a crash in
the IP stack because it's interpreted as IP options.

This patch papers over the problem by clearing the IPCB area in that
particular spot.  To fix this properly we'd also need to parse any
IP options if present but I'm way too lazy for that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
Signed-off-by: David S. Miller <davem@davemloft.net>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bridge/br_netfilter.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 4c4977d..54d812e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -601,6 +601,9 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, len);
 
+	/* BUG: Should really parse the IP options here. */
+	memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
+
 	nf_bridge_put(skb->nf_bridge);
 	if (!nf_bridge_alloc(skb))
 		return NF_DROP;
-- 
1.7.3.3

