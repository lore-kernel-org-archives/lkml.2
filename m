Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030723Ab2CFNcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:32:06 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49135 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030554Ab2CFNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:32:02 -0500
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Date: Tue,  6 Mar 2012 14:31:31 +0100
Message-Id: <1331040694-12558-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1331040694-12558-1-git-send-email-bp@amd64.org>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The idea here is to pass an additional decoded MCE message through
the tracepoint and into the ring buffer for userspace to consume. The
designated consumers are RAS daemons and other tools collecting RAS
information.

Drop unneeded fields while at it, thus saving some room in the ring
buffer.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 include/trace/events/mce.h       |   19 +++++++------------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2e9e91..072e020ecaf3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -144,7 +144,7 @@ void mce_log(struct mce *mce)
 	int ret = 0;
 
 	/* Emit the trace record: */
-	trace_mce_record(mce);
+	trace_mce_record("", mce);
 
 	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
 	if (ret == NOTIFY_STOP)
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 4cbbcef6baa8..6fb5c2e0c5e1 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -10,11 +10,12 @@
 
 TRACE_EVENT(mce_record,
 
-	TP_PROTO(struct mce *m),
+	TP_PROTO(const char *msg, struct mce *m),
 
-	TP_ARGS(m),
+	TP_ARGS(msg, m),
 
 	TP_STRUCT__entry(
+		__string(	msg,		msg		)
 		__field(	u64,		mcgcap		)
 		__field(	u64,		mcgstatus	)
 		__field(	u64,		status		)
@@ -24,15 +25,13 @@ TRACE_EVENT(mce_record,
 		__field(	u64,		tsc		)
 		__field(	u64,		walltime	)
 		__field(	u32,		cpu		)
-		__field(	u32,		cpuid		)
-		__field(	u32,		apicid		)
 		__field(	u32,		socketid	)
 		__field(	u8,		cs		)
 		__field(	u8,		bank		)
-		__field(	u8,		cpuvendor	)
 	),
 
 	TP_fast_assign(
+		__assign_str(msg,	msg);
 		__entry->mcgcap		= m->mcgcap;
 		__entry->mcgstatus	= m->mcgstatus;
 		__entry->status		= m->status;
@@ -42,25 +41,21 @@ TRACE_EVENT(mce_record,
 		__entry->tsc		= m->tsc;
 		__entry->walltime	= m->time;
 		__entry->cpu		= m->extcpu;
-		__entry->cpuid		= m->cpuid;
-		__entry->apicid		= m->apicid;
 		__entry->socketid	= m->socketid;
 		__entry->cs		= m->cs;
 		__entry->bank		= m->bank;
-		__entry->cpuvendor	= m->cpuvendor;
 	),
 
-	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+	TP_printk("%s" HW_ERR "(CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, TIME: %llu, SOCKET: %u)",
+		__get_str(msg),
 		__entry->cpu,
 		__entry->mcgcap, __entry->mcgstatus,
 		__entry->bank, __entry->status,
 		__entry->addr, __entry->misc,
 		__entry->cs, __entry->ip,
 		__entry->tsc,
-		__entry->cpuvendor, __entry->cpuid,
 		__entry->walltime,
-		__entry->socketid,
-		__entry->apicid)
+		__entry->socketid)
 );
 
 #endif /* _TRACE_MCE_H */
-- 
1.7.8.rc0

