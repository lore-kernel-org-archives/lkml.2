Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0DHEMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:12:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:53240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0DHEMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] percpu: factor out pcpu_addr_in_first/reserved_chunk() and update per_cpu_ptr_to_phys()
Date: Thu,  8 Apr 2010 13:11:01 +0900
Message-Id: <1270699865-16954-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270699865-16954-1-git-send-email-tj@kernel.org>
References: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out pcpu_addr_in_first/reserved_chunk() from
pcpu_chunk_addr_search() and use it to update per_cpu_ptr_to_phys()
such that it handles first chunk differently from the rest.

This patch doesn't cause any functional change and is to prepare for
percpu nommu support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 mm/percpu.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 6e09741..1aeb081 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -177,6 +177,21 @@ static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static void pcpu_reclaim(struct work_struct *work);
 static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
 
+static bool pcpu_addr_in_first_chunk(void *addr)
+{
+	void *first_start = pcpu_first_chunk->base_addr;
+
+	return addr >= first_start && addr < first_start + pcpu_unit_size;
+}
+
+static bool pcpu_addr_in_reserved_chunk(void *addr)
+{
+	void *first_start = pcpu_first_chunk->base_addr;
+
+	return addr >= first_start &&
+		addr < first_start + pcpu_reserved_chunk_limit;
+}
+
 static int __pcpu_size_to_slot(int size)
 {
 	int highbit = fls(size);	/* size is in bytes */
@@ -334,12 +349,10 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
  */
 static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
-	void *first_start = pcpu_first_chunk->base_addr;
-
 	/* is it in the first chunk? */
-	if (addr >= first_start && addr < first_start + pcpu_unit_size) {
+	if (pcpu_addr_in_first_chunk(addr)) {
 		/* is it in the reserved area? */
-		if (addr < first_start + pcpu_reserved_chunk_limit)
+		if (pcpu_addr_in_reserved_chunk(addr))
 			return pcpu_reserved_chunk;
 		return pcpu_first_chunk;
 	}
@@ -1343,10 +1356,13 @@ bool is_kernel_percpu_address(unsigned long addr)
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
-	if ((unsigned long)addr < VMALLOC_START ||
-			(unsigned long)addr >= VMALLOC_END)
-		return __pa(addr);
-	else
+	if (pcpu_addr_in_first_chunk(addr)) {
+		if ((unsigned long)addr < VMALLOC_START ||
+		    (unsigned long)addr >= VMALLOC_END)
+			return __pa(addr);
+		else
+			return page_to_phys(vmalloc_to_page(addr));
+	} else
 		return page_to_phys(vmalloc_to_page(addr));
 }
 
-- 
1.6.4.2

