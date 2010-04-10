Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0DJUEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:04:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12632 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0DJUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=k0O1SnDmI7sARzlCaRQf0XjS3LPgkP8STca4hBRq5nXrY+MePAcUaZw38dvOvkmNd/
         FQFFPDSChxvm327eHQJ6KTkspTimRkiQq/6yTJQiKp4ZLzkWSCZ7+XecQ25fcWw486Yj
         Oil+AP/KRJSvX09UX0TRqOjfJQ9Fo9sZfTmYk=
From: marcin.slusarz@gmail.com
To: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Cc: nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>, Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] fbmem: fix aperture overlapping check
Date: Sat, 10 Apr 2010 21:55:32 +0200
Message-Id: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fb_do_apertures_overlap is returning wrong value when one aperture
is completely whithin the other. Add generic ranges_overlap macro
(probably kernel.h candidate) and use it here.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Peter Jones <pjones@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/fbmem.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index a15b44e..41f2e5e 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1468,15 +1468,25 @@ static int fb_check_foreignness(struct fb_info *fi)
 	return 0;
 }
 
+/**
+ * ranges_overlap - check whether two ranges overlap (their intersection is not empty)
+ * @start1: start of the first range
+ * @size1:  length of the first range
+ * @start2: start of the second range
+ * @size2:  length of the second range
+ */
+#define ranges_overlap(start1, size1, start2, size2) ({	\
+	typeof(start1) __start1 = (start1);		\
+	typeof(size1)  __size1  = (size1);		\
+	typeof(start2) __start2 = (start2);		\
+	typeof(size2)  __size2  = (size2);		\
+	__start1 < __start2 + __size2 && __start1 + __size1 > __start2; \
+})
+
 static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
 {
-	/* is the generic aperture base the same as the HW one */
-	if (gen->aperture_base == hw->aperture_base)
-		return true;
-	/* is the generic aperture base inside the hw base->hw base+size */
-	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)
-		return true;
-	return false;
+	return ranges_overlap(gen->aperture_base, gen->aperture_size,
+				hw->aperture_base, hw->aperture_size);
 }
 /**
  *	register_framebuffer - registers a frame buffer device
-- 
1.7.0.4

