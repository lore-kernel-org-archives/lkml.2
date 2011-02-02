Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1BBBA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:00:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:37546 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1BBAoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960617"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, nelhage@ksplice.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [67/139] econet: Fix crash in aun_incoming().
Message-Id: <20110202004423.E72EF3E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/econet/af_econet.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/econet/af_econet.c
===================================================================
--- linux-2.6.35.y.orig/net/econet/af_econet.c
+++ linux-2.6.35.y/net/econet/af_econet.c
@@ -849,7 +849,11 @@ static void aun_incoming(struct sk_buff 
 	unsigned char stn = ntohl(ip->saddr) & 0xff;
 	struct sock *sk;
 	struct sk_buff *newskb;
-	struct ec_device *edev = skb->dev->ec_ptr;
+	struct dst_entry *dst = skb_dst(skb);
+	struct ec_device *edev = NULL;
+
+	if (dst)
+		edev = dst->dev->ec_ptr;
 
 	if (! edev)
 		goto bad;
