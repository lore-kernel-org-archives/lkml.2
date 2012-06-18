Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2FRIui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:50:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2FRIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:50:36 -0400
Date: Mon, 18 Jun 2012 01:50:03 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-ea131377148cdfe90641b42ae9aa5a6b3a4fa327@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154322.GA9561@redhat.com>
References: <20120615154322.GA9561@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Valid_vma() should reject VM_HUGETLB
Git-Commit-ID: ea131377148cdfe90641b42ae9aa5a6b3a4fa327
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:50:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea131377148cdfe90641b42ae9aa5a6b3a4fa327
Gitweb:     http://git.kernel.org/tip/ea131377148cdfe90641b42ae9aa5a6b3a4fa327
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:41 +0200

uprobes: Valid_vma() should reject VM_HUGETLB

__replace_page() obviously can't work with the hugetlbfs
mappings, uprobe_register() will likely crash the kernel. Change
valid_vma() to check VM_HUGETLB as well.

As for PageTransHuge() no need to worry, vma->vm_file != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154322.GA9561@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b52376d..f0d0453 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -99,7 +99,8 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 	if (!is_register)
 		return true;
 
-	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) == (VM_READ|VM_EXEC))
+	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
+				== (VM_READ|VM_EXEC))
 		return true;
 
 	return false;
