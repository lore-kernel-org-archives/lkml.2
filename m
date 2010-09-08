Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0IHPM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:12:56 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33419 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467Ab0IHPMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:12:55 -0400
To: kexec@lists.infradead.org, mingo@elte.hu
Subject: [PATCH] x86: copy_oldmem_page using cached addressing
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1OtMLz-0001yp-Ia@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 08 Sep 2010 10:14:27 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The copy of /proc/vmcore to a user buffer proceeds much faster
if the kernel addresses memory as cached.

With this patch we have seen an increase in transfer rate from less than
15MB/s to 80-460MB/s, depending on size of the transfer.  This makes
a big difference in time needed to save a system dump.

(Does anyone know of a reason why copy_oldmem_page() would need
 to use uncached addresses?)

Diffed against 2.6.36-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/crash_dump_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linus.current/arch/x86/kernel/crash_dump_64.c
===================================================================
--- linus.current.orig/arch/x86/kernel/crash_dump_64.c
+++ linus.current/arch/x86/kernel/crash_dump_64.c
@@ -34,7 +34,7 @@ ssize_t copy_oldmem_page(unsigned long p
 	if (!csize)
 		return 0;
 
-	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
 	if (!vaddr)
 		return -ENOMEM;
 
