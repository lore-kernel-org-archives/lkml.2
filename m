Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FTWPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:15:42 -0400
Received: from claw.goop.org ([74.207.240.146]:53652 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1FTWPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/15] xen/mmu: use extend_args for more mmuext updates
Date: Mon, 20 Jun 2011 15:15:06 -0700
Message-Id: <33d3519a9483d932335b36ff25b980604d32f7ea.1308607697.git.jeremy.fitzhardinge@citrix.com>
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
 arch/x86/xen/mmu.c |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ad8a226..112259f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -228,6 +228,24 @@ static void xen_extend_mmu_update(const struct mmu_update *update)
 	*u = *update;
 }
 
+static void xen_extend_mmuext_op(const struct mmuext_op *op)
+{
+	struct multicall_space mcs;
+	struct mmuext_op *u;
+
+	mcs = xen_mc_extend_args(__HYPERVISOR_mmuext_op, sizeof(*u));
+
+	if (mcs.mc != NULL) {
+		mcs.mc->args[1]++;
+	} else {
+		mcs = __xen_mc_entry(sizeof(*u));
+		MULTI_mmuext_op(mcs.mc, mcs.args, 1, NULL, DOMID_SELF);
+	}
+
+	u = mcs.args;
+	*u = *op;
+}
+
 static void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 {
 	struct mmu_update u;
@@ -809,14 +827,12 @@ static void xen_pte_unlock(void *v)
 
 static void xen_do_pin(unsigned level, unsigned long pfn)
 {
-	struct mmuext_op *op;
-	struct multicall_space mcs;
+	struct mmuext_op op;
 
-	mcs = __xen_mc_entry(sizeof(*op));
-	op = mcs.args;
-	op->cmd = level;
-	op->arg1.mfn = pfn_to_mfn(pfn);
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+	op.cmd = level;
+	op.arg1.mfn = pfn_to_mfn(pfn);
+
+	xen_extend_mmuext_op(&op);
 }
 
 static int xen_pin_page(struct mm_struct *mm, struct page *page,
@@ -1302,8 +1318,7 @@ static void set_current_cr3(void *v)
 
 static void __xen_write_cr3(bool kernel, unsigned long cr3)
 {
-	struct mmuext_op *op;
-	struct multicall_space mcs;
+	struct mmuext_op op;
 	unsigned long mfn;
 
 	trace_xen_mmu_write_cr3(kernel, cr3);
@@ -1315,13 +1330,10 @@ static void __xen_write_cr3(bool kernel, unsigned long cr3)
 
 	WARN_ON(mfn == 0 && kernel);
 
-	mcs = __xen_mc_entry(sizeof(*op));
+	op.cmd = kernel ? MMUEXT_NEW_BASEPTR : MMUEXT_NEW_USER_BASEPTR;
+	op.arg1.mfn = mfn;
 
-	op = mcs.args;
-	op->cmd = kernel ? MMUEXT_NEW_BASEPTR : MMUEXT_NEW_USER_BASEPTR;
-	op->arg1.mfn = mfn;
-
-	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+	xen_extend_mmuext_op(&op);
 
 	if (kernel) {
 		percpu_write(xen_cr3, cr3);
-- 
1.7.5.4

