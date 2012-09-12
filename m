Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab2ILPJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:09:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49575 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834Ab2ILPHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:07:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] drivers/staging/rtl8192u/r8192U_core.c: Remove useless kfree
Date: Wed, 12 Sep 2012 17:06:43 +0200
Message-Id: <1347462407-13499-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove useless kfree() and clean up code related to the removal.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
position p1,p2;
expression x;
@@

if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }

@unchanged exists@
position r.p1,r.p2;
expression e <= r.x,x,e1;
iterator I;
statement S;
@@

if (x@p1 == NULL) { ... when != I(x,...) S
                        when != e = e1
                        when != e += e1
                        when != e -= e1
                        when != ++e
                        when != --e
                        when != e++
                        when != e--
                        when != &e
   kfree@p2(x); ... return ...; }

@ok depends on unchanged exists@
position any r.p1;
position r.p2;
expression x;
@@

... when != true x@p1 == NULL
kfree@p2(x);

@depends on !ok && unchanged@
position r.p2;
expression x;
@@

*kfree@p2(x);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/rtl8192u/r8192U_core.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 5c132ac..5a2fab9 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2232,24 +2232,15 @@ short rtl8192_usb_initendpoints(struct net_device *dev)
 	memset(priv->rx_urb, 0, sizeof(struct urb*) * MAX_RX_URB);
 	priv->pp_rxskb = kcalloc(MAX_RX_URB, sizeof(struct sk_buff *),
 				 GFP_KERNEL);
-	if (priv->pp_rxskb == NULL)
-		goto destroy;
-
-	goto _middle;
-
-
-destroy:
-	kfree(priv->pp_rxskb);
-	kfree(priv->rx_urb);
-
-	priv->pp_rxskb = NULL;
-	priv->rx_urb = NULL;
-
-	DMESGE("Endpoint Alloc Failure");
-	return -ENOMEM;
+	if (!priv->pp_rxskb) {
+		kfree(priv->rx_urb);
 
+		priv->pp_rxskb = NULL;
+		priv->rx_urb = NULL;
 
-_middle:
+		DMESGE("Endpoint Alloc Failure");
+		return -ENOMEM;
+	}
 
 	printk("End of initendpoints\n");
 	return 0;

