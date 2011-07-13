Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1GMNYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:24:41 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:63461 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab1GMNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:24:35 -0400
X-AuditID: 1209190f-b7c82ae000000a20-e4-4e1d9c89a721
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andy Lutomirski <luto@MIT.EDU>, Clemens Ladisch <clemens@ladisch.de>,
        linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3 5/8] clocksource: Replace vread with generic arch data
Date: Wed, 13 Jul 2011 09:24:13 -0400
Message-Id: <3ae5ec76a168eaaae63f08a2a1060b91aa0b7759.1310563276.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
In-Reply-To: <cover.1310563276.git.luto@mit.edu>
References: <cover.1310563276.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsUixG6nrts5R9bP4MU3U4u+K0fZLS42bmOx
	WHLiIZNF2zRHi9a189ktPnS8Y7W4vGsOm8WWS82sFptO/Ga02LxpKrPFmwv3WCx+bHjM6sDj
	0f3oE6PHrbY/zB47Z91l91i85yWTx6ZVnWweP1b0M3u8O3eO3ePctT5mj8+b5AI4o7hsUlJz
	MstSi/TtErgyNl9azVRwX7li1vIVrA2MG2S7GDk4JARMJLqnxnUxcgKZYhIX7q1n62Lk4hAS
	2McocetqOyNIQkhgA6PExg3sEIlnTBLzFk5jAkmwCahIdCx9wAQySERASGLp3TqQGmaB1cwS
	Pz8+YQapERbwlPi6fh07SA2LgKrE1DVBIGFegSCJH/e3s0IslpM4cvk52EhOAQOJOQtusEPs
	1Zd43nGYGZf4BEaBBYwMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3RN9HIzS/RSU0o3MYJigFOS
	fwfjt4NKhxgFOBiVeHil4mX8hFgTy4orcw8xSnIwKYnyqs6W9RPiS8pPqcxILM6ILyrNSS0+
	xCjBwawkwlvfAJTjTUmsrEotyodJSXOwKInzlnv/9xUSSE8sSc1OTS1ILYLJynBwKEnwigNj
	XUiwKDU9tSItM6cEIc3EwQkynAdouDBIDW9xQWJucWY6RP4UozFH/+a5Rxg5Tp1ZcIRRiCUv
	Py9VSpxXB6RUAKQ0ozQPbhosjb1iFAd6TpjXFqSKB5gC4ea9AlrFBLRqnRXYqpJEhJRUA+O0
	B+nBG7XlVpe1xvVnpFhWrc5awc+W/p5DxeXlMi6zZGP+ipfPX3PHqsYGPj7/1zc0R8ttRsvU
	tIVa0zIe1STMlZhjvnvFOY/N229bHjXYEOddF36JafecC6+PB33g2rhYUuxP2PTFq6P2f69r
	WWR4UHR/gUR3/o8NVUuXpobs1/1dcvtF0WslluKMREMt5qLiRABQv59hPgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vread field was bloating struct clocksource everywhere except
x86_64, and I want to change the way this works on x86_64, so let's
split it out into per-arch data.

Cc: x86@kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-ia64@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/clocksource.h |   16 ++++++++++++++++
 arch/x86/kernel/hpet.c             |    2 +-
 arch/x86/kernel/tsc.c              |    2 +-
 arch/x86/kernel/vsyscall_64.c      |    2 +-
 include/asm-generic/clocksource.h  |    4 ++++
 include/linux/clocksource.h        |   10 ++++++++--
 6 files changed, 31 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/include/asm/clocksource.h
 create mode 100644 include/asm-generic/clocksource.h

diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
new file mode 100644
index 0000000..a5df33f
--- /dev/null
+++ b/arch/x86/include/asm/clocksource.h
@@ -0,0 +1,16 @@
+/* x86-specific clocksource additions */
+
+#ifndef _ASM_X86_CLOCKSOURCE_H
+#define _ASM_X86_CLOCKSOURCE_H
+
+#ifdef CONFIG_X86_64
+
+#define __ARCH_HAS_CLOCKSOURCE_DATA
+
+struct arch_clocksource_data {
+	cycle_t (*vread)(void);
+};
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_CLOCKSOURCE_H */
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index e9f5605..0e07257 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -753,7 +753,7 @@ static struct clocksource clocksource_hpet = {
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 	.resume		= hpet_resume_counter,
 #ifdef CONFIG_X86_64
-	.vread		= vread_hpet,
+	.archdata	= { .vread = vread_hpet },
 #endif
 };
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6cc6922..e7a74b8 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -777,7 +777,7 @@ static struct clocksource clocksource_tsc = {
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
 				  CLOCK_SOURCE_MUST_VERIFY,
 #ifdef CONFIG_X86_64
-	.vread                  = vread_tsc,
+	.archdata               = { .vread = vread_tsc },
 #endif
 };
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index a262400..12d488f 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -74,7 +74,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
 
 	/* copy vsyscall data */
-	vsyscall_gtod_data.clock.vread		= clock->vread;
+	vsyscall_gtod_data.clock.vread		= clock->archdata.vread;
 	vsyscall_gtod_data.clock.cycle_last	= clock->cycle_last;
 	vsyscall_gtod_data.clock.mask		= clock->mask;
 	vsyscall_gtod_data.clock.mult		= mult;
diff --git a/include/asm-generic/clocksource.h b/include/asm-generic/clocksource.h
new file mode 100644
index 0000000..0a462d3
--- /dev/null
+++ b/include/asm-generic/clocksource.h
@@ -0,0 +1,4 @@
+/*
+ * Architectures should override this file to add private userspace
+ * clock magic if needed.
+ */
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 18a1baf..9ab6b6a 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -22,6 +22,8 @@
 typedef u64 cycle_t;
 struct clocksource;
 
+#include <asm/clocksource.h>
+
 /**
  * struct cyclecounter - hardware abstraction for a free running counter
  *	Provides completely state-free accessors to the underlying hardware.
@@ -153,7 +155,7 @@ extern u64 timecounter_cyc2time(struct timecounter *tc,
  * @shift:		cycle to nanosecond divisor (power of two)
  * @max_idle_ns:	max idle time permitted by the clocksource (nsecs)
  * @flags:		flags describing special properties
- * @vread:		vsyscall based read
+ * @archdata:		arch-specific data
  * @suspend:		suspend function for the clocksource, if necessary
  * @resume:		resume function for the clocksource, if necessary
  */
@@ -175,10 +177,14 @@ struct clocksource {
 #else
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
+
+#ifdef __ARCH_HAS_CLOCKSOURCE_DATA
+	struct arch_clocksource_data archdata;
+#endif
+
 	const char *name;
 	struct list_head list;
 	int rating;
-	cycle_t (*vread)(void);
 	int (*enable)(struct clocksource *cs);
 	void (*disable)(struct clocksource *cs);
 	unsigned long flags;
-- 
1.7.6

