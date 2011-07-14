Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1GNNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1GNNQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:16:25 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, matt.fleming@linux.intel.com, hughd@google.com
Subject: [PATCH] exec: remove page_table_lock for mm counters in acct_arg_size()
Date: Thu, 14 Jul 2011 15:16:20 +0200
Message-Id: <1310649380-13492-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 172703b mm: delete non-atomic mm counter implementation
removed non-atomic mm counters implementation. I think there is no need to hold
page_table_lock for add_mm_counter() when the splitted page table locks are not
used. This patch removes the locking.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 fs/exec.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..e6fc5e1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -182,13 +182,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 
 	bprm->vma_pages = pages;
 
-#ifdef SPLIT_RSS_COUNTING
 	add_mm_counter(mm, MM_ANONPAGES, diff);
-#else
-	spin_lock(&mm->page_table_lock);
-	add_mm_counter(mm, MM_ANONPAGES, diff);
-	spin_unlock(&mm->page_table_lock);
-#endif
 }
 
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
-- 
1.7.4.4

