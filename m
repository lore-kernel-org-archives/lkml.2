Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112Ab1C3VJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:33640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977Ab1C3VJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133809"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: anton@samba.org, a.p.zijlstra@chello.nl, ak@linux.intel.com, mingo@elte.hu,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [210/275] perf, powerpc: Handle events that raise an exception without overflowing
Message-Id: <20110330210734.C95103E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Anton Blanchard <anton@samba.org>

commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 upstream.

Events on POWER7 can roll back if a speculative event doesn't
eventually complete. Unfortunately in some rare cases they will
raise a performance monitor exception. We need to catch this to
ensure we reset the PMC. In all cases the PMC will be 256 or less
cycles from overflow.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20110309143842.6c22845e@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/reg.h   |    1 +
 arch/powerpc/kernel/perf_event.c |   24 +++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/powerpc/include/asm/reg.h
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/include/asm/reg.h	2011-03-29 22:50:34.616372673 -0700
+++ linux-2.6.35.y/arch/powerpc/include/asm/reg.h	2011-03-29 23:03:02.632232817 -0700
@@ -878,6 +878,7 @@
 #define PV_970		0x0039
 #define PV_POWER5	0x003A
 #define PV_POWER5p	0x003B
+#define PV_POWER7	0x003F
 #define PV_970FX	0x003C
 #define PV_630		0x0040
 #define PV_630p	0x0041
Index: linux-2.6.35.y/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/kernel/perf_event.c	2011-03-29 22:50:34.616372673 -0700
+++ linux-2.6.35.y/arch/powerpc/kernel/perf_event.c	2011-03-29 23:03:02.633232791 -0700
@@ -1230,6 +1230,28 @@
 	return ip;
 }
 
+static bool pmc_overflow(unsigned long val)
+{
+	if ((int)val < 0)
+		return true;
+
+	/*
+	 * Events on POWER7 can roll back if a speculative event doesn't
+	 * eventually complete. Unfortunately in some rare cases they will
+	 * raise a performance monitor exception. We need to catch this to
+	 * ensure we reset the PMC. In all cases the PMC will be 256 or less
+	 * cycles from overflow.
+	 *
+	 * We only do this if the first pass fails to find any overflowing
+	 * PMCs because a user might set a period of less than 256 and we
+	 * don't want to mistakenly reset them.
+	 */
+	if (__is_processor(PV_POWER7) && ((0x80000000 - val) <= 256))
+		return true;
+
+	return false;
+}
+
 /*
  * Performance monitor interrupt stuff
  */
@@ -1277,7 +1299,7 @@
 			if (is_limited_pmc(i + 1))
 				continue;
 			val = read_pmc(i + 1);
-			if ((int)val < 0)
+			if (pmc_overflow(val))
 				write_pmc(i + 1, 0);
 		}
 	}
