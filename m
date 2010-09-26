Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab0IZJ6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:58:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33648 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0IZJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 05:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dfqH0yRq3UykWpExd6Wjdw3ay5use5IaKDnSKR8TkryrultsUVCQiXXz/GeUNQhsyN
         Uovnki8v/XoW2ec0mM2mQUHSVQiBWjiMuDr/y/yxfL4cTEGRpmLRoPcy/vzS1mxn+4qx
         49JePenLtOk370pFiQ20L4cwO2Vr3OkSge7RM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] sgiseeq: use free_netdev(netdev) instead of kfree()
Date: Sun, 26 Sep 2010 13:58:06 +0400
Message-Id: <1285495086-21956-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing netdev without free_netdev() leads to net, tx leaks.
I might lead to dereferencing freed pointer.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

@@
struct net_device* dev;
@@

-kfree(dev)
+free_netdev(dev)
---
 drivers/net/sgiseeq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sgiseeq.c b/drivers/net/sgiseeq.c
index cc4bd8c..9265315 100644
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -804,7 +804,7 @@ static int __devinit sgiseeq_probe(struct platform_device *pdev)
 err_out_free_page:
 	free_page((unsigned long) sp->srings);
 err_out_free_dev:
-	kfree(dev);
+	free_netdev(dev);
 
 err_out:
 	return err;
-- 
1.7.0.4

