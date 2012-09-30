Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2I3H7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 03:59:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33003 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2I3H5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 03:57:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
Date: Sun, 30 Sep 2012 00:57:15 -0700
Message-Id: <1348991844-12285-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After

| commit 8548c84da2f47e71bbbe300f55edb768492575f7
| Author: Takashi Iwai <tiwai@suse.de>
| Date:   Sun Oct 23 23:19:12 2011 +0200
|
|    x86: Fix S4 regression
|
|    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
|    regression since 2.6.39, namely the machine reboots occasionally at S4
|    resume.  It doesn't happen always, overall rate is about 1/20.  But,
|    like other bugs, once when this happens, it continues to happen.
|
|    This patch fixes the problem by essentially reverting the memory
|    assignment in the older way.

Have some page table around 512M again, that will prevent kdump to find 512M
under 768M.

We need revert that reverting, so we could put page table high again for 64bit.

Takashi agreed that S4 regression could be something else.

	https://lkml.org/lkml/2012/6/15/182

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 9f69180..aadb154 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
 	good_end = max_pfn_mapped << PAGE_SHIFT;
+#endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (!base)
-- 
1.7.7

