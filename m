Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1HTSHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 14:07:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1HTSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 14:07:51 -0400
Date: Thu, 18 Aug 2011 16:50:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH] dmatest: make dmatest threads freezable
Message-ID: <Pine.LNX.4.64.1108181648370.5245@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:RNP3QzzlI/tlRmd2IUu5bu+P74mXdF7jVIvlVueMIxJ
 jJf2T08H3CFrwCbf0gAkuParR4b8HYk13mBLa43pW7BPSfD5Zi
 7llHgOGo9YnWoEkAUwX+RFs/lRv1WefXC5mJ2e/X7vGBaZGrG0
 TtypD/EjHO9rY2KJPxGKv+kZQSvHlC7mftbMtVQd6S+trfUS3d
 SzGmhLJTjAMfIrGrZEqrqmrfMg4DUM7w/or0aRupbQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making dmatest threads freezable allows its use for system PM testing.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/dmatest.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 765f5ff..fc0ea6c 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -10,6 +10,7 @@
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/freezer.h>
 #include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
@@ -251,6 +252,7 @@ static int dmatest_func(void *data)
 	int			i;
 
 	thread_name = current->comm;
+	set_freezable_with_signal();
 
 	ret = -ENOMEM;
 
@@ -305,7 +307,8 @@ static int dmatest_func(void *data)
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
 		struct completion cmp;
-		unsigned long tmo = msecs_to_jiffies(timeout);
+		unsigned long start, tmo, end = 0 /* compiler... */;
+		bool reload = true;
 		u8 align = 0;
 
 		total_tests++;
@@ -404,7 +407,17 @@ static int dmatest_func(void *data)
 		}
 		dma_async_issue_pending(chan);
 
-		tmo = wait_for_completion_timeout(&cmp, tmo);
+		do {
+			start = jiffies;
+			if (reload)
+				end = start + msecs_to_jiffies(timeout);
+			else if (end <= start)
+				end = start + 1;
+			tmo = wait_for_completion_interruptible_timeout(&cmp,
+								end - start);
+			reload = try_to_freeze();
+		} while (tmo == -ERESTARTSYS);
+
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
 		if (tmo == 0) {
-- 
1.7.2.5

