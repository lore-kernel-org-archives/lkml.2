Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2GaUbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:31:18 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:12537 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2GaUbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:31:17 -0400
Date: Tue, 31 Jul 2012 22:31:15 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Airlie <airlied@linux.ie>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jesse.barnes@intel.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Fix mem leak in intel_sdvo_write_cmd()
Message-ID: <alpine.LNX.2.00.1207312228270.7100@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the allocation of 'buf' succeeds but the allocation of 'msgs' fails
we'll return false and leak 'buf' when it goes out of scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

 note: compile tested only due to lack of hardware.

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 26a6a4d..1f73e24 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -444,13 +444,12 @@ static bool intel_sdvo_write_cmd(struct intel_sdvo *intel_sdvo, u8 cmd,
 	struct i2c_msg *msgs;
 	int i, ret = true;
 
-	buf = (u8 *)kzalloc(args_len * 2 + 2, GFP_KERNEL);
-	if (!buf)
-		return false;
-
+	buf = kzalloc(args_len * 2 + 2, GFP_KERNEL);
 	msgs = kcalloc(args_len + 3, sizeof(*msgs), GFP_KERNEL);
-	if (!msgs)
-		return false;
+	if (!msgs || !buf) {
+		ret = false;
+		goto out;
+	}
 
 	intel_sdvo_debug_write(intel_sdvo, cmd, args, args_len);
 
-- 
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

