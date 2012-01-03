Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2ACWjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033Ab2ACWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:21 2012
Message-Id: <20120103223321.582682324@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [07/75] drm/i915: prevent division by zero when asking for chipset power
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit 4ed0b577457eb6aeb7cdc7e7316576e63d15abb2 upstream.

This prevents an in-kernel division by zero which happens when we are
asking for i915_chipset_val too quickly, or within a race condition
between the power monitoring thread and userspace accesses via debugfs.

The issue can be reproduced easily via the following command:
while ``; do cat /sys/kernel/debug/dri/0/i915_emon_status; done

This is particularly dangerous because it can be triggered by
a non-privileged user by just reading the debugfs entry.

This issue was also found independently by Konstantin Belousov
<kostikbel@gmail.com>, who proposed a similar patch.

Reported-by: Konstantin Belousov <kostikbel@gmail.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |   10 ++++++++++
 drivers/gpu/drm/i915/i915_drv.h |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1453,6 +1453,14 @@ unsigned long i915_chipset_val(struct dr
 
 	diff1 = now - dev_priv->last_time1;
 
+	/* Prevent division-by-zero if we are asking too fast.
+	 * Also, we don't get interesting results if we are polling
+	 * faster than once in 10ms, so just return the saved value
+	 * in such cases.
+	 */
+	if (diff1 <= 10)
+		return dev_priv->chipset_power;
+
 	count1 = I915_READ(DMIEC);
 	count2 = I915_READ(DDREC);
 	count3 = I915_READ(CSIEC);
@@ -1483,6 +1491,8 @@ unsigned long i915_chipset_val(struct dr
 	dev_priv->last_count1 = total_count;
 	dev_priv->last_time1 = now;
 
+	dev_priv->chipset_power = ret;
+
 	return ret;
 }
 
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -707,6 +707,7 @@ typedef struct drm_i915_private {
 
 	u64 last_count1;
 	unsigned long last_time1;
+	unsigned long chipset_power;
 	u64 last_count2;
 	struct timespec last_time2;
 	unsigned long gfx_power;


