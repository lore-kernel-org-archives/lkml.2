Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0EYJxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab0EYJxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:53:15 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86/pat: fix memory leak in free_memtype
Date: Tue, 25 May 2010 17:52:36 +0800
Message-Id: <1274781156-2861-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_memtype will allocate memory for new memtype, but
in free_memtype, after the memtype erased from rbtree, the
memory is not freed.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat_rbtree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index 07de4cb..fb8c1e5 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -15,6 +15,7 @@
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 
 #include <asm/pgtable.h>
 #include <asm/pat.h>
@@ -240,6 +241,7 @@ int rbt_memtype_erase(u64 start, u64 end)
 		return -EINVAL;
 
 	rb_erase(&data->rb, &memtype_rbroot);
+	kfree(data);
 	return 0;
 }
 
-- 
1.7.0.1

