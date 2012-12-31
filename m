Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2LaRwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:52:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab2LaRwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:44 -0500
Date: Mon, 31 Dec 2012 18:52:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] uprobes: Fix utask->xol_vaddr leak in pre_ssout()
Message-ID: <20121231175226.GA32108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pre_ssout() should do xol_free_insn_slot() if arch_uprobe_pre_xol()
fails, otherwise nobody will free the allocated slot.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2ed6239..bd94d2c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1306,6 +1306,7 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 {
 	struct uprobe_task *utask;
 	unsigned long xol_vaddr;
+	int err;
 
 	utask = current->utask;
 
@@ -1316,7 +1317,13 @@ pre_ssout(struct uprobe *uprobe, struct pt_regs *regs, unsigned long bp_vaddr)
 	utask->xol_vaddr = xol_vaddr;
 	utask->vaddr = bp_vaddr;
 
-	return arch_uprobe_pre_xol(&uprobe->arch, regs);
+	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
+	if (unlikely(err)) {
+		xol_free_insn_slot(current);
+		return err;
+	}
+
+	return 0;
 }
 
 /*
-- 
1.5.5.1

