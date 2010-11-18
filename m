Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0KRHBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:01:34 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:60464 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0KRHBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EqmQhW4pKawkY1rkXoO+2GROQbANS76eK9lNt2lJ4iHXf5RcC/f12IS5Mxhyy7s8kB
         H2kGiS2N5IVoKMgl3RiBku/+I/NdtIEsXC08ataSSK2Jjg/oh4sm052s0XO8XpV9JTlr
         tG0bd8AbJVGCzXJDT6pdiBdwFMm2XVpJFCFQM=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 1/5] MIPS/Perf-events: Work with irq_work
Date: Thu, 18 Nov 2010 14:56:37 +0800
Message-Id: <1290063401-25440-2-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MIPS part of the following commit by Peter Zijlstra:

e360adbe29241a0194e10e20595360dd7b98a2b3
	irq_work: Add generic hardirq context callbacks

Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/perf_event.h   |   12 +-----------
 arch/mips/kernel/perf_event_mipsxx.c |    2 +-
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 67a2fa2..c44c38d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,6 +4,7 @@ config MIPS
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
diff --git a/arch/mips/include/asm/perf_event.h b/arch/mips/include/asm/perf_event.h
index e00007c..d0c7749 100644
--- a/arch/mips/include/asm/perf_event.h
+++ b/arch/mips/include/asm/perf_event.h
@@ -11,15 +11,5 @@
 
 #ifndef __MIPS_PERF_EVENT_H__
 #define __MIPS_PERF_EVENT_H__
-
-/*
- * MIPS performance counters do not raise NMI upon overflow, a regular
- * interrupt will be signaled. Hence we can do the pending perf event
- * work at the tail of the irq handler.
- */
-static inline void
-set_perf_event_pending(void)
-{
-}
-
+/* Leave it empty here. The file is required by linux/perf_event.h */
 #endif /* __MIPS_PERF_EVENT_H__ */
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 5c7c6fc..fa00edc 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -696,7 +696,7 @@ static int mipsxx_pmu_handle_shared_irq(void)
 	 * interrupt, not NMI.
 	 */
 	if (handled == IRQ_HANDLED)
-		perf_event_do_pending();
+		irq_work_run();
 
 #ifdef CONFIG_MIPS_MT_SMP
 	read_unlock(&pmuint_rwlock);
-- 
1.7.1

