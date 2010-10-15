Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0JOUME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:12:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0JOUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:10:38 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=GFTHqsE1lUEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Op-mwl0xAAAA:8 a=meVymXHHAAAA:8 a=YARMKTzuC7XxI4AYRegA:9 a=n6EABryYw485qJXwiCUA:7 a=yktOZIr3FUDQaoH2oewAjK3ze3MA:4 a=jEp0ucaQiEUA:10 a=d4CUUju0HPYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101015201035.892341112@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 15 Oct 2010 16:09:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 1/9] jump label/x86: Move arch_init_ideal_nop5 later
References: <20101015200949.134732894@goodmis.org>
Content-Disposition: inline; filename=0001-jump-label-x86-Move-arch_init_ideal_nop5-later.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

arch_init_ideal_nop5() was being called from setup_arch() before
the exception table was setup. Move it later into
alternative_instructions().

Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
processor.

Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jason Baron <jbaron@redhat.com>
LKML-Reference: <20101004154633.GA2900@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/alternative.c |    5 +++++
 arch/x86/kernel/setup.c       |    6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..83a56a2 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -454,6 +454,7 @@ extern struct paravirt_patch_site __start_parainstructions[],
 
 void __init alternative_instructions(void)
 {
+	unsigned long flags;
 	/* The patching is not fully atomic, so try to avoid local interruptions
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
@@ -508,6 +509,10 @@ void __init alternative_instructions(void)
 				(unsigned long)__smp_locks_end);
 
 	restart_nmi();
+
+	local_irq_save(flags);
+	arch_init_ideal_nop5();
+	local_irq_restore(flags);
 }
 
 /**
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 00e1678..c3a4fbb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,7 +112,6 @@
 #include <asm/numa_64.h>
 #endif
 #include <asm/mce.h>
-#include <asm/alternative.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -727,7 +726,6 @@ void __init setup_arch(char **cmdline_p)
 {
 	int acpi = 0;
 	int k8 = 0;
-	unsigned long flags;
 
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -1073,10 +1071,6 @@ void __init setup_arch(char **cmdline_p)
 	x86_init.oem.banner();
 
 	mcheck_init();
-
-	local_irq_save(flags);
-	arch_init_ideal_nop5();
-	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1


