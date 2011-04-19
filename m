Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1DSU0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:26:52 -0400
Received: from kroah.org ([198.145.64.141]:47699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1DSURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.236331061@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [29/70] bridge: Reset IPCB when entering IP stack on NF_FORWARD
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6b1e960fdbd75dcd9bcc3ba5ff8898ff1ad30b6e ]

Whenever we enter the IP stack proper from bridge netfilter we
need to ensure that the skb is in a form the IP stack expects
it to be in.

The entry point on NF_FORWARD did not meet the requirements of
the IP stack, therefore leading to potential crashes/panics.

This patch fixes the problem.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_netfilter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -741,6 +741,9 @@ static unsigned int br_nf_forward_ip(uns
 		nf_bridge->mask |= BRNF_PKT_TYPE;
 	}
 
+	if (br_parse_ip_options(skb))
+		return NF_DROP;
+
 	/* The physdev module checks on this */
 	nf_bridge->mask |= BRNF_BRIDGED;
 	nf_bridge->physoutdev = skb->dev;


