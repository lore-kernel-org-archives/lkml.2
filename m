Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab2LZVtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 16:49:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:49155 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2LZVtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 16:49:43 -0500
Date: Wed, 26 Dec 2012 22:49:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: netfilter@vger.kernel.org
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jay Schulist <jschlst@samba.org>, Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] netfilter: Don't leak 'exp' in ctnetlink_create_expect()
Message-ID: <alpine.LNX.2.00.1212262246390.23814@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'if ((!help) && (!cda[CTA_EXPECT_TIMEOUT]))' then we should remember
to free 'exp' that was allocated by 'nf_ct_expect_alloc()' by jumping
to the 'err_out' label rather than the 'out' label in
ctnetlink_create_expect().
This patch should get rid of the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 note: compile tested only.

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4e078cd..627b0e5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2624,7 +2624,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	if (!help) {
 		if (!cda[CTA_EXPECT_TIMEOUT]) {
 			err = -EINVAL;
-			goto out;
+			goto err_out;
 		}
 		exp->timeout.expires =
 		  jiffies + ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

