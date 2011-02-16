Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab1BPAcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:32:09 -0500
Received: from kroah.org ([198.145.64.141]:49782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab1BPAYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:49 2011
Message-Id: <20110216001449.092630590@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ari Kauppi <kauppi@papupata.org>, Will Deacon <will.deacon@arm.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [240/272] ARM: oprofile: Fix backtraces in timer mode
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ari Kauppi <kauppi@papupata.org>

commit d14dd7e20d5e526557f5d3cfef4046a642f80924 upstream.

Always allow backtraces when using oprofile on ARM, even if a PMU
isn't present. Restores functionality originally introduced in commit
1b7b56982fdcd9d85effd76f3928cf5d6eb26155 ("oprofile: Always allow
backtraces on ARM") by Richard Purdie.

It is not that obvious, but there is now only one oprofile_arch_init()
function. So the .backtrace callback is available also in timer mode.

Implemented by removing code and using stubs for oprofile_perf_{init,
exit} provided by <linux/oprofile.h>. This allows cleaning of other
architecture specific implementations too.

Signed-off-by: Ari Kauppi <kauppi@papupata.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 8aa9744..2b66391 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -10,8 +10,6 @@
  */
 
 #include <linux/cpumask.h>
-#include <linux/err.h>
-#include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/oprofile.h>
@@ -46,6 +44,7 @@ char *op_name_from_perf_id(void)
 		return NULL;
 	}
 }
+#endif
 
 static int report_trace(struct stackframe *frame, void *d)
 {
@@ -111,6 +110,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
 {
+	/* provide backtrace support also in timer mode: */
 	ops->backtrace		= arm_backtrace;
 
 	return oprofile_perf_init(ops);
@@ -120,11 +120,3 @@ void __exit oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 }
-#else
-int __init oprofile_arch_init(struct oprofile_operations *ops)
-{
-	pr_info("oprofile: hardware counters not available\n");
-	return -ENODEV;
-}
-void __exit oprofile_arch_exit(void) {}
-#endif /* CONFIG_HW_PERF_EVENTS */
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 54c8382..1ca6411 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -16,6 +16,8 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/printk.h>
 #include <asm/atomic.h>
  
 /* Each escaped entry is prefixed by ESCAPE_CODE
@@ -190,6 +192,13 @@ int oprofile_write_commit(struct op_entry *entry);
 int __init oprofile_perf_init(struct oprofile_operations *ops);
 void oprofile_perf_exit(void);
 char *op_name_from_perf_id(void);
+#else
+static inline int __init oprofile_perf_init(struct oprofile_operations *ops)
+{
+	pr_info("oprofile: hardware counters not available\n");
+	return -ENODEV;
+}
+static inline void oprofile_perf_exit(void) { }
 #endif /* CONFIG_HW_PERF_EVENTS */
 
 #endif /* OPROFILE_H */


