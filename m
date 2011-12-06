Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab1LFJ7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:59:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35045 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1LFJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:59:10 -0500
Date: Tue, 6 Dec 2011 01:58:49 -0800
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Message-ID: <tip-855c743a27bb58a9a521bdc485ef5acfdb69badc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mgorman@suse.de, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mgorman@suse.de, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
In-Reply-To: <20111206080833.GB3105@redhat.com>
References: <20111206080833.GB3105@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Initialize high mem before free_all_bootmem()
Git-Commit-ID: 855c743a27bb58a9a521bdc485ef5acfdb69badc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:58:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  855c743a27bb58a9a521bdc485ef5acfdb69badc
Gitweb:     http://git.kernel.org/tip/855c743a27bb58a9a521bdc485ef5acfdb69badc
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 6 Dec 2011 09:08:34 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:23:53 +0100

x86/mm: Initialize high mem before free_all_bootmem()

Patch fixes a boot crash with pagealloc debugging enabled:

  Initializing HighMem for node 0 (000377fe:0003fff0)
  BUG: unable to handle kernel paging request at f6fefe80
  IP: [<c1621ab5>] find_range_array+0x5e/0x69
  [...]
  Call Trace:
   [<c1622064>] __get_free_all_memory_range+0x39/0xb4
   [<c1620dd0>] add_highpages_with_active_regions+0x18/0x9b
   [<c1621a2e>] set_highmem_pages_init+0x70/0x90
   [<c162122b>] mem_init+0x50/0x21b
   [<c16155bd>] start_kernel+0x1bf/0x31c
   [<c1615065>] i386_start_kernel+0x65/0x67

The crash happens when memblock wants to allocate big area for
temporary "struct range" array and reuses pages from top of low
memory, which were already passed to the buddy allocator.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/r/20111206080833.GB3105@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 3bebaed..a2fecb1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -744,6 +744,17 @@ void __init mem_init(void)
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
+	/*
+	 * With CONFIG_DEBUG_PAGEALLOC initialization of highmem pages has to
+	 * be done before free_all_bootmem(). Memblock use free low memory for
+	 * temporary data (see find_range_array()) and for this purpose can use
+	 * pages that was already passed to the buddy allocator, hence marked as
+	 * not accessible in the page tables when compiled with
+	 * CONFIG_DEBUG_PAGEALLOC. Otherwise order of initialization is not
+	 * important here.
+	 */
+	set_highmem_pages_init();
+
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
@@ -755,8 +766,6 @@ void __init mem_init(void)
 		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
 			reservedpages++;
 
-	set_highmem_pages_init();
-
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
