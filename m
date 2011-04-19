Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1DSU1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:27:31 -0400
Received: from kroah.org ([198.145.64.141]:47682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1DSURL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:11 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:46 2011
Message-Id: <20110419201046.036815583@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        =?ISO-8859-15?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [27/70] xfrm: Refcount destination entry on xfrm_lookup
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit fbd5060875d25f7764fd1c3d35b83a8ed1d88d7b ]

We return a destination entry without refcount if a socket
policy is found in xfrm_lookup. This triggers a warning on
a negative refcount when freeeing this dst entry. So take
a refcount in this case to fix it.

This refcount was forgotten when xfrm changed to cache bundles
instead of policies for outgoing flows.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/xfrm/xfrm_policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1778,6 +1778,8 @@ restart:
 				goto no_transform;
 			}
 
+			dst_hold(&xdst->u.dst);
+
 			spin_lock_bh(&xfrm_policy_sk_bundle_lock);
 			xdst->u.dst.next = xfrm_policy_sk_bundles;
 			xfrm_policy_sk_bundles = &xdst->u.dst;


