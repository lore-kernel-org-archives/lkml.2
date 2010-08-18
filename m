Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0HRU2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:28:53 -0400
Received: from kroah.org ([198.145.64.141]:42254 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab0HRU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:28:28 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 18 13:27:12 2010
Message-Id: <20100818202712.242765536@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 18 Aug 2010 13:25:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 2/3] mm: fix up some user-visible effects of the stack guard page
In-Reply-To: <20100818202723.GA547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d7824370e26325c881b665350ce64fb0a4fde24a upstream.

This commit makes the stack guard page somewhat less visible to user
space. It does this by:

 - not showing the guard page in /proc/<pid>/maps

   It looks like lvm-tools will actually read /proc/self/maps to figure
   out where all its mappings are, and effectively do a specialized
   "mlockall()" in user space.  By not showing the guard page as part of
   the mapping (by just adding PAGE_SIZE to the start for grows-up
   pages), lvm-tools ends up not being aware of it.

 - by also teaching the _real_ mlock() functionality not to try to lock
   the guard page.

   That would just expand the mapping down to create a new guard page,
   so there really is no point in trying to lock it in place.

It would perhaps be nice to show the guard page specially in
/proc/<pid>/maps (or at least mark grow-down segments some way), but
let's not open ourselves up to more breakage by user space from programs
that depends on the exact deails of the 'maps' file.

Special thanks to Henrique de Moraes Holschuh for diving into lvm-tools
source code to see what was going on with the whole new warning.

Reported-and-tested-by: François Valenduc <francois.valenduc@tvcablenet.be
Reported-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    8 +++++++-
 mm/mlock.c         |    8 ++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,6 +210,7 @@ static void show_map_vma(struct seq_file
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
+	unsigned long start;
 	dev_t dev = 0;
 	int len;
 
@@ -220,8 +221,13 @@ static void show_map_vma(struct seq_file
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
+	/* We don't show the stack guard page in /proc/maps */
+	start = vma->vm_start;
+	if (vma->vm_flags & VM_GROWSDOWN)
+		start += PAGE_SIZE;
+
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-			vma->vm_start,
+			start,
 			vma->vm_end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -167,6 +167,14 @@ static long __mlock_vma_pages_range(stru
 	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	/* We don't try to access the guard page of a stack vma */
+	if (vma->vm_flags & VM_GROWSDOWN) {
+		if (start == vma->vm_start) {
+			start += PAGE_SIZE;
+			nr_pages--;
+		}
+	}
+
 	while (nr_pages > 0) {
 		int i;
 


