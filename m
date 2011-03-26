Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1CZGnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 02:43:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57906 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1CZGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 02:43:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86_64: Fix page table building regression
Date: Fri, 25 Mar 2011 23:43:31 -0700
Message-ID: <m1k4fmxtyk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bddkYDleKCAcJbsjCA442nNwm9ofsxUM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently I had cause to enable PAGE_ALLOC_DEBUG and I discovered my
kdump kernel would not boot.  After some investigation it turns out that
in commit 80989ce064 "x86: clean up and and print out initial max_pfn_mapped"
that a limitation of the 32bit page table setup was unnecessarily
applied to the 64bit code.  The initial 64bit page table setup code is
careful to map in it's initial page table pages and unmap then when done
so they can live anywhere in memory, so we don't need to limit ourselves
to using pages that are already mapped into memory.

In my case I hit this because the first 512M was not usable by the
kdump kernel.

Allocating the page tables higher should improve the reliability of
kdump kernels.  As it stands today with the recommended 128M reserved
for a kdump kernel the area reserved for kdump kernels will frequently
be allocated above 512M, and the kdump kernels will only be able to
allocate it's page tables from the low 1M of RAM.  Strictly speaking
that memory is available but it is the one piece of memory that we don't
have a 100% guarantee there was not on-going DMA to before the kdump
kernel starts.

Allowing the page tables to not come from the low 512M also will allow
kernels built with DEBUG_PAGE_ALLOC to boot on systems with 256G of RAM.

Cc: stable@kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 arch/x86/mm/init.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 947f42a..52460a1 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -33,7 +33,7 @@ int direct_gbpages
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
-	unsigned long puds, pmds, ptes, tables, start;
+	unsigned long puds, pmds, ptes, tables, start, stop;
 	phys_addr_t base;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
@@ -74,11 +74,13 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
+	/* The 32bit kernel_physical_mapping_init is limited */
+	stop = max_pfn_mapped<<PAGE_SHIFT;
 #else
 	start = 0x8000;
+	stop = end;
 #endif
-	base = memblock_find_in_range(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
+	base = memblock_find_in_range(start, stop, tables, PAGE_SIZE);
 	if (base == MEMBLOCK_ERROR)
 		panic("Cannot find space for the kernel page tables");
 
-- 
1.7.4

