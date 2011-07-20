Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1GTDYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 23:24:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57050 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1GTDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 23:24:10 -0400
X-Nat-Received: from [202.181.97.72]:60743 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1311131972.18633
Message-Id: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp>
Subject: [PATCH linux-next-20110718] Fix build error at mm/slab.c .
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Jul 2011 12:19:32 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 20072011 #5646396, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_SLAB_MINALIGN might be defined as

  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)

but gcc 3.3 cannot understand

  #if __alignof__(unsigned long long)

line.

  CC      mm/slab.o
mm/slab.c:3156:5: warning: "__alignof__" is not defined
mm/slab.c:3156:5: missing binary operator before token "("
make[1]: *** [mm/slab.o] Error 1
make: *** [mm] Error 2

Use "if (ARCH_SLAB_MINALIGN)" rather than "#if ARCH_SLAB_MINALIGN".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/slab.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-3.0-next.orig/mm/slab.c
+++ linux-3.0-next/mm/slab.c
@@ -3153,12 +3153,9 @@ static void *cache_alloc_debugcheck_afte
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
-#if ARCH_SLAB_MINALIGN
-	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
+	if (ARCH_SLAB_MINALIGN && ((u32)objp & (ARCH_SLAB_MINALIGN-1)))
 		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
 		       objp, ARCH_SLAB_MINALIGN);
-	}
-#endif
 	return objp;
 }
 #else
