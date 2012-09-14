Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2INQhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:37:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42784 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab2INQhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:37:50 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86: Dump family, model, stepping of the BSP
Date: Fri, 14 Sep 2012 18:37:46 +0200
Message-Id: <1347640666-13638-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When acting on a user bug report, we find ourselves constantly asking
for /proc/cpuinfo in order to know the exact family, model, stepping of
the CPU in question. Instead of having to ask this, add this to dmesg
so that it is visible and no ambiguities can ensue from looking at the
official name string of the CPU coming from CPUID and trying to map it
to f/m/s.

Output then looks like this:

[    0.146041] smpboot: CPU0: AMD FX(tm)-8100 Eight-Core Processor (fam: 15 model: 01 stepping: 02)

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/common.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2ea24da6f7fb..90f7f8f9212f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1022,14 +1022,16 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
+		printk(KERN_CONT "%s", strim(c->x86_model_id));
 	else
 		printk(KERN_CONT "%d86", c->x86);
 
+	printk(KERN_CONT " (fam: %02x model: %02x", c->x86, c->x86_model);
+
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
+		printk(KERN_CONT " stepping: %02x)\n", c->x86_mask);
 	else
-		printk(KERN_CONT "\n");
+		printk(KERN_CONT ")\n");
 
 	print_cpu_msr(c);
 }
-- 
1.7.11.rc1

