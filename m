Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2LMOK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2LMOKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Rogozhkin <dmitry.v.rogozhkin@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 163/241] drm/i915: EBUSY status handling added to i915_gem_fault().
Date: Thu, 13 Dec 2012 11:58:48 -0200
Message-Id: <1355407206-17100-164-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fc6683a..4dc8a9b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1144,6 +1144,11 @@ out:
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
-- 
1.7.9.5

