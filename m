Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab1CaSwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:52:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759109Ab1CaSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:52:17 -0400
Date: Thu, 31 Mar 2011 11:51:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] nommu: sort mm->mmap list properly
Message-Id: <20110331115141.bd8f28d8.akpm@linux-foundation.org>
In-Reply-To: <1301320607-7259-2-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
	<1301320607-7259-2-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 22:56:42 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> @vma added into @mm should be sorted by start addr, end addr and VMA struct
> addr in that order because we may get identical VMAs in the @mm. However
> this was true only for the rbtree, not for the list.
> 
> This patch fixes this by remembering 'rb_prev' during the tree traversal
> like find_vma_prepare() does and linking the @vma via __vma_link_list().
> After this patch, we can iterate the whole VMAs in correct order simply
> by using @mm->mmap list.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  mm/nommu.c |   62 ++++++++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index e7dbd3fae187..20d9c330eb0e 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -672,6 +672,30 @@ static void protect_vma(struct vm_area_struct *vma, unsigned long flags)
>  #endif
>  }
>  
> +/* borrowed from mm/mmap.c */
> +static inline void
> +__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
> +		struct vm_area_struct *prev, struct rb_node *rb_parent)
> +{
> +	struct vm_area_struct *next;
> +
> +	vma->vm_prev = prev;
> +	if (prev) {
> +		next = prev->vm_next;
> +		prev->vm_next = vma;
> +	} else {
> +		mm->mmap = vma;
> +		if (rb_parent)
> +			next = rb_entry(rb_parent,
> +					struct vm_area_struct, vm_rb);
> +		else
> +			next = NULL;
> +	}
> +	vma->vm_next = next;
> +	if (next)
> +		next->vm_prev = vma;
> +}

Duplicating code is rather bad.  And putting random vma functions into
mm/util.c is pretty ugly too, but I suppose it's less bad.

 mm/internal.h |    4 ++++
 mm/mmap.c     |   22 ----------------------
 mm/nommu.c    |   24 ------------------------
 mm/util.c     |   24 ++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 46 deletions(-)

diff -puN mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/nommu.c
--- a/mm/nommu.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/nommu.c
@@ -672,30 +672,6 @@ static void protect_vma(struct vm_area_s
 #endif
 }
 
-/* borrowed from mm/mmap.c */
-static inline void
-__vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 /*
  * add a VMA into a process's mm_struct in the appropriate place in the list
  * and tree and add to the address space's page tree also if not an anonymous
diff -puN mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/util.c
--- a/mm/util.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/util.c
@@ -6,6 +6,8 @@
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/kmem.h>
 
@@ -215,6 +217,28 @@ char *strndup_user(const char __user *s,
 }
 EXPORT_SYMBOL(strndup_user);
 
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent)
+{
+	struct vm_area_struct *next;
+
+	vma->vm_prev = prev;
+	if (prev) {
+		next = prev->vm_next;
+		prev->vm_next = vma;
+	} else {
+		mm->mmap = vma;
+		if (rb_parent)
+			next = rb_entry(rb_parent,
+					struct vm_area_struct, vm_rb);
+		else
+			next = NULL;
+	}
+	vma->vm_next = next;
+	if (next)
+		next->vm_prev = vma;
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
diff -puN mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix mm/internal.h
--- a/mm/internal.h~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/internal.h
@@ -66,6 +66,10 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
+/* mm/util.c */
+void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
+		struct vm_area_struct *prev, struct rb_node *rb_parent);
+
 #ifdef CONFIG_MMU
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
diff -puN mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix mm/mmap.c
--- a/mm/mmap.c~mm-nommu-sort-mm-mmap-list-properly-fix
+++ a/mm/mmap.c
@@ -398,28 +398,6 @@ find_vma_prepare(struct mm_struct *mm, u
 	return vma;
 }
 
-void __vma_link_list(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev, struct rb_node *rb_parent)
-{
-	struct vm_area_struct *next;
-
-	vma->vm_prev = prev;
-	if (prev) {
-		next = prev->vm_next;
-		prev->vm_next = vma;
-	} else {
-		mm->mmap = vma;
-		if (rb_parent)
-			next = rb_entry(rb_parent,
-					struct vm_area_struct, vm_rb);
-		else
-			next = NULL;
-	}
-	vma->vm_next = next;
-	if (next)
-		next->vm_prev = vma;
-}
-
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
_


