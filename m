Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab2FMWWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:22:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43674 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754890Ab2FMWWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:22:01 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+CaSwEByKCkRfqdG1YirpWuM4yHuqoo44AbRE/Pl
	phEOiOjBspft7R
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Peter Huewe <peterhuewe@gmx.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] staging/xgifb: Add mutext for fb_mmap locking
Date: Thu, 14 Jun 2012 00:21:40 +0200
Message-Id: <1339626112-20671-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
References: <1339626112-20671-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a mutex for fb_mmap around smem_start and smem_len
so the mutex inside the fb_mmap() is actually used.  Changing of
these fields before calling the framebuffer_register() are not mutexed.

We check whether framebuffer_register has been called by reading
fbinfo->count.

See 537a1bf0 - "fbdev: add mutex for fb_mmap locking" by Krzysztof Helt
for details.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/XGI_main_26.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ff88f1d..f427b85 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1350,10 +1350,17 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 
 	strncpy(fix->id, "XGI", sizeof(fix->id) - 1);
 
-	fix->smem_start = xgifb_info->video_base;
+	/* if register_framebuffer has been called, we must lock */
+	if (atomic_read(&info->count))
+		mutex_lock(&info->mm_lock);
 
+	fix->smem_start = xgifb_info->video_base;
 	fix->smem_len = xgifb_info->video_size;
 
+	/* if register_framebuffer has been called, we can unlock */
+	if (atomic_read(&info->count))
+		mutex_unlock(&info->mm_lock);
+
 	fix->type = FB_TYPE_PACKED_PIXELS;
 	fix->type_aux = 0;
 	if (xgifb_info->video_bpp == 8)
-- 
1.7.3.4

