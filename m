Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab0HaNzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:55:06 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60469 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab0HaNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:55:05 -0400
Message-ID: <4C7D09B6.8010604@canonical.com>
Date: Tue, 31 Aug 2010 15:55:02 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Fix hiding the stack guard page in proc
References: <4C7CFCAC.1080003@canonical.com> <AANLkTimUisNx_eeBYiVWELQfmjiQZefnjTQv99A36ync@mail.gmail.com>
In-Reply-To: <AANLkTimUisNx_eeBYiVWELQfmjiQZefnjTQv99A36ync@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------020204090203010008090907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020204090203010008090907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 08/31/2010 03:33 PM, Linus Torvalds wrote:
> On Tuesday, August 31, 2010, Stefan Bader <stefan.bader@canonical.com> wrote:
>>
>> Maybe its would be worth moving the inlines to mm.h.
> 
> Yes, I think it would be a good idea to try to abstract it out a bit...
> 
>        Linus

Quick and dirty (and very untested)

Stefan

--------------020204090203010008090907
Content-Type: text/x-diff;
 name="0002-mm-Move-vma_stack_continue-into-mm.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-mm-Move-vma_stack_continue-into-mm.h.patch"

>From 33f7a4a8d572628dd82c8953d434b2806a1c448e Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 31 Aug 2010 15:52:27 +0200
Subject: [PATCH] mm: Move vma_stack_continue into mm.h

So it can be used by all that need to check for that.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 fs/proc/task_mmu.c |    3 +--
 include/linux/mm.h |    7 +++++++
 mm/mlock.c         |    6 ------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2e302b4..ac0101a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -224,8 +224,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
 	if (vma->vm_flags & VM_GROWSDOWN)
-		if (!vma->vm_prev || vma->vm_prev->vm_flags != VM_GROWSDOWN ||
-		    vma->vm_start != vma->vm_prev->vm_end)
+		if(!vma_stack_continue(vma->vm_prev, vma->vm_start))
 			start += PAGE_SIZE;
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e6b1210..4f4773a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -864,6 +864,13 @@ int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
+/* Is the vma a continuation of the stack vma above it? */
+static inline int vma_stack_continue(struct vm_area_struct *vma,
+				     unsigned long addr)
+{
+	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len);
diff --git a/mm/mlock.c b/mm/mlock.c
index cbae7c5..b70919c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -135,12 +135,6 @@ void munlock_vma_page(struct page *page)
 	}
 }
 
-/* Is the vma a continuation of the stack vma above it? */
-static inline int vma_stack_continue(struct vm_area_struct *vma, unsigned long addr)
-{
-	return vma && (vma->vm_end == addr) && (vma->vm_flags & VM_GROWSDOWN);
-}
-
 static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	return (vma->vm_flags & VM_GROWSDOWN) &&
-- 
1.7.0.4


--------------020204090203010008090907--
