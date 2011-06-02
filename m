Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1FBFs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:48:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47912 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab1FBFs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:48:56 -0400
Date: Thu, 2 Jun 2011 07:48:50 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, wg@grandegger.com, kernel-janitors@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wharms@bfs.de
Subject: Re: [PATCH 4/10] drivers/net/can/flexcan.c: add missing clk_put
In-Reply-To: <20110601.131136.391831410750786951.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1106020748020.22932@ask.diku.dk>
References: <1306948213-20767-4-git-send-email-julia@diku.dk>
 <1306949175.32125.20.camel@Joe-Laptop> <Pine.LNX.4.64.1106012207260.5871@ask.diku.dk>
 <20110601.131136.391831410750786951.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The failed_get label is used after the call to clk_get has succeeded, so it
should be moved up above the call to clk_put.

The failed_req labels doesn't do anything different than failed_get, so
delete it.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression e1,e2;
statement S;
@@

e1 = clk_get@p1(...);
... when != e1 = e2
    when != clk_put(e1)
    when any
if (...) { ... when != clk_put(e1)
               when != if (...) { ... clk_put(e1) ... }
* return@p3 ...;
 } else S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/can/flexcan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index d499056..1767811 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -923,7 +923,7 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
 	mem_size = resource_size(mem);
 	if (!request_mem_region(mem->start, mem_size, pdev->name)) {
 		err = -EBUSY;
-		goto failed_req;
+		goto failed_get;
 	}
 
 	base = ioremap(mem->start, mem_size);
@@ -977,9 +977,8 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
 	iounmap(base);
  failed_map:
 	release_mem_region(mem->start, mem_size);
- failed_req:
-	clk_put(clk);
  failed_get:
+	clk_put(clk);
  failed_clock:
 	return err;
 }
