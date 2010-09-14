Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0INTk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:40:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0INTk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:40:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/18] m68k: remove big kernel lock
Date: Tue, 14 Sep 2010 21:40:11 +0200
Message-Id: <1284493213-7263-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493139-7233-1-git-send-email-arnd@arndb.de>
References: <1284493139-7233-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PzApYKEF9KG192FsmrrDDC/pPT5b4OU3NEQnJO0U2uq
 3DRps4uPWw7hUFkr7hOUHMjXGt9W6cmh2qHseHS2Ff7aKx+JgK
 fuWm/CLzjbwK5Qrtrc+Y+4pzxIyRDD377vHRzvwf2E1NeLf+NM
 x85olkAGgA+eWDCa0xRaDUrQ96JKIGMQ9vkOu+tSIjXfXG0dD3
 NrLM5rsbC9ZQeHy/3viaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache flush code only locks against itself, so there
is no excuse to use the BKL here. This replaces it with
a local mutex in order to maintain serialization of flushes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/kernel/sys_m68k.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 2f431ec..f6aec52 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -12,7 +12,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
@@ -374,10 +374,11 @@ cache_flush_060 (unsigned long addr, int scope, int cache, unsigned long len)
 asmlinkage int
 sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 {
+	static DEFINE_MUTEX(cacheflush_mutex);
 	struct vm_area_struct *vma;
 	int ret = -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&cacheflush_mutex);
 	if (scope < FLUSH_SCOPE_LINE || scope > FLUSH_SCOPE_ALL ||
 	    cache & ~FLUSH_CACHE_BOTH)
 		goto out;
@@ -446,7 +447,7 @@ sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 	    }
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&cacheflush_mutex);
 	return ret;
 }
 
-- 
1.7.1

