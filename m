Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0HaUyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:54:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0HaUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:54:00 -0400
X-Authority-Analysis: v=1.1 cv=h9FjAN2ougM9pVhvDq3M6+cWFo1DP5/t8S/Ny2XAPyw= c=1 sm=0 a=Z-yiUSIHDfwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=YoxM-lRnAAAA:8 a=meVymXHHAAAA:8 a=2Eb3M-HBDHbGhLOxzIAA:9 a=gMDuhlW99jDBfKOEI4MA:7 a=hqz3wTj3hV_q4evp6TWP5-Q7mpIA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] tracing/lockdep: Fix dependency of TRACE_IRQFLAGS
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Richard Kennedy <richard@rsk.demon.co.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 16:53:58 -0400
Message-ID: <1283288038.1377.465.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This only fixes a build warning, so I'm guessing that it can wait till
2.6.37. If you think otherwise, I could add it to my tip/perf/urgent
branch instead.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (1):
      tracing/lockdep: Fix dependency of TRACE_IRQFLAGS

----
 lib/Kconfig.debug |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
---------------------------
commit 46b93b74fc022885ab69dfc8e2af0562dd626638
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Aug 31 16:35:20 2010 -0400

    tracing/lockdep: Fix dependency of TRACE_IRQFLAGS
    
    When CONFIG_IRQSOFF_TRACER is set and CONFIG_PROVE_LOCKING is not, we
    get the following error:
    
    $  make oldconfig
    scripts/kconfig/conf --oldconfig arch/x86/Kconfig
    warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE && TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING)
    warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE && TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING)
    
    This is because IRQSOFF_TRACER selects TRACE_IRQFLAGS but TRACE_IRQFLAGS
    has PROVE_LOCKING as a dependency. This code is incorrect, and
    this patch changes the TRACE_IRQFLAGS to be just a simple bool that
    does not depend or select anything. Instead both IRQSOFF_TRACER and
    PROVE_LOCKING select it.
    
    Reported-by: Richard Kennedy <richard@rsk.demon.co.uk>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..e85d549 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -482,6 +482,7 @@ config PROVE_LOCKING
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
 	select DEBUG_LOCK_ALLOC
+	select TRACE_IRQFLAGS
 	default n
 	help
 	 This feature enables the kernel to prove that all locking
@@ -579,11 +580,10 @@ config DEBUG_LOCKDEP
 	  of more runtime overhead.
 
 config TRACE_IRQFLAGS
-	depends on DEBUG_KERNEL
 	bool
-	default y
-	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on PROVE_LOCKING
+	help
+	  Enables hooks to interrupt enabling and disabling for
+	  either tracing or lock debugging.
 
 config DEBUG_SPINLOCK_SLEEP
 	bool "Spinlock debugging: sleep-inside-spinlock checking"


