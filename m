Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0IPDXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 23:23:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab0IPDXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 23:23:42 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [PATCH] Export amount of anonymous memory in a mapping via smaps
Date: Thu, 16 Sep 2010 08:56:25 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Matt Mackall <mpm@selenic.com>, Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
References: <20100915134724.C9EE.A69D9226@jp.fujitsu.com> <1284579969.21906.451.camel@calx> <AANLkTini3k1hK-9RM6io0mOf4VoDzGpbUEpiv=WHfhEW@mail.gmail.com>
In-Reply-To: <AANLkTini3k1hK-9RM6io0mOf4VoDzGpbUEpiv=WHfhEW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009160856.25923.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the number of anonymous pages in a mapping via smaps.

Even the private pages in a mapping backed by a file, would be marked as
anonymous, when they are modified. Export this information to user-space via
smaps.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..3c18fc8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -326,6 +326,7 @@ struct mem_size_stats {
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long anonymous;
 	unsigned long swap;
 	u64 pss;
 };
@@ -356,6 +357,9 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		if (!page)
 			continue;
 
+		if (PageAnon(page))
+			mss->anonymous += PAGE_SIZE;
+
 		mss->resident += PAGE_SIZE;
 		/* Accumulate the size in pages that have been accessed. */
 		if (pte_young(ptent) || PageReferenced(page))
@@ -409,6 +413,7 @@ static int show_smap(struct seq_file *m, void *v)
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
+		   "Anonymous:      %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n",
@@ -420,6 +425,7 @@ static int show_smap(struct seq_file *m, void *v)
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
+		   mss.anonymous >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10);
