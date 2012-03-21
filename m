Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab2CUG4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:56:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968Ab2CUG4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:56:33 -0400
Subject: [PATCH 04/16] mm/nommu: use vm_flags_t for vma flags
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Date: Wed, 21 Mar 2012 10:56:29 +0400
Message-ID: <20120321065629.13852.5630.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@uclinux.org>
---
 fs/proc/nommu.c      |    3 ++-
 fs/proc/task_nommu.c |   14 ++++++++------
 mm/nommu.c           |   19 ++++++++++---------
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index b1822dd..cadc798 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -39,7 +39,8 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
-	int flags, len;
+	int len;
+	vm_flags_t vm_flags;
 
 	flags = region->vm_flags;
 	file = region->vm_file;
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 8aaba8c..9abbc66 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -142,10 +142,11 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
-	int flags, len;
+	int len;
+	vm_flags_t vm_flags;
 	unsigned long long pgoff = 0;
 
-	flags = vma->vm_flags;
+	vm_flags = vma->vm_flags;
 	file = vma->vm_file;
 
 	if (file) {
@@ -159,10 +160,11 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 		   vma->vm_start,
 		   vma->vm_end,
-		   flags & VM_READ ? 'r' : '-',
-		   flags & VM_WRITE ? 'w' : '-',
-		   flags & VM_EXEC ? 'x' : '-',
-		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
+		   vm_flags & VM_READ ? 'r' : '-',
+		   vm_flags & VM_WRITE ? 'w' : '-',
+		   vm_flags & VM_EXEC ? 'x' : '-',
+		   vm_flags & VM_MAYSHARE ?
+			vm_flags & VM_SHARED ? 'S' : 's' : 'p',
 		   pgoff,
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
diff --git a/mm/nommu.c b/mm/nommu.c
index f59e170..33d0ab7 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -130,7 +130,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		     int *retry)
 {
 	struct vm_area_struct *vma;
-	unsigned long vm_flags;
+	vm_flags_t vm_flags;
 	int i;
 
 	/* calculate required read or write permissions.
@@ -658,13 +658,13 @@ static void put_nommu_region(struct vm_region *region)
 /*
  * update protection on a vma
  */
-static void protect_vma(struct vm_area_struct *vma, unsigned long flags)
+static void protect_vma(struct vm_area_struct *vma, vm_flags_t vm_flags)
 {
 #ifdef CONFIG_MPU
 	struct mm_struct *mm = vma->vm_mm;
 	long start = vma->vm_start & PAGE_MASK;
 	while (start < vma->vm_end) {
-		protect_page(mm, start, flags);
+		protect_page(mm, start, vm_flags);
 		start += PAGE_SIZE;
 	}
 	update_protections(mm);
@@ -1060,12 +1060,12 @@ static int validate_mmap_request(struct file *file,
  * we've determined that we can make the mapping, now translate what we
  * now know into VMA flags
  */
-static unsigned long determine_vm_flags(struct file *file,
-					unsigned long prot,
-					unsigned long flags,
-					unsigned long capabilities)
+static vm_flags_t determine_vm_flags(struct file *file,
+				     unsigned long prot,
+				     unsigned long flags,
+				     unsigned long capabilities)
 {
-	unsigned long vm_flags;
+	vm_flags_t vm_flags;
 
 	vm_flags = calc_vm_prot_bits(prot) | calc_vm_flag_bits(flags);
 	/* vm_flags |= mm->def_flags; */
@@ -1243,7 +1243,8 @@ unsigned long do_mmap_pgoff(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
-	unsigned long capabilities, vm_flags, result;
+	unsigned long capabilities, result;
+	vm_flags_t vm_flags;
 	int ret;
 
 	kenter(",%lx,%lx,%lx,%lx,%lx", addr, len, prot, flags, pgoff);

