Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0C3GW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:22:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59491 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0C3GWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:22:55 -0400
Date: Tue, 30 Mar 2010 17:22:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the slabh tree with the percpu tree
Message-Id: <20100330172253.de55195b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the slabh tree got a conflict in
include/linux/percpu.h between commit
10fad5e46f6c7bdfb01b1a012380a38e3c6ab346 ("percpu, module: implement and
use is_kernel/module_percpu_address()") from the percpu tree and commit
d103d3b3e8512312b5254950035366d4422a479a ("percpu: don't implicitly
include slab.h from percpu.h") from the slabh tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/percpu.h
index 11d5f83,c784513..0000000
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@@ -135,10 -135,6 +135,7 @@@ extern int __init pcpu_page_first_chunk
  #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
  
  extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
- extern void __percpu *__alloc_percpu(size_t size, size_t align);
- extern void free_percpu(void __percpu *__pdata);
 +extern bool is_kernel_percpu_address(unsigned long addr);
- extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
  
  #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
  extern void __init setup_per_cpu_areas(void);
@@@ -148,33 -144,6 +145,12 @@@
  
  #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
  
- static inline void __percpu *__alloc_percpu(size_t size, size_t align)
- {
- 	/*
- 	 * Can't easily make larger alignment work with kmalloc.  WARN
- 	 * on it.  Larger alignment should only be used for module
- 	 * percpu sections on SMP for which this path isn't used.
- 	 */
- 	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
- 	return kzalloc(size, GFP_KERNEL);
- }
- 
- static inline void free_percpu(void __percpu *p)
- {
- 	kfree(p);
- }
- 
 +/* can't distinguish from other static vars, always false */
 +static inline bool is_kernel_percpu_address(unsigned long addr)
 +{
 +	return false;
 +}
 +
- static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
- {
- 	return __pa(addr);
- }
- 
  static inline void __init setup_per_cpu_areas(void) { }
  
  static inline void *pcpu_lpage_remapped(void *kaddr)
