Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab1DNSiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:38:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081Ab1DNSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=pWhelesGbx0S3074pRMmqlTocxaSc91+H2OrUG+JK7hP6yx6GtuwxpfmnDYWtobAof
         j6x4kin1WW1LCpcpOKkw==
Date: Thu, 14 Apr 2011 11:38:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch v2] x86: allow ZONE_DMA to be configurable
Message-ID: <alpine.DEB.2.00.1104141134260.386@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZONE_DMA is unnecessary for a large number of machines that do not
require addressing in the lower 16MB of memory because they do not use
ISA devices with 16-bit address registers (plus one page byte register).

This patch allows users to disable ZONE_DMA for x86 if they know they
will not be using such devices with their kernel.

This prevents the VM from unnecessarily reserving a ratio of memory
(defaulting to 1/256th of system capacity) with lowmem_reserve_ratio
for such allocations when it will never be used.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: updated from October 2010

     H. Peter Anvin requested that CONFIG_EMBEDDED be renamed to
     CONFIG_EXPERT prior to this change in the original thread:

	http://marc.info/?t=128701541500005

     I did that at Ingo's suggestion.  Also, CONFIG_GENERIC_ISA_DMA
     and CONFIG_ISA_DMA_API are now configurable on x86 as discussed
     in the same thread, as well, for additional text savings in
     combination with this patch.

 arch/x86/Kconfig      |    9 ++++++++-
 arch/x86/mm/init_32.c |    2 ++
 arch/x86/mm/init_64.c |    2 ++
 3 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,7 +112,14 @@ config MMU
 	def_bool y
 
 config ZONE_DMA
-	def_bool y
+	bool "DMA memory allocation support" if EXPERT
+	default y
+	help
+	  DMA memory allocation support allows old ISA devices with 16-bit
+	  address registers to allocate memory within the first 16MB of
+	  address space.  Disable if no such devices will be used.
+
+	  If unsure, say Y.
 
 config SBUS
 	bool
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
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
 
