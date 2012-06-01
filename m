Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2FAM13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:27:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48867 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2FAM0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:26:32 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 3/5] vmevent: Refresh vmstats before sampling
Date: Fri,  1 Jun 2012 05:24:04 -0700
Message-Id: <1338553446-22292-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120601122118.GA6128@lizard>
References: <20120601122118.GA6128@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On SMP, kernel updates vmstats only once per second, which makes vmevent
unusable. Let's fix it by updating vmstats before sampling.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/vmevent.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 4ca2a04..35fd0d5 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -2,6 +2,7 @@
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/vmevent.h>
+#include <linux/mm.h>
 #include <linux/syscalls.h>
 #include <linux/workqueue.h>
 #include <linux/file.h>
@@ -163,6 +164,9 @@ static void vmevent_sample(struct vmevent_watch *watch)
 
 	if (atomic_read(&watch->pending))
 		return;
+
+	refresh_vm_stats();
+
 	if (!vmevent_match(watch))
 		return;
 
-- 
1.7.9.2

