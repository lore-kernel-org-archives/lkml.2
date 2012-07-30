Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2G3OKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:10:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45522 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2G3OKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:10:01 -0400
Date: Mon, 30 Jul 2012 07:09:40 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-f403072c6108e15f319a4a5036b650c77760522c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182212.GA20304@redhat.com>
References: <20120729182212.GA20304@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Don't recheck vma/
 f_mapping in write_opcode()
Git-Commit-ID: f403072c6108e15f319a4a5036b650c77760522c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:09:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f403072c6108e15f319a4a5036b650c77760522c
Gitweb:     http://git.kernel.org/tip/f403072c6108e15f319a4a5036b650c77760522c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:12 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:18 +0200

uprobes: Don't recheck vma/f_mapping in write_opcode()

write_opcode() rechecks valid_vma() and ->f_mapping, this is
pointless. The caller, register_for_each_vma() or uprobe_mmap(),
has already done these checks under mmap_sem.

To clarify, uprobe_mmap() checks valid_vma() only, but we can
rely on build_probe_list(vm_file->f_mapping->host).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182212.GA20304@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f935327..a2b32a5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -206,33 +206,16 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 			unsigned long vaddr, uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
-	struct address_space *mapping;
 	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
-	struct uprobe *uprobe;
 	int ret;
+
 retry:
 	/* Read the page with vaddr into memory */
 	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
 	if (ret <= 0)
 		return ret;
 
-	ret = -EINVAL;
-
-	/*
-	 * We are interested in text pages only. Our pages of interest
-	 * should be mapped for read and execute only. We desist from
-	 * adding probes in write mapped pages since the breakpoints
-	 * might end up in the file copy.
-	 */
-	if (!valid_vma(vma, is_swbp_insn(&opcode)))
-		goto put_out;
-
-	uprobe = container_of(auprobe, struct uprobe, arch);
-	mapping = uprobe->inode->i_mapping;
-	if (mapping != vma->vm_file->f_mapping)
-		goto put_out;
-
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
