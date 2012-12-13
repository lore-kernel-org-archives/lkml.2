Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab2LMON1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44996 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab2LMONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 203/241] net: inet_diag -- Return error code if protocol handler is missed
Date: Thu, 13 Dec 2012 11:59:28 -0200
Message-Id: <1355407206-17100-204-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrill Gorcunov <gorcunov@openvz.org>

commit cacb6ba0f36ab14a507f4ee7697e8332899015d2 upstream.

We've observed that in case if UDP diag module is not
supported in kernel the netlink returns NLMSG_DONE without
notifying a caller that handler is missed.

This patch makes __inet_diag_dump to return error code instead.

So as example it become possible to detect such situation
and handle it gracefully on userspace level.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: David Miller <davem@davemloft.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/inet_diag.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 46d1e71..1bfc104 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -875,13 +875,16 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		struct inet_diag_req_v2 *r, struct nlattr *bc)
 {
 	const struct inet_diag_handler *handler;
+	int err = 0;
 
 	handler = inet_diag_lock_handler(r->sdiag_protocol);
 	if (!IS_ERR(handler))
 		handler->dump(skb, cb, r, bc);
+	else
+		err = PTR_ERR(handler);
 	inet_diag_unlock_handler(handler);
 
-	return skb->len;
+	return err ? : skb->len;
 }
 
 static int inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
-- 
1.7.9.5

