Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1BBAo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:13783 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab1BBAoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960654"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: mk@lab.zgora.pl, davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [73/139] net: Fix header size check for GSO case in recvmsg (af_packet)
Message-Id: <20110202004430.329783E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Mariusz Kozlowski <mk@lab.zgora.pl>

[ Upstream commit 1f18b7176e2e41fada24584ce3c80e9abfaca52b]

Parameter 'len' is size_t type so it will never get negative.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/packet/af_packet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/net/packet/af_packet.c
===================================================================
--- linux-2.6.35.y.orig/net/packet/af_packet.c
+++ linux-2.6.35.y/net/packet/af_packet.c
@@ -1595,9 +1595,11 @@ static int packet_recvmsg(struct kiocb *
 
 		err = -EINVAL;
 		vnet_hdr_len = sizeof(vnet_hdr);
-		if ((len -= vnet_hdr_len) < 0)
+		if (len < vnet_hdr_len)
 			goto out_free;
 
+		len -= vnet_hdr_len;
+
 		if (skb_is_gso(skb)) {
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
 
