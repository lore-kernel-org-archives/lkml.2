Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2DNSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:25:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DNSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:25:55 -0400
Date: Sat, 14 Apr 2012 11:25:12 -0700
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-7396fa818d6278694a44840f389ddc40a3269a9a@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        anton@redhat.com, rostedt@goodmis.org, jkenisto@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, linux-mm@kvack.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, hch@infradead.org,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, anton@redhat.com, rostedt@goodmis.org,
        jkenisto@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        linux-mm@kvack.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, hch@infradead.org, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        srikar@linux.vnet.ibm.com
In-Reply-To: <20120411103516.23245.2700.sendpatchset@srdronam.in.ibm.com>
References: <20120411103516.23245.2700.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] uprobes/core:
  Make background page replacement logic account for rss_stat counters
Git-Commit-ID: 7396fa818d6278694a44840f389ddc40a3269a9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 14 Apr 2012 11:25:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7396fa818d6278694a44840f389ddc40a3269a9a
Gitweb:     http://git.kernel.org/tip/7396fa818d6278694a44840f389ddc40a3269a9a
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Wed, 11 Apr 2012 16:05:16 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 14 Apr 2012 13:25:47 +0200

uprobes/core: Make background page replacement logic account for rss_stat counters

Background page replacement logic adds a new anonymous page
instead of a file backed (while inserting a breakpoint) /
anonymous page (while removing a breakpoint).

Hence the uprobes logic should take care to update the
task->ss_stat counters accordingly.

This bug became apparent courtesy of commit c3f0327f8e9d
("mm: add rss counters consistency check").

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Linux-mm <linux-mm@kvack.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120411103516.23245.2700.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 29e881b..c5caeec 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -160,6 +160,11 @@ static int __replace_page(struct vm_area_struct *vma, struct page *page, struct
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
 
+	if (!PageAnon(page)) {
+		dec_mm_counter(mm, MM_FILEPAGES);
+		inc_mm_counter(mm, MM_ANONPAGES);
+	}
+
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
