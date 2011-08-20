Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1HTGNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 02:13:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59990 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1HTGMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 02:12:49 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dong Aisheng <b29396@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] sound/soc/mxs/mxs-saif.c: add missing kfree
Date: Sat, 20 Aug 2011 08:12:40 +0200
Message-Id: <1313820761-12042-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The error handling code prior to get_clk also needs to call kfree.  The
label name is changed to reflect its more general use.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
expression E1!=0,E2,E3,E4;
statement S;
iterator I;
@@

(
if (...) { ... when != kfree(x)
               when != x = E3
               when != E3 = x
*  return ...;
 }
... when != x = E2
    when != I(...,x,...) S
if (...) { ... when != x = E4
 kfree(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/mxs/mxs-saif.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 0b3adae..4a17bc8 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -523,8 +523,10 @@ static int mxs_saif_probe(struct platform_device *pdev)
 	if (!saif)
 		return -ENOMEM;
 
-	if (pdev->id >= ARRAY_SIZE(mxs_saif))
-		return -EINVAL;
+	if (pdev->id >= ARRAY_SIZE(mxs_saif)) {
+		ret = -EINVAL;
+		goto failed;
+	}
 	mxs_saif[pdev->id] = saif;
 
 	saif->clk = clk_get(&pdev->dev, NULL);
@@ -532,7 +534,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		ret = PTR_ERR(saif->clk);
 		dev_err(&pdev->dev, "Cannot get the clock: %d\n",
 			ret);
-		goto failed_clk;
+		goto failed;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -625,7 +627,7 @@ failed_ioremap:
 	release_mem_region(res->start, resource_size(res));
 failed_get_resource:
 	clk_put(saif->clk);
-failed_clk:
+failed:
 	kfree(saif);
 
 	return ret;

