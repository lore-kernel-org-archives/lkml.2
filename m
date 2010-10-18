Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0JROEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:04:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:33893 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0JROEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:04:50 -0400
From: Julia Lawall <julia@diku.dk>
To: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/net/ax88796.c: Return error code in failure
Date: Mon, 18 Oct 2010 16:11:14 +0200
Message-Id: <1287411074-19825-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this code, 0 is returned on failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@a@
identifier alloc;
identifier ret;
constant C;
expression x;
@@

x = alloc(...);
if (x == NULL) { <+... \(ret = -C; \| return -C; \) ...+> }

@@
identifier f, a.alloc;
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = alloc(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Another call to platform_get_resource in the same function uses -ENXIO, so
I have used the same value here.

 drivers/net/ax88796.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index 20e946b..b6da4cf 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -864,6 +864,7 @@ static int ax_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no IRQ specified\n");
+		ret = -ENXIO;
 		goto exit_mem;
 	}
 

