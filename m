Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2JJXX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:23:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47496 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757646Ab2JJWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:19 -0400
X-Sasl-enc: Xno+GQSZjgtgg6cCylGddU1AOHx+Yj3YyX+LU0+WX0zR 1349909658
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 028/133] xfrm_user: return error pointer instead of NULL
Date: Thu, 11 Oct 2012 07:50:54 +0900
Message-Id: <20121010224859.543211963@linuxfoundation.org>
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

[ Upstream commit 864745d291b5ba80ea0bd0edcbe67273de368836 ]

When dump_one_state() returns an error, e.g. because of a too small
buffer to dump the whole xfrm state, xfrm_state_netlink() returns NULL
instead of an error pointer. But its callers expect an error pointer
and therefore continue to operate on a NULL skbuff.

This could lead to a privilege escalation (execution of user code in
kernel context) if the attacker has CAP_NET_ADMIN and is able to map
address 0.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -872,6 +872,7 @@ static struct sk_buff *xfrm_state_netlin
 {
 	struct xfrm_dump_info info;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
@@ -882,9 +883,10 @@ static struct sk_buff *xfrm_state_netlin
 	info.nlmsg_seq = seq;
 	info.nlmsg_flags = 0;
 
-	if (dump_one_state(x, 0, &info)) {
+	err = dump_one_state(x, 0, &info);
+	if (err) {
 		kfree_skb(skb);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	return skb;


