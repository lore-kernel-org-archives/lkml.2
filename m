Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1HCXdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:33:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab1HCXbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:31:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.550620781@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>
Subject: [094/102] oom: task->mm == NULL doesnt mean the memory was freed
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c027a474a68065391c8773f6e83ed5412657e369 upstream.

exit_mm() sets ->mm == NULL then it does mmput()->exit_mmap() which
frees the memory.

However select_bad_process() checks ->mm != NULL before TIF_MEMDIE,
so it continues to kill other tasks even if we have the oom-killed
task freeing its memory.

Change select_bad_process() to check ->mm after TIF_MEMDIE, but skip
the tasks which have already passed exit_notify() to ensure a zombie
with TIF_MEMDIE set can't block oom-killer. Alternatively we could
probably clear TIF_MEMDIE after exit_mmap().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -303,7 +303,7 @@ static struct task_struct *select_bad_pr
 	do_each_thread(g, p) {
 		unsigned int points;
 
-		if (!p->mm)
+		if (p->exit_state)
 			continue;
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
@@ -319,6 +319,8 @@ static struct task_struct *select_bad_pr
 		 */
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
+		if (!p->mm)
+			continue;
 
 		if (p->flags & PF_EXITING) {
 			/*


