Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab1BPLTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:19:33 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:48259 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab1BPLT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:19:28 -0500
Message-Id: <20110216111923.544389637@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Wed, 16 Feb 2011 12:01:19 +0100
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: [patch v2 1/3] Put parameters in a structure and pass the pointer to the struct instead
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,
References: <20110216110118.316927092@linux.vnet.ibm.com>
Content-Disposition: inline; filename=oprofile_parms_struct.patch

From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>

To reduce the number of parameters in various functions use a struct to host specific sample input data.
 
Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
---
 drivers/oprofile/cpu_buffer.c |  105 +++++++++++++++++++++++++-----------------
 drivers/oprofile/cpu_buffer.h |    9 +++
 2 files changed, 73 insertions(+), 41 deletions(-)

Index: s390/drivers/oprofile/cpu_buffer.c
===================================================================
--- s390.orig/drivers/oprofile/cpu_buffer.c
+++ s390/drivers/oprofile/cpu_buffer.c
@@ -1,12 +1,13 @@
 /**
  * @file cpu_buffer.c
  *
- * @remark Copyright 2002-2009 OProfile authors
+ * @remark Copyright 2002-2011 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
  * @author Barry Kasindorf <barry.kasindorf@amd.com>
  * @author Robert Richter <robert.richter@amd.com>
+ * @author Heinz Graalfs <graalfs@linux.vnet.ibm.com>
  *
  * Each CPU has a local buffer that stores PC value/event
  * pairs. We also log context switches when we notice them.
@@ -179,8 +180,8 @@ unsigned long op_cpu_buffer_entries(int
 }
 
 static int
-op_add_code(struct oprofile_cpu_buffer *cpu_buf, unsigned long backtrace,
-	    int is_kernel, struct task_struct *task)
+op_add_code(struct oprofile_cpu_buffer *cpu_buf,
+		    struct oprofile_sample_parms *parms)
 {
 	struct op_entry entry;
 	struct op_sample *sample;
@@ -189,21 +190,21 @@ op_add_code(struct oprofile_cpu_buffer *
 
 	flags = 0;
 
-	if (backtrace)
+	if (parms->backtrace)
 		flags |= TRACE_BEGIN;
 
 	/* notice a switch from user->kernel or vice versa */
-	is_kernel = !!is_kernel;
-	if (cpu_buf->last_is_kernel != is_kernel) {
-		cpu_buf->last_is_kernel = is_kernel;
+	parms->is_kernel = !!parms->is_kernel;
+	if (cpu_buf->last_is_kernel != parms->is_kernel) {
+		cpu_buf->last_is_kernel = parms->is_kernel;
 		flags |= KERNEL_CTX_SWITCH;
-		if (is_kernel)
+		if (parms->is_kernel)
 			flags |= IS_KERNEL;
 	}
 
 	/* notice a task switch */
-	if (cpu_buf->last_task != task) {
-		cpu_buf->last_task = task;
+	if (cpu_buf->last_task != parms->task) {
+		cpu_buf->last_task = parms->task;
 		flags |= USER_CTX_SWITCH;
 	}
 
@@ -224,7 +225,7 @@ op_add_code(struct oprofile_cpu_buffer *
 	sample->event = flags;
 
 	if (size)
-		op_cpu_buffer_add_data(&entry, (unsigned long)task);
+		op_cpu_buffer_add_data(&entry, (unsigned long)parms->task);
 
 	op_cpu_buffer_write_commit(&entry);
 
@@ -233,7 +234,7 @@ op_add_code(struct oprofile_cpu_buffer *
 
 static inline int
 op_add_sample(struct oprofile_cpu_buffer *cpu_buf,
-	      unsigned long pc, unsigned long event)
+		      struct oprofile_sample_parms *parms)
 {
 	struct op_entry entry;
 	struct op_sample *sample;
@@ -242,8 +243,8 @@ op_add_sample(struct oprofile_cpu_buffer
 	if (!sample)
 		return -ENOMEM;
 
-	sample->eip = pc;
-	sample->event = event;
+	sample->eip = parms->pc;
+	sample->event = parms->event;
 
 	return op_cpu_buffer_write_commit(&entry);
 }
@@ -256,23 +257,23 @@ op_add_sample(struct oprofile_cpu_buffer
  * pc. We tag this in the buffer by generating kernel enter/exit
  * events whenever is_kernel changes
  */
+
 static int
-log_sample(struct oprofile_cpu_buffer *cpu_buf, unsigned long pc,
-	   unsigned long backtrace, int is_kernel, unsigned long event,
-	   struct task_struct *task)
+log_sample(struct oprofile_cpu_buffer *cpu_buf,
+	   struct oprofile_sample_parms *parms)
 {
-	struct task_struct *tsk = task ? task : current;
+	parms->task = parms->task ? parms->task : current;
 	cpu_buf->sample_received++;
 
-	if (pc == ESCAPE_CODE) {
+	if (parms->pc == ESCAPE_CODE) {
 		cpu_buf->sample_invalid_eip++;
 		return 0;
 	}
 
-	if (op_add_code(cpu_buf, backtrace, is_kernel, tsk))
+	if (op_add_code(cpu_buf, parms))
 		goto fail;
 
-	if (op_add_sample(cpu_buf, pc, event))
+	if (op_add_sample(cpu_buf, parms))
 		goto fail;
 
 	return 1;
@@ -293,26 +294,24 @@ static inline void oprofile_end_trace(st
 }
 
 static inline void
-__oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
-			  unsigned long event, int is_kernel,
-			  struct task_struct *task)
+__oprofile_add_ext_sample(struct oprofile_sample_parms *parms)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
-	unsigned long backtrace = oprofile_backtrace_depth;
+	parms->backtrace = oprofile_backtrace_depth;
 
 	/*
 	 * if log_sample() fail we can't backtrace since we lost the
 	 * source of this event
 	 */
-	if (!log_sample(cpu_buf, pc, backtrace, is_kernel, event, task))
+	if (!log_sample(cpu_buf, parms))
 		/* failed */
 		return;
 
-	if (!backtrace)
+	if (!parms->backtrace)
 		return;
 
 	oprofile_begin_trace(cpu_buf);
-	oprofile_ops.backtrace(regs, backtrace);
+	oprofile_ops.backtrace(parms->regs, parms->backtrace);
 	oprofile_end_trace(cpu_buf);
 }
 
@@ -320,29 +319,41 @@ void oprofile_add_ext_hw_sample(unsigned
 				unsigned long event, int is_kernel,
 				struct task_struct *task)
 {
-	__oprofile_add_ext_sample(pc, regs, event, is_kernel, task);
+	struct oprofile_sample_parms parms = {
+		.pc = pc, .backtrace = 0, .event = event,
+		.is_kernel = is_kernel, .regs = regs,
+		.task = task ? task : current
+	};
+
+	__oprofile_add_ext_sample(&parms);
 }
 
 void oprofile_add_ext_sample(unsigned long pc, struct pt_regs * const regs,
 			     unsigned long event, int is_kernel)
 {
-	__oprofile_add_ext_sample(pc, regs, event, is_kernel, NULL);
+	struct oprofile_sample_parms parms = {
+		.pc = pc, .backtrace = 0, .event = event,
+		.is_kernel = is_kernel, .regs = regs, .task = NULL
+	};
+	__oprofile_add_ext_sample(&parms);
 }
 
 void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
 {
-	int is_kernel;
-	unsigned long pc;
+	struct oprofile_sample_parms parms = {
+		.pc = 0, .backtrace = 0, .event = event,
+		.is_kernel = 0, .regs = regs, .task = NULL
+	};
 
 	if (likely(regs)) {
-		is_kernel = !user_mode(regs);
-		pc = profile_pc(regs);
+		parms.is_kernel = !user_mode(regs);
+		parms.pc = profile_pc(regs);
 	} else {
-		is_kernel = 0;    /* This value will not be used */
-		pc = ESCAPE_CODE; /* as this causes an early return. */
+		parms.is_kernel = 0;    /* This value will not be used */
+		parms.pc = ESCAPE_CODE; /* as this causes an early return. */
 	}
 
-	__oprofile_add_ext_sample(pc, regs, event, is_kernel, NULL);
+	__oprofile_add_ext_sample(&parms);
 }
 
 /*
@@ -356,13 +367,17 @@ oprofile_write_reserve(struct op_entry *
 		       unsigned long pc, int code, int size)
 {
 	struct op_sample *sample;
-	int is_kernel = !user_mode(regs);
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_sample_parms parms = {
+		.pc = pc, .backtrace = 0, .event = 0,
+		.is_kernel = !user_mode(regs), .task = current,
+		.regs = regs
+	};
 
 	cpu_buf->sample_received++;
 
 	/* no backtraces for samples with data */
-	if (op_add_code(cpu_buf, 0, is_kernel, current))
+	if (op_add_code(cpu_buf, &parms))
 		goto fail;
 
 	sample = op_cpu_buffer_write_reserve(entry, size + 2);
@@ -413,12 +428,20 @@ int oprofile_write_commit(struct op_entr
 void oprofile_add_pc(unsigned long pc, int is_kernel, unsigned long event)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
-	log_sample(cpu_buf, pc, 0, is_kernel, event, NULL);
+	struct oprofile_sample_parms parms = {
+		.pc = pc, .backtrace = 0, .event = event,
+		.is_kernel = is_kernel, .task = NULL, .regs = NULL
+	};
+	log_sample(cpu_buf, &parms);
 }
 
 void oprofile_add_trace(unsigned long pc)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &__get_cpu_var(op_cpu_buffer);
+	struct oprofile_sample_parms parms = {
+		.pc = pc, .backtrace = 0, .event = 0,
+		.is_kernel = 0, .task = NULL, .regs = NULL
+	};
 
 	if (!cpu_buf->tracing)
 		return;
@@ -430,7 +453,7 @@ void oprofile_add_trace(unsigned long pc
 	if (pc == ESCAPE_CODE)
 		goto fail;
 
-	if (op_add_sample(cpu_buf, pc, 0))
+	if (op_add_sample(cpu_buf, &parms))
 		goto fail;
 
 	return;
Index: s390/drivers/oprofile/cpu_buffer.h
===================================================================
--- s390.orig/drivers/oprofile/cpu_buffer.h
+++ s390/drivers/oprofile/cpu_buffer.h
@@ -51,6 +51,15 @@ struct oprofile_cpu_buffer {
 	struct delayed_work work;
 };
 
+struct oprofile_sample_parms {
+	int is_kernel;
+	unsigned long pc;
+	unsigned long backtrace;
+	unsigned long event;
+	struct task_struct *task;
+	struct pt_regs *regs;
+};
+
 DECLARE_PER_CPU(struct oprofile_cpu_buffer, op_cpu_buffer);
 
 /*

