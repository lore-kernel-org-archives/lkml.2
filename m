Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2KNGHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:07:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab2KNFuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:01 -0500
Message-Id: <20121114053936.093915450@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/82] rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit a4b64fbe482c7766f7925f03067fc637716bfa3f upstream.

nlmsg_parse() might return an error, so test its return value before
potential random memory accesses.

Errors introduced in commit 115c9b81928 (rtnetlink: Fix problem with
buffer allocation)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg Rose <gregory.v.rose@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 606a6e8..f965dce 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1060,11 +1060,12 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
-		    ifla_policy);
+	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >= 0) {
 
-	if (tb[IFLA_EXT_MASK])
-		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
 
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
@@ -1900,10 +1901,11 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX, ifla_policy);
-
-	if (tb[IFLA_EXT_MASK])
-		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >= 0) {
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
 
 	if (!ext_filter_mask)
 		return NLMSG_GOODSIZE;


