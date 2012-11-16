Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2KPQ3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:29:34 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41441 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2KPQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:25:45 -0500
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Paul Turner <pjt@google.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 05/19] sched, numa, mm, s390/thp: Implement pmd_pgprot() for s390
Date: Fri, 16 Nov 2012 17:25:07 +0100
Message-Id: <1353083121-4560-6-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353083121-4560-1-git-send-email-mingo@kernel.org>
References: <1353083121-4560-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

This patch adds an implementation of pmd_pgprot() for s390,
in preparation to future THP changes.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/s390/include/asm/pgtable.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index dd647c9..098fc5a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1240,6 +1240,19 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 	*pmdp = entry;
 }
 
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	pgprot_t prot = PAGE_RW;
+
+	if (pmd_val(pmd) & _SEGMENT_ENTRY_RO) {
+		if (pmd_val(pmd) & _SEGMENT_ENTRY_INV)
+			prot = PAGE_NONE;
+		else
+			prot = PAGE_RO;
+	}
+	return prot;
+}
+
 static inline unsigned long massage_pgprot_pmd(pgprot_t pgprot)
 {
 	unsigned long pgprot_pmd = 0;
-- 
1.7.11.7

