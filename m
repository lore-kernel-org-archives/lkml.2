Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2G3OTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2G3OTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:19:40 -0400
Date: Mon, 30 Jul 2012 07:19:24 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-f4d6dfe55115efe981b4b5f37183ddccaaa792f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182244.GA20362@redhat.com>
References: <20120729182244.GA20362@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Fix register_for_each_vma()->vma_address(
 ) check
Git-Commit-ID: f4d6dfe55115efe981b4b5f37183ddccaaa792f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:19:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4d6dfe55115efe981b4b5f37183ddccaaa792f0
Gitweb:     http://git.kernel.org/tip/f4d6dfe55115efe981b4b5f37183ddccaaa792f0
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:24 +0200

uprobes: Fix register_for_each_vma()->vma_address() check

1. register_for_each_vma() checks that vma_address() == vaddr,
   but this is not enough. We should also ensure that
   vaddr >= vm_start, find_vma() guarantees "vaddr < vm_end" only.

2. After the prevous changes, register_for_each_vma() is the
   only reason why vma_address() has to return loff_t, all other
   users know that we have the valid mapping at this offset and
   thus the overflow is not possible.

   Change the code to use vaddr_to_offset() instead, imho this looks
   more clean/understandable and now we can change vma_address().

3. While at it, remove the unnecessary type-cast.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182244.GA20362@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b03256c..cdc3c95 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -823,12 +823,13 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 			goto free;
 
 		down_write(&mm->mmap_sem);
-		vma = find_vma(mm, (unsigned long)info->vaddr);
-		if (!vma || !valid_vma(vma, is_register))
+		vma = find_vma(mm, info->vaddr);
+		if (!vma || !valid_vma(vma, is_register) ||
+		    vma->vm_file->f_mapping->host != uprobe->inode)
 			goto unlock;
 
-		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-		    vma_address(vma, uprobe->offset) != info->vaddr)
+		if (vma->vm_start > info->vaddr ||
+		    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
 			goto unlock;
 
 		if (is_register) {
