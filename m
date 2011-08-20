Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1HTGNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 02:13:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59977 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1HTGMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 02:12:49 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Alexander Sverdlin <subaparts@yandex.ru>,
        Ryan Mallon <rmallon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sound/soc/ep93xx/ep93xx-i2s.c: add missing kfree
Date: Sat, 20 Aug 2011 08:12:39 +0200
Message-Id: <1313820761-12042-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Introduce a new label that includes kfree and jump to that one.

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
 sound/soc/ep93xx/ep93xx-i2s.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index 56efa0c..099614e 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -385,14 +385,14 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		err = -ENODEV;
-		goto fail;
+		goto fail_free_info;
 	}
 
 	info->mem = request_mem_region(res->start, resource_size(res),
 				       pdev->name);
 	if (!info->mem) {
 		err = -EBUSY;
-		goto fail;
+		goto fail_free_info;
 	}
 
 	info->regs = ioremap(info->mem->start, resource_size(info->mem));
@@ -435,6 +435,7 @@ fail_unmap_mem:
 	iounmap(info->regs);
 fail_release_mem:
 	release_mem_region(info->mem->start, resource_size(info->mem));
+fail_free_info:
 	kfree(info);
 fail:
 	return err;

