Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1DRMPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:15:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42443 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRMP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:15:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/3] mn10300: replace mm->cpu_vm_mask with mm_cpumask
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
In-Reply-To: <20110418211455.9359.A69D9226@jp.fujitsu.com>
References: <20110418211455.9359.A69D9226@jp.fujitsu.com>
Message-Id: <20110418211626.935D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 18 Apr 2011 21:15:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plant to change mm->cpu_vm_mask definition later. Thus this
patch convert it into mm_cpumask().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/kernel/smp.c |    2 +-
 arch/mn10300/mm/tlb-smp.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

mn10300 is one of last two cpu_vm_mask direct access users.

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 83fb279..6d59726 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -986,7 +986,7 @@ int __cpu_disable(void)
 		return -EBUSY;
 
 	migrate_irqs();
-	cpu_clear(cpu, current->active_mm->cpu_vm_mask);
+	cpu_clear(cpu, mm_cpumask(current->active_mm));
 	return 0;
 }
 
diff --git a/arch/mn10300/mm/tlb-smp.c b/arch/mn10300/mm/tlb-smp.c
index 0b6a5ad..9d357b4 100644
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -146,7 +146,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -165,7 +165,7 @@ void flush_tlb_current_task(void)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb();
@@ -186,7 +186,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
 	cpumask_t cpu_mask;
 
 	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 
 	local_flush_tlb_page(mm, va);
-- 
1.7.3.1



