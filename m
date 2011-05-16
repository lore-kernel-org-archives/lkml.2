Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1EPXNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:13:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:36692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1EPXN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:13:29 -0400
Date: Mon, 16 May 2011 23:13:07 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-dc382fd5bcca7098a984705ed6ac880f539d068e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Allow ZONE_DMA to be configurable
Git-Commit-ID: dc382fd5bcca7098a984705ed6ac880f539d068e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 23:13:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc382fd5bcca7098a984705ed6ac880f539d068e
Gitweb:     http://git.kernel.org/tip/dc382fd5bcca7098a984705ed6ac880f539d068e
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 16 May 2011 13:54:10 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 May 2011 14:03:28 -0700

x86, mm: Allow ZONE_DMA to be configurable

ZONE_DMA is unnecessary for a large number of machines that do not
require less than 32-bit DMA addressing, e.g. ISA legacy DMA or PCI
cards with a restricted DMA address mask.

This patch allows users to disable ZONE_DMA for x86 if they know they
will not be using such devices with their kernel.

This prevents the VM from unnecessarily reserving a ratio of memory
(defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
for such allocations when it will never be used.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1105161353560.4353@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig      |    9 ++++++++-
 arch/x86/mm/init_32.c |    2 ++
 arch/x86/mm/init_64.c |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 648fca4..0eb801a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,7 +112,14 @@ config MMU
 	def_bool y
 
 config ZONE_DMA
-	def_bool y
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows devices with less than 32-bit
+	  addressing to allocate within the first 16MB of address space.
+	  Disable if no such devices will be used.
+
+	  If unsure, say Y.
 
 config SBUS
 	bool
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2cde0a34..29f7c6d 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -678,8 +678,10 @@ static void __init zone_sizes_init(void)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] =
 		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 #ifdef CONFIG_HIGHMEM
 	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0404bb3..d865c4a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -616,7 +616,9 @@ void __init paging_init(void)
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
+#endif
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
