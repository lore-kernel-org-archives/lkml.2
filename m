Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1HTHCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 03:02:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56910 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1HTHCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 03:02:09 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Timur Tabi <timur@freescale.com>, Axel Lin <axel.lin@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/2] sound/soc/fsl/p1022_ds.c: add missing of_node_put
Date: Sat, 20 Aug 2011 09:02:00 +0200
Message-Id: <1313823721-16930-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dma_channel_np has been accessed at this point, so decrease its reference
count before leaving the function.

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
if (...) { ... when != of_node_put(x)
               when != x = E3
               when != E3 = x
*  return ...;
 }
... when != x = E2
    when != I(...,x,...) S
if (...) { ... when != x = E4
 of_node_put(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/fsl/p1022_ds.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
index 8fa4d5f..fcb862e 100644
--- a/sound/soc/fsl/p1022_ds.c
+++ b/sound/soc/fsl/p1022_ds.c
@@ -297,8 +297,10 @@ static int get_dma_channel(struct device_node *ssi_np,
 	 * dai->platform name should already point to an allocated buffer.
 	 */
 	ret = of_address_to_resource(dma_channel_np, 0, &res);
-	if (ret)
+	if (ret) {
+		of_node_put(dma_channel_np);
 		return ret;
+	}
 	snprintf((char *)dai->platform_name, DAI_NAME_SIZE, "%llx.%s",
 		 (unsigned long long) res.start, dma_channel_np->name);
 

