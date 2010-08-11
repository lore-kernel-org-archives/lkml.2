Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0HKKLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:11:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41231 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870Ab0HKKLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:11:10 -0400
Date: Wed, 11 Aug 2010 12:11:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/dma: Return -ENOMEM on memory allocation failure
Message-ID: <Pine.LNX.4.64.1008111210490.8669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this code, 0 is returned on memory allocation failure, even though other
failures return -ENOMEM or other similar values.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression ret;
expression x,e1,e2,e3;
@@

ret = 0
... when != ret = e1
*x = \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != ret = e2
if (x == NULL) { ... when != ret = e3
  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/dma/coh901318.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 557e227..6dd9488 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1475,8 +1475,10 @@ static int __init coh901318_probe(struct platform_device *pdev)
 		       pdata->max_channels *
 		       sizeof(struct coh901318_chan),
 		       GFP_KERNEL);
-	if (!base)
+	if (!base) {
+		err = -ENOMEM;
 		goto err_alloc_coh_dma_channels;
+	}
 
 	base->chans = ((void *)base) + ALIGN(sizeof(struct coh901318_base), 4);
 
