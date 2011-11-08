Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1KHP3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:29:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946Ab1KHP3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:29:25 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Rafael J. Wysocki" <rjw@suse.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] thp: reduce khugepaged freezing latency
Date: Tue,  8 Nov 2011 16:29:11 +0100
Message-Id: <1320766151-2619-2-git-send-email-aarcange@redhat.com>
In-Reply-To: <1320766151-2619-1-git-send-email-aarcange@redhat.com>
References: <4EB8E969.6010502@suse.cz>
 <1320766151-2619-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lack of set_freezable_with_signal() prevented khugepaged to be waken
up (and prevented to sleep again) across the
schedule_timeout_interruptible() calls after freezing() becomes
true. The tight loop in khugepaged_alloc_hugepage() also missed one
try_to_freeze() call in case alloc_hugepage() would repeatedly fail in
turn preventing the loop to break and to reach the try_to_freeze() in
the khugepaged main loop.

khugepaged would still freeze just fine by trying again the next
minute but it's better if it freezes immediately.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/huge_memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4298aba..67311d1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2277,6 +2277,7 @@ static struct page *khugepaged_alloc_hugepage(void)
 		if (!hpage) {
 			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 			khugepaged_alloc_sleep();
+			try_to_freeze();
 		} else
 			count_vm_event(THP_COLLAPSE_ALLOC);
 	} while (unlikely(!hpage) &&
@@ -2331,7 +2332,7 @@ static int khugepaged(void *none)
 {
 	struct mm_slot *mm_slot;
 
-	set_freezable();
+	set_freezable_with_signal();
 	set_user_nice(current, 19);
 
 	/* serialize with start_khugepaged() */
