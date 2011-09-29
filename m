Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab1I2LCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:02:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34922 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755336Ab1I2LCr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:02:47 -0400
Subject: [PATCH 3/4] kmemleak: When the early log buffer is exceeded,
 report the actual number
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 29 Sep 2011 12:02:34 +0100
Message-ID: <20110929110234.10660.59748.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-118-g0cb4
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2011 11:02:42.0566 (UTC) FILETIME=[4F7D1260:01CC7E97]
X-MC-Unique: 111092912024503001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just telling that the early log buffer has been exceeded doesn't mean
much. This patch moves the error printing to the kmemleak_init()
function and displays the actual calls to the kmemleak API during early
logging.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 573152e..e6dd17b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -797,9 +797,13 @@ static void __init log_early(int op_type, const void *ptr, size_t size,
 	unsigned long flags;
 	struct early_log *log;
 
+	if (atomic_read(&kmemleak_error)) {
+		/* kmemleak stopped recording, just count the requests */
+		crt_early_log++;
+		return;
+	}
+
 	if (crt_early_log >= ARRAY_SIZE(early_log)) {
-		pr_warning("Early log buffer exceeded, "
-			   "please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n");
 		kmemleak_disable();
 		return;
 	}
@@ -1634,7 +1638,6 @@ static void kmemleak_disable(void)
 		return;
 
 	/* stop any memory operation tracing */
-	atomic_set(&kmemleak_early_log, 0);
 	atomic_set(&kmemleak_enabled, 0);
 
 	/* check whether it is too early for a kernel thread */
@@ -1694,12 +1697,18 @@ void __init kmemleak_init(void)
 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);
 	INIT_PRIO_TREE_ROOT(&object_tree_root);
 
+	if (crt_early_log >= ARRAY_SIZE(early_log))
+		pr_warning("Early log buffer exceeded (%d), please increase "
+			   "DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n", crt_early_log);
+
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
-	if (!atomic_read(&kmemleak_error)) {
+	atomic_set(&kmemleak_early_log, 0);
+	if (atomic_read(&kmemleak_error)) {
+		local_irq_restore(flags);
+		return;
+	} else
 		atomic_set(&kmemleak_enabled, 1);
-		atomic_set(&kmemleak_early_log, 0);
-	}
 	local_irq_restore(flags);
 
 	/*


