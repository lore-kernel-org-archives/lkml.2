Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2EHMfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:35:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2EHMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:35:28 -0400
Date: Tue, 8 May 2012 05:35:19 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-0d15d74a1ead10673b5b1db66d4c90552769096c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120505150141.491002124@linutronix.de>
References: <20120505150141.491002124@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] fork:
  Provide kmemcache based thread_info allocator
Git-Commit-ID: 0d15d74a1ead10673b5b1db66d4c90552769096c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:35:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d15d74a1ead10673b5b1db66d4c90552769096c
Gitweb:     http://git.kernel.org/tip/0d15d74a1ead10673b5b1db66d4c90552769096c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 14:08:44 +0200

fork: Provide kmemcache based thread_info allocator

Several architectures have their own kmemcache based thread allocator
because THREAD_SIZE is smaller than PAGE_SIZE. Add it to the core code
conditionally on THREAD_SIZE < PAGE_SIZE so the private copies can go.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120505150141.491002124@linutronix.de
---
 kernel/fork.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 2dfad02..7590bd6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -132,6 +132,11 @@ static inline void free_task_struct(struct task_struct *tsk)
 
 void __weak arch_release_thread_info(struct thread_info *ti) { }
 
+/*
+ * Allocate pages if THREAD_SIZE is >= PAGE_SIZE, otherwise use a
+ * kmemcache based allocator.
+ */
+# if THREAD_SIZE >= PAGE_SIZE
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
@@ -146,6 +151,28 @@ static inline void free_thread_info(struct thread_info *ti)
 	arch_release_thread_info(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
+# else
+static struct kmem_cache *thread_info_cache;
+
+static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
+						  int node)
+{
+	return kmem_cache_alloc_node(thread_info_cache, THREADINFO_GFP, node);
+}
+
+static void free_thread_info(struct thread_info *ti)
+{
+	arch_release_thread_info(ti);
+	kmem_cache_free(thread_info_cache, ti);
+}
+
+void thread_info_cache_init(void)
+{
+	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
+					      THREAD_SIZE, 0, NULL);
+	BUG_ON(thread_info_cache == NULL);
+}
+# endif
 #endif
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
