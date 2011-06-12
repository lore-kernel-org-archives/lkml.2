Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1FLOgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 10:36:43 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13639 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1FLOgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 10:36:42 -0400
Date: Sun, 12 Jun 2011 16:28:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: netdev@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Sergey Lapin <slapin@ossfans.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Maxim Osipov <maxim.osipov@siemens.com>
Subject: [PATCH] ieee802154: Don't leak memory in ieee802154_nl_fill_phy
Message-ID: <alpine.LNX.2.00.1106121621360.25151@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In net/ieee802154/nl-phy.c::ieee802154_nl_fill_phy() I see two small 
issues.
1) If the allocation of 'buf' fails we may just as well return -EMSGSIZE
   directly rather than jumping to 'out:' and do a pointless kfree(0).
2) We do not free 'buf' unless we jump to one of the error labels and this
   leaks memory.
This patch should address both.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 nl-phy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

  I have no way to properly test this patch, so it's compile tested only.

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index ed0eab3..02548b2 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -44,7 +44,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 pid,
 	pr_debug("%s\n", __func__);
 
 	if (!buf)
-		goto out;
+		return -EMSGSIZE;
 
 	hdr = genlmsg_put(msg, 0, seq, &nl802154_family, flags,
 		IEEE802154_LIST_PHY);
@@ -65,6 +65,7 @@ static int ieee802154_nl_fill_phy(struct sk_buff *msg, u32 pid,
 				pages * sizeof(uint32_t), buf);
 
 	mutex_unlock(&phy->pib_lock);
+	kfree(buf);
 	return genlmsg_end(msg, hdr);
 
 nla_put_failure:


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

