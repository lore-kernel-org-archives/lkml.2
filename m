Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1HTHCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 03:02:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56895 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1HTHCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 03:02:08 -0400
From: Julia Lawall <julia@diku.dk>
To: Timur Tabi <timur@freescale.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/2] sound/soc/fsl/mpc8610_hpcd.c: add missing of_node_put
Date: Sat, 20 Aug 2011 09:02:01 +0200
Message-Id: <1313823721-16930-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The first change is to add an of_node_put, since codec_np has previously
been allocated.  The rest of the patch reorganizes the error handling code
so the only code executed is that which is needed.

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
 sound/soc/fsl/mpc8610_hpcd.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index a192979..358f0ba 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -345,8 +345,10 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
 	}
 
 	machine_data = kzalloc(sizeof(struct mpc8610_hpcd_data), GFP_KERNEL);
-	if (!machine_data)
-		return -ENOMEM;
+	if (!machine_data) {
+		ret = -ENOMEM;
+		goto error_alloc;
+	}
 
 	machine_data->dai[0].cpu_dai_name = dev_name(&ssi_pdev->dev);
 	machine_data->dai[0].ops = &mpc8610_hpcd_ops;
@@ -494,7 +496,7 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
 	ret = platform_device_add(sound_device);
 	if (ret) {
 		dev_err(&pdev->dev, "platform device add failed\n");
-		goto error;
+		goto error_sound;
 	}
 	dev_set_drvdata(&pdev->dev, sound_device);
 
@@ -502,14 +504,12 @@ static int mpc8610_hpcd_probe(struct platform_device *pdev)
 
 	return 0;
 
+error_sound:
+	platform_device_unregister(sound_device);
 error:
-	of_node_put(codec_np);
-
-	if (sound_device)
-		platform_device_unregister(sound_device);
-
 	kfree(machine_data);
-
+error_alloc:
+	of_node_put(codec_np);
 	return ret;
 }
 

