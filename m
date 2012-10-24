Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2JXJhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:37:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2JXJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:37:04 -0400
Date: Wed, 24 Oct 2012 02:35:50 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-mnkio02xxtttiepsg9ek6qkw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de,
        dan.carpenter@oracle.com
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de, dan.carpenter@oracle.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, sched, mm: Fix NULL-ptr deref
Git-Commit-ID: 836e3bf3d85dfe29309cb62dc1714bb89801eea5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:35:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  836e3bf3d85dfe29309cb62dc1714bb89801eea5
Gitweb:     http://git.kernel.org/tip/836e3bf3d85dfe29309cb62dc1714bb89801eea5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 22 Oct 2012 19:21:32 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 08:52:12 +0200

numa, sched, mm: Fix NULL-ptr deref

Dan reported that there's a possible NULL pointer deref in this logic,
fix that. Further fix it to avoid a possible inf. loop (completely
unlikely in the case no vma is migratable). Also don't endlessly loop
on large length, simply truncate at the end of the address-space and
restart on the next go.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-mnkio02xxtttiepsg9ek6qkw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1dad296..dea3ca6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -933,40 +933,31 @@ void task_numa_work(struct callback_head *work)
 	if (cmpxchg(&mm->numa_next_scan, migrate, next_scan) != migrate)
 		return;
 
-
 	offset = mm->numa_scan_offset;
 	length = sysctl_sched_numa_scan_size;
 	length <<= 20;
 
 	down_write(&mm->mmap_sem);
 	vma = find_vma(mm, offset);
-again:
 	if (!vma) {
 		ACCESS_ONCE(mm->numa_scan_seq)++;
 		offset = 0;
 		vma = mm->mmap;
 	}
-	while (vma && !vma_migratable(vma)) {
-		vma = vma->vm_next;
-		if (!vma)
-			goto again;
-	}
-
-	offset = max(offset, vma->vm_start);
-	end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
-	length -= end - offset;
+	for (; vma && length > 0; vma = vma->vm_next) {
+		if (!vma_migratable(vma))
+			continue;
 
-	change_prot_none(vma, offset, end);
+		offset = max(offset, vma->vm_start);
+		end = min(ALIGN(offset + length, HPAGE_SIZE), vma->vm_end);
+		length -= end - offset;
 
-	offset = end;
+		change_prot_none(vma, offset, end);
 
-	if (length > 0) {
-		vma = vma->vm_next;
-		goto again;
+		offset = end;
 	}
 	mm->numa_scan_offset = offset;
 	up_write(&mm->mmap_sem);
-
 }
 
 /*
