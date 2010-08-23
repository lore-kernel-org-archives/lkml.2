Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0HWWhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:37:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:41686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab0HWWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:37:00 -0400
Message-Id: <8u3s8d$jcc0rr@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,259,1280732400"; 
   d="scan'208";a="650511227"
Date: Mon, 23 Aug 2010 23:36:55 +0100
To: Jonathan Corbet <corbet@lwn.net>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
References: <20100823110145.08eb72fd@bike.lwn.net> <20100823151708.6b242599@bike.lwn.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100823151708.6b242599@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 15:17:08 -0600, Jonathan Corbet <corbet@lwn.net> wrote:
> I went ahead and bisected the problem, which was added between -rc1 and
> -rc2.  The end result is this:

Taking the patch at face value, the cause should be a mistake in error
handling. So the first step would be to identify which i2c_transfer()
failed.

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 093e914..6afc7cf 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -269,7 +269,7 @@ static bool intel_sdvo_read_byte(struct intel_sdvo *intel_sdvo, u8 addr, u8 *ch)
 		return true;
 	}
 
-	DRM_DEBUG_KMS("i2c transfer returned %d\n", ret);
+	WARN(1, "i2c transfer failed, ret=%d\n", ret);
 	return false;
 }
 
@@ -284,8 +284,13 @@ static bool intel_sdvo_write_byte(struct intel_sdvo *intel_sdvo, int addr, u8 ch
 			.buf = out_buf,
 		}
 	};
+	int ret;
+
+	if ((ret = i2c_transfer(intel_sdvo->base.i2c_bus, msgs, 1)) == 1)
+		return true;
 
-	return i2c_transfer(intel_sdvo->base.i2c_bus, msgs, 1) == 1;
+	WARN(1, "i2c transfer failed, ret=%d\n", ret);
+	return false;
 }
 
 #define SDVO_CMD_NAME_ENTRY(cmd) {cmd, #cmd}

-- 
Chris Wilson, Intel Open Source Technology Centre
