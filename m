Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1FTWRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:17:48 -0400
Received: from claw.goop.org ([74.207.240.146]:53613 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944Ab1FTWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/15] xen/trace: add xen_pgd_(un)pin tracepoints
Date: Mon, 20 Jun 2011 15:15:03 -0700
Message-Id: <cdfa49a00e83b62d4fbd0cab251c9c1571a3ce6f.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c         |    4 ++++
 include/trace/events/xen.h |   24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 84c796f..8aaa398 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -884,6 +884,8 @@ static int xen_pin_page(struct mm_struct *mm, struct page *page,
    read-only, and can be pinned. */
 static void __xen_pgd_pin(struct mm_struct *mm, pgd_t *pgd)
 {
+	trace_xen_mmu_pgd_pin(mm, pgd);
+
 	xen_mc_batch();
 
 	if (__xen_pgd_walk(mm, pgd, xen_pin_page, USER_LIMIT)) {
@@ -1009,6 +1011,8 @@ static int xen_unpin_page(struct mm_struct *mm, struct page *page,
 /* Release a pagetables pages back as normal RW */
 static void __xen_pgd_unpin(struct mm_struct *mm, pgd_t *pgd)
 {
+	trace_xen_mmu_pgd_unpin(mm, pgd);
+
 	xen_mc_batch();
 
 	xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 16edcb7..5811c24 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -381,6 +381,30 @@ TRACE_EVENT(xen_mmu_release_ptpage,
 		      __entry->pinned ? "" : "un")
 	);
 
+TRACE_EVENT(xen_mmu_pgd_pin,
+	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
+	    TP_ARGS(mm, pgd),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->pgd = pgd),
+	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
+	);
+
+TRACE_EVENT(xen_mmu_pgd_unpin,
+	    TP_PROTO(struct mm_struct *mm, pgd_t *pgd),
+	    TP_ARGS(mm, pgd),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(pgd_t *, pgd)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->pgd = pgd),
+	    TP_printk("mm %p pgd %p", __entry->mm, __entry->pgd)
+	);
+
 #endif /*  _TRACE_XEN_H */
 
 /* This part must be outside protection */
-- 
1.7.5.4

