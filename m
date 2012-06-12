Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2FLFVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:21:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2FLFVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:21:20 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Yinghai Lu <yinghai.lu@oracle.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] x86: revert "x86: Fix S4 regression"
Date: Tue, 12 Jun 2012 13:21:03 +0800
Message-Id: <1339478463-31172-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

This reverts the following commit:

	commit 8548c84da2f47e71bbbe300f55edb768492575f7
	Author: Takashi Iwai <tiwai@suse.de>
	Date:   Sun Oct 23 23:19:12 2011 +0200

	    x86: Fix S4 regression
	    
	    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
	    regression since 2.6.39, namely the machine reboots occasionally at S4
	    resume.  It doesn't happen always, overall rate is about 1/20.  But,
	    like other bugs, once when this happens, it continues to happen.
	    
	    This patch fixes the problem by essentially reverting the memory
	    assignment in the older way.

According to the previous discussion:
http://marc.info/?l=linux-kernel&m=133161674120253&w=2
it seems that so far the best solution is just reverting it.

Takashi, could you help to test if the S4 regression is still
there after this patch?

Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
 arch/x86/mm/init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..7ab7975 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -74,8 +74,9 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 #ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
-#endif
+
 	good_end = max_pfn_mapped << PAGE_SHIFT;
+#endif
 
 	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
 	if (!base)
-- 
1.7.7.6

