Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2L1TVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:21:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55721 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab2L1TT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:59 -0500
Message-Id: <20121228190335.226935053@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 025/173] drm/i915: EBUSY status handling added to i915_gem_fault().
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>

commit e79e0fe380847493266fba557217e2773c61bd1b upstream.

Subsequent threads returning EBUSY from vm_insert_pfn() was not handled
correctly. As a result concurrent access from new threads to
mmapped data caused SIGBUS.

Note that this fixes i-g-t/tests/gem_threaded_tiled_access.

Tested-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 76bbb37..5fa3419 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1400,6 +1400,11 @@ out:
 	case 0:
 	case -ERESTARTSYS:
 	case -EINTR:
+	case -EBUSY:
+		/*
+		 * EBUSY is ok: this just means that another thread
+		 * already did the job.
+		 */
 		return VM_FAULT_NOPAGE;
 	case -ENOMEM:
 		return VM_FAULT_OOM;


