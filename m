Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab1IOW5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:57:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:43409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935243Ab1IOW5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48919099"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf_events: Pass the event to perf_instruction_pointer
Date: Thu, 15 Sep 2011 15:56:50 -0700
Message-Id: <1316127412-1912-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Used in next patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    3 ++-
 arch/powerpc/kernel/perf_event.c             |    3 ++-
 arch/x86/include/asm/perf_event.h            |    3 ++-
 arch/x86/kernel/cpu/perf_event.c             |    3 ++-
 include/linux/perf_event.h                   |    2 +-
 kernel/events/core.c                         |    2 +-
 6 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 8f1df12..ea82ec3 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -59,7 +59,8 @@ extern int register_power_pmu(struct power_pmu *);
 
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
-extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs,
+					      struct perf_event *event);
 
 #define PERF_EVENT_INDEX_OFFSET	1
 
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 10a140f..9067e0a 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1281,7 +1281,8 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
  * Called from generic code to get the instruction pointer
  * for an event_id.
  */
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
+unsigned long perf_instruction_pointer(struct pt_regs *regs,
+				       struct perf_event *event)
 {
 	unsigned long ip;
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 094fb30..790479f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -137,7 +137,8 @@ extern void perf_events_lapic_init(void);
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 
 struct pt_regs;
-extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs, 
+					      struct perf_event *event);
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 #define perf_misc_flags(regs)	perf_misc_flags(regs)
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index cfa62ec..373a614 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1923,7 +1923,8 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 	}
 }
 
-unsigned long perf_instruction_pointer(struct pt_regs *regs)
+unsigned long perf_instruction_pointer(struct pt_regs *regs,
+				       struct perf_event *event)
 {
 	unsigned long ip;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c816075..f8b93ec 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1129,7 +1129,7 @@ extern void perf_bp_event(struct perf_event *event, void *data);
 #ifndef perf_misc_flags
 # define perf_misc_flags(regs) \
 		(user_mode(regs) ? PERF_RECORD_MISC_USER : PERF_RECORD_MISC_KERNEL)
-# define perf_instruction_pointer(regs)	instruction_pointer(regs)
+# define perf_instruction_pointer(regs,event)	instruction_pointer(regs)
 #endif
 
 extern int perf_output_begin(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f85778..7f5c966 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4004,7 +4004,7 @@ void perf_prepare_sample(struct perf_event_header *header,
 	__perf_event_header__init_id(header, data, event);
 
 	if (sample_type & PERF_SAMPLE_IP)
-		data->ip = perf_instruction_pointer(regs);
+		data->ip = perf_instruction_pointer(regs, event);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
-- 
1.7.4.4

