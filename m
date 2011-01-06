Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1AFAtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:49:12 -0500
Received: from kroah.org ([198.145.64.141]:35762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab1AFAaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:02 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:03 2011
Message-Id: <20110106002303.244370129@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [070/152] econet: Fix crash in aun_incoming().
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 4e085e76cbe558b79b54cbab772f61185879bc64 ]

Unconditional use of skb->dev won't work here,
try to fetch the econet device via skb_dst()->dev
instead.

Suggested by Eric Dumazet.

Reported-by: Nelson Elhage <nelhage@ksplice.com>
Tested-by: Nelson Elhage <nelhage@ksplice.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/econet/af_econet.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -851,9 +851,13 @@ static void aun_incoming(struct sk_buff
 {
 	struct iphdr *ip = ip_hdr(skb);
 	unsigned char stn = ntohl(ip->saddr) & 0xff;
+	struct dst_entry *dst = skb_dst(skb);
+	struct ec_device *edev = NULL;
 	struct sock *sk = NULL;
 	struct sk_buff *newskb;
-	struct ec_device *edev = skb->dev->ec_ptr;
+
+	if (dst)
+		edev = dst->dev->ec_ptr;
 
 	if (! edev)
 		goto bad;


