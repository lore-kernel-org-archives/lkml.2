Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab1GAEg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 00:36:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:38616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1GAEg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 00:36:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="22221742"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [PATCH] i915: silence gcc warnings with CONFIG_BUG disabled
Date: Thu, 30 Jun 2011 21:36:14 -0700
Message-Id: <1356458e54b6de3c2ae4bea7744f3ddd85bce0cc.1309494974.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_BUG disabled, gcc issues the following warnings:

drivers/gpu/drm/i915/intel_display.c:773: warning: ‘state_string’ defined but not used
drivers/gpu/drm/i915/intel_display.c: In function ‘intel_pin_and_fence_fb_obj’:
drivers/gpu/drm/i915/intel_display.c:1790: warning: ‘alignment’ may be used uninitialized in this function

Fix the "state_string()" error with a __maybe_unused tag.

Fix the "alignment" error by assigning it to 0 in the default case,
this avoids an unecessary initialization in the common case.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/i915/intel_display.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 21b6f93..adf483e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -770,7 +770,7 @@ void intel_wait_for_pipe_off(struct drm_device *dev, int pipe)
 	}
 }
 
-static const char *state_string(bool enabled)
+static __maybe_unused const char *state_string(bool enabled)
 {
 	return enabled ? "on" : "off";
 }
@@ -1808,6 +1808,8 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev,
 		DRM_ERROR("Y tiled not allowed for scan out buffers\n");
 		return -EINVAL;
 	default:
+		/* silence gcc uninitialized warnings with CONFIG_BUG not set */
+		alignment = 0;
 		BUG();
 	}
 
-- 
1.7.1

