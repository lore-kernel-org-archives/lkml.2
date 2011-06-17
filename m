Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1FQQmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:42:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51152 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1FQQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:42:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pFhdTJfQIPAOPYPgSB7j8Vo+i9FcbELyFXHHCdxviuorSmydKcHy3KY46UNJozQAkt
         qOjAdbSl31SszfV51avot2Q/wNrDRiephvHzoRBSG1lmRgTQoFghgRV3EKDxGWD6dVmW
         5JbKUpSY6Htm6Bz6vXH6cFggR+LKn+Epyedto=
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>, Yi Sun <yi.sun@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mengmeng Meng <mengmeng.meng@intel.com>,
        Robert Hooker <sarvatt@ubuntu.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [PATCH 3.0-rc3, v2] i915: Fix gen6 (SNB) GPU stalling
Date: Sat, 18 Jun 2011 00:42:00 +0800
Message-Id: <1308328920-2068-1-git-send-email-daniel.blueman@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround Sandy Bridge GPU stalls by allowing the blitter command streamer
to write interrupt state to the Hardware Status Page when a MI_USER_INTERRUPT
command is decoded.

v1->v2: Moved to prior interrupt handler installation and RMW flags as per
feedback.

Eric, if you're happy, please sign-off and send to Dave for inclusion in -rc4
if possible. Further changes may be needed for -stable.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
---
 drivers/gpu/drm/i915/i915_irq.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b9fafe3..b7f11a5 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1741,6 +1741,13 @@ void ironlake_irq_preinstall(struct drm_device *dev)
 
 	I915_WRITE(HWSTAM, 0xeffe);
 
+	if (IS_GEN6(dev))
+		/* workaround stalls observed on Sandy Bridge GPUs by
+		   allowing the blitter command streamer to generate a
+		   write to the Hardware Status Page for MI_USER_INTERRUPT */
+		I915_WRITE(GEN6_BLITTER_HWSTAM, I915_READ(GEN6_BLITTER_HWSTAM)
+			& ~GEN6_BLITTER_USER_INTERRUPT);
+
 	/* XXX hotplug from PCH */
 
 	I915_WRITE(DEIMR, 0xffffffff);
-- 
1.7.4.1

