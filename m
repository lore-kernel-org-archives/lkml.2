Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1GYBQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:16:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32878 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1GYBQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:16:37 -0400
Date: Mon, 25 Jul 2011 11:16:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonas Bonn <jonas@southpole.se>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the origin tree
Message-Id: <20110725111627.0b0d8c8f0b73cff8f6ab85e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After merging the origin tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Presumably caused by commit a87e553fabe8 ("asm-generic: delay.h fix
udelay and ndelay for 8 bit args").
drivers/staging/gma500/psb_intel_display.c has a udelay
(20000) which is explicitly disallowed by this patch.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Jul 2011 11:13:13 +1000
Subject: [PATCH] gma500: udlay(20000) is too large

So we use mdelay(20) instead.  Fixes this build error:

ERROR: "__bad_udelay" [drivers/staging/gma500/psb_gfx.ko] undefined!

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/gma500/psb_intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 4f47d09..09e378d 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -331,7 +331,7 @@ static bool psb_intel_find_best_PLL(struct drm_crtc *crtc, int target,
 void psb_intel_wait_for_vblank(struct drm_device *dev)
 {
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
-	udelay(20000);
+	mdelay(20);
 }
 
 int psb_intel_pipe_set_base(struct drm_crtc *crtc,
-- 
1.7.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
