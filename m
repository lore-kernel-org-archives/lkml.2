Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2G3OPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:15:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2G3OPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:15:13 -0400
Date: Mon, 30 Jul 2012 07:14:57 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-aefd8933d445abf7ff0d4027c624737898827bcd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182233.GA20339@redhat.com>
References: <20120729182233.GA20339@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Fix overflow in vma_address()/
 find_active_uprobe()
Git-Commit-ID: aefd8933d445abf7ff0d4027c624737898827bcd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:15:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aefd8933d445abf7ff0d4027c624737898827bcd
Gitweb:     http://git.kernel.org/tip/aefd8933d445abf7ff0d4027c624737898827bcd
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:33 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:21 +0200

uprobes: Fix overflow in vma_address()/find_active_uprobe()

vma->vm_pgoff is "unsigned long", it should be promoted to
loff_t before the multiplication to avoid the overflow.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182233.GA20339@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9db9cdf..fb961d5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -117,7 +117,7 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
 	loff_t vaddr;
 
 	vaddr = vma->vm_start + offset;
-	vaddr -= vma->vm_pgoff << PAGE_SHIFT;
+	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 
 	return vaddr;
 }
@@ -1450,7 +1450,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 
 			inode = vma->vm_file->f_mapping->host;
 			offset = bp_vaddr - vma->vm_start;
-			offset += (vma->vm_pgoff << PAGE_SHIFT);
+			offset += (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 			uprobe = find_uprobe(inode, offset);
 		}
 
