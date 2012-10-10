Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2JJXXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:23:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33962 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757674Ab2JJWyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:54:25 -0400
X-Sasl-enc: IPvYJiduBum/oredBc1+HUkHrv+WvW5FivfwXLxn72lE 1349909664
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 035/133] xfrm_user: dont copy esn replay window twice for new states
Date: Thu, 11 Oct 2012 07:51:01 +0900
Message-Id: <20121010224900.811451947@linuxfoundation.org>
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

[ Upstream commit e3ac104d41a97b42316915020ba228c505447d21 ]

The ESN replay window was already fully initialized in
xfrm_alloc_replay_state_esn(). No need to copy it again.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -442,10 +442,11 @@ static void copy_from_user_state(struct
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
@@ -555,7 +556,7 @@ static struct xfrm_state *xfrm_state_con
 		goto error;
 
 	/* override default values from above */
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 0);
 
 	return x;
 
@@ -1819,7 +1820,7 @@ static int xfrm_new_ae(struct sk_buff *s
 		goto out;
 
 	spin_lock_bh(&x->lock);
-	xfrm_update_ae_params(x, attrs);
+	xfrm_update_ae_params(x, attrs, 1);
 	spin_unlock_bh(&x->lock);
 
 	c.event = nlh->nlmsg_type;


