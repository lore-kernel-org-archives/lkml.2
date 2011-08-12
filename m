Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1HNQHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:07:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1HNQHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.516350646@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>
Subject: [27/90] drm/i915: Hold mode_config->mutex during hotplug processing
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit a65e34c79c88895766ab1f8a5afa451eed26622b upstream.

Hotplug detection is a mode setting operation and must hold the
struct_mutex or risk colliding with other mode setting operations.

In particular, the display port hotplug function attempts to re-train
the link if the monitor is supposed to be running when plugged back
in. If that happens while mode setting is underway, the link will get
scrambled, leaving it in an inconsistent state.

This is a special case -- usually the driver mode setting entry points
are covered by the upper level DRM code, but in this case the function
is invoked as a work function not under the control of DRM.

Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -306,6 +306,7 @@ static void i915_hotplug_work_func(struc
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct intel_encoder *encoder;
 
+	mutex_lock(&mode_config->mutex);
 	DRM_DEBUG_KMS("running encoder hotplug functions\n");
 
 	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
@@ -314,6 +315,8 @@ static void i915_hotplug_work_func(struc
 
 	/* Just fire off a uevent and let userspace tell us what to do */
 	drm_helper_hpd_irq_event(dev);
+
+	mutex_unlock(&mode_config->mutex);
 }
 
 static void i915_handle_rps_change(struct drm_device *dev)


