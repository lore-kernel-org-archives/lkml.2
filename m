Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1AXHfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:35:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1AXHfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:35:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pli9zYLGBKP7+q3YlnCKJDy8AMhS/4nFS3STtS47j67NB5ecH9s5JYC8agHPvy2d9E
         RjgpUS1/HRvFclUdUWtDaglbljUHA5gK0vibx+FgPDIkQRqOCw6aTbWXw5wy7qdy4eY6
         9v2TARlpKYZZWHbu2IqqlfEr/LDBp2T00bUJg=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com,
        ddaney@caviumnetworks.com
Subject: [RESEND PATCH v4 1/5] MIPS/Perf-events: Work with irq_work
Date: Mon, 24 Jan 2011 15:35:45 +0800
Message-Id: <1295854549-7928-2-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295854549-7928-1-git-send-email-dengcheng.zhu@gmail.com>
References: <1295854549-7928-1-git-send-email-dengcheng.zhu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the MIPS part of the following commit by Peter Zijlstra:

- e360adbe29241a0194e10e20595360dd7b98a2b3
    irq_work: Add generic hardirq context callbacks

    Provide a mechanism that allows running code in IRQ context. It is
    most useful for NMI code that needs to interact with the rest of the
    system -- like wakeup a task to drain buffers.

    Perf currently has such a mechanism, so extract that and provide it as
    a generic feature, independent of perf so that others may also
    benefit.

    The IRQ context callback is generated through self-IPIs where
    possible, or on architectures like powerpc the decrementer (the
    built-in timer facility) is set to generate an interrupt immediately.

    Architectures that don't have anything like this get to do with a
    callback from the timer tick. These architectures can call
    irq_work_run() at the tail of any IRQ handlers that might enqueue such
    work (like the perf IRQ handler) to avoid undue latencies in
    processing the work.

For MIPSXX, we need to call irq_work_run() at the tail of the perf IRQ
handler as described above.

Reported-by: Wu Zhangjin <wuzhangjin@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
Changes:
v4 - v3:
o None
v3 - v2:
o Keep all mentioned commits in the form of number + title + original
summary + (MIPS specific info when needed).
v2 - v1:
o None

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

