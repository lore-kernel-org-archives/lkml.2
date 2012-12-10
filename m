Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2LJJLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:11:50 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37695 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2LJJLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:11:47 -0500
Message-ID: <50C5A747.1020105@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 17:11:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 0/5] KVM: x86: improve reexecute_instruction
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121009-0260-0000-0000-000002461885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
There are some changes from Marcelo and Gleb's review, thank you all!
- access indirect_shadow_pages in the protection of mmu-lock
- fix the issue when unhandleable instruction access on large page
- add a new test case for large page

The current reexecute_instruction can not well detect the failed instruction
emulation. It allows guest to retry all the instructions except it accesses
on error pfn.

For example, these cases can not be detected:
- for tdp used
  currently, it refused to retry all instructions. If nested npt is used, the
  emulation may be caused by shadow page, it can be fixed by unshadow the
  shadow page.

- for shadow mmu
  some cases are nested-write-protect, for example, if the page we want to
  write is used as PDE but it chains to itself. Under this case, we should
  stop the emulation and report the case to userspace.

There are two test cases based on kvm-unit-test can trigger a infinite loop on
current code (ept = 0), after this patchset, it can report the error to Qemu.

Subject: [PATCH] access test: test unhandleable instruction

Test the instruction which can not be handled by kvm

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 x86/access.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 23a5995..9141c70 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -2,6 +2,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "vm.h"

 #define smp_id() 0

@@ -739,6 +740,54 @@ err:
 	return 0;
 }

+static int check_retry_unhandleable_ins(ac_pool_t *pool)
+{
+	unsigned long mem = 30 * 1024 * 1024;
+	unsigned long esp;
+	ac_test_t at;
+
+	ac_test_init(&at, (void *)(0x123406003000));
+	at.flags[AC_PDE_PRESENT] = at.flags[AC_PDE_WRITABLE] = 1;
+	at.flags[AC_PTE_PRESENT] = at.flags[AC_PTE_WRITABLE] = 1;
+	at.flags[AC_CPU_CR0_WP] = 1;
+
+	at.phys = mem;
+	ac_setup_specific_pages(&at, pool, mem, 0);
+
+	asm volatile("mov %%rsp, %%rax  \n\t" : "=a"(esp));
+	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(0x123406003000 + 0xf0));
+	asm volatile ("int $0x3 \n\t");
+	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(esp));
+
+	return 1;
+}
+
+static int check_large_mapping_write_page_table(ac_pool_t *pool)
+{
+	unsigned long mem = 0x1000000;
+	unsigned long esp;
+	ac_test_t at;
+	ulong cr3;
+
+	ac_test_init(&at, (void *)(0x123400000000));
+	at.flags[AC_PDE_PRESENT] = at.flags[AC_PDE_WRITABLE] = 1;
+	at.flags[AC_PDE_PSE] = 1;
+	at.flags[AC_CPU_CR0_WP] = 1;
+
+	at.phys = mem;
+	ac_setup_specific_pages(&at, pool, mem, 0);
+
+	cr3 = read_cr3();
+	write_cr3(cr3);
+
+	asm volatile("mov %%rsp, %%rax  \n\t" : "=a"(esp));
+	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(0x123400000000 + 0x6f0));
+	asm volatile ("int $0x3 \n\t");
+	asm volatile("mov %%rax, %%rsp  \n\t" : : "a"(esp));
+
+	return 1;
+}
+
 int ac_test_exec(ac_test_t *at, ac_pool_t *pool)
 {
     int r;
@@ -756,7 +805,9 @@ const ac_test_fn ac_test_cases[] =
 {
 	corrupt_hugepage_triger,
 	check_pfec_on_prefetch_pte,
-	check_smep_andnot_wp
+	check_smep_andnot_wp,
+	check_retry_unhandleable_ins,
+	check_large_mapping_write_page_table
 };

 int ac_test_run(void)
@@ -770,6 +821,7 @@ int ac_test_run(void)
     tests = successes = 0;
     ac_env_int(&pool);
     ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()));
+
     do {
 	if (at.flags[AC_CPU_CR4_SMEP] && (ptl2[2] & 0x4))
 		ptl2[2] -= 0x4;
-- 
1.7.7.6

