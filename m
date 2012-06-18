Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2FRJBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:01:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2FRJBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:01:47 -0400
Date: Mon, 18 Jun 2012 02:01:26 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-593609a59600c8377f311b300f14deacb155b9a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154359.GA9625@redhat.com>
References: <20120615154359.GA9625@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: __copy_insn() needs "loff_t offset"
Git-Commit-ID: 593609a59600c8377f311b300f14deacb155b9a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 02:01:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  593609a59600c8377f311b300f14deacb155b9a4
Gitweb:     http://git.kernel.org/tip/593609a59600c8377f311b300f14deacb155b9a4
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:49 +0200

uprobes: __copy_insn() needs "loff_t offset"

1. __copy_insn() needs "loff_t offset", not "unsigned long",
   to read the file.

2. use pgoff_t for "idx" and remove the unnecessary typecast.

3. fix the typo, "&=" is not what we want

4. can't resist, rename off1 to off.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154359.GA9625@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4df84b7..d1b2eeb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -581,12 +581,12 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 
 static int
 __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
-			unsigned long nbytes, unsigned long offset)
+			unsigned long nbytes, loff_t offset)
 {
 	struct page *page;
 	void *vaddr;
-	unsigned long off1;
-	unsigned long idx;
+	unsigned long off;
+	pgoff_t idx;
 
 	if (!filp)
 		return -EINVAL;
@@ -594,8 +594,8 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 	if (!mapping->a_ops->readpage)
 		return -EIO;
 
-	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
-	off1 = offset &= ~PAGE_MASK;
+	idx = offset >> PAGE_CACHE_SHIFT;
+	off = offset & ~PAGE_MASK;
 
 	/*
 	 * Ensure that the page that has the original instruction is
@@ -606,7 +606,7 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 		return PTR_ERR(page);
 
 	vaddr = kmap_atomic(page);
-	memcpy(insn, vaddr + off1, nbytes);
+	memcpy(insn, vaddr + off, nbytes);
 	kunmap_atomic(vaddr);
 	page_cache_release(page);
 
