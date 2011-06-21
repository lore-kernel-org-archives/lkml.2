Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1FUUi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:38:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:39463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab1FUUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:38:25 -0400
Date: Tue, 21 Jun 2011 20:38:11 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Message-ID: <tip-1938931a20da89359fb3f1189d46f9b0f29e5117@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1307470409-7654-3-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1307470409-7654-3-git-send-email-stefano.stabellini@eu.citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, init : Move memblock_x86_reserve_range PGTABLE to find_early_table_space
Git-Commit-ID: 1938931a20da89359fb3f1189d46f9b0f29e5117
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 20:38:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1938931a20da89359fb3f1189d46f9b0f29e5117
Gitweb:     http://git.kernel.org/tip/1938931a20da89359fb3f1189d46f9b0f29e5117
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Tue, 7 Jun 2011 19:13:29 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Jun 2011 13:07:14 -0700

x86, init : Move memblock_x86_reserve_range PGTABLE to find_early_table_space

Now that find_early_table_space knows how to calculate the exact amout
of memory needed by the kernel pagetable, we can reserve the range
directly in find_early_table_space.

This allows Xen to know what memory range these will occupy and
therefore how to manage that memory.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Link: http://lkml.kernel.org/r/1307470409-7654-3-git-send-email-stefano.stabellini@eu.citrix.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 15590fd..36bacfe 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -104,6 +104,10 @@ static void __init find_early_table_space(unsigned long start,
 
 	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
 		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+
+	if (pgt_buf_top > pgt_buf_start)
+		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
+				 pgt_buf_top << PAGE_SHIFT, "PGTABLE");
 }
 
 struct map_range {
@@ -301,10 +305,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		printk(KERN_DEBUG "initial kernel pagetable allocation wasted %lx"
 				" pages\n", pgt_buf_top - pgt_buf_end);
 
-	if (!after_bootmem && pgt_buf_end > pgt_buf_start)
-		memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
-				 pgt_buf_end << PAGE_SHIFT, "PGTABLE");
-
 	if (!after_bootmem)
 		early_memtest(start, end);
 
