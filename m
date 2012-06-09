Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2FIJnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 05:43:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59237 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab2FIJni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 05:43:38 -0400
Subject: [PATCH] mm: correctly synchronize rss-counters at exit/exec
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Date: Sat, 09 Jun 2012 13:43:32 +0400
Message-ID: <20120609094332.5636.91441.stgit@zurg>
In-Reply-To: <20120608170152.GA30975@redhat.com>
References: <20120608170152.GA30975@redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_exit() and exec_mmap() call sync_mm_rss() before mm_release()
does put_user(clear_child_tid) which can update task->rss_stat
and thus make mm->rss_stat inconsistent. This triggers the "BUG:"
printk in check_mm().

Let's fix this bug in the safest way, and optimize/cleanup this later.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/exec.c     |    2 +-
 kernel/exit.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index a79786a..da27b91 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -819,10 +819,10 @@ static int exec_mmap(struct mm_struct *mm)
 	/* Notify parent that we're no longer interested in the old VM */
 	tsk = current;
 	old_mm = current->mm;
-	sync_mm_rss(old_mm);
 	mm_release(tsk, old_mm);
 
 	if (old_mm) {
+		sync_mm_rss(old_mm);
 		/*
 		 * Make sure that if there is a core dump in progress
 		 * for the old mm, we get out and die instead of going
diff --git a/kernel/exit.c b/kernel/exit.c
index 34867cc..c0277d3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -643,6 +643,7 @@ static void exit_mm(struct task_struct * tsk)
 	mm_release(tsk, mm);
 	if (!mm)
 		return;
+	sync_mm_rss(mm);
 	/*
 	 * Serialize with any possible pending coredump.
 	 * We must hold mmap_sem around checking core_state

