Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab1BOXTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:19:52 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:43712 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab1BOXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:19:45 -0500
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH 2/5] bridge: Fix IPv6 multicast snooping by correcting offset in MLDv2 report
Date: Wed, 16 Feb 2011 00:19:18 +0100
Message-Id: <1297811961-19249-3-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18eW/eOIj168VqA5uiQtzsoN5L9xj4FVrO+hbAu
	redpYbTwGOBFpqjpxtPAcAm2Da4CE+D7QgTmonLj23dThz/civ
	MY6W+T6kyY6ayta1eVkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We actually want a pointer to the grec_nsrcr and not the following
field. Otherwise we can get very high values for *nsrcs as the first two
bytes of the IPv6 multicast address are being used instead, leading to
a failing pskb_may_pull() which results in MLDv2 reports not being
parsed.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_multicast.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 135d929..45dcf10 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1014,7 +1014,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 
 		nsrcs = skb_header_pointer(skb,
 					   len + offsetof(struct mld2_grec,
-							  grec_mca),
+							  grec_nsrcs),
 					   sizeof(_nsrcs), &_nsrcs);
 		if (!nsrcs)
 			return -EINVAL;
-- 
1.7.2.3

