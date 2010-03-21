Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0CUSts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:49:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0CUStZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:49:25 -0400
Date: Sun, 21 Mar 2010 19:47:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] exit: move taskstats_tgid_free() from
	__exit_signal() to free_signal_struct()
Message-ID: <20100321184757.GA29078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move taskstats_tgid_free() from __exit_signal() to free_signal_struct().

This way signal->stats never points to nowhere and we can read ->stats
lockless.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    1 -
 kernel/fork.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- 34-rc1/kernel/exit.c~13_SIGNAL_STATS	2010-03-21 18:34:02.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-21 18:36:44.000000000 +0100
@@ -145,7 +145,6 @@ static void __exit_signal(struct task_st
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
 	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
-		taskstats_tgid_free(sig);
 		tty_kref_put(tty);
 	}
 }
--- 34-rc1/kernel/fork.c~13_SIGNAL_STATS	2010-03-21 18:35:01.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-21 18:37:31.000000000 +0100
@@ -160,6 +160,7 @@ EXPORT_SYMBOL(free_task);
 
 static inline void free_signal_struct(struct signal_struct *sig)
 {
+	taskstats_tgid_free(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 

