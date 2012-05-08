Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2EHMdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:33:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab2EHMds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:33:48 -0400
Date: Tue, 8 May 2012 05:33:38 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-41101809a865dd0be1b56eff46c83fad321870b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20120505150141.366461660@linutronix.de>
References: <20120505150141.366461660@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] fork: Provide weak arch_release_[
 task_struct|thread_info] functions
Git-Commit-ID: 41101809a865dd0be1b56eff46c83fad321870b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:33:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41101809a865dd0be1b56eff46c83fad321870b2
Gitweb:     http://git.kernel.org/tip/41101809a865dd0be1b56eff46c83fad321870b2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 5 May 2012 15:05:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 13:55:20 +0200

fork: Provide weak arch_release_[task_struct|thread_info] functions

These functions allow us to move most of the duplicated thread_info
allocators to the core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20120505150141.366461660@linutronix.de

---
 kernel/fork.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5d22b9b..2dfad02 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -112,14 +112,26 @@ int nr_processes(void)
 }
 
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-# define alloc_task_struct_node(node)		\
-		kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node)
-# define free_task_struct(tsk)			\
-		kmem_cache_free(task_struct_cachep, (tsk))
 static struct kmem_cache *task_struct_cachep;
+
+static inline struct task_struct *alloc_task_struct_node(int node)
+{
+	return kmem_cache_alloc_node(task_struct_cachep, GFP_KERNEL, node);
+}
+
+void __weak arch_release_task_struct(struct task_struct *tsk) { }
+
+static inline void free_task_struct(struct task_struct *tsk)
+{
+	arch_release_task_struct(tsk);
+	kmem_cache_free(task_struct_cachep, tsk);
+}
 #endif
 
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+void __weak arch_release_thread_info(struct thread_info *ti) { }
+
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
@@ -131,6 +143,7 @@ static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 
 static inline void free_thread_info(struct thread_info *ti)
 {
+	arch_release_thread_info(ti);
 	free_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 #endif
