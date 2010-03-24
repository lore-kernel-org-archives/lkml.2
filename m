Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0CXQZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:25:19 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:39175 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0CXQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Hep8OwVLLxrCirHrBx4Vqz8hyLXltqsxc0gxo+5K5s0IWeqdPKDC7HCoIeQ6HSFgxT
         iUR24RJm7zYRKQWqdfNZmBoWRRk+NWtUWeiZO5h+fBVZgc+NdF3Hh4sl/8uJ6cUfGdK8
         6bXiVdyMgUYouI49Pd0yOKuq4zVobxtVrFcnU=
From: Anfei Zhou <anfei.zhou@gmail.com>
To: akpm@linux-foundation.org, rientjes@google.com,
       kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] oom killer: break from infinite loop
Date: Thu, 25 Mar 2010 00:25:05 +0800
Message-Id: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
X-Mailer: git-send-email 1.6.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In multi-threading environment, if the current task(A) have got
the mm->mmap_sem semaphore, and the thread(B) in the same process
is selected to be oom killed, because they shares the same semaphore,
thread B can not really be killed.  So __alloc_pages_slowpath turns
to be a infinite loop.  Here set all the threads in the group to
TIF_MEMDIE, it gets a chance to break and exit.

Signed-off-by: Anfei Zhou <anfei.zhou@gmail.com>
---
 mm/oom_kill.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 9b223af..aab9892 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -381,6 +381,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
  */
 static void __oom_kill_task(struct task_struct *p, int verbose)
 {
+	struct task_struct *t;
+
 	if (is_global_init(p)) {
 		WARN_ON(1);
 		printk(KERN_WARNING "tried to kill init!\n");
@@ -412,6 +414,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 	 */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
+	for (t = next_thread(p); t != p; t = next_thread(t))
+		set_tsk_thread_flag(t, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
 }
-- 
1.6.4.rc1

