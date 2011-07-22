Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1GVTkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:40:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:60215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab1GVTkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:40:17 -0400
Date: Fri, 22 Jul 2011 19:40:02 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-b17a5f97d413c9bd882ea5011462f7a530d37ae0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1311178074-16833-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1311178074-16833-1-git-send-email-stefano.stabellini@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86_32: Calculate additional memory needed by the fixmap
Git-Commit-ID: b17a5f97d413c9bd882ea5011462f7a530d37ae0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:40:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b17a5f97d413c9bd882ea5011462f7a530d37ae0
Gitweb:     http://git.kernel.org/tip/b17a5f97d413c9bd882ea5011462f7a530d37ae0
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Wed, 20 Jul 2011 17:07:54 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:45:55 -0700

x86_32: Calculate additional memory needed by the fixmap

When NR_CPUS increases the fixmap might need more than the page
allocated by head_32.S.
This patch introduces the logic to calculate the additional memory that
is going to be required by early_ioremap_page_table_range_init:

- enough memory to allocate the pte pages needed to cover the fixmap
virtual memory range, minus the single page allocated by head_32.S;

- account for the page already allocated by early_ioremap_init;

- account for the two additional pages that might be needed to make sure
that the kmap's ptes are contiguous.

Changes to v1:

- refactor the fixmap space calculation in a new function to make it
easier to read and avoid compilation warnings on x86_64.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Link: http://lkml.kernel.org/r/1311178074-16833-1-git-send-email-stefano.stabellini@eu.citrix.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e72c9f8..a90ccc4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,6 +28,57 @@ int direct_gbpages
 #endif
 ;
 
+static unsigned long __init find_early_fixmap_space(void)
+{
+	unsigned long size = 0;
+#ifdef CONFIG_X86_32
+	int kmap_begin_pmd_idx, kmap_end_pmd_idx;
+	int fixmap_begin_pmd_idx, fixmap_end_pmd_idx;
+	int btmap_begin_pmd_idx;
+
+	fixmap_begin_pmd_idx =
+		__fix_to_virt(__end_of_fixed_addresses - 1) >> PMD_SHIFT;
+	/*
+	 * fixmap_end_pmd_idx is the end of the fixmap minus the PMD that
+	 * has been defined in the data section by head_32.S (see
+	 * initial_pg_fixmap).
+	 * Note: This is similar to what early_ioremap_page_table_range_init
+	 * does except that the "end" has PMD_SIZE expunged as per previous
+	 * comment.
+	 */
+	fixmap_end_pmd_idx = (FIXADDR_TOP - 1) >> PMD_SHIFT;
+	btmap_begin_pmd_idx = __fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT;
+	kmap_begin_pmd_idx = __fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	kmap_end_pmd_idx = __fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+
+	size = fixmap_end_pmd_idx - fixmap_begin_pmd_idx;
+	/*
+	 * early_ioremap_init has already allocated a PMD at
+	 * btmap_begin_pmd_idx
+	 */
+	if (btmap_begin_pmd_idx < fixmap_end_pmd_idx)
+		size--;
+
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * see page_table_kmap_check: if the kmap spans multiple PMDs, make
+	 * sure the pte pages are allocated contiguously. It might need up
+	 * to two additional pte pages to replace the page declared by
+	 * head_32.S and the one allocated by early_ioremap_init, if they
+	 * are even partially used for the kmap.
+	 */
+	if (kmap_begin_pmd_idx != kmap_end_pmd_idx) {
+		if (kmap_end_pmd_idx == fixmap_end_pmd_idx)
+			size++;
+		if (btmap_begin_pmd_idx >= kmap_begin_pmd_idx &&
+				btmap_begin_pmd_idx <= kmap_end_pmd_idx)
+			size++;
+	}
+#endif
+#endif
+	return (size * PMD_SIZE + PAGE_SIZE - 1) >> PAGE_SHIFT;
+}
+
 static void __init find_early_table_space(unsigned long start,
 		unsigned long end, int use_pse, int use_gbpages)
 {
@@ -92,6 +143,8 @@ static void __init find_early_table_space(unsigned long start,
 	} else
 		ptes = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
+	ptes += find_early_fixmap_space();
+
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
 	if (!tables)
