Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab1KOIeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:34:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1KOIen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:34:43 -0500
Date: Tue, 15 Nov 2011 16:36:46 +0800
From: Dave Young <dyoung@redhat.com>
To: gregkh@suse.de, tj@kernel.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCCH percpu: add cpunum param in per_cpu_ptr_to_phys
Message-ID: <20111115083646.GA21468@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per_cpu_ptr_to_phys iterate all cpu to get the phy addr
let's leave the caller to pass the cpu number to it.

Actually in the only one user show_crash_notes,
cpunum is provided already before calling this. 

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/base/cpu.c     |    2 +-
 include/linux/percpu.h |    2 +-
 mm/percpu.c            |   29 ++++-------------------------
 3 files changed, 6 insertions(+), 27 deletions(-)

--- linux-2.6.orig/drivers/base/cpu.c	2011-09-20 12:39:36.000000000 +0800
+++ linux-2.6/drivers/base/cpu.c	2011-11-15 14:52:42.742852411 +0800
@@ -125,7 +125,7 @@ static ssize_t show_crash_notes(struct s
 	 * boot up and this data does not change there after. Hence this
 	 * operation should be safe. No locking required.
 	 */
-	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
+	addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum), cpunum);
 	rc = sprintf(buf, "%Lx\n", addr);
 	return rc;
 }
--- linux-2.6.orig/include/linux/percpu.h	2011-11-15 11:06:18.000000000 +0800
+++ linux-2.6/include/linux/percpu.h	2011-11-15 14:53:28.352605321 +0800
@@ -160,7 +160,7 @@ extern void __init percpu_init_late(void
 
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
-extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
+extern phys_addr_t per_cpu_ptr_to_phys(void *addr, int cpunum);
 
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
--- linux-2.6.orig/mm/percpu.c	2011-11-15 11:06:19.000000000 +0800
+++ linux-2.6/mm/percpu.c	2011-11-15 14:59:56.927166899 +0800
@@ -971,6 +971,7 @@ bool is_kernel_percpu_address(unsigned l
 /**
  * per_cpu_ptr_to_phys - convert translated percpu address to physical address
  * @addr: the address to be converted to physical address
+ * @cpunum: the cpu number of percpu address
  *
  * Given @addr which is dereferenceable address obtained via one of
  * percpu access macros, this function translates it into its physical
@@ -980,34 +981,12 @@ bool is_kernel_percpu_address(unsigned l
  * RETURNS:
  * The physical address for @addr.
  */
-phys_addr_t per_cpu_ptr_to_phys(void *addr)
+phys_addr_t per_cpu_ptr_to_phys(void *addr, int cpunum)
 {
 	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
-	bool in_first_chunk = false;
-	unsigned long first_start, first_end;
-	unsigned int cpu;
+	void *start = per_cpu_ptr(base, cpunum);
 
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
+	if (addr >= start && addr < start + pcpu_unit_size) {
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
