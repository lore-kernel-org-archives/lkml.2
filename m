Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2EESrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:47:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2EESrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:47:08 -0400
Date: Sat, 5 May 2012 11:46:56 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-cce4517f33384c3794c759e206cc8e1bb6df146b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20120503085033.898475542@linutronix.de>
References: <20120503085033.898475542@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] frv: Use correct size for task_struct allocation
Git-Commit-ID: cce4517f33384c3794c759e206cc8e1bb6df146b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:47:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cce4517f33384c3794c759e206cc8e1bb6df146b
Gitweb:     http://git.kernel.org/tip/cce4517f33384c3794c759e206cc8e1bb6df146b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:21 +0200

frv: Use correct size for task_struct allocation

alloc_task_struct_node() allocates THREAD_SIZE and maintains some
weird refcount in the allocated memory. This never blew up as
task_struct size on 32bit machines was always less than THREAD_SIZE

Allocate just sizeof(struct task_struct) and get rid of the magic
refcounting.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085033.898475542@linutronix.de

---
 arch/frv/kernel/process.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index d4de48b..1ac84b2 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -45,17 +45,12 @@ EXPORT_SYMBOL(pm_power_off);
 
 struct task_struct *alloc_task_struct_node(int node)
 {
-	struct task_struct *p = kmalloc_node(THREAD_SIZE, GFP_KERNEL, node);
-
-	if (p)
-		atomic_set((atomic_t *)(p+1), 1);
-	return p;
+	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
 }
 
 void free_task_struct(struct task_struct *p)
 {
-	if (atomic_dec_and_test((atomic_t *)(p+1)))
-		kfree(p);
+	kfree(p);
 }
 
 static void core_sleep_idle(void)
