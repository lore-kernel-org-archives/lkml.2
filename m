Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1JRAHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:07:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9759 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1JRAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:07:16 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
Cc: Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm: avoid switching to text console if there is no panic timeout
Date: Mon, 17 Oct 2011 17:06:40 -0700
Message-Id: <1318896400-32498-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@chromium.org>

Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
we're going to reboot immediately, the user will not be able to see the
messages anyway, and messing with the video mode may display artifacts,
and certainly get into several layers of complexity (including mutexes and
memory allocations) which we shall be much safer to avoid.

Signed-off-by: Hugh Dickins <hughd@google.com>
[ Edited commit message and modified to short-circuit panic_timeout < 0
  instead of testing panic_timeout >= 0.  -Mandeep ]
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_fb_helper.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index f7c6854..0e62c93 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -254,6 +254,13 @@ bool drm_fb_helper_force_kernel_mode(void)
 int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
 			void *panic_str)
 {
+	/*
+	 * It's a waste of time and effort to switch back to text console
+	 * if the kernel should reboot before panic messages can be seen.
+	 */
+	if (panic_timeout < 0)
+		return 0;
+
 	printk(KERN_ERR "panic occurred, switching back to text console\n");
 	return drm_fb_helper_force_kernel_mode();
 }
-- 
1.7.3.1

