Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab2EKT6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:58:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:47148 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632Ab2EKT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:58:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] frv: delete incorrect task prototypes causing compile fail
Date: Fri, 11 May 2012 15:58:06 -0400
Message-Id: <1336766286-3701-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 41101809a865dd0be1b56eff46c83fad321870b2

    "fork: Provide weak arch_release_[task_struct|thread_info] functions"

highlights a problem in the frv arch, where it has needles prototypes
for alloc_task_struct_node and free_task_struct.  This now shows up as:

kernel/fork.c:120:66: error: static declaration of 'alloc_task_struct_node' follows non-static declaration
kernel/fork.c:127:51: error: static declaration of 'free_task_struct' follows non-static declaration

since 4110180 turned them into real functions.  Since the arch/frv
does does not define define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR (i.e. it
just uses the generic ones) it shouldn't list these at all.

Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index 81c2e27..9b1a92b 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -135,10 +135,6 @@ unsigned long get_wchan(struct task_struct *p);
 #define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
 #define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
 
-/* Allocation and freeing of basic task resources. */
-extern struct task_struct *alloc_task_struct_node(int node);
-extern void free_task_struct(struct task_struct *p);
-
 #define cpu_relax()    barrier()
 
 /* data cache prefetch */
-- 
1.7.9.1

