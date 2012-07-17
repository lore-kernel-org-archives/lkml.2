Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2GQCDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:03:17 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:32902 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2GQCDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:03:16 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: ftrace: Trace function entry before updating index
Date: Mon, 16 Jul 2012 19:03:12 -0700
Message-Id: <1342490592-20373-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 722b3c74695377d11d18a52f3da08114d37f3f37 modified x86 ftrace to
avoid tracing all functions called from irqs when function graph was
used with a filter.  Port the same fix to ARM.

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Colin Cross <ccross@android.com>
---

It looks like the same issue affects blackfin, microblaze, mips,
parisc, powerpc, s390, sh, and sparc, but I don't have patches to
fix those.

 arch/arm/kernel/ftrace.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index df0bf0c..34e5664 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -179,19 +179,20 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	old = *parent;
 	*parent = return_hooker;
 
-	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
-				       frame_pointer);
-	if (err == -EBUSY) {
-		*parent = old;
-		return;
-	}
-
 	trace.func = self_addr;
+	trace.depth = current->curr_ret_stack + 1;
 
 	/* Only trace if the calling function expects to */
 	if (!ftrace_graph_entry(&trace)) {
-		current->curr_ret_stack--;
 		*parent = old;
+		return;
+	}
+
+	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
+				       frame_pointer);
+	if (err == -EBUSY) {
+		*parent = old;
+		return;
 	}
 }
 
-- 
1.7.7.3

