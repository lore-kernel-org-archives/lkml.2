Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1HENPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:15:18 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57664 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab1HENPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:15:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Andre Przywara <Andre.Przywara@amd.com>,
        Martin Pohlack <Martin.Pohlack@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3.1 2/3] x86: Add a BSP cpuinit helper
Date: Fri,  5 Aug 2011 15:15:09 +0200
Message-Id: <1312550110-24160-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1312550110-24160-1-git-send-email-bp@amd64.org>
References: <1312550110-24160-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a function ptr to struct x86_cpuinit_ops which is destined to be run
only once on the BSP during boot.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/cpu/common.c    |    2 ++
 arch/x86/kernel/x86_init.c      |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d3d8590..08994a0 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -147,6 +147,7 @@ struct x86_init_ops {
  */
 struct x86_cpuinit_ops {
 	void (*setup_percpu_clockev)(void);
+	void (*run_on_bsp)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22a073d..465e633 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -681,6 +681,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
+
+	x86_cpuinit.run_on_bsp();
 }
 
 void __init early_cpu_init(void)
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 6f164bd..76b37ed 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -90,6 +90,7 @@ struct x86_init_ops x86_init __initdata = {
 
 struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
+	.run_on_bsp			= x86_init_noop,
 };
 
 static void default_nmi_init(void) { };
-- 
1.7.4.rc2

