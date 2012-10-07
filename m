Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2JGXhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:37:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38399 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754071Ab2JGXWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:36 -0400
Message-Id: <20121007225845.910413552@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Brad Spengler <spender@grsecurity.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 081/108] xfrm_user: fix info leak in copy_to_user_tmpl()
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 1f86840f897717f86d523a13e99a447e6a5d2fa5 ]

The memory used for the template copy is a local stack variable. As
struct xfrm_user_tmpl contains multiple holes added by the compiler for
alignment, not initializing the memory will lead to leaking stack bytes
to userland. Add an explicit memset(0) to avoid the info leak.

Initial version of the patch by Brad Spengler.

Cc: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1d222e9..8f916a7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1405,6 +1405,7 @@ static int copy_to_user_tmpl(struct xfrm_policy *xp, struct sk_buff *skb)
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];
 
+		memset(up, 0, sizeof(*up));
 		memcpy(&up->id, &kp->id, sizeof(up->id));
 		up->family = kp->encap_family;
 		memcpy(&up->saddr, &kp->saddr, sizeof(up->saddr));


