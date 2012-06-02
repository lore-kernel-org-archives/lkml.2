Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab2FBQyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 12:54:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34381 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab2FBQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 12:54:36 -0400
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH] Avoid dereferencing a possibly NULL mm
Date: Sat,  2 Jun 2012 22:24:22 +0530
Message-Id: <1338656062-25008-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NULL check for mm in exit_mm occurs after mm_release is
called. This looks wrong because mm_release dereferences mm:

...
                if (!(tsk->flags & PF_SIGNALED) &&
                    atomic_read(&mm->mm_users) > 1) {
                        /*
...

This dereference seems unsafe and hence is fixed by moving the NULL
check above mm_release.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 kernel/exit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 34867cc..15fe63c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -640,9 +640,11 @@ static void exit_mm(struct task_struct * tsk)
 	struct mm_struct *mm = tsk->mm;
 	struct core_state *core_state;
 
-	mm_release(tsk, mm);
 	if (!mm)
 		return;
+
+	mm_release(tsk, mm);
+
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state
-- 
1.7.7.6

