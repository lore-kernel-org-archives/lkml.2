Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2CII1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:27:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab2CII1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:27:45 -0500
Date: Fri, 9 Mar 2012 16:30:09 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux@arm.linux.org.uk,
        vgoyal@redhat.com
Subject: [PATCH] kdump x86: fix total mem size calculation for reservation
Message-ID: <20120309083009.GA14067@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crashkernel reservation need know the total memory size. Current get_total_mem
simply use max_pfn - min_low_pfn. It is wrong because it will including
memory holes in the middle.

Especially for kvm guest with memory > 0xe0000000, there's below in qemu code:
qemu split memory as below:
    if (ram_size >= 0xe0000000 ) {
        above_4g_mem_size = ram_size - 0xe0000000;
        below_4g_mem_size = 0xe0000000;
    } else {
        below_4g_mem_size = ram_size;
    }
So for 4G mem guest, seabios will insert a 512M usable region beyond of 4G.
Thus in above case max_pfn - min_low_pfn will be more than original memsize.

Fixing this issue by using memblock_phys_mem_size() to get the total memsize.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 [Ther's similar code in arm, I'm not sure whether the memblock_phys_mem_size
 works with arm or not. If it works I can also update that part of code.]
 arch/x86/kernel/setup.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- linux-2.6.orig/arch/x86/kernel/setup.c	2012-03-09 11:27:30.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup.c	2012-03-09 15:41:29.666530976 +0800
@@ -509,16 +509,6 @@ static void __init memblock_x86_reserve_
 
 #ifdef CONFIG_KEXEC
 
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_pfn - min_low_pfn;
-	printk("hidave: memsize=%llu\n", memblock_phys_mem_size());
-
-	return total << PAGE_SHIFT;
-}
-
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
@@ -537,7 +527,7 @@ static void __init reserve_crashkernel(v
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	total_mem = get_total_mem();
+	total_mem = memblock_phys_mem_size();
 
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
