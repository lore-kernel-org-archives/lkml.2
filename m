Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0LHBpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:45:04 -0500
Received: from kroah.org ([198.145.64.141]:48740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab0LHBAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:14 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:29 2010
Message-Id: <20101208005729.545228191@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [082/289] drm/radeon/kms: properly compute group_size on 6xx/7xx
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 881fe6c1d06bf49f4ab7aef212cdaf66bd059614 upstream.

Needed for tiled surfaces.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r600.c  |    7 +++++--
 drivers/gpu/drm/radeon/rv770.c |    9 +++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1608,8 +1608,11 @@ void r600_gpu_init(struct radeon_device
 	rdev->config.r600.tiling_npipes = rdev->config.r600.max_tile_pipes;
 	rdev->config.r600.tiling_nbanks = 4 << ((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	tiling_config |= BANK_TILING((ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
-	tiling_config |= GROUP_SIZE(0);
-	rdev->config.r600.tiling_group_size = 256;
+	tiling_config |= GROUP_SIZE((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
+	if ((ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
+		rdev->config.r600.tiling_group_size = 512;
+	else
+		rdev->config.r600.tiling_group_size = 256;
 	tmp = (ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT;
 	if (tmp > 3) {
 		tiling_config |= ROW_TILING(3);
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -643,10 +643,11 @@ static void rv770_gpu_init(struct radeon
 	else
 		gb_tiling_config |= BANK_TILING((mc_arb_ramcfg & NOOFBANK_MASK) >> NOOFBANK_SHIFT);
 	rdev->config.rv770.tiling_nbanks = 4 << ((gb_tiling_config >> 4) & 0x3);
-
-	gb_tiling_config |= GROUP_SIZE(0);
-	rdev->config.rv770.tiling_group_size = 256;
-
+	gb_tiling_config |= GROUP_SIZE((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT);
+	if ((mc_arb_ramcfg & BURSTLENGTH_MASK) >> BURSTLENGTH_SHIFT)
+		rdev->config.rv770.tiling_group_size = 512;
+	else
+		rdev->config.rv770.tiling_group_size = 256;
 	if (((mc_arb_ramcfg & NOOFROWS_MASK) >> NOOFROWS_SHIFT) > 3) {
 		gb_tiling_config |= ROW_TILING(3);
 		gb_tiling_config |= SAMPLE_SPLIT(3);


