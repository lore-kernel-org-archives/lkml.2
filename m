Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0GWCMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:12:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:57695 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0GWCMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:12:35 -0400
From: Dongdong Deng <dongdong.deng@windriver.com>
To: jason.wessel@windriver.com, fweisbec@gmail.com, will.deacon@arm.com,
        lethal@linux-sh.org, mahesh@linux.vnet.ibm.com,
        prasad@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org
Cc: mingo@elte.hu, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] hw-breakpoints, kgdb, x86: add a flag to pass DIE_DEBUG notification
Date: Fri, 23 Jul 2010 10:16:01 +0800
Message-Id: <1279851361-32604-1-git-send-email-dongdong.deng@windriver.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 23 Jul 2010 02:11:42.0944 (UTC) FILETIME=[64CECE00:01CB2A0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw_breakpoint subsystem consumes all the hardware
breakpoint exceptions since it hooks the notify_die
handlers first, this means that kgdb doesn't get the
opportunity to handle hw breakpoint exceptions generated
by kgdb itself.

This patch adds an extend flag to perf_event_attr for
hw_breakpoint_handler() to decide to pass or stop the
DIE_DEBUG notification.

As KGDB set that flag, hw_breakpoint_handler() will pass
the DIE_DEBUG notification, thus kgdb have the chance
to take DIE_DEBUG notification.

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
---
 arch/x86/kernel/hw_breakpoint.c |   14 ++++++++++++++
 arch/x86/kernel/kgdb.c          |    2 ++
 include/linux/perf_event.h      |    9 +++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index a8f1b80..b38f786 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -406,6 +406,8 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
  * ii) When there are more bits than trap<n> set in DR6 register (such
  * as BD, BS or BT) indicating that more than one debug condition is
  * met and requires some more action in do_debug().
+ * iii) The source of hw breakpoint event want to handle the event
+ * by itself, currently just KGDB have this notion.
  *
  * NOTIFY_STOP returned for all other cases
  *
@@ -464,6 +466,18 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 			break;
 		}
 
+		if (bp->attr.flag == SKIP_HWBP_EVENT_PERF_FLAG) {
+			/*
+			 * when attr.flag is set to SKIP_HWBP_EVENT_PERF_FLAG
+			 * it indicates currently hw breakpoint event
+			 * source want to handle this event by itself.
+			 * thus return NOTIFY_DONE here.
+			 */
+			rc = NOTIFY_DONE;
+			rcu_read_unlock();
+			break;
+		}
+
 		perf_bp_event(bp, args->regs);
 
 		rcu_read_unlock();
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 4f4af75..bc3321f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -641,6 +641,8 @@ void kgdb_arch_late(void)
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
+	/* set kgdb's special requires flag to perf_event */
+	attr.flag = SKIP_HWBP_EVENT_PERF_FLAG;
 	for (i = 0; i < 4; i++) {
 		if (breakinfo[i].pev)
 			continue;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5d0266d..fcefb09 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -160,6 +160,11 @@ enum perf_event_read_format {
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
 
+enum perf_event_attr_flag {
+	NOSET_PERF_FLAG               = 0,
+	SKIP_HWBP_EVENT_PERF_FLAG     = 1,
+};
+
 /*
  * Hardware event_id to monitor via a performance monitoring event:
  */
@@ -225,6 +230,10 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+	/*
+	 * Ext flag, currently just kgdb used it.
+	 */
+	enum perf_event_attr_flag	flag;
 };
 
 /*
-- 
1.6.0.4

