Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2G3ORD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:17:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab2G3ORA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:17:00 -0400
Date: Mon, 30 Jul 2012 07:16:44 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-89133786f9408d53361874a8c784fff150fc7f7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182238.GA20349@redhat.com>
References: <20120729182238.GA20349@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Remove insert_vm_struct()->uprobe_mmap()
Git-Commit-ID: 89133786f9408d53361874a8c784fff150fc7f7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:16:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89133786f9408d53361874a8c784fff150fc7f7c
Gitweb:     http://git.kernel.org/tip/89133786f9408d53361874a8c784fff150fc7f7c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:38 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:22 +0200

uprobes: Remove insert_vm_struct()->uprobe_mmap()

Remove insert_vm_struct()->uprobe_mmap(). It is not needed, nobody
except arch/ia64/kernel/perfmon.c uses insert_vm_struct(vma)
with vma->vm_file != NULL.

And it is wrong. Again, get_user_pages() can not succeed before
vma_link(vma) makes is visible to find_vma(). And even if this
worked, we must not insert the new bp before this mapping is
visible to vma_prio_tree_foreach() for uprobe_unregister().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182238.GA20349@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index e5a4614..4fe2697 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2345,9 +2345,6 @@ int insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
 	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
 		return -ENOMEM;
 
-	if (vma->vm_file && uprobe_mmap(vma))
-		return -EINVAL;
-
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
 }
