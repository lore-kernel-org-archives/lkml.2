Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2JJWyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:54:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42534 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757532Ab2JJWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:08 -0400
X-Sasl-enc: k2gZlwZeci0kONUqKP7Beph7tH7T5xlYNAmfyNEJ+CWg 1349909647
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 029/133] xfrm_user: return error pointer instead of NULL #2
Date: Thu, 11 Oct 2012 07:50:55 +0900
Message-Id: <20121010224859.720215180@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit c25463722509fef0ed630b271576a8c9a70236f3 ]

When dump_one_policy() returns an error, e.g. because of a too small
buffer to dump the whole xfrm policy, xfrm_policy_netlink() returns
NULL instead of an error pointer. But its caller expects an error
pointer and therefore continues to operate on a NULL skbuff.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1543,6 +1543,7 @@ static struct sk_buff *xfrm_policy_netli
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
@@ -1553,9 +1554,10 @@ static struct sk_buff *xfrm_policy_netli
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


