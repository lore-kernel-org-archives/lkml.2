Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2JQODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:03:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18132 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab2JQODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:03:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] x86/wakeup/sleep: Check whether the TSS GDT descriptor is empty before using it.
Date: Wed, 17 Oct 2012 09:49:43 -0400
Message-Id: <1350481786-4969-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check the TSS descriptor before we try to dereference it.
Also fix up the value to use the #defines.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/power/cpu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 218cdb1..c17370e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -133,7 +133,9 @@ static void fix_processor_context(void)
 {
 	int cpu = smp_processor_id();
 	struct tss_struct *t = &per_cpu(init_tss, cpu);
-
+#ifdef CONFIG_X86_64
+	struct desc_struct *desc = get_cpu_gdt_table(cpu);
+#endif
 	set_tss_desc(cpu, t);	/*
 				 * This just modifies memory; should not be
 				 * necessary. But... This is necessary, because
@@ -142,7 +144,8 @@ static void fix_processor_context(void)
 				 */
 
 #ifdef CONFIG_X86_64
-	get_cpu_gdt_table(cpu)[GDT_ENTRY_TSS].type = 9;
+	if (!desc_empty(&desc[GDT_ENTRY_TSS]))
+		desc[GDT_ENTRY_TSS].type = DESC_TSS;
 
 	syscall_init();				/* This sets MSR_*STAR and related */
 #endif
-- 
1.7.7.6

