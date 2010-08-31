Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0HaPst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:48:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44556 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603Ab0HaPsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:48:47 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/4] sound/soc/fsl/p1022_ds.c: Add of_node_put to avoid memory leak
Date: Tue, 31 Aug 2010 17:48:56 +0200
Message-Id: <1283269738-14612-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283269738-14612-1-git-send-email-julia@diku.dk>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to of_node_put in the error handling code following a call to
of_parse_phandle.

This patch also moves the existing call to of_node_put tothe end of the
error handling code, to make it possible to jump to of_node_put without
doing the other cleanup operations.  These appear to be disjoint
operations, so the ordering doesn't matter.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E,E1,E2;
statement S;
@@

*x = 
(of_find_node_by_path
|of_find_node_by_name
|of_find_node_by_phandle
|of_get_parent
|of_get_next_parent
|of_get_next_child
|of_find_compatible_node
|of_match_node
|of_find_node_by_type
|of_find_node_with_property
|of_find_matching_node
|of_parse_phandle
)(...);
...
if (x == NULL) S
<... when != x = E
*if (...) {
  ... when != of_node_put(x)
      when != if (...) { ... of_node_put(x); ... }
(
  return <+...x...+>;
|
*  return ...;
)
}
...>
(
E2 = x;
|
of_node_put(x);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/fsl/p1022_ds.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
index f8176e8..63b9eaa 100644
--- a/sound/soc/fsl/p1022_ds.c
+++ b/sound/soc/fsl/p1022_ds.c
@@ -346,8 +346,10 @@ static int p1022_ds_probe(struct platform_device *pdev)
 	}
 
 	mdata = kzalloc(sizeof(struct machine_data), GFP_KERNEL);
-	if (!mdata)
-		return -ENOMEM;
+	if (!mdata) {
+		ret = -ENOMEM;
+		goto error_put;
+	}
 
 	mdata->dai[0].cpu_dai_name = dev_name(&ssi_pdev->dev);
 	mdata->dai[0].ops = &p1022_ds_ops;
@@ -502,13 +504,12 @@ static int p1022_ds_probe(struct platform_device *pdev)
 	return 0;
 
 error:
-	of_node_put(codec_np);
-
 	if (sound_device)
 		platform_device_unregister(sound_device);
 
 	kfree(mdata);
-
+error_put:
+	of_node_put(codec_np);
 	return ret;
 }
 

