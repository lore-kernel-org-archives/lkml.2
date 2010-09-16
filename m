Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0IPE6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:58:38 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34333 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750714Ab0IPE6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:58:37 -0400
Date: Thu, 16 Sep 2010 00:57:58 -0400 (EDT)
From: caiqian@redhat.com
To: tj@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        kexec <kexec@lists.infradead.org>, graff.yang@gmail.com,
        Marcelo Tosatti <mtosatti@redhat.com>, dhowells@redhat.com,
        sonic.adi@gmail.com, Avi Kivity <avi@redhat.com>,
        Chris Lalancette <clalance@redhat.com>, stable@kernel.org,
        Cliff Wickman <cpw@sgi.com>
Message-ID: <1301046921.1075601284613078206.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <387799126.1075471284612953135.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: [PATCH] fix kvm kdump regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

020ec6537aa65c18e9084c568d7b94727f2026fd introduced a regression that an empty vmcore was generated during kdump on a kvm guest.
ioremap: invalid physical address db74000000000000
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x307/0x380()
Hardware name: KVM
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.36-rc2-mm1+ #2
Call Trace:
 [<ffffffff8105f48f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8103052e>] ? copy_oldmem_page+0x4e/0xc0
 [<ffffffff8105f4ea>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8103f0a7>] __ioremap_caller+0x307/0x380
 [<ffffffff8103f1f7>] ioremap_nocache+0x17/0x20
 [<ffffffff8103052e>] copy_oldmem_page+0x4e/0xc0
 [<ffffffff811af4ca>] read_from_oldmem+0x7a/0xb0
 [<ffffffff81c4f70b>] merge_note_headers_elf64.clone.1+0x6c/0x21f
 [<ffffffff8103056e>] ? copy_oldmem_page+0x8e/0xc0
 [<ffffffff811af4ca>] ? read_from_oldmem+0x7a/0xb0
 [<ffffffff81c4fa5b>] vmcore_init+0x19d/0x396
 [<ffffffff81c4f8be>] ? vmcore_init+0x0/0x396
 [<ffffffff81002053>] do_one_initcall+0x43/0x190
 [<ffffffff81c278ab>] kernel_init+0x2a0/0x330
 [<ffffffff8100be84>] kernel_thread_helper+0x4/0x10
 [<ffffffff81c2760b>] ? kernel_init+0x0/0x330
 [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
---[ end trace 93d72a36b9146f22 ]---
Kdump: vmcore not initialized

This patch fixed it by reverting a chunk of the above commit and 9983b6f0cf8263e51bcf4c8a9dc0c1ef175b3c60 which is based on it.

Signed-off-by: CAI Qian <caiqian@redhat.com>

diff --git a/mm/percpu.c b/mm/percpu.c
index 77e3f5a..0dbb12a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -986,38 +986,10 @@ bool is_kernel_percpu_address(unsigned long addr)
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
-	bool in_first_chunk = false;
-	unsigned long first_start, first_end;
-	unsigned int cpu;
-
-	/*
-	 * The following test on first_start/end isn't strictly
-	 * necessary but will speed up lookups of addresses which
-	 * aren't in the first chunk.
-	 */
-	first_start = pcpu_chunk_addr(pcpu_first_chunk, pcpu_first_unit_cpu, 0);
-	first_end = pcpu_chunk_addr(pcpu_first_chunk, pcpu_last_unit_cpu,
-				    pcpu_unit_pages);
-	if ((unsigned long)addr >= first_start &&
-	    (unsigned long)addr < first_end) {
-		for_each_possible_cpu(cpu) {
-			void *start = per_cpu_ptr(base, cpu);
-
-			if (addr >= start && addr < start + pcpu_unit_size) {
-				in_first_chunk = true;
-				break;
-			}
-		}
-	}
-
-	if (in_first_chunk) {
-		if ((unsigned long)addr < VMALLOC_START ||
-		    (unsigned long)addr >= VMALLOC_END)
-			return __pa(addr);
-		else
-			return page_to_phys(vmalloc_to_page(addr));
-	} else
+	if ((unsigned long)addr < VMALLOC_START ||
+			(unsigned long)addr >= VMALLOC_END)
+		return __pa(addr);
+	else
 		return page_to_phys(pcpu_addr_to_page(addr));
 }
