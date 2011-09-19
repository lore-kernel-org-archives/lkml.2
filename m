Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1ISV0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:26:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab1ISV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:43 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Wllq6pXuHmMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=NufY4J3AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=cFu57EwL7RpKT11XtPMA:9 a=jEp0ucaQiEUA:10 a=re9sYKne76oA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212641.527742267@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/5] percpu: Add preempt checks back into this_cpu_read/write()
References: <20110919212040.745370781@goodmis.org>
Content-Disposition: inline; filename=0005-percpu-Add-preempt-checks-back-into-this_cpu_read-wr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The conversion of per_cpu() and get_cpu_var() to this_cpu_read/write()
removed the debug check against using cpu variables in non atomic sections.

There are few cases where that is fine, but 99% of the time, if a per cpu
variable is going to be played with, it had better happen in an atomic
area, otherwise hard to find bugs may occur.

Right now only this_cpu_read/write() were updated. Maybe it would be a good
idea to handle the other this_cpu_*() functions as well.

Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/percpu.h |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9ca008f..a4048de 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -22,6 +22,13 @@
 	 PERCPU_MODULE_RESERVE)
 #endif
 
+#ifdef CONFIG_DEBUG_PREEMPT
+# define debug_check_cpu() smp_processor_id()
+#else
+# define debug_check_cpu()
+#endif
+ 
+
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
  * we force a syntax error here if it isn't.
@@ -342,7 +349,10 @@ do {									\
 # ifndef this_cpu_read_8
 #  define this_cpu_read_8(pcp)	_this_cpu_generic_read(pcp)
 # endif
-# define this_cpu_read(pcp)	__pcpu_size_call_return(this_cpu_read_, (pcp))
+# define this_cpu_read(pcp)	({					\
+			debug_check_cpu();				\
+			__pcpu_size_call_return(this_cpu_read_, (pcp));	\
+		})
 #endif
 
 #define _this_cpu_generic_to_op(pcp, val, op)				\
@@ -365,7 +375,10 @@ do {									\
 # ifndef this_cpu_write_8
 #  define this_cpu_write_8(pcp, val)	_this_cpu_generic_to_op((pcp), (val), =)
 # endif
-# define this_cpu_write(pcp, val)	__pcpu_size_call(this_cpu_write_, (pcp), (val))
+# define this_cpu_write(pcp, val)	({				\
+			debug_check_cpu();				\
+			__pcpu_size_call(this_cpu_write_, (pcp), (val)); \
+		})
 #endif
 
 #ifndef this_cpu_add
-- 
1.7.5.4


