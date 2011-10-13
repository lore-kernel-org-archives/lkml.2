Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab1JMXJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:09:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:61259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab1JMXI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62778877"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/12] Force always inline for gcc 4.5 when optimizing for size
Date: Thu, 13 Oct 2011 16:08:52 -0700
Message-Id: <1318547332-23155-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
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

So this patch forces inlining with gcc 4.5 with -Os.

Unfortunately it costs some code size with just this patch.

   text	   data	    bss	    dec	    hex	filename
11507035	1940276	1191936	14639247	 df608f	vmlinux-O2
10189858	1908124	1187840	13285822	 cab9be	vmlinux-Os-force
9808525		1940204	1187840	12936569 	 c56579	vmlinux-Os-orig

It turned out most of this was because of unnecessary inlines.
With a lot of inlines removed I now get:

11175824        1977200 1191936 14344960         dae300 vmlinux-inlines-removed-no-optimize
11642530        2018416 1191936 14852882         e2a312 vmlinux-master-no-optimize
11530439        2001264 1191936 14723639         e0aa37 vmlinux-master-optimize

which is significantly smaller.

I haven't tested earlier gcc 4.x versions, but they may need
the same treatment.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/compiler-gcc.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 59e4028..e477a7c 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -44,9 +44,12 @@
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

