Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0HXAMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:12:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:60822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0HXAM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:12:27 -0400
Message-Id: <89kc63$hrmse5@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208";a="599486917"
Date: Tue, 24 Aug 2010 01:12:22 +0100
To: Sitsofe Wheeler <sitsofe@yahoo.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION, i915]: Periodic stalls with 2.6.36-rc2
References: <20100823233551.GA31920@sucs.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100823233551.GA31920@sucs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 00:35:51 +0100, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Hi,
> 
> With 2.6.36-rc2 I see periodic stalls when running with a stock Ubuntu
> 10.04 userspace. These stalls were not present in 2.6.36-rc1 on an EeePC
> 900 with an i915.

>From the error message, I'd suggest we'd tackle hangcheck - it simply
shouldn't be firing at all under normal circumstances. (Looking at it we
don't handle the introduction of the BSD ring correctly, but that is
irrelevant on the EeePC 900.)

Do the stalls and tearing go away with:

diff --git a/drivers/gpu/drm/i915/i915_irq.c
b/drivers/gpu/drm/i915/i915_irq.c
index e4d42a7..dc5fb4f 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1305,8 +1305,7 @@ void i915_hangcheck_elapsed(unsigned long data)
                dev_priv->hangcheck_count = 0;
 
                /* Issue a wake-up to catch stuck h/w. */
-               if (dev_priv->render_ring.waiting_gem_seqno |
-                   dev_priv->bsd_ring.waiting_gem_seqno) {
+               if (0) {
                        DRM_ERROR("Hangcheck timer elapsed... GPU idle, missed IRQ.\n");
                        if (dev_priv->render_ring.waiting_gem_seqno)
                                DRM_WAKEUP(&dev_priv->render_ring.irq_queue);

-- 
Chris Wilson, Intel Open Source Technology Centre
