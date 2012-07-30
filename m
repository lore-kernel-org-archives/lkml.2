Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2G3OQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:16:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2G3OQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:16:07 -0400
Date: Mon, 30 Jul 2012 07:15:52 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-6dab3cc078e3da0d26534410bc9e018a17031d95@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182236.GA20342@redhat.com>
References: <20120729182236.GA20342@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Remove copy_vma()->uprobe_mmap()
Git-Commit-ID: 6dab3cc078e3da0d26534410bc9e018a17031d95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:15:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dab3cc078e3da0d26534410bc9e018a17031d95
Gitweb:     http://git.kernel.org/tip/6dab3cc078e3da0d26534410bc9e018a17031d95
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:22 +0200

uprobes: Remove copy_vma()->uprobe_mmap()

Remove copy_vma()->uprobe_mmap(new_vma), it is absolutely wrong.

This new_vma was just initialized to represent the new unmapped
area, [vm_start, vm_end) was returned by get_unmapped_area() in
the caller.

This means that uprobe_mmap()->get_user_pages() will fail for
sure, simply because find_vma() can never succeed. And I
verified that sys_mremap()->mremap_to() indeed always fails with
the wrong ENOMEM code if [addr, addr+old_len] is probed.

And why this uprobe_mmap() was added? I believe the intent was
wrong. Note that the caller is going to do move_page_tables(),
all registered uprobes are already faulted in, we only change
the virtual addresses.

NOTE: However, somehow we need to close the race with
uprobe_register() which relies on map_info->vaddr. This needs
another fix I'll try to do later. Probably we need uprobe_mmap()
in move_vma() but we can not do this right now, this can confuse
uprobes_state.counter (which I still hope we are going to kill).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182236.GA20342@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3edfcdf..e5a4614 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2418,9 +2418,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			if (new_vma->vm_file) {
 				get_file(new_vma->vm_file);
 
-				if (uprobe_mmap(new_vma))
-					goto out_free_mempol;
-
 				if (vma->vm_flags & VM_EXECUTABLE)
 					added_exe_file_vma(mm);
 			}
