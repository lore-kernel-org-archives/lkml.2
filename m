Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1GCKIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 06:08:00 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24197 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab1GCKH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 06:07:58 -0400
Date: Sun, 3 Jul 2011 11:58:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] nouveau: Don't leak in nva3_pm_clock_pre()
Message-ID: <alpine.LNX.2.00.1107031156450.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If nva3_calc_pll() returns less than 0 in
drivers/gpu/drm/nouveau/nva3_pm.c:nva3_pm_clock_pre() we'll return
without freeing 'pll'.
This patch should fix the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/nouveau/nva3_pm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

  Compile tested only - no hardware to test for real.

diff --git a/drivers/gpu/drm/nouveau/nva3_pm.c b/drivers/gpu/drm/nouveau/nva3_pm.c
index e4b2b9e..80443d2 100644
--- a/drivers/gpu/drm/nouveau/nva3_pm.c
+++ b/drivers/gpu/drm/nouveau/nva3_pm.c
@@ -137,8 +137,10 @@ nva3_pm_clock_pre(struct drm_device *dev, struct nouveau_pm_level *perflvl,
 
 	if (!pll->new_div) {
 		ret = nva3_calc_pll(dev, &limits, khz, &N, NULL, &M, &P);
-		if (ret < 0)
+		if (ret < 0) {
+			kfree(pll);
 			return ERR_PTR(ret);
+		}
 
 		pll->new_pnm = (P << 16) | (N << 8) | M;
 		pll->new_div = 2 - 1;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

