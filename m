Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab2FRIvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:51:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2FRIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:51:38 -0400
Date: Mon, 18 Jun 2012 01:50:56 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-cc359d180fa9c25a4c1819f17e07a422d788353d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154325.GA9568@redhat.com>
References: <20120615154325.GA9568@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: __copy_insn() should ensure a_ops->
 readpage != NULL
Git-Commit-ID: cc359d180fa9c25a4c1819f17e07a422d788353d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:51:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc359d180fa9c25a4c1819f17e07a422d788353d
Gitweb:     http://git.kernel.org/tip/cc359d180fa9c25a4c1819f17e07a422d788353d
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:42 +0200

uprobes: __copy_insn() should ensure a_ops->readpage != NULL

__copy_insn() blindly calls read_mapping_page(), this will crash
the kernel if ->readpage == NULL, add the necessary check. For
example, hugetlbfs_aops->readpage is NULL. Perhaps we should
change read_mapping_page() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154325.GA9568@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f0d0453..604930b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -610,6 +610,9 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
 	if (!filp)
 		return -EINVAL;
 
+	if (!mapping->a_ops->readpage)
+		return -EIO;
+
 	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
 	off1 = offset &= ~PAGE_MASK;
 
