Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1EUACQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:58587 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab1EUACI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="5514053"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/12] Force always inline for gcc 4.5 when optimizing for size
Date: Fri, 20 May 2011 17:01:11 -0700
Message-Id: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I found that gcc 4.5 didn't inline a lot of inlines with
CONFIG_OPTIMIZE_INLINING and CONFIG_CC_OPTIMIZE_FOR_SIZE. It was quite
common to have very small inlines to be out of line, or worse inline
statics in include files to be out of line with a copy for every file
using it too.

This is handily visible in a function graph trace for might_fault:

 10)               |    might_fault() {
 10)               |      _cond_resched() {
 10)               |        should_resched() {
 10)               |          need_resched() {
 10)   0.063 us    |            test_ti_thread_flag();
 10)   0.643 us    |          }
 10)   1.238 us    |        }
 10)   1.845 us    |      }
 10)   2.438 us    |    }

Note all of these functions are very small and should be definitely
inlined in each other. In many cases even copy_from_user
ends up out of line now which is really bad!

If I switch to -O2 it is also not quite as bad, but since a lot
of people use -Os I was trying to fix it up.

So this patch forces inlining with gcc 4.4 with -Os.

Unfortunately it costs some code size with just this patch.

   text	   data	    bss	    dec	    hex	filename
11507035	1940276	1191936	14639247	 df608f	vmlinux-O2
10189858	1908124	1187840	13285822	 cab9be	vmlinux-Os-force
9808525		1940204	1187840	12936569 	 c56579	vmlinux-Os-orig

But after some starring on bloat-o-meter it turned out only
some subsystems (in my kernel) had a real problem. The biggest
offender was DRM. I fixed those up manually by removing
inlines. With these changes (and disabling DRM debugging, which is on
by default) I get a kernel with force inline that is a few KB smaller.
With DRM debugging enabled it's about 50k larger (nearly
all of it in DRM, mostly radeon). I hope the default for this
can be changed.

I haven't tested earlier gcc 4.x versions, but they may need
the same treatment.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/compiler-gcc.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cb4c1eb..0f2b513 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -40,9 +40,12 @@
 /*
  * Force always-inline if the user requests it so via the .config,
  * or if gcc is too old:
+ * When optimizing for size on gcc 4.5 always force inlining too.
  */
 #if !defined(CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING) || \
-    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4)
+    !defined(CONFIG_OPTIMIZE_INLINING) || (__GNUC__ < 4) || \
+    (defined(CONFIG_CC_OPTIMIZE_FOR_SIZE) && \
+		(__GNUC__ == 4 && __GNUC_MINOR__ == 5))
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
-- 
1.7.4.4

