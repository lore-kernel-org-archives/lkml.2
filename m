Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab0FKUd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:33:56 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:46042 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab0FKUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:33:54 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAA47EkyrR7Ht/2dsb2JhbACefHGlKZlqhRgEg0wh
X-IronPort-AV: E=Sophos;i="4.53,404,1272844800"; 
   d="scan'208";a="143334460"
Date: Fri, 11 Jun 2010 13:33:53 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: to@dvomlehn-lnx2.corp.sa.net, "linux-kernel@vger.kernel.org"@cisco.com,
       linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4 v2][RFC] Infrastructure for out-of-band parameter
	passing
Message-ID: <20100611203353.GA28412@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Infrastructure to support out of band/indirect passing of data to functions.

It is useful at times to be able to pass data from one function to another
nested many stack frames more deeply than the passing function. Doing so
allows the interfaces in the intervening functions to be simpler, though
this "hidden" information passing risks increased complexity. In cases
where this is justified, this simple infrastructure provides the
functionality.

Out of band data passing is implemented by adding, for each instance,
an element to the task_struct that serves as the pointer to the top
of a OOB parameter stack. Data is made available by being pushed
on the OOB parameter stack by a function, and accessed via the top
element of the OOB parameter stack.

History
v2	Tweak comments to fix documentation errors
v1	Original version

Signed-off-by: David VomLehn (dvomlehn@cisco.com)
---
 include/linux/oobparam.h |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/include/linux/oobparam.h b/include/linux/oobparam.h
new file mode 100644
index 0000000..36daa97
--- /dev/null
+++ b/include/linux/oobparam.h
@@ -0,0 +1,94 @@
+/*
+ * Definitions used to pass information across multiple stack frames
+ * within a single task.
+ *
+ * Copyright (C) 2010  Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Author: David VomLehn
+ *
+ * These definitions allow one function to establish a context for another
+ * function without adding parameters to the intervening functions. It can,
+ * for example, supply state information from one function to be used in the
+ * case that some function nested several levels more deeply wants to report
+ * the context from the original function. Since it works in a way invisible
+ * to the intervening functions, passing information this way is less
+ * obvious than simply supplying parameters and it should be used sparingly.
+ *
+ * To use this:
+ * 1.	Define a structure containing a struct oobparam:
+ *		struct ctx {
+ *			const char *name;
+ *			OOBPARAM_FRAME(frame);
+ *			...
+ *		};
+ * 2.	Create an element in the task_struct to serve as the top of the
+ *	oobparam stack:
+ *		OOBPARAM_TOP(my_top);
+ * 3.	Populate the structure in the function that has context to be passed.
+ *		struct ctx ctx;
+ *		ctx.name = __func__;
+ * 4.	Surround the call to the next function with oobparam_push() and
+ *	oobparam_pop():
+ *		oobparam_push(&ctx.frame);
+ *		myfunc();
+ *		oobparam_pop(&ctx.frame);
+ * 5.	In function that wants to use the parameter value, use OOBPARAM_CUR
+ *	to retrieve the value:
+ *		struct ctx *ctx;
+ *		ctx = OOBPARAM_CUR(&my_top, struct ctx, frame);
+ *		pr_info("Indirectly called by %s\n", ctx->name);
+ */
+
+#ifndef	_LINUX_OOBPARAM_H_
+#define _LINUX_OOBPARAM_H_
+
+struct oobparam {
+	struct oobparam *next;
+};
+
+#define OOBPARAM_TOP(name)	struct oobparam name;
+#define OOBPARAM_FRAME(name)	struct oobparam name;
+
+/**
+ * oobparam_push - push an out-of-band parameter frame on the OOB param stack
+ * @top:	Pointer to the OOB parameter stack top, which must be in the
+ *		task structure.
+ * @frame:	Pointer to the OOB parameter frame, generally embedded in
+ *		another structure
+ */
+static inline void oobparam_push(struct oobparam *top, struct oobparam *frame)
+{
+	frame->next = top;
+	/* We need to ensure that the pointer in the frame is set prior to
+	 * the pointer to the top in case we handle an interrupt in between
+	 * the two stores. */
+	wmb();
+	top->next = frame;
+}
+
+/**
+ * oobparam_pop - pop an out-of-band parameter frame from the OOB param stack
+ * @top:	Pointer to the OOB parameter stack top, as passed to
+ *		oobparam_push()
+ */
+static inline void oobparam_pop(struct oobparam *top)
+{
+	top->next = top->next->next;
+}
+
+#define OOBPARAM_CUR(top, type, frame) container_of((top)->next, type, frame)
+#endif
