Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab0HEOlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:41:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:41663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423Ab0HEOkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:40 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 7/9] i915: when kgdb is active display compression should be off
Date: Thu,  5 Aug 2010 09:39:56 -0500
Message-Id: <1281019198-6777-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-7-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-5-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-6-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:09.0623 (UTC) FILETIME=[1AA4FA70:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the HW compression is left on, the call backs from the HW will
crash the kernel.  The only time this code is called is when kernel
mode setting is in use with kgdb and the kdb shell.

The atomic display pipe handler callback will reset everything when
kgdb restores kernel to the run state.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index eff28e5..714bf53 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1251,6 +1251,10 @@ static void intel_update_fbc(struct drm_crtc *crtc,
 		goto out_disable;
 	}
 
+	/* If the kernel debugger is active, always disable compression */
+	if (in_dbg_master())
+		goto out_disable;
+
 	if (intel_fbc_enabled(dev)) {
 		/* We can re-enable it in this case, but need to update pitch */
 		if ((fb->pitch > dev_priv->cfb_pitch) ||
-- 
1.6.4.rc1

