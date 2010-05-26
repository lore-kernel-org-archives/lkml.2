Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab0EZBvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759151Ab0EZBvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:51:37 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH V2] x86/pat: fix memory leak in free_memtype
Date: Wed, 26 May 2010 09:51:10 +0800
Message-Id: <1274838670-8731-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1274832742.2892.549.camel@sbs-t61.sc.intel.com>
References: <1274832742.2892.549.camel@sbs-t61.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_memtype will allocate memory for new memtype, but
in free_memtype, after the memtype erased from rbtree, the
memory is not freed.

Changes since V1:
	make rbt_memtype_erase return erased memtype so that 
	it can be freed in free_memtype.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/pat.c          |   10 +++++++---
 arch/x86/mm/pat_internal.h |    6 +++---
 arch/x86/mm/pat_rbtree.c   |    7 ++++---
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index bbe5502..bf2b5fa 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -336,6 +336,7 @@ int free_memtype(u64 start, u64 end)
 {
 	int err = -EINVAL;
 	int is_range_ram;
+	struct memtype *entry;
 
 	if (!pat_enabled)
 		return 0;
@@ -355,17 +356,20 @@ int free_memtype(u64 start, u64 end)
 	}
 
 	spin_lock(&memtype_lock);
-	err = rbt_memtype_erase(start, end);
+	entry = rbt_memtype_erase(start, end);
 	spin_unlock(&memtype_lock);
 
-	if (err) {
+	if (!entry) {
 		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
 			current->comm, current->pid, start, end);
+		return -EINVAL;
 	}
+	
+	kfree(entry);
 
 	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
 
-	return err;
+	return 0;
 }
 
 
diff --git a/arch/x86/mm/pat_internal.h b/arch/x86/mm/pat_internal.h
index 4f39eef..77e5ba1 100644
--- a/arch/x86/mm/pat_internal.h
+++ b/arch/x86/mm/pat_internal.h
@@ -28,15 +28,15 @@ static inline char *cattr_name(unsigned long flags)
 #ifdef CONFIG_X86_PAT
 extern int rbt_memtype_check_insert(struct memtype *new,
 					unsigned long *new_type);
-extern int rbt_memtype_erase(u64 start, u64 end);
+extern struct memtype *rbt_memtype_erase(u64 start, u64 end);
 extern struct memtype *rbt_memtype_lookup(u64 addr);
 extern int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos);
 #else
 static inline int rbt_memtype_check_insert(struct memtype *new,
 					unsigned long *new_type)
 { return 0; }
-static inline int rbt_memtype_erase(u64 start, u64 end)
-{ return 0; }
+static inline struct memtype *rbt_memtype_erase(u64 start, u64 end)
+{ return NULL; }
 static inline struct memtype *rbt_memtype_lookup(u64 addr)
 { return NULL; }
 static inline int rbt_memtype_copy_nth_element(struct memtype *out, loff_t pos)
diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
index 07de4cb..f537087 100644
--- a/arch/x86/mm/pat_rbtree.c
+++ b/arch/x86/mm/pat_rbtree.c
@@ -231,16 +231,17 @@ int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
 	return err;
 }
 
-int rbt_memtype_erase(u64 start, u64 end)
+struct memtype *rbt_memtype_erase(u64 start, u64 end)
 {
 	struct memtype *data;
 
 	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
 	if (!data)
-		return -EINVAL;
+		goto out;
 
 	rb_erase(&data->rb, &memtype_rbroot);
-	return 0;
+out:
+	return data;
 }
 
 struct memtype *rbt_memtype_lookup(u64 addr)
-- 
1.6.6.1

