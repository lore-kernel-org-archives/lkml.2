Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab0ERVYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:24:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41938 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab0ERVYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=BB89QvXwaenfAmW6msY4oeJkIBY1ig0Gb4ltQumKVSANHKzV7PcFsdwETnMLEP/uc8
         tZdgi22xu7oczLjTRYmXmsjpXCp+dZfoL8ZXf0OtdsK74Uc1cxfJNl5lD4QDp4Nr2TZ4
         XvID82etM4L5HIjfTYcm+o42cEGAEfYeuvZQY=
Message-Id: <20100518212439.542226770@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 19 May 2010 01:19:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Stephane Eranian <eranian@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 4/4] x86,perf: P4 PMU -- prepare header for user-space inclusion
References: <20100518211916.407689068@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-export
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header need to be exported to be able to use P4 PMU
in user space applications (for RAW events mostly).

So before make a real export it should sit under linux
sources just to estimate the convenience of its structure.

Note that cache events are not exported at the moment since
they should be redesigned a bit (we need to export and support
the whole metrics set for those who need them for some wild
experiments).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/perf_event_p4.h |   38 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -5,9 +5,6 @@
 #ifndef PERF_EVENT_P4_H
 #define PERF_EVENT_P4_H
 
-#include <linux/cpu.h>
-#include <linux/bitops.h>
-
 /*
  * NetBurst has perfomance MSRs shared between
  * threads if HT is turned on, ie for both logical
@@ -19,7 +16,6 @@
 #define ARCH_P4_RESERVED_ESCR	(2) /* IQ_ESCR(0,1) not always present */
 #define ARCH_P4_MAX_ESCR	(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
 #define ARCH_P4_MAX_CCCR	(18)
-#define ARCH_P4_MAX_COUNTER	(ARCH_P4_MAX_CCCR / 2)
 
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
@@ -71,10 +67,6 @@
 #define P4_CCCR_THRESHOLD(v)		((v) << P4_CCCR_THRESHOLD_SHIFT)
 #define P4_CCCR_ESEL(v)			((v) << P4_CCCR_ESCR_SELECT_SHIFT)
 
-/* Custom bits in reerved CCCR area */
-#define P4_CCCR_CACHE_OPS_MASK		0x0000003fU
-
-
 /* Non HT mask */
 #define P4_CCCR_MASK				\
 	(P4_CCCR_OVF			|	\
@@ -96,6 +88,17 @@
 	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_EMASK_BIT(class, name)		class##__##name
 
+#ifdef __KERNEL__
+
+#include <linux/cpu.h>
+#include <linux/bitops.h>
+
+/*
+ * Cache events are special and we use low 6 bits in
+ * CCCR reserved area for them
+ */
+#define P4_CCCR_CACHE_OPS_MASK		0x0000003fU
+
 /*
  * config field is 64bit width and consists of
  * HT << 63 | ESCR << 32 | CCCR
@@ -214,6 +217,14 @@ static inline u32 p4_default_escr_conf(i
 	return escr;
 }
 
+#endif /* __KERNEL__ */
+
+/*
+ * This are the events which should be used in "Event Select"
+ * field of ESCR register, they are like unique keys which allow
+ * the kernel to determinate which CCCR and COUNTER should be
+ * used to track an event
+ */
 enum P4_EVENTS {
 	P4_EVENT_TC_DELIVER_MODE,
 	P4_EVENT_BPU_FETCH_REQUEST,
@@ -263,6 +274,8 @@ enum P4_EVENTS {
 	P4_EVENT_INSTR_COMPLETED,
 };
 
+#ifdef __KERNEL__
+
 #define P4_OPCODE(event)		event##_OPCODE
 #define P4_OPCODE_ESEL(opcode)		((opcode & 0x00ff) >> 0)
 #define P4_OPCODE_EVNT(opcode)		((opcode & 0xff00) >> 8)
@@ -557,11 +570,13 @@ enum P4_EVENT_OPCODES {
 	 */
 };
 
+#endif /* __KERNEL__ */
+
 /*
  * a caller should use P4_ESCR_EMASK_NAME helper to
  * pick the EventMask needed, for example
  *
- *	P4_ESCR_EMASK_NAME(P4_EVENT_TC_DELIVER_MODE, DD)
+ *	P4_ESCR_EMASK_BIT(P4_EVENT_TC_DELIVER_MODE, DD)
  */
 enum P4_ESCR_EMASKS {
 	P4_GEN_ESCR_EMASK(P4_EVENT_TC_DELIVER_MODE, DD, 0),
@@ -753,6 +768,8 @@ enum P4_ESCR_EMASKS {
 	P4_GEN_ESCR_EMASK(P4_EVENT_INSTR_COMPLETED, BOGUS, 1),
 };
 
+#ifdef __KERNEL__
+
 /* P4 PEBS: stale for a while */
 #define P4_PEBS_METRIC_MASK	0x00001fffU
 #define P4_PEBS_UOB_TAG		0x01000000U
@@ -792,4 +809,7 @@ enum P4_CACHE_EVENTS {
 	P4_CACHE__MAX
 };
 
+#endif /* __KERNEL__ */
+
 #endif /* PERF_EVENT_P4_H */
+

