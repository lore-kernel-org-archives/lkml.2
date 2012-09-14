Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2INT77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:59:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60643 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693Ab2INT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:59:57 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH] xfrm_user: return error pointer instead of NULL #2
Date: Fri, 14 Sep 2012 21:58:32 +0200
Message-Id: <1347652712-14584-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dump_one_policy() returns an error, e.g. because of a too small
buffer to dump the whole xfrm policy, xfrm_policy_netlink() returns
NULL instead of an error pointer. But its caller expects an error
pointer and therefore continues to operate on a NULL skbuff.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---

Note, this is a different, but similar issue as my previous patch
with the almost same subject.

I'm not aware of a way how to exploit this bug as the policy *should*
always fit into the netlink buffer but better safe then sorry, so cc
stable.

 net/xfrm/xfrm_user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index dac08e2..d12b625 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1548,6 +1548,7 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
@@ -1558,9 +1559,10 @@ static struct sk_buff *xfrm_policy_netlink(struct sk_buff *in_skb,
 	info.nlmsg_seq = seq;
 	info.nlmsg_flags = 0;
 
-	if (dump_one_policy(xp, dir, 0, &info) < 0) {
+	err = dump_one_policy(xp, dir, 0, &info);
+	if (err) {
 		kfree_skb(skb);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	return skb;
-- 
1.7.10.4

