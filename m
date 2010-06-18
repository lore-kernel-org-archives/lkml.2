Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab0FRJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:56:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:46761 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749Ab0FRJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:56:19 -0400
Message-ID: <4C1B42C0.3090906@kernel.org>
Date: Fri, 18 Jun 2010 11:56:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: fix first chunk match in per_cpu_ptr_to_phys()
References: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com> <4C1A5679.8010907@kernel.org> <4C1A5CD4.3020802@kernel.org> <20100617182453.GA31478@sgi.com>
In-Reply-To: <20100617182453.GA31478@sgi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 09:56:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

per_cpu_ptr_to_phys() determines whether the passed in @addr belongs
to the first_chunk or not by just matching the address against the
address range of the base unit (unit0, used by cpu0).  When an adress
from another cpu was passed in, it will always determine that the
address doesn't belong to the first chunk even when it does.  This
makes the function return a bogus physical address which may lead to
crash.

This problem was discovered by Cliff Wickman while investigating a
crash during kdump on a SGI UV system.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Cliff Wickman <cpw@sgi.com>
---
Can you please verify this one?  I added a small optimization so that
it doesn't suck too bad on large machines and it works fine here but
it would be great to have your Tested-by:.

Thanks.

 mm/percpu.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 46485e1..6470e77 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -229,8 +229,8 @@ static int __maybe_unused pcpu_page_idx(unsigned int cpu, int page_idx)
 	return pcpu_unit_map[cpu] * pcpu_unit_pages + page_idx;
 }

-static unsigned long __maybe_unused pcpu_chunk_addr(struct pcpu_chunk *chunk,
-						unsigned int cpu, int page_idx)
+static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
+				     unsigned int cpu, int page_idx)
 {
 	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
 		(page_idx << PAGE_SHIFT);
@@ -978,7 +978,32 @@ bool is_kernel_percpu_address(unsigned long addr)
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	if (pcpu_addr_in_first_chunk(addr)) {
+	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
+	bool in_first_chunk = false;
+	unsigned long first_start, first_end;
+	unsigned int cpu;
+
+	/*
+	 * The following test on first_start/end isn't strictly
+	 * necessary but will speed up lookups of addresses which
+	 * aren't in the first chunk.
+	 */
+	first_start = pcpu_chunk_addr(pcpu_first_chunk, pcpu_first_unit_cpu, 0);
+	first_end = pcpu_chunk_addr(pcpu_first_chunk, pcpu_last_unit_cpu,
+				    pcpu_unit_pages);
+	if ((unsigned long)addr >= first_start &&
+	    (unsigned long)addr < first_end) {
+		for_each_possible_cpu(cpu) {
+			void *start = per_cpu_ptr(base, cpu);
+
+			if (addr >= start && addr < start + pcpu_unit_size) {
+				in_first_chunk = true;
+				break;
+			}
+		}
+	}
+
+	if (in_first_chunk) {
 		if ((unsigned long)addr < VMALLOC_START ||
 		    (unsigned long)addr >= VMALLOC_END)
 			return __pa(addr);
-- 
1.6.4.2

