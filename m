Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0FAOeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:34:50 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51351 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab0FAOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:34:48 -0400
Date: Tue, 1 Jun 2010 16:34:38 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] drivers/mfd: introduce missing kfree
Message-ID: <Pine.LNX.4.64.1006011634200.12546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/mfd/davinci_voicecodec.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index 3e75f02..33c923d 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -94,7 +94,8 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto fail4;
 	}
 
 	davinci_vc->davinci_vcif.dma_tx_channel = res->start;
@@ -104,7 +105,8 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
-		return -ENXIO;
+		ret = -ENXIO;
+		goto fail4;
 	}
 
 	davinci_vc->davinci_vcif.dma_rx_channel = res->start;
