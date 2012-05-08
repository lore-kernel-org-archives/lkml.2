Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2EHMc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:32:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2EHMc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:32:58 -0400
Date: Tue, 8 May 2012 05:32:48 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-2889f60814e15dea644782597d897cdba943564f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120505150141.428211694@linutronix.de>
References: <20120505150141.428211694@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] fork: Move thread info gfp flags to header
Git-Commit-ID: 2889f60814e15dea644782597d897cdba943564f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:32:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2889f60814e15dea644782597d897cdba943564f
Gitweb:     http://git.kernel.org/tip/2889f60814e15dea644782597d897cdba943564f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 13:55:20 +0200

fork: Move thread info gfp flags to header

These flags can be useful for extra allocations outside of the core
code.

Add __GFP_NOTRACK to them, so the archs which have kmemcheck do
not have to provide extra allocators just for that reason.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120505150141.428211694@linutronix.de
---
 include/linux/thread_info.h |    6 ++++++
 kernel/fork.c               |    8 ++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 8d03f07..db78775 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -54,6 +54,12 @@ extern long do_no_restart_syscall(struct restart_block *parm);
 
 #ifdef __KERNEL__
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK | __GFP_ZERO)
+#else
+# define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
+#endif
+
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
diff --git a/kernel/fork.c b/kernel/fork.c
index a79b36e..5d22b9b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -123,12 +123,8 @@ static struct kmem_cache *task_struct_cachep;
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-#ifdef CONFIG_DEBUG_STACK_USAGE
-	gfp_t mask = GFP_KERNEL | __GFP_ZERO;
-#else
-	gfp_t mask = GFP_KERNEL;
-#endif
-	struct page *page = alloc_pages_node(node, mask, THREAD_SIZE_ORDER);
+	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
+					     THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
 }
