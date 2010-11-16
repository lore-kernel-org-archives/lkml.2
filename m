Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab0KPSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:03:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45175 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0KPSDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:03:13 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sergio Aguirre <saaguirre@ti.com>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH v2] irq_work: Drop cmpxchg result
Date: Tue, 16 Nov 2010 12:02:47 -0600
Message-Id: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This solves this compilation warning:

kernel/irq_work.c: In function 'irq_work_run':
kernel/irq_work.c:148: warning: value computed is not used

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Changelog:
v2 - Keep ignoring the cmpxchg return value, as pointed
     out by Peter Zijlstra, and update patch subject/description

v1 - Initial version
     (found here: https://patchwork.kernel.org/patch/328662/)

 kernel/irq_work.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f16763f..90f8819 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -145,7 +145,9 @@ void irq_work_run(void)
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
+		(void)cmpxchg(&entry->next,
+			      next_flags(NULL, IRQ_WORK_BUSY),
+			      NULL);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
-- 
1.7.0.4

