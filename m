Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab2G3OVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:21:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45809 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2G3OVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:21:03 -0400
Date: Mon, 30 Jul 2012 07:20:17 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-57683f72b8c01c53c85fe13e82fe1feb3a06bcd5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182247.GA20365@redhat.com>
References: <20120729182247.GA20365@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Rename vma_address() and make it return "
 unsigned long"
Git-Commit-ID: 57683f72b8c01c53c85fe13e82fe1feb3a06bcd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:20:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57683f72b8c01c53c85fe13e82fe1feb3a06bcd5
Gitweb:     http://git.kernel.org/tip/57683f72b8c01c53c85fe13e82fe1feb3a06bcd5
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:25 +0200

uprobes: Rename vma_address() and make it return "unsigned long"

1. vma_address() returns loff_t, this looks confusing and this
   is unnecessary after the previous change. Make it return "ulong",
   all callers truncate the result anyway.

2. Its name conflicts with mm/rmap.c:vma_address(), rename it to
   offset_to_vaddr(), this matches vaddr_to_offset().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182247.GA20365@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index cdc3c95..bb30a4f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -112,14 +112,9 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 	return false;
 }
 
-static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
+static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
 {
-	loff_t vaddr;
-
-	vaddr = vma->vm_start + offset;
-	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
-
-	return vaddr;
+	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 }
 
 static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
@@ -775,7 +770,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 		curr = info;
 
 		info->mm = vma->vm_mm;
-		info->vaddr = vma_address(vma, offset);
+		info->vaddr = offset_to_vaddr(vma, offset);
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
 
@@ -1042,7 +1037,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
 		if (!ret) {
-			loff_t vaddr = vma_address(vma, uprobe->offset);
+			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
 
 			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 			/*
@@ -1103,7 +1098,7 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	build_probe_list(inode, vma, start, end, &tmp_list);
 
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
-		loff_t vaddr = vma_address(vma, uprobe->offset);
+		unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
 		/*
 		 * An unregister could have removed the probe before
 		 * unmap. So check before we decrement the count.
