Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2LNLCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:02:02 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38081 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2LNLB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:56 -0500
Subject: [PATCH] x86/test_nx: update testing module after recent kernel changes
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: x86@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 14 Dec 2012 15:01:49 +0400
Message-ID: <20121214110149.9548.37883.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"test_nx" isn't uptodate, kernel has been changed since its last revision.
For now it only able to crash kernel on loading.

exception tables are relative since commit v3.4-rc3-33-g7062765
("x86, extable: Switch to relative exception table entries")

Exception entries now unusable for this test, because exception table cannot
lays farther than 2gb from covering address. This patch adds DIE_PAGE_FAULT
notifier into no_context() function in arch/x86/mm/fault.c and handles these
exceptions manually.

modules' data sections now can be ro/nx protected since v2.6.37-rc2-3-g84e1c6b
("x86: Add RO/NX protection for loadable kernel modules")
thus fourth testcase can be enabled.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org

---

sample oops on module loading before this patch:

[    2.343411] Testing NX protection
[    2.343457] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    2.343494] BUG: unable to handle kernel paging request at ffff88007c951da5
[    2.343590] IP: [<ffff88007c951da5>] 0xffff88007c951da4
[    2.343657] PGD 1e0c063 PUD 1fffc067 PMD 800000007c8001e3
[    2.343780] Oops: 0011 [#1] SMP
[    2.343872] Modules linked in: test_nx(+) ide_generic eni suni atm mce_inject edac_core ar7part mtd cmd640 sctp cs5520 dccp_ipv6 dccp_ipv4 dccp cs55
35_mfgpt bnep rfcomm bluetooth fuse nfsd exportfs powernow_k8 kvm_amd k8temp i2c_nforce2 evbug pcspkr kvm btrfs zlib_deflate libcrc32c ide_pci_generic
ide_core ata_generic pata_acpi sata_nv [last unloaded: cdc_wdm]
[    2.344363] CPU 1
[    2.344363] Pid: 15140, comm: modprobe Tainted: P             3.7.0-rc8-next-20121211+ #597 Gigabyte Technology Co., Ltd. M52S-S3P/M52S-S3P
[    2.344363] RIP: 0010:[<ffff88007c951da5>]  [<ffff88007c951da5>] 0xffff88007c951da4
[    2.344363] RSP: 0018:ffff88007c951d70  EFLAGS: 00010246
[    2.344363] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88007fc8f328
[    2.344363] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88007c951da5
[    2.344363] RBP: ffff88007c951d88 R08: 0000000000000000 R09: 0000000000000000
[    2.344363] R10: ffff88007c951fd8 R11: 0000000000000992 R12: ffff88007c951da5
[    2.344363] R13: 0000000000000000 R14: ffff88007b0553e0 R15: ffff88007c951ee8
[    2.344363] FS:  00007f12352de700(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
[    2.344363] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.344363] CR2: ffff88007c951da5 CR3: 000000007a23b000 CR4: 00000000000007e0
[    2.344363] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.344363] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.344363] Process modprobe (pid: 15140, threadinfo ffff88007c950000, task ffff880079038000)
[    2.344363] Stack:
[    2.344363]  ffffffffa0bf002f ffffffffa0bf0320 ffffffffa0bf00a0 ffff88007c951db8
[    2.344363]  ffffffffa0bf00d5 ffff88007b0553e0 0090c30000000000 ffffffffa0bf0320
[    2.344363]  ffffffffa0bf00a0 ffff88007c951de8 ffffffff810002da ffffffffa0bf0320
[    2.344363] Call Trace:
[    2.344363]  [<ffffffffa0bf002f>] ? foo_label+0x3/0x74 [test_nx]
[    2.344363]  [<ffffffffa0bf00a0>] ? foo_label+0x74/0x74 [test_nx]
[    2.344363]  [<ffffffffa0bf00d5>] test_NX+0x35/0x120 [test_nx]
[    2.344363]  [<ffffffffa0bf00a0>] ? foo_label+0x74/0x74 [test_nx]
[    2.344363]  [<ffffffff810002da>] do_one_initcall+0x11a/0x170
[    2.344363]  [<ffffffff810a28ad>] load_module+0x196d/0x1e40
[    2.344363]  [<ffffffff8109e8f0>] ? __unlink_module+0x30/0x30
[    2.344363]  [<ffffffff810a2e46>] sys_init_module+0xc6/0xf0
[    2.344363]  [<ffffffff81801a12>] system_call_fastpath+0x16/0x1b
[    2.344363] Code: bf a0 ff ff ff ff a0 00 bf a0 ff ff ff ff b8 1d 95 7c 00 88 ff ff d5 00 bf a0 ff ff ff ff e0 53 05 7b 00 88 ff ff 00 00 00 00 00 <c3> 90 00 20 03 bf a0 ff ff ff ff a0 00 bf a0 ff ff ff ff e8 1d
[    2.344363] RIP  [<ffff88007c951da5>] 0xffff88007c951da4
[    2.344363]  RSP <ffff88007c951d70>
[    2.344363] CR2: ffff88007c951da5
---
 arch/x86/kernel/test_nx.c |   82 +++++++++++++++++++--------------------------
 arch/x86/mm/fault.c       |    4 ++
 2 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
index 3f92ce0..98020bc 100644
--- a/arch/x86/kernel/test_nx.c
+++ b/arch/x86/kernel/test_nx.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/kdebug.h>
 
 #include <asm/uaccess.h>
 #include <asm/asm.h>
@@ -27,48 +28,30 @@ extern int rodata_test_data;
  *
  * To do this, the test code tries to execute memory in stack/kmalloc/etc,
  * and then checks if the expected trap happens.
- *
- * Sadly, this implies having a dynamic exception handling table entry.
- * ... which can be done (and will make Rusty cry)... but it can only
- * be done in a stand-alone module with only 1 entry total.
- * (otherwise we'd have to sort and that's just too messy)
  */
 
+static void *exception_label;
 
+void fixup_label(void);
 
-/*
- * We want to set up an exception handling point on our stack,
- * which means a variable value. This function is rather dirty
- * and walks the exception table of the module, looking for a magic
- * marker and replaces it with a specific function.
- */
-static void fudze_exception_table(void *marker, void *new)
+static int die_notify(struct notifier_block *nb, unsigned long val, void *data)
 {
-	struct module *mod = THIS_MODULE;
-	struct exception_table_entry *extable;
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
 
-	/*
-	 * Note: This module has only 1 exception table entry,
-	 * so searching and sorting is not needed. If that changes,
-	 * this would be the place to search and re-sort the exception
-	 * table.
-	 */
-	if (mod->num_exentries > 1) {
-		printk(KERN_ERR "test_nx: too many exception table entries!\n");
-		printk(KERN_ERR "test_nx: test results are not reliable.\n");
-		return;
+	if (val == DIE_PAGE_FAULT &&
+	    regs->ip == (unsigned long)exception_label) {
+		regs->ip = (unsigned long)fixup_label;
+		return NOTIFY_STOP;
 	}
-	extable = (struct exception_table_entry *)mod->extable;
-	extable[0].insn = (unsigned long)new;
-}
 
+	return NOTIFY_DONE;
+}
 
-/*
- * exception tables get their symbols translated so we need
- * to use a fake function to put in there, which we can then
- * replace at runtime.
- */
-void foo_label(void);
+struct notifier_block die_notify_block = {
+	.notifier_call = die_notify,
+	.priority = INT_MAX, /* Highest priority */
+};
 
 /*
  * returns 0 for not-executable, negative for executable
@@ -81,23 +64,20 @@ static noinline int test_address(void *address)
 {
 	unsigned long result;
 
-	/* Set up an exception table entry for our address */
-	fudze_exception_table(&foo_label, address);
+	/* Set up an exception label for our address */
+	exception_label = address;
+
 	result = 1;
 	asm volatile(
-		"foo_label:\n"
-		"0:	call *%[fake_code]\n"
-		"1:\n"
+		"	call *%[fake_code]\n"
 		".section .fixup,\"ax\"\n"
-		"2:	mov %[zero], %[rslt]\n"
+		"fixup_label:\n"
+		"	mov %[zero], %[rslt]\n"
 		"	ret\n"
 		".previous\n"
-		_ASM_EXTABLE(0b,2b)
 		: [rslt] "=r" (result)
 		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)
 	);
-	/* change the exception table back for the next round */
-	fudze_exception_table(address, &foo_label);
 
 	if (result)
 		return -ENODEV;
@@ -108,10 +88,14 @@ static unsigned char test_data = 0xC3; /* 0xC3 is the opcode for "ret" */
 
 static int test_NX(void)
 {
-	int ret = 0;
 	/* 0xC3 is the opcode for "ret" */
 	char stackcode[] = {0xC3, 0x90, 0 };
 	char *heap;
+	int ret;
+
+	ret = register_die_notifier(&die_notify_block);
+	if (ret)
+		return ret;
 
 	test_data = 0xC3;
 
@@ -126,8 +110,10 @@ static int test_NX(void)
 
 	/* Test 2: Check if the heap is executable */
 	heap = kmalloc(64, GFP_KERNEL);
-	if (!heap)
-		return -ENOMEM;
+	if (!heap) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	heap[0] = 0xC3; /* opcode for "ret" */
 
 	if (test_address(heap)) {
@@ -153,14 +139,16 @@ static int test_NX(void)
 	}
 #endif
 
-#if 0
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX
 	/* Test 4: Check if the .data section of a module is executable */
 	if (test_address(&test_data)) {
 		printk(KERN_ERR "test_nx: .data section is executable\n");
 		ret = -ENODEV;
 	}
-
 #endif
+
+out:
+	unregister_die_notifier(&die_notify_block);
 	return ret;
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 027088f..0d2665e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -664,6 +664,10 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	if (is_errata93(regs, address))
 		return;
 
+	if (notify_die(DIE_PAGE_FAULT, "page fault", regs, error_code,
+				X86_TRAP_PF, signal) == NOTIFY_STOP)
+		return;
+
 	/*
 	 * Oops. The kernel tried to access some bad page. We'll have to
 	 * terminate things with extreme prejudice:

