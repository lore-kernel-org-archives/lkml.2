Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2FMSxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2FMSxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:53:24 -0400
Date: Wed, 13 Jun 2012 20:51:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] uprobes: __copy_insn() needs "loff_t offset"
Message-ID: <20120613185122.GF13878@redhat.com>
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. __copy_insn() needs "loff_t offset", not "unsigned long",
   to read the file.

2. use pgoff_t for "idx" and remove the unnecessary typecast.

3. fix the typo, "&=" is not what we want

4. can't resist, rename off1 to off.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 773bb37..5ad1d77 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -581,20 +581,20 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 
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
 	if (!mapping->a_ops->readpage)
 		return -EIO;
 
-	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
-	off1 = offset &= ~PAGE_MASK;
+	idx = offset >> PAGE_CACHE_SHIFT;
+	off = offset & ~PAGE_MASK;
 
 	/*
 	 * Ensure that the page that has the original instruction is
@@ -605,7 +605,7 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 		return PTR_ERR(page);
 
 	vaddr = kmap_atomic(page);
-	memcpy(insn, vaddr + off1, nbytes);
+	memcpy(insn, vaddr + off, nbytes);
 	kunmap_atomic(vaddr);
 	page_cache_release(page);
 
-- 
1.5.5.1


