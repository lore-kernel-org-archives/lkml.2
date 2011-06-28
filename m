Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1F1Qxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:53:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58967 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1F1QxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:53:05 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=1F_JT-UbaZcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=J2V5SHATNPe-tGh5OtcA:9 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110628165302.706740714@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jun 2011 12:47:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/2] mm: Remove use of ALLOW_RETRY when RETRY_NOWAIT is set
References: <20110628164750.281686775@goodmis.org>
Content-Disposition: inline; filename=0001-mm-Remove-use-of-ALLOW_RETRY-when-RETRY_NOWAIT-is-se.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The only user of FAULT_FLAG_RETRY_NOWAIT also sets the
FAULT_FLAG_ALLOW_RETRY flag. This makes the check in the
__lock_page_or_retry redundant as it checks the RETRY_NOWAIT
just after checking ALLOW_RETRY and then returns if it is
set.  The FAULT_FLAG_ALLOW_RETRY does not make any other
difference in this path.

Setting both and then ignoring one is quite confusing,
especially since this code has very subtle locking issues
when it comes to the mmap_sem.

Only set the RETRY_WAIT flag and have that do the necessary
work instead of confusing reviewers of this code by setting
ALLOW_RETRY and not releasing the mmap_sem.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/mm.h |    4 ++--
 mm/filemap.c       |   14 +++++++-------
 mm/memory.c        |    2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..2ec71d9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -151,8 +151,8 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 #define FAULT_FLAG_MKWRITE	0x04	/* Fault was mkwrite of existing pte */
-#define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking */
-#define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Don't drop mmap_sem and wait when retrying */
+#define FAULT_FLAG_ALLOW_RETRY	0x08	/* Retry fault if blocking (drops mmap_sem) */
+#define FAULT_FLAG_RETRY_NOWAIT	0x10	/* Wait when retrying (don't drop mmap_sem) */
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 
 /*
diff --git a/mm/filemap.c b/mm/filemap.c
index a8251a8..bc9978f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -665,14 +665,14 @@ EXPORT_SYMBOL_GPL(__lock_page_killable);
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
-	if (flags & FAULT_FLAG_ALLOW_RETRY) {
-		/*
-		 * CAUTION! In this case, mmap_sem is not released
-		 * even though return 0.
-		 */
-		if (flags & FAULT_FLAG_RETRY_NOWAIT)
-			return 0;
+	/*
+	 * Don't drop mmap_sem if FAULT_FLAG_RETRY_NOWAIT is
+	 * set, even if FAULT_FLAG_ALLOW_RETRY is set.
+	 */
+	if (flags & FAULT_FLAG_RETRY_NOWAIT)
+		return 0;
 
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
 		up_read(&mm->mmap_sem);
 		if (flags & FAULT_FLAG_KILLABLE)
 			wait_on_page_locked_killable(page);
diff --git a/mm/memory.c b/mm/memory.c
index 40b7531..5371b5e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1742,7 +1742,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				if (nonblocking)
 					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
 				if (foll_flags & FOLL_NOWAIT)
-					fault_flags |= (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT);
+					fault_flags |= FAULT_FLAG_RETRY_NOWAIT;
 
 				ret = handle_mm_fault(mm, vma, start,
 							fault_flags);
-- 
1.7.5.4


