Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1H3TPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:15:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19600 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab1H3TPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114068364"
Message-Id: <20110830190802.933911290@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:08:03 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch v2 34/35] Hexagon: Add basic stacktrace functionality for Hexagon architecture.
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=stacktrace.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/stacktrace.c |   66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/kernel/stacktrace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/stacktrace.c	2011-08-24 18:45:48.603877517 -0500
@@ -0,0 +1,66 @@
+/*
+ * Stacktrace support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/sched.h>
+#include <linux/stacktrace.h>
+#include <linux/thread_info.h>
+#include <linux/module.h>
+
+register unsigned long current_frame_pointer asm("r30");
+
+struct stackframe {
+	unsigned long fp;
+	unsigned long rets;
+};
+
+/*
+ * Save stack-backtrace addresses into a stack_trace buffer.
+ */
+void save_stack_trace(struct stack_trace *trace)
+{
+	unsigned long low, high;
+	unsigned long fp;
+	struct stackframe *frame;
+	int skip = trace->skip;
+
+	low = (unsigned long)task_stack_page(current);
+	high = low + THREAD_SIZE;
+	fp = current_frame_pointer;
+
+	while (fp >= low && fp <= (high - sizeof(*frame))) {
+		frame = (struct stackframe *)fp;
+
+		if (skip) {
+			skip--;
+		} else {
+			trace->entries[trace->nr_entries++] = frame->rets;
+			if (trace->nr_entries >= trace->max_entries)
+				break;
+		}
+
+		/*
+		 * The next frame must be at a higher address than the
+		 * current frame.
+		 */
+		low = fp + sizeof(*frame);
+		fp = frame->fp;
+	}
+}
+EXPORT_SYMBOL_GPL(save_stack_trace);

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

