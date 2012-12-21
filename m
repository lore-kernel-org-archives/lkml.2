Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2LUDAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:00:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54817 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab2LUDAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:00:35 -0500
Date: Thu, 20 Dec 2012 19:00:18 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [RFC] stack and heap are executable on x86_64
Message-ID: <20121221030018.GA15032@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only works up until 706276543b699d80f546e45f8b12574e7b18d952
(v3.5), where the exception tables are made relative. Prior to that,
stock test_nx didn't work because of 84e1c6bb38eb318e456558b610396d9f1afaabf0
(v2.6.38) makes the table read-only.

While trying to fix test_nx, I discovered that it looks like stack and
heap are executable again (at least on x86_64). :( I tried to bisect
this, but ran into a lot of trouble in the x86/x86_64 merging, where
things either didn't compile or didn't boot. Regardless:

1a98fd1 bad
...
736f12b good

So it looks like it broke in 2.6.27, and no one noticed until 2.6.38 when
it wasn't possible to run the test any more, and then stayed unnoticed.

This change for pre-v3.5 creates a new exception table instead of
trying to rewrite the old one. Since the tables are now relative,
we can't actually set up an exception for things in stack and heap on
x86_64 since the distance between the address and the table's .insn is
more than INT_MAX. And if the table were moved into the stack or heap,
then the fixup couldn't point back to the module's text segment. For
v3.5 and later, I'm not sure what to do...

So, mainly two things:
- we need to fix the stack/heap markings.
- it'd be nice to get test_nx back on its feet again.

Thoughts?

-Kees


Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/test_nx.c |  107 ++++++++++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 3f92ce0..cbaa557 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -9,6 +9,9 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+
+#define pr_fmt(fmt) "test_nx: " fmt
+
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
@@ -16,6 +19,11 @@
 #include <asm/uaccess.h>
 #include <asm/asm.h>
 
+/* 0xC3 is the opcode for "ret" */
+#define INSN_RET	0xC3
+/* 0x90 is the opcode for "nop" */
+#define INSN_NOP	0x90
+
 extern int rodata_test_data;
 
 /*
@@ -34,18 +42,15 @@ extern int rodata_test_data;
  * (otherwise we'd have to sort and that's just too messy)
  */
 
-
-
 /*
  * We want to set up an exception handling point on our stack,
- * which means a variable value. This function is rather dirty
- * and walks the exception table of the module, looking for a magic
- * marker and replaces it with a specific function.
+ * which means a variable value.
  */
-static void fudze_exception_table(void *marker, void *new)
+static struct exception_table_entry *original_extable;
+static struct exception_table_entry replaced_extable;
+static void fake_exception_table(void *new)
 {
 	struct module *mod = THIS_MODULE;
-	struct exception_table_entry *extable;
 
 	/*
 	 * Note: This module has only 1 exception table entry,
@@ -54,12 +59,30 @@ static void fudze_exception_table(void *marker, void *new)
 	 * table.
 	 */
 	if (mod->num_exentries > 1) {
-		printk(KERN_ERR "test_nx: too many exception table entries!\n");
-		printk(KERN_ERR "test_nx: test results are not reliable.\n");
+		pr_err("too many exception table entries!\n");
+		pr_err("test results are not reliable.\n");
 		return;
 	}
-	extable = (struct exception_table_entry *)mod->extable;
-	extable[0].insn = (unsigned long)new;
+	/* Save original exception table when first called. */
+	if (original_extable == NULL)
+		original_extable = mod->extable;
+	/* Replace the original exception table with a duplicate. */
+	if (mod->extable == original_extable)
+		mod->extable = &replaced_extable;
+
+	/* Record new insn address. */
+	mod->extable->insn = (unsigned long)new;
+
+	/* Record new fixup address. */
+	mod->extable->fixup = original_extable->fixup;
+}
+
+static void restore_exception_table(void)
+{
+	struct module *mod = THIS_MODULE;
+
+	if (original_extable)
+		mod->extable = original_extable;
 }
 
 
@@ -82,7 +105,8 @@ static noinline int test_address(void *address)
 	unsigned long result;
 
 	/* Set up an exception table entry for our address */
-	fudze_exception_table(&foo_label, address);
+	fake_exception_table(address);
+	pr_info("calling %p (0x%02X)\n", address, *(unsigned char *)address);
 	result = 1;
 	asm volatile(
 		"foo_label:\n"
@@ -97,76 +121,87 @@ static noinline int test_address(void *address)
 		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
 	);
 	/* change the exception table back for the next round */
-	fudze_exception_table(address, &foo_label);
+	restore_exception_table();
 
 	if (result)
 		return -ENODEV;
 	return 0;
 }
 
-static unsigned char test_data = 0xC3; /* 0xC3 is the opcode for "ret" */
+static unsigned char test_data;
+static const int module_rodata_test_data = INSN_RET;
 
 static int test_NX(void)
 {
 	int ret = 0;
-	/* 0xC3 is the opcode for "ret" */
-	char stackcode[] = {0xC3, 0x90, 0 };
+	char stackcode[] = {INSN_RET, INSN_NOP, 0 };
 	char *heap;
 
-	test_data = 0xC3;
+	test_data = INSN_RET;
 
-	printk(KERN_INFO "Testing NX protection\n");
+	pr_info("Testing NX protection ...\n");
 
 	/* Test 1: check if the stack is not executable */
 	if (test_address(&stackcode)) {
-		printk(KERN_ERR "test_nx: stack was executable\n");
+		pr_err("stack is executable\n");
 		ret = -ENODEV;
 	}
 
-
 	/* Test 2: Check if the heap is executable */
 	heap = kmalloc(64, GFP_KERNEL);
 	if (!heap)
 		return -ENOMEM;
-	heap[0] = 0xC3; /* opcode for "ret" */
+	heap[0] = INSN_RET;
 
 	if (test_address(heap)) {
-		printk(KERN_ERR "test_nx: heap was executable\n");
+		pr_err("heap is executable\n");
 		ret = -ENODEV;
 	}
 	kfree(heap);
 
-	/*
-	 * The following 2 tests currently fail, this needs to get fixed
-	 * Until then, don't run them to avoid too many people getting scared
-	 * by the error message
-	 */
-
 #ifdef CONFIG_DEBUG_RODATA
-	/* Test 3: Check if the .rodata section is executable */
-	if (rodata_test_data != 0xC3) {
-		printk(KERN_ERR "test_nx: .rodata marker has invalid value\n");
+	/* Test 3: Check if the kernel .rodata section is executable */
+	if (rodata_test_data != INSN_RET) {
+		pr_err("kernel .rodata marker has invalid value\n");
 		ret = -ENODEV;
 	} else if (test_address(&rodata_test_data)) {
-		printk(KERN_ERR "test_nx: .rodata section is executable\n");
+		pr_err("kernel .rodata section is executable\n");
 		ret = -ENODEV;
 	}
+#else
+	pr_err("kernel .rodata section executable: missing " \
+		"CONFIG_DEBUG_RODATA\n");
+	ret = -ENODEV;
 #endif
 
-#if 0
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
 	/* Test 4: Check if the .data section of a module is executable */
 	if (test_address(&test_data)) {
-		printk(KERN_ERR "test_nx: .data section is executable\n");
+		pr_err(".data section is executable\n");
 		ret = -ENODEV;
 	}
 
+	/* Test 5: Check if the .rodata section of a module is executable */
+	if (module_rodata_test_data != INSN_RET) {
+		pr_err("module .rodata marker has invalid value\n");
+		ret = -ENODEV;
+	} else if (test_address((void *)&module_rodata_test_data)) {
+		pr_err("module .rodata section is executable\n");
+		ret = -ENODEV;
+	}
+#else
+	pr_err("module .data and .rodata sections executable: missing " \
+		"CONFIG_DEBUG_SET_MODULE_RONX\n");
+	ret = -ENODEV;
 #endif
+
+	pr_info("Done testing.\n");
+
 	return ret;
 }
 
 static void test_exit(void)
-{
-}
+{ }
 
 module_init(test_NX);
 module_exit(test_exit);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
