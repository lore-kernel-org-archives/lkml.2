Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2DAUlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:41:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:54150 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2DAUjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 05/11] blackfin: fix cmpxchg build fails from system.h fallout
Date: Sun,  1 Apr 2012 16:38:41 -0400
Message-Id: <1333312727-11428-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3bed8d67469cc7129b0babc0211c32fa68408ce0

    "Disintegrate asm/system.h for Blackfin [ver #2]"

introduced arch/blackfin/include/asm/cmpxchg.h but has it also
including the asm-generic one which causes this:

  CC      arch/blackfin/kernel/asm-offsets.s
  In file included from arch/blackfin/include/asm/cmpxchg.h:125:0,
                 from arch/blackfin/include/asm/atomic.h:10,
                 from include/linux/atomic.h:4,
                 from include/linux/spinlock.h:384,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/blackfin/kernel/asm-offsets.c:10:
  include/asm-generic/cmpxchg.h:24:15: error: redefinition of '__xchg'
  arch/blackfin/include/asm/cmpxchg.h:82:29: note: previous definition of '__xchg' was here
  In file included from arch/blackfin/include/asm/atomic.h:10:0,
                 from include/linux/atomic.h:4,
                 from include/linux/spinlock.h:384,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/blackfin/kernel/asm-offsets.c:10:
  arch/blackfin/include/asm/cmpxchg.h:129:0: warning: "xchg" redefined [enabled by default]
  include/asm-generic/cmpxchg.h:81:0: note: this is the location of the previous definition
  make[2]: *** [arch/blackfin/kernel/asm-offsets.s] Error 1

It really only needs two simple defines from asm-generic, so just
use those instead.

Cc: Bob Liu <lliubbo@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/blackfin/include/asm/cmpxchg.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/include/asm/cmpxchg.h b/arch/blackfin/include/asm/cmpxchg.h
index ba2484f..c05868c 100644
--- a/arch/blackfin/include/asm/cmpxchg.h
+++ b/arch/blackfin/include/asm/cmpxchg.h
@@ -122,7 +122,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			(unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-#include <asm-generic/cmpxchg.h>
+#define cmpxchg(ptr, o, n)	cmpxchg_local((ptr), (o), (n))
+#define cmpxchg64(ptr, o, n)	cmpxchg64_local((ptr), (o), (n))
 
 #endif /* !CONFIG_SMP */
 
-- 
1.7.9.1

