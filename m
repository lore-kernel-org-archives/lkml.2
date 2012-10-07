Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab2JGXW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab2JGXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:33 -0400
Message-Id: <20121007225846.047918957@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 082/108] xfrm_user: dont copy esn replay window twice for new  states
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

[ Upstream commit e3ac104d41a97b42316915020ba228c505447d21 ]

The ESN replay window was already fully initialized in
xfrm_alloc_replay_state_esn(). No need to copy it again.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/xfrm/xfrm_user.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8f916a7..28e4f751 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -442,10 +442,11 @@ static void copy_from_user_state(struct xfrm_state *x, struct xfrm_usersa_info *
  * somehow made shareable and move it to xfrm_state.c - JHS
  *
 */
-static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs)
+static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs,
+				  int update_esn)
 {
 	struct nlattr *rp = attrs[XFRMA_REPLAY_VAL];
-	struct nlattr *re = attrs[XFRMA_REPLAY_ESN_VAL];
+	struct nlattr *re = update_esn ? attrs[XFRMA_REPLAY_ESN_VAL] : NULL;
 	struct nlattr *lt = attrs[XFRMA_LTIME_VAL];
 	struct nlattr *et = attrs[XFRMA_ETIMER_THRESH];
 	struct nlattr *rt = attrs[XFRMA_REPLAY_THRESH];
@@ -555,7 +556,7 @@ static struct xfrm_state *xfrm_state_construct(struct net *net,
 		goto error;
 
 	/* override default values from above */
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 0);
 
 	return x;
 
@@ -1801,7 +1802,7 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 
 	spin_lock_bh(&x->lock);
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 1);
 	spin_unlock_bh(&x->lock);
 
 	c.event = nlh->nlmsg_type;


