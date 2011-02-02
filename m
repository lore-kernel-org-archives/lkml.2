Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1BBApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:64699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab1BBApJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028655"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [120/139] drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
Message-Id: <20110202004519.5B65E3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 86f5c9edbb3bac37cc8cee6528a929005ba72aad upstream.

This fixes module reloading and resume as the gfx block seems to
be left in a bad state in some cases.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/evergreen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.35.y/drivers/gpu/drm/radeon/evergreen.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/radeon/evergreen.c
+++ linux-2.6.35.y/drivers/gpu/drm/radeon/evergreen.c
@@ -2080,6 +2080,11 @@ int evergreen_resume(struct radeon_devic
 {
 	int r;
 
+	/* reset the asic, the gfx blocks are often in a bad state
+	 * after the driver is unloaded or after a resume
+	 */
+	if (radeon_asic_reset(rdev))
+		dev_warn(rdev->dev, "GPU reset failed !\n");
 	/* Do not reset GPU before posting, on rv770 hw unlike on r500 hw,
 	 * posting will perform necessary task to bring back GPU into good
 	 * shape.
@@ -2181,6 +2186,11 @@ int evergreen_init(struct radeon_device 
 	r = radeon_atombios_init(rdev);
 	if (r)
 		return r;
+	/* reset the asic, the gfx blocks are often in a bad state
+	 * after the driver is unloaded or after a resume
+	 */
+	if (radeon_asic_reset(rdev))
+		dev_warn(rdev->dev, "GPU reset failed !\n");
 	/* Post card if necessary */
 	if (!evergreen_card_posted(rdev)) {
 		if (!rdev->bios) {
