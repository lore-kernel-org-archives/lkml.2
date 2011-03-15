Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1CODtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 23:49:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45593 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab1CODtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 23:49:13 -0400
Date: Tue, 15 Mar 2011 14:49:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexdeucher@gmail.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20110315144908.c245696a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/radeon/ni.c: In function 'cayman_cp_enable':
drivers/gpu/drm/radeon/ni.c:1042: error: 'struct radeon_mc' has no member named 'active_vram_size'

Caused by commit 0c88a02ef6b7 ("drm/radeon/kms: add support for CP setup
on cayman asics") interacting with commit 5359533801e3 ("drm/radeon: fix
problem with changing active VRAM size. (v2)") from Linus' tree.

I allied the following fix up patch for today (I am not sure if it is
correct).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 15 Mar 2011 14:44:59 +1100
Subject: [PATCH] drm/radeon/kms: update for active_vram_size removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/gpu/drm/radeon/ni.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 8c199c4..7aade20 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1039,7 +1039,7 @@ static void cayman_cp_enable(struct radeon_device *rdev, bool enable)
 	if (enable)
 		WREG32(CP_ME_CNTL, 0);
 	else {
-		rdev->mc.active_vram_size = rdev->mc.visible_vram_size;
+		radeon_ttm_set_active_vram_size(rdev, rdev->mc.visible_vram_size);
 		WREG32(CP_ME_CNTL, (CP_ME_HALT | CP_PFP_HALT));
 		WREG32(SCRATCH_UMSK, 0);
 	}
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
