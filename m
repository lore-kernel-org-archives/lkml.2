Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191Ab1FWXqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:46:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:33370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab1FWXqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:46:42 -0400
Date: Thu, 23 Jun 2011 23:46:21 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-2e9fbad5955f34bf1934bd6a8165c1f49ac8cc46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com, mingo@elte.hu
In-Reply-To: <1308827665-28890-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1308827665-28890-1-git-send-email-stefano.stabellini@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse
Git-Commit-ID: 2e9fbad5955f34bf1934bd6a8165c1f49ac8cc46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 23 Jun 2011 23:46:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e9fbad5955f34bf1934bd6a8165c1f49ac8cc46
Gitweb:     http://git.kernel.org/tip/2e9fbad5955f34bf1934bd6a8165c1f49ac8cc46
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Thu, 23 Jun 2011 12:14:25 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Jun 2011 16:14:02 -0700

x86-64, mm: Do not assume head_64.S used 4KB pages when !use_pse

head_64.S, which sets up the initial page table on x86_64, is not aware
of PSE being enabled or disabled and it always allocates the initial
mapping using 2MB pages.

Therefore on x86_64 find_early_table_space shouldn't update the amount
of pages needed for pte pages depending on the size of the initial
mapping, because we know for sure that no pte pages have been allocated
yet.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Link: http://lkml.kernel.org/r/1308827665-28890-1-git-send-email-stefano.stabellini@eu.citrix.com
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 36bacfe..e72c9f8 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -42,12 +42,19 @@ static void __init find_early_table_space(unsigned long start,
 			(PMD_SIZE * PTRS_PER_PMD));
 	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
 
+	/*
+	 * On x86_64 do not limit the size we need to cover with 4KB pages
+	 * depending on the initial allocation because head_64.S always uses
+	 * 2MB pages.
+	 */
+#ifdef CONFIG_X86_32
 	if (start < PFN_PHYS(max_pfn_mapped)) {
 		if (PFN_PHYS(max_pfn_mapped) < end)
 			size -= PFN_PHYS(max_pfn_mapped) - start;
 		else
 			size = 0;
 	}
+#endif
 
 #ifndef __PAGETABLE_PUD_FOLDED
 	if (end > pud_mapped) {
