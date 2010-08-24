Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0HXWDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:03:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:9618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab0HXWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,264,1280732400"; 
   d="scan'208";a="831342725"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org
Subject: [PATCH] hide guard page for stacks that grow upwards
Date: Tue, 24 Aug 2010 15:03:02 -0700
Message-Id: <4c74419664798b8c9@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pa-risc and ia64 have stacks that grow upwards. Don't
show the guard page on upward growing vma in /proc/$$/maps

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

This looks useful too ... but I can't see where the code is that
made vm_start be PAGE_SIZE lower to begin with. I'd expect to have
to make a matching change to make vm_end PAGE_SIZE higher for the
VM_GROWSUP areas.

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..ef262f6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -210,7 +210,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 	int flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
-	unsigned long start;
+	unsigned long start, end;
 	dev_t dev = 0;
 	int len;
 
@@ -223,12 +223,15 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
 
 	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
+	end = vma->vm_end;
 	if (vma->vm_flags & VM_GROWSDOWN)
 		start += PAGE_SIZE;
+	if (vma->vm_flags & VM_GROWSUP)
+		end -= PAGE_SIZE;
 
 	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
 			start,
-			vma->vm_end,
+			end,
 			flags & VM_READ ? 'r' : '-',
 			flags & VM_WRITE ? 'w' : '-',
 			flags & VM_EXEC ? 'x' : '-',
