Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2KUKbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:31:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab2KUKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:22:16 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 11/46] mm: numa: define _PAGE_NUMA
Date: Wed, 21 Nov 2012 10:21:17 +0000
Message-Id: <1353493312-8069-12-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Arcangeli <aarcange@redhat.com>

The objective of _PAGE_NUMA is to be able to trigger NUMA hinting page
faults to identify the per NUMA node working set of the thread at
runtime.

Arming the NUMA hinting page fault mechanism works similarly to
setting up a mprotect(PROT_NONE) virtual range: the present bit is
cleared at the same time that _PAGE_NUMA is set, so when the fault
triggers we can identify it as a NUMA hinting page fault.

_PAGE_NUMA on x86 shares the same bit number of _PAGE_PROTNONE (but it
could also use a different bitflag, it's up to the architecture to
decide).

It would be confusing to call the "NUMA hinting page faults" as
"do_prot_none faults". They're different events and _PAGE_NUMA doesn't
alter the semantics of mprotect(PROT_NONE) in any way.

Sharing the same bitflag with _PAGE_PROTNONE in fact complicates
things: it requires us to ensure the code paths executed by
_PAGE_PROTNONE remains mutually exclusive to the code paths executed
by _PAGE_NUMA at all times, to avoid _PAGE_NUMA and _PAGE_PROTNONE to
step into each other toes.

Because we want to be able to set this bitflag in any established pte
or pmd (while clearing the present bit at the same time) without
losing information, this bitflag must never be set when the pte and
pmd are present, so the bitflag picked for _PAGE_NUMA usage, must not
be used by the swap entry format.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/pgtable_types.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index ec8a1fc..3c32db8 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -64,6 +64,26 @@
 #define _PAGE_FILE	(_AT(pteval_t, 1) << _PAGE_BIT_FILE)
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
 
+/*
+ * _PAGE_NUMA indicates that this page will trigger a numa hinting
+ * minor page fault to gather numa placement statistics (see
+ * pte_numa()). The bit picked (8) is within the range between
+ * _PAGE_FILE (6) and _PAGE_PROTNONE (8) bits. Therefore, it doesn't
+ * require changes to the swp entry format because that bit is always
+ * zero when the pte is not present.
+ *
+ * The bit picked must be always zero when the pmd is present and not
+ * present, so that we don't lose information when we set it while
+ * atomically clearing the present bit.
+ *
+ * Because we shared the same bit (8) with _PAGE_PROTNONE this can be
+ * interpreted as _PAGE_NUMA only in places that _PAGE_PROTNONE
+ * couldn't reach, like handle_mm_fault() (see access_error in
+ * arch/x86/mm/fault.c, the vma protection must not be PROT_NONE for
+ * handle_mm_fault() to be invoked).
+ */
+#define _PAGE_NUMA	_PAGE_PROTNONE
+
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |	\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
-- 
1.7.9.2

