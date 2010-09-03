Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0ICQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:28:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0ICQ2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:28:46 -0400
Message-ID: <4C812209.1040707@kernel.org>
Date: Fri, 03 Sep 2010 18:27:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH RESEND 1/3] vmalloc: pcpu_get/free_vm_areas() aren't needed
 on UP
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org> <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org>
In-Reply-To: <4C762734.1030402@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 16:27:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are used only by percpu memory allocator on SMP.
Don't build them on UP.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@kernel.dk>
---
(resending w/ Nick's new email address)

So, something like these three patches.  Also available in the
following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-up

Nick, can I route this one through percpu tree?

Thanks.

 include/linux/vmalloc.h |    2 ++
 mm/vmalloc.c            |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index de05e96..3d510e8 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -115,10 +115,12 @@ extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 extern __init void vm_area_register_early(struct vm_struct *vm, size_t align);

+#ifdef CONFIG_SMP
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
 				     size_t align, gfp_t gfp_mask);

 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
+#endif

 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b7e314b..eb57a63 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2052,6 +2052,7 @@ void free_vm_area(struct vm_struct *area)
 }
 EXPORT_SYMBOL_GPL(free_vm_area);

+#ifdef CONFIG_SMP
 static struct vmap_area *node_to_va(struct rb_node *n)
 {
 	return n ? rb_entry(n, struct vmap_area, rb_node) : NULL;
@@ -2332,6 +2333,7 @@ void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
 		free_vm_area(vms[i]);
 	kfree(vms);
 }
+#endif	/* CONFIG_SMP */

 #ifdef CONFIG_PROC_FS
 static void *s_start(struct seq_file *m, loff_t *pos)
-- 
1.7.1

