Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2FULH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:07:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2FULH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:07:58 -0400
Message-ID: <1340276867.21745.172.camel@twins>
Subject: Re: [PATCH -mm 1/7] mm: track free size between VMAs in VMA rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Date: Thu, 21 Jun 2012 13:07:47 +0200
In-Reply-To: <1340057126-31143-2-git-send-email-riel@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
	 <1340057126-31143-2-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 18:05 -0400, Rik van Riel wrote:
> @@ -473,11 +524,17 @@ __vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
>                 struct vm_area_struct *prev)
>  {
>         struct vm_area_struct *next = vma->vm_next;
> +       struct rb_node *deepest;
>  
>         prev->vm_next = next;
> -       if (next)
> +       if (next) {
>                 next->vm_prev = prev;
> +               adjust_free_gap(next);
> +       }
> +       deepest = rb_augment_erase_begin(&vma->vm_rb);
>         rb_erase(&vma->vm_rb, &mm->mm_rb);
> +       rb_augment_erase_end(deepest, vma_rb_augment_cb, NULL);
> +
>         if (mm->mmap_cache == vma)
>                 mm->mmap_cache = prev;
>  }


> @@ -1933,7 +2002,10 @@ detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
>         insertion_point = (prev ? &prev->vm_next : &mm->mmap);
>         vma->vm_prev = NULL;
>         do {
> +               struct rb_node *deepest;
> +               deepest = rb_augment_erase_begin(&vma->vm_rb);
>                 rb_erase(&vma->vm_rb, &mm->mm_rb);
> +               rb_augment_erase_end(deepest, vma_rb_augment_cb, NULL); 


---
 include/linux/rbtree.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 033b507..07c5843 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -155,6 +155,14 @@ extern struct rb_node *rb_augment_erase_begin(struct rb_node *node);
 extern void rb_augment_erase_end(struct rb_node *node,
 				 rb_augment_f func, void *data);
 
+static inline void rb_augment_erase(struct rb_node *node, struct rb_root *root,
+				    rb_augment_f func, void *data)
+{
+	struct rb_node *deepest = rb_augment_erase_begin(node);
+	rb_erase(node, root);
+	rb_augment_erase_end(deepest, func, data);
+}
+
 /* Find logical next and previous nodes in a tree */
 extern struct rb_node *rb_next(const struct rb_node *);
 extern struct rb_node *rb_prev(const struct rb_node *);

