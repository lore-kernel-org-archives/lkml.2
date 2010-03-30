Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0C3XRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:17:23 -0400
Received: from kroah.org ([198.145.64.141]:51682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab0C3XRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:20 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:55:56 2010
Message-Id: <20100330225555.505413415@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:54:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Eric Anholt <eric@anholt.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [001/116] drm/i915: fix gpio register detection logic for BIOS without VBT
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 29874f44fbcbc24b231b42c9956f8f9de9407231 upstream.

if no VBT is present, crt_ddc_bus will be left at 0, and cause us
to use that for the GPIO register offset. That's never a valid register
offset, so let the "undefined" value be 0 instead of -1.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
[anholt: clarified the commit message a bit]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.h   |    2 +-
 drivers/gpu/drm/i915/intel_bios.c |    4 ----
 drivers/gpu/drm/i915/intel_crt.c  |    2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -258,7 +258,7 @@ typedef struct drm_i915_private {
 
 	struct notifier_block lid_notifier;
 
-	int crt_ddc_bus; /* -1 = unknown, else GPIO to use for CRT DDC */
+	int crt_ddc_bus; /* 0 = unknown, else GPIO to use for CRT DDC */
 	struct drm_i915_fence_reg fence_regs[16]; /* assume 965 */
 	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */
 	int num_fence_regs; /* 8 on pre-965, 16 otherwise */
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -241,10 +241,6 @@ parse_general_definitions(struct drm_i91
 		GPIOF,
 	};
 
-	/* Set sensible defaults in case we can't find the general block
-	   or it is the wrong chipset */
-	dev_priv->crt_ddc_bus = -1;
-
 	general = find_section(bdb, BDB_GENERAL_DEFINITIONS);
 	if (general) {
 		u16 block_size = get_blocksize(general);
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -557,7 +557,7 @@ void intel_crt_init(struct drm_device *d
 	else {
 		i2c_reg = GPIOA;
 		/* Use VBT information for CRT DDC if available */
-		if (dev_priv->crt_ddc_bus != -1)
+		if (dev_priv->crt_ddc_bus != 0)
 			i2c_reg = dev_priv->crt_ddc_bus;
 	}
 	intel_output->ddc_bus = intel_i2c_create(dev, i2c_reg, "CRTDDC_A");


