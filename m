Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab1BPAWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:12 -0500
Received: from kroah.org ([198.145.64.141]:39449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1BPAWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001438.957474236@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>
Subject: [139/272] inet6: prevent network storms caused by linux IPv6 routers
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

[ Upstream commit 72b43d0898e97f588293b4a24b33c58c46633d81 ]

Linux IPv6 forwards unicast packets, which are link layer multicasts...
The hole was present since day one. I was 100% this check is there, but it is not.

The problem shows itself, f.e. when Microsoft Network Load Balancer runs on a network.
This software resolves IPv6 unicast addresses to multicast MAC addresses.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/ip6_output.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -401,6 +401,9 @@ int ip6_forward(struct sk_buff *skb)
 		goto drop;
 	}
 
+	if (skb->pkt_type != PACKET_HOST)
+		goto drop;
+
 	skb_forward_csum(skb);
 
 	/*


