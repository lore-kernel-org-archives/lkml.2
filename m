Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934850Ab1KJD1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934817Ab1KJD1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.614424204@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [139/262] l2tp: fix a potential skb leak in l2tp_xmit_skb()
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 835acf5da239b91edb9f7ebe36516999e156e6ee ]

l2tp_xmit_skb() can leak one skb if skb_cow_head() returns an error.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/l2tp/l2tp_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1045,8 +1045,10 @@ int l2tp_xmit_skb(struct l2tp_session *s
 	headroom = NET_SKB_PAD + sizeof(struct iphdr) +
 		uhlen + hdr_len;
 	old_headroom = skb_headroom(skb);
-	if (skb_cow_head(skb, headroom))
+	if (skb_cow_head(skb, headroom)) {
+		dev_kfree_skb(skb);
 		goto abort;
+	}
 
 	new_headroom = skb_headroom(skb);
 	skb_orphan(skb);


