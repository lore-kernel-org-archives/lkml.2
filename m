Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459Ab0FQRfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:35:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0FQRfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:35:19 -0400
Message-ID: <4C1A5CD4.3020802@kernel.org>
Date: Thu, 17 Jun 2010 19:35:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: per_cpu_ptr_to_phys() failure on UV x86_64
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com> <4C1A5679.8010907@kernel.org>
In-Reply-To: <4C1A5679.8010907@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 17:35:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 07:08 PM, Tejun Heo wrote:
> (scratching head...) So, that means it's given an address for which
> !pcpu_addr_in_first_chunk() but outside of vmalloc area.  Strange.
> I'll find out what's going on.

Does the following patch work?  The original patch assumed that @addr
would be the address of the base cpu which isn't true.  I only compile
tested the patch so it might be broken (sorry, I gotta go somewhere
now) but this should be the right direction.

Thanks.

diff --git a/mm/percpu.c b/mm/percpu.c
index 46485e1..8956155 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -978,14 +978,23 @@ bool is_kernel_percpu_address(unsigned long addr)
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	if (pcpu_addr_in_first_chunk(addr)) {
-		if ((unsigned long)addr < VMALLOC_START ||
-		    (unsigned long)addr >= VMALLOC_END)
-			return __pa(addr);
-		else
-			return page_to_phys(vmalloc_to_page(addr));
-	} else
-		return page_to_phys(pcpu_addr_to_page(addr));
+	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		void *start = per_cpu_ptr(base, cpu);
+
+		if (addr >= start && addr < start + pcpu_unit_size) {
+			/* in the first chunk */
+			if ((unsigned long)addr < VMALLOC_START ||
+			    (unsigned long)addr >= VMALLOC_END)
+				return __pa(addr);
+			else
+				return page_to_phys(vmalloc_to_page(addr));
+		}
+	}
+	/* in one of the other chunks */
+	return page_to_phys(pcpu_addr_to_page(addr));
 }

 static inline size_t pcpu_calc_fc_sizes(size_t static_size,


-- 
tejun
