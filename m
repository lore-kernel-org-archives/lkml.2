Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab1IQArZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:47:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62417 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab1IQArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:47:19 -0400
Message-Id: <093448$3hsu05@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6471"; a="119437317"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Wed, 14 Sep 2011 13:19:18 -0500
Subject: [PATCH v4 34/36] Hexagon: Add basic stacktrace functionality for Hexagon architecture.
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/kernel/stacktrace.c |   66 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/kernel/stacktrace.c

diff --git a/arch/hexagon/kernel/stacktrace.c b/arch/hexagon/kernel/stacktrace.c
new file mode 100644
index 0000000..11c597b
--- /dev/null
+++ b/arch/hexagon/kernel/stacktrace.c
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
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
