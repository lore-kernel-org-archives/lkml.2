Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1GZReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:34:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1GZRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:33:58 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=S3fonzSR94QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ggj0aaQ4im6rEyUJR9cA:9 a=RLUKswjI9ogZVw0hqSEA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH] kmemleak: Show where early_log issues come from
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 13:33:56 -0400
Message-ID: <1311701636.3526.97.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I triggered the following warning from kmemleak:

kmemleak: Trying to color unknown object at 0xf5840000 as Grey
Pid: 0, comm: swapper Not tainted 3.0.0-test #12
Call Trace:
 [<c17e34e6>] ? printk+0x1d/0x1f^M
 [<c10e2941>] paint_ptr+0x4f/0x78
 [<c178ab57>] kmemleak_not_leak+0x58/0x7d
 [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
 [<c1cdb462>] kmemleak_init+0x19d/0x1e9
 [<c1cbf771>] start_kernel+0x346/0x3ec
 [<c1cbf1b4>] ? loglevel+0x18/0x18
 [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0

The backtrace is from where the problem was detected, not where the
problem occurred. I also noticed that the logs that are stored include a
stack_trace dump. But this trace is only added when ALLOC is done.

The above issues ended up being from the cgroup code calling
kmemleak_not_leak(), which does not store the trace. But that didn't
matter, because even if it did, the trace is not printed out here
leaving the above output still unhelpful in finding where the problem
occurred.

By having all early kmemleak logs record the stack_trace, and by having
the above error message / detection bubble up the call stack that an
error occurred. We can have kmemleak_init() write exactly where the
problem occurred.

With the patch, I now have this:

allocated 8388608 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
kmemleak: Trying to color unknown object at 0xf5840000 as Grey
Pid: 0, comm: swapper Not tainted 3.0.0-test+ #14
Call Trace:
 [<c17e3516>] ? printk+0x1d/0x1f
 [<c10e2941>] paint_ptr+0x4f/0x7d
 [<c10e32f5>] __kmemleak_not_leak+0x59/0x86
 [<c108ae9f>] ? __rcu_read_unlock+0x9/0x7d
 [<c1cdb48b>] kmemleak_init+0x19d/0x1f4
 [<c1cbf771>] start_kernel+0x346/0x3ec
 [<c1cbf1b4>] ? loglevel+0x18/0x18
 [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
kmemleak:   object backtrace:
     [<c10e3319>] __kmemleak_not_leak+0x7d/0x86
     [<c178ad87>] kmemleak_not_leak+0xd/0xf
     [<c1cdb0bd>] page_cgroup_init+0x86/0x142
     [<c1cbf76c>] start_kernel+0x341/0x3ec
     [<c1cbf0aa>] i386_start_kernel+0xaa/0xb0
     [<ffffffff>] 0xffffffff

Which would have saved me about an hour in tracking this down.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index aacee45..4ed3b7f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -686,7 +686,7 @@ static void paint_it(struct kmemleak_object *object, int color)
 	spin_unlock_irqrestore(&object->lock, flags);
 }
 
-static void paint_ptr(unsigned long ptr, int color)
+static int paint_ptr(unsigned long ptr, int color)
 {
 	struct kmemleak_object *object;
 
@@ -696,28 +696,29 @@ static void paint_ptr(unsigned long ptr, int color)
 			      "at 0x%08lx as %s\n", ptr,
 			      (color == KMEMLEAK_GREY) ? "Grey" :
 			      (color == KMEMLEAK_BLACK) ? "Black" : "Unknown");
-		return;
+		return -1;
 	}
 	paint_it(object, color);
 	put_object(object);
+	return 0;
 }
 
 /*
  * Mark an object permanently as gray-colored so that it can no longer be
  * reported as a leak. This is used in general to mark a false positive.
  */
-static void make_gray_object(unsigned long ptr)
+static int make_gray_object(unsigned long ptr)
 {
-	paint_ptr(ptr, KMEMLEAK_GREY);
+	return paint_ptr(ptr, KMEMLEAK_GREY);
 }
 
 /*
  * Mark the object as black-colored so that it is ignored from scans and
  * reporting.
  */
-static void make_black_object(unsigned long ptr)
+static int make_black_object(unsigned long ptr)
 {
-	paint_ptr(ptr, KMEMLEAK_BLACK);
+	return paint_ptr(ptr, KMEMLEAK_BLACK);
 }
 
 /*
@@ -811,8 +812,7 @@ static void __init log_early(int op_type, const void *ptr, size_t size,
 	log->ptr = ptr;
 	log->size = size;
 	log->min_count = min_count;
-	if (op_type == KMEMLEAK_ALLOC)
-		log->trace_len = __save_stack_trace(log->trace);
+	log->trace_len = __save_stack_trace(log->trace);
 	crt_early_log++;
 	local_irq_restore(flags);
 }
@@ -917,14 +917,20 @@ EXPORT_SYMBOL_GPL(kmemleak_free_part);
  * Calling this function on an object will cause the memory block to no longer
  * be reported as leak and always be scanned.
  */
-void __ref kmemleak_not_leak(const void *ptr)
+static int __kmemleak_not_leak(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
-		make_gray_object((unsigned long)ptr);
+		return make_gray_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
 		log_early(KMEMLEAK_NOT_LEAK, ptr, 0, 0);
+	return 0;
+}
+
+void __ref kmemleak_not_leak(const void *ptr)
+{
+	__kmemleak_not_leak(ptr);
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
 
@@ -937,14 +943,19 @@ EXPORT_SYMBOL(kmemleak_not_leak);
  * it is known that the corresponding block is not a leak and does not contain
  * any references to other allocated memory blocks.
  */
-void __ref kmemleak_ignore(const void *ptr)
+static int __kmemleak_ignore(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
 	if (atomic_read(&kmemleak_enabled) && ptr && !IS_ERR(ptr))
-		make_black_object((unsigned long)ptr);
+		return make_black_object((unsigned long)ptr);
 	else if (atomic_read(&kmemleak_early_log))
 		log_early(KMEMLEAK_IGNORE, ptr, 0, 0);
+	return 0;
+}
+void __ref kmemleak_ignore(const void *ptr)
+{
+	__kmemleak_ignore(ptr);
 }
 EXPORT_SYMBOL(kmemleak_ignore);
 
@@ -1659,6 +1670,17 @@ static int kmemleak_boot_config(char *str)
 }
 early_param("kmemleak", kmemleak_boot_config);
 
+static void __init print_log_stack(struct early_log *log)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = log->trace_len;
+	trace.entries = log->trace;
+
+	pr_notice("  object backtrace:\n");
+	print_stack_trace(&trace, 4);
+}
+
 /*
  * Kmemleak initialization.
  */
@@ -1708,10 +1730,12 @@ void __init kmemleak_init(void)
 			kmemleak_free_part(log->ptr, log->size);
 			break;
 		case KMEMLEAK_NOT_LEAK:
-			kmemleak_not_leak(log->ptr);
+			if (__kmemleak_not_leak(log->ptr) < 0)
+				print_log_stack(log);
 			break;
 		case KMEMLEAK_IGNORE:
-			kmemleak_ignore(log->ptr);
+			if (__kmemleak_ignore(log->ptr) < 0)
+				print_log_stack(log);
 			break;
 		case KMEMLEAK_SCAN_AREA:
 			kmemleak_scan_area(log->ptr, log->size, GFP_KERNEL);


