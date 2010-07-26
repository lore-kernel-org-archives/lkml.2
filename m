Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0GZIYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:24:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59735 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab0GZIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m9EDtr2QDQKU3v7y1eQz0OEsoHNG0w21KEQ9L9yedVeGQqp4S/mcNVJV8m4wRxR0tY
         JGFW9HO+NMiVuon0L2BE34DpGFCOOeNgKgQvnF9Q23Q/Jy+bECDXp42D4oRFCnx0qYAw
         kPjonmSB9htcpqnBxU8qfvW3L1Bten3lnSPuA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: nouveau: set TASK_(UN)INTERRUPTIBLE before schedule_timeout()
Date: Mon, 26 Jul 2010 12:23:54 +0400
Message-Id: <1280132635-7961-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_current_state() is called only once before the first iteration.
After return from schedule_timeout() current state is TASK_RUNNING. If
we are going to wait again, set_current_state() must be called.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
index 813d853..b7777ae 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -186,7 +186,6 @@ nouveau_fence_wait(void *sync_obj, void *sync_arg, bool lazy, bool intr)
 	unsigned long timeout = jiffies + (3 * DRM_HZ);
 	int ret = 0;
 
-	__set_current_state(intr ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
 
 	while (1) {
 		if (nouveau_fence_signalled(sync_obj, sync_arg))
@@ -197,6 +196,8 @@ nouveau_fence_wait(void *sync_obj, void *sync_arg, bool lazy, bool intr)
 			break;
 		}
 
+		__set_current_state(intr ? TASK_INTERRUPTIBLE
+			: TASK_UNINTERRUPTIBLE);
 		if (lazy)
 			schedule_timeout(1);
 
-- 
1.7.0.4

