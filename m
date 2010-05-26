Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab0EZUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:22:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:56695 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab0EZUWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:22:24 -0400
Date: Wed, 26 May 2010 20:22:04 GMT
From: tip-bot for Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, steiner@sgi.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, dfeng@redhat.com,
       hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, steiner@sgi.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, dfeng@redhat.com,
       hpa@linux.intel.com
In-Reply-To: <1274838670-8731-1-git-send-email-dfeng@redhat.com>
References: <1274838670-8731-1-git-send-email-dfeng@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, pat: Fix memory leak in free_memtype
Message-ID: <tip-20413f27163fb1b8b806c0c219dc95eae67c633a@git.kernel.org>
Git-Commit-ID: 20413f27163fb1b8b806c0c219dc95eae67c633a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 May 2010 20:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20413f27163fb1b8b806c0c219dc95eae67c633a
Gitweb:     http://git.kernel.org/tip/20413f27163fb1b8b806c0c219dc95eae67c633a
Author:     Xiaotian Feng <dfeng@redhat.com>
AuthorDate: Wed, 26 May 2010 09:51:10 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 26 May 2010 11:26:04 -0700

x86, pat: Fix memory leak in free_memtype

Reserve_memtype will allocate memory for new memtype, but
in free_memtype, after the memtype erased from rbtree, the
memory is not freed.

Changes since V1:
	make rbt_memtype_erase return erased memtype so that
	it can be freed in free_memtype.

[ hpa: not for -stable: 2.6.34 and earlier not affected ]

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
LKML-Reference: <1274838670-8731-1-git-send-email-dfeng@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Jack Steiner <steiner@sgi.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pat.c          |   10 +++++++---
 arch/x86/mm/pat_internal.h |    6 +++---
 arch/x86/mm/pat_rbtree.c   |    7 ++++---
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index bbe5502..acc15b2 100644
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
 
+	kfree(entry);
+
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
