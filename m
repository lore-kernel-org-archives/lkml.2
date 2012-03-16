Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030947Ab2CPDE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab2CPDEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:04:25 -0400
Date: Fri, 16 Mar 2012 11:02:16 +0800
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux@arm.linux.org.uk, vgoyal@redhat.com,
        kexec@lists.infradead.org, akpm@linux-foundation.org
Subject: [PATCH v2 resend] kdump x86: fix total mem size calculation for
 reservation
Message-ID: <20120316030216.GA5123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
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

[v1 -> v2]: refresh the patch based on latest linus tree

Signed-off-by: Dave Young <dyoung@redhat.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/x86/kernel/setup.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- linux-2.6.orig/arch/x86/kernel/setup.c	2012-03-04 03:46:35.000000000 +0800
+++ linux-2.6/arch/x86/kernel/setup.c	2012-03-10 12:44:58.133300788 +0800
@@ -509,15 +509,6 @@ static void __init memblock_x86_reserve_
 
 #ifdef CONFIG_KEXEC
 
-static inline unsigned long long get_total_mem(void)
-{
-	unsigned long long total;
-
-	total = max_pfn - min_low_pfn;
-
-	return total << PAGE_SHIFT;
-}
-
 /*
  * Keep the crash kernel below this limit.  On 32 bits earlier kernels
  * would limit the kernel to the low 512 MiB due to mapping restrictions.
@@ -536,7 +527,7 @@ static void __init reserve_crashkernel(v
 	unsigned long long crash_size, crash_base;
 	int ret;
 
-	total_mem = get_total_mem();
+	total_mem = memblock_phys_mem_size();
 
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
