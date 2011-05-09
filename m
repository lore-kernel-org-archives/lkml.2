Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1EILBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:01:12 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:55964 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1EILBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:01:11 -0400
Date: Mon, 9 May 2011 13:01:09 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
In-Reply-To: <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1908654874-151666094-1304938869=:32299"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1908654874-151666094-1304938869=:32299
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Sun, 8 May 2011, Linus Torvalds wrote:

> On Sun, May 8, 2011 at 11:55 AM, Mikulas Patocka
> <mikulas@artax.karlin.mff.cuni.cz> wrote:
> >
> > This patch fixes lvm2 on PA-RISC (and possibly other architectures with
> > up-growing stack). lvm2 calculates the number of used pages when locking
> > and when unlocking and reports an internal error if the numbers mismatch.
> 
> This patch won't apply on current kernels (including stable) because
> of commit a1fde08c74e9 that changed the test of "pages" to instead
> just test "flags & FOLL_MLOCK".
> 
> That should be trivial to fix up.
> 
> However, I really don't much like this complex test:
> 
> >  static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
> >  {
> > -       return (vma->vm_flags & VM_GROWSDOWN) &&
> > +       return ((vma->vm_flags & VM_GROWSDOWN) &&
> >                (vma->vm_start == addr) &&
> > -               !vma_stack_continue(vma->vm_prev, addr);
> > +               !vma_stack_continue(vma->vm_prev, addr)) ||
> > +              ((vma->vm_flags & VM_GROWSUP) &&
> > +               (vma->vm_end == addr + PAGE_SIZE) &&
> > +               !vma_stack_growsup_continue(vma->vm_next, addr + PAGE_SIZE));
> >  }
> 
> in that format. It gets really hard to read, and I think you'd be
> better off writing it as two helper functions (or macros) for the two
> cases, and then have
> 
>   static inline int stack_guard_page(struct vm_area_struct *vma,
> unsigned long addr)
>   {
>     return stack_guard_page_growsdown(vma, addr) ||
>       stack_guard_page_growsup(vma, addr);
>   }
> 
> I'd also like to verify that it doesn't actually generate any extra
> code for the common case (iirc VM_GROWSUP is 0 for the architectures
> that don't need it, and so the compiler shouldn't generate any extra
> code, but I'd like that mentioned and verified explicitly).
> 
> Hmm?
> 
> Other than that it looks ok to me.
> 
> That said, could we please fix LVM to not do that crazy sh*t in the
> first place? The STACK_GROWSUP case is never going to have a lot of
> testing, this is just sad.

LVM reads process maps from /proc/self/maps and locks them with mlock.

Why it doesn't use mlockall()? Because glibc maps all locales to the 
process. Glibc packs all locales to a 100MB file and maps that file to 
every process. Even if the process uses just one locale, glibc maps all.

So, when LVM used mlockall, it consumed >100MB memory and it caused 
out-of-memory problems in system installers.

So, alternate way of locking was added to LVM --- read all maps and lock 
them, except for the glibc locale file.

The real fix would be to fix glibc not to map 100MB to every process.

>                    Linus
> 

This is updated patch. I tested it on x86-64 and it doesn't change 
generated code.

Mikulas

---

Don't lock guardpage if the stack is growing up

Linux kernel excludes guard page when performing mlock on a VMA with
down-growing stack. However, some architectures have up-growing stack
and locking the guard page should be excluded in this case too.

This patch fixes lvm2 on PA-RISC (and possibly other architectures with
up-growing stack). lvm2 calculates number of used pages when locking and
when unlocking and reports an internal error if the numbers mismatch.

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 include/linux/mm.h |   10 +++++++++-
 mm/memory.c        |   21 ++++++++++++++++++---
 2 files changed, 27 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2011-05-09 12:33:50.000000000 +0200
+++ linux-2.6/include/linux/mm.h	2011-05-09 12:42:05.000000000 +0200
@@ -1011,11 +1011,19 @@ int set_page_dirty_lock(struct page *pag
 int clear_page_dirty_for_io(struct page *page);
 
 /* Is the vma a continuation of the stack vma above it? */
-static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
+static inline int vma_stack_growsdown_continue(struct vm_area_struct *vma,
+					       unsigned long addr)
 {
 	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
 }
 
+/* Is the vma a continuation of the stack vma below it? */
+static inline int vma_stack_growsup_continue(struct vm_area_struct *vma,
+					     unsigned long addr)
+{
+	return vma && (vma->vm_start == addr) && (vma->vm_flags & VM_GROWSUP);
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len);
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2011-05-09 12:33:51.000000000 +0200
+++ linux-2.6/mm/memory.c	2011-05-09 12:41:38.000000000 +0200
@@ -1410,11 +1410,21 @@ no_page_table:
 	return page;
 }
 
-static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
+static inline int stack_guard_page_growsdown(struct vm_area_struct *vma,
+					     unsigned long addr)
 {
 	return (vma->vm_flags & VM_GROWSDOWN) &&
 		(vma->vm_start == addr) &&
-		!vma_stack_continue(vma->vm_prev, addr);
+		!vma_stack_growsdown_continue(vma->vm_prev, addr);
+}
+
+
+static inline int stack_guard_page_growsup(struct vm_area_struct *vma,
+					   unsigned long addr)
+{
+	return (vma->vm_flags & VM_GROWSUP) &&
+		(vma->vm_end == addr + PAGE_SIZE) &&
+		!vma_stack_growsup_continue(vma->vm_next, addr + PAGE_SIZE);
 }
 
 /**
@@ -1554,13 +1564,18 @@ int __get_user_pages(struct task_struct 
 		/*
 		 * For mlock, just skip the stack guard page.
 		 */
-		if ((gup_flags & FOLL_MLOCK) && stack_guard_page(vma, start))
+		if ((gup_flags & FOLL_MLOCK) &&
+		    stack_guard_page_growsdown(vma, start))
 			goto next_page;
 
 		do {
 			struct page *page;
 			unsigned int foll_flags = gup_flags;
 
+			if ((gup_flags & FOLL_MLOCK) &&
+			    stack_guard_page_growsup(vma, start))
+				goto next_page;
+
 			/*
 			 * If we have a pending SIGKILL, don't keep faulting
 			 * pages and potentially allocating memory.
--1908654874-151666094-1304938869=:32299--
