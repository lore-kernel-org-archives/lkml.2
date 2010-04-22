Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0DVTx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:53:27 -0400
Received: from kroah.org ([198.145.64.141]:40862 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab0DVT2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:39 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.174409231@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>,
       Dave Airlie <airlied@redhat.com>
Subject: [087/197] drm/radeon: R300 AD only has one quad pipe.
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>

commit 57b54ea6b7863ccfeb41851b5f58f9fd1b83c79e upstream.

Gleaned from the Mesa code.

Fixes https://bugs.freedesktop.org/show_bug.cgi?id=27355 .

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/r300.c      |    5 +++--
 drivers/gpu/drm/radeon/radeon_cp.c |   10 ++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -346,11 +346,12 @@ void r300_gpu_init(struct radeon_device
 
 	r100_hdp_reset(rdev);
 	/* FIXME: rv380 one pipes ? */
-	if ((rdev->family == CHIP_R300) || (rdev->family == CHIP_R350)) {
+	if ((rdev->family == CHIP_R300 && rdev->pdev->device != 0x4144) ||
+	    (rdev->family == CHIP_R350)) {
 		/* r300,r350 */
 		rdev->num_gb_pipes = 2;
 	} else {
-		/* rv350,rv370,rv380 */
+		/* rv350,rv370,rv380,r300 AD */
 		rdev->num_gb_pipes = 1;
 	}
 	rdev->num_z_pipes = 1;
--- a/drivers/gpu/drm/radeon/radeon_cp.c
+++ b/drivers/gpu/drm/radeon/radeon_cp.c
@@ -417,8 +417,9 @@ static int radeon_do_wait_for_idle(drm_r
 	return -EBUSY;
 }
 
-static void radeon_init_pipes(drm_radeon_private_t *dev_priv)
+static void radeon_init_pipes(struct drm_device *dev)
 {
+	drm_radeon_private_t *dev_priv = dev->dev_private;
 	uint32_t gb_tile_config, gb_pipe_sel = 0;
 
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV530) {
@@ -436,11 +437,12 @@ static void radeon_init_pipes(drm_radeon
 		dev_priv->num_gb_pipes = ((gb_pipe_sel >> 12) & 0x3) + 1;
 	} else {
 		/* R3xx */
-		if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R300) ||
+		if (((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R300 &&
+		     dev->pdev->device != 0x4144) ||
 		    ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_R350)) {
 			dev_priv->num_gb_pipes = 2;
 		} else {
-			/* R3Vxx */
+			/* RV3xx/R300 AD */
 			dev_priv->num_gb_pipes = 1;
 		}
 	}
@@ -736,7 +738,7 @@ static int radeon_do_engine_reset(struct
 
 	/* setup the raster pipes */
 	if ((dev_priv->flags & RADEON_FAMILY_MASK) >= CHIP_R300)
-	    radeon_init_pipes(dev_priv);
+	    radeon_init_pipes(dev);
 
 	/* Reset the CP ring */
 	radeon_do_cp_reset(dev_priv);


