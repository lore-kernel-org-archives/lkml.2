Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2CLOCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:02:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2CLOCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:02:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] tile_edac: Fix the memory controller ID
Date: Mon, 12 Mar 2012 11:01:57 -0300
Message-Id: <1331560917-14071-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression introduced by changeset 7b03829a8ba4:

-       mci = edac_mc_alloc(sizeof(struct tile_edac_priv),
-               TILE_EDAC_NR_CSROWS, TILE_EDAC_NR_CHANS, pdev->id);
+       mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
+                           sizeof(struct tile_edac_priv));

The pdev->id is missing.

Compile-tested only. Btw, in order to compile it, I had to:

1) comment a header at arch/tile/include/asm/linkage.h:

	-#include <feedback.h>
	+//#include <feedback.h>

2) Use the ./arch/tile/configs/tilegx_defconfig . the tilepro_defconfig
   is broken;

3) manually enable the EDAC module on it.

Somebody has to fix it ;)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/tile_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index 9a91826..3e878bf 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -141,7 +141,7 @@ static int __devinit tile_edac_mc_probe(struct platform_device *pdev)
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = TILE_EDAC_NR_CHANS;
 	layers[1].is_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, false,
+	mci = edac_mc_alloc(pdev->id, ARRAY_SIZE(layers), layers, false,
 			    sizeof(struct tile_edac_priv));
 	if (mci == NULL)
 		return -ENOMEM;
-- 
1.7.8

