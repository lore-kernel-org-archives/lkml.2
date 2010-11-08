Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0KHW10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:27:26 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:56849 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0KHW1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:27:24 -0500
X-Greylist: delayed 1646 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 17:27:24 EST
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] Fix header size check for GSO case in recvmsg (af_packet)
Date: Mon,  8 Nov 2010 22:58:45 +0100
Message-Id: <1289253525-7020-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on
	Spam=No score=-1.4 bayes=0.5
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameter 'len' is size_t type so it will never get negative.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 net/packet/af_packet.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 3616f27..3451191 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1610,9 +1610,11 @@ static int packet_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 		err = -EINVAL;
 		vnet_hdr_len = sizeof(vnet_hdr);
-		if ((len -= vnet_hdr_len) < 0)
+		if (len < vnet_hdr_len)
 			goto out_free;
 
+		len -= vnet_hdr_len;
+
 		if (skb_is_gso(skb)) {
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
 
-- 
1.7.0.4

