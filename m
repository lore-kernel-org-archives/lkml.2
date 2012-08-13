Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2HMUVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2HMUVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>,
        Uros Bizjak <ubizjak@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 24/82] ARM: 7479/1: mm: avoid NULL dereference when flushing gate_vma with VIVT caches
Date: Mon, 13 Aug 2012 13:19:00 -0700
Message-Id: <20120813201748.557997362@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit b74253f78400f9a4b42da84bb1de7540b88ce7c4 upstream.

The vivt_flush_cache_{range,page} functions check that the mm_struct
of the VMA being flushed has been active on the current CPU before
performing the cache maintenance.

The gate_vma has a NULL mm_struct pointer and, as such, will cause a
kernel fault if we try to flush it with the above operations. This
happens during ELF core dumps, which include the gate_vma as it may be
useful for debugging purposes.

This patch adds checks to the VIVT cache flushing functions so that VMAs
with a NULL mm_struct are flushed unconditionally (the vectors page may
be dirty if we use it to store the current TLS pointer).

Reported-by: Gilles Chanteperdrix <gilles.chanteperdrix@xenomai.org>
Tested-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/cacheflush.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -215,7 +215,9 @@ static inline void vivt_flush_cache_mm(s
 static inline void
 vivt_flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
-	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (!mm || cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm)))
 		__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
 					vma->vm_flags);
 }
@@ -223,7 +225,9 @@ vivt_flush_cache_range(struct vm_area_st
 static inline void
 vivt_flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn)
 {
-	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (!mm || cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm))) {
 		unsigned long addr = user_addr & PAGE_MASK;
 		__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
 	}


