Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3AHXrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:47:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:63681 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3AHXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:24 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 48/77] percpu: fix first chunk match in per_cpu_ptr_to_phys()
Date: Tue, 8 Jan 2013 18:35:27 -0500
Message-ID: <1357688156-25387-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9983b6f0cf8263e51bcf4c8a9dc0c1ef175b3c60 upstream.

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
Tested-by: Cliff Wickman <cpw@sgi.com>
[PG: for 2.6.34, diffstat differs slightly due to a trivial indenting
 difference, and 34 does not have the _maybe_unused annotation to delete]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/percpu.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 717cc6e..558543b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1343,10 +1343,36 @@ bool is_kernel_percpu_address(unsigned long addr)
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	if ((unsigned long)addr < VMALLOC_START ||
-			(unsigned long)addr >= VMALLOC_END)
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
+		if ((unsigned long)addr < VMALLOC_START ||
+		    (unsigned long)addr >= VMALLOC_END)
 		return __pa(addr);
-	else
+	} else
 		return page_to_phys(vmalloc_to_page(addr));
 }
 
-- 
1.7.12.1

