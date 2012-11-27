Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2K0MQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:16:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45770 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2K0MQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:16:39 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH] perf tools: fix build for various architectures
Date: Tue, 27 Nov 2012 12:16:31 +0000
Message-Id: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 27 Nov 2012 12:16:35.0897 (UTC) FILETIME=[0B857290:01CDCC99]
X-MC-Unique: 112112712163610801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qARCGi5O000629

The UAPI changes broke the perf tool, and as of 3.7-rc7, it
still won't build for arm:

	In file included from util/../perf.h:81:0,
			 from util/cache.h:7,
			 from perf.c:12:
	util/../../../arch/arm/include/asm/unistd.h:16:29: fatal error: uapi/asm/unistd.h: No such file or directory
	compilation terminated.
	make: *** [perf.o] Error 1

It seems the perf tool build infrastructure can't map <uapi/*> paths,
and several architectures (arm, arm64, ia64, mips, parisc, powerpc,
s390) include <uapi/asm/unistd.h> from their <asm/unistd.h>.

This patch copies 77626081: "perf tools: Fix build on sparc." in simply
changing the path to use arch/arm/include/uapi/asm/unistd.h directly for
all of these cases.

I've tested this on arm, but I don't have the necessary toolchains to
check the other cases.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 tools/perf/perf.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c50985e..b42fd6a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -26,14 +26,14 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
+#include "../../arch/powerpc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
 #endif
 
 #ifdef __s390__
-#include "../../arch/s390/include/asm/unistd.h"
+#include "../../arch/s390/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("bcr 15,0" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
@@ -50,7 +50,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __hppa__
-#include "../../arch/parisc/include/asm/unistd.h"
+#include "../../arch/parisc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("" ::: "memory")
 #define cpu_relax()	asm volatile("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
@@ -71,14 +71,14 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __ia64__
-#include "../../arch/ia64/include/asm/unistd.h"
+#include "../../arch/ia64/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile ("mf" ::: "memory")
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #define CPUINFO_PROC	"model name"
 #endif
 
 #ifdef __arm__
-#include "../../arch/arm/include/asm/unistd.h"
+#include "../../arch/arm/include/uapi/asm/unistd.h"
 /*
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
@@ -89,13 +89,13 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __aarch64__
-#include "../../arch/arm64/include/asm/unistd.h"
+#include "../../arch/arm64/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("dmb ld" ::: "memory")
 #define cpu_relax()	asm volatile("yield" ::: "memory")
 #endif
 
 #ifdef __mips__
-#include "../../arch/mips/include/asm/unistd.h"
+#include "../../arch/mips/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile(					\
 				".set	mips2\n\t"			\
 				"sync\n\t"				\
-- 
1.7.0.4


