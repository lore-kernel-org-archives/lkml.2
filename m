Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2HSIq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:46:58 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52549 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab2HSIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216903"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: kernel-janitors@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/14] drivers/spi/spi-omap-100k.c: fix error return code
Date: Sun, 19 Aug 2012 10:44:28 +0200
Message-Id: <1345365870-29831-13-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initialize return variable before exiting on an error path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Actually, omap1_spi100k_reset currently always returns 0, so the test is
never true.  Perhaps this should be taken into account in some other way.

 drivers/spi/spi-omap-100k.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 9bd1c92..b581107 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -542,7 +542,8 @@ static int __devinit omap1_spi100k_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
-	if (omap1_spi100k_reset(spi100k) < 0)
+	status = omap1_spi100k_reset(spi100k);
+	if (status < 0)
 		goto err3;
 
 	status = spi_register_master(master);

