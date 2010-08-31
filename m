Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0HaM72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:59:28 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46661 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0HaM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:59:26 -0400
Message-ID: <4C7CFCAC.1080003@canonical.com>
Date: Tue, 31 Aug 2010 14:59:24 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm: Fix hiding the stack guard page in proc
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------030001060900000304040903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030001060900000304040903
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Looking at the other changes I believe that the logic for proc also needs to
look at the previous vma to decide whether to hide the first page of it or not.
The following patch against current head should fix that (only compile tested here .
I only made the change to task_mmu.c here. But basically its the same check as
in mlock.c. Maybe its would be worth moving the inlines to mm.h.

-Stefan

Current output before:
...
b778e000-b7790000 rw-p 00000000 00:00 0
bfdc8000-bfddd000 rw-p 00000000 00:00 0          [stack]

After mlocking parts of the stack:
...
b778d000-b7790000 rw-p 00000000 00:00 0
bfdc8000-bfdda000 rw-p 00000000 00:00 0
bfddb000-bfddb000 rw-p 00000000 00:00 0          [stack]
bfddc000-bfddd000 rw-p 00000000 00:00 0

--------------030001060900000304040903
Content-Type: text/x-diff;
 name="0001-mm-Fix-hiding-the-stack-guard-page-in-proc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mm-Fix-hiding-the-stack-guard-page-in-proc.patch"

>From baa30fb2027096d6604c9f0ba2bad04a30edc482 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 31 Aug 2010 13:59:58 +0200
Subject: [PATCH] mm: Fix hiding the stack guard page in proc

Commit d7824370e26325c881b665350ce64fb0a4fde24a tried to hide the stack
guard page from user-space by adapting mlock and hiding it in /proc.
Commit 7798330ac8114c731cfab83e634c6ecedaa233d7 fixed the mlock part,
using the newly added double linked vma lists.
Still the proc change would hide the first page of each stack vma which
would be wrong for those vmas that are just continuations of the stack
after its vma has been split.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: stable@kernel.org
---
 fs/proc/task_mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..2e302b4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -224,7 +224,9 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
 	if (vma->vm_flags & VM_GROWSDOWN)
-		start += PAGE_SIZE;
+		if (!vma->vm_prev || vma->vm_prev->vm_flags != VM_GROWSDOWN ||
+		    vma->vm_start != vma->vm_prev->vm_end)
+			start += PAGE_SIZE;
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
-- 
1.7.0.4


--------------030001060900000304040903--
