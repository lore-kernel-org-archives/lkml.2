Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2FRI6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:58:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40535 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2FRI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:58:18 -0400
Date: Mon, 18 Jun 2012 01:57:57 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-eb2bf57bee42c7565032f93adaa211e2c9fcc52c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154347.GA9604@redhat.com>
References: <20120615154347.GA9604@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: No need to re-check vma_address()
  in write_opcode()
Git-Commit-ID: eb2bf57bee42c7565032f93adaa211e2c9fcc52c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:58:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb2bf57bee42c7565032f93adaa211e2c9fcc52c
Gitweb:     http://git.kernel.org/tip/eb2bf57bee42c7565032f93adaa211e2c9fcc52c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:47 +0200

uprobes: No need to re-check vma_address() in write_opcode()

write_opcode() is called by register_for_each_vma() and
uprobe_mmap() paths. In both cases the caller has already
verified this vaddr under mmap_sem, no need to re-check.

Note also that this check is wrong anyway, we should not
truncate loff_t returned by vma_address() if we do not trust
this mapping.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154347.GA9604@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2db1d94..14c71a2 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -211,7 +211,6 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	struct uprobe *uprobe;
 	unsigned long pgoff;
-	loff_t addr;
 	int ret;
 retry:
 	/* Read the page with vaddr into memory */
@@ -235,10 +234,6 @@ retry:
 	if (mapping != vma->vm_file->f_mapping)
 		goto put_out;
 
-	addr = vma_address(vma, uprobe->offset);
-	if (vaddr != (unsigned long)addr)
-		goto put_out;
-
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
