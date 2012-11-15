Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab2KOEao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:30:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:49405 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993010Ab2KOELz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [ 54/66] net: inet_diag -- Return error code if protocol handler is missed
Date: Wed, 14 Nov 2012 20:10:59 -0800
Message-Id: <20121115040943.045361711@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Cyrill Gorcunov <gorcunov@openvz.org>

[ Upstream commit cacb6ba0f36ab14a507f4ee7697e8332899015d2 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -883,13 +883,16 @@ static int __inet_diag_dump(struct sk_bu
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


