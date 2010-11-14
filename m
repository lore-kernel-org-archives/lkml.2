Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0KNHgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 02:36:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58449 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0KNHgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 02:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=PGzPAAagfF8Xm3+FG1apET4q53WnooZEtk4dI2p/XbBLdFKH2ABZnGPmoKy/rdjQBK
         UEU6ACz7fzrnLRJKtNHZdtYyOssM3VXetAi0AoxGQjFQRZDN6r8rgHt3hU/fyqj7JU1q
         PWGYR81GXwCXooVz6kdmCu4aqbzxyExrkt64k=
From: Zhang Le <r0bertz@gentoo.org>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhang Le <r0bertz@gentoo.org>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH] ipv4: mitigate an integer underflow when comparing tcp timestamps
Date: Sun, 14 Nov 2010 15:35:56 +0800
Message-Id: <1289720156-30118-1-git-send-email-r0bertz@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behind a loadbalancer which does NAT, peer->tcp_ts could be much smaller than
req->ts_recent. In this case, theoretically the req should not be ignored.

But in fact, it could be ignored, if peer->tcp_ts is so small that the
difference between this two number is larger than 2 to the power of 31.

I understand that under this situation, timestamp does not make sense any more,
because it actually comes from difference machines. However, if anyone
ever need to do the same investigation which I have done, this will
save some time for him.

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 8f8527d..1eb4974 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1352,8 +1352,8 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 		    peer->v4daddr == saddr) {
 			inet_peer_refcheck(peer);
 			if ((u32)get_seconds() - peer->tcp_ts_stamp < TCP_PAWS_MSL &&
-			    (s32)(peer->tcp_ts - req->ts_recent) >
-							TCP_PAWS_WINDOW) {
+			    ((s32)(peer->tcp_ts - req->ts_recent) > TCP_PAWS_WINDOW &&
+			     peer->tcp_ts > req->ts_recent)) {
 				NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_PAWSPASSIVEREJECTED);
 				goto drop_and_release;
 			}
-- 
1.7.3.2

