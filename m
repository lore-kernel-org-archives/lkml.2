Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1KOP4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:56:18 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47174 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab1KOP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:56:17 -0500
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, microcode, AMD: Restrict microcode reporting
Date: Tue, 15 Nov 2011 16:55:56 +0100
Message-Id: <1321372556-6205-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

bcb80e53877c ("x86, microcode, AMD: Add microcode revision to
/proc/cpuinfo") added support for dumping microcode patch level in
/proc/cpuinfo on AMD. Although we were very cautious and did rdmsr_safe
the microcode patch level MSR, this broke booting on Geode LX because
this CPU doesn't have that MSR and at the time we do the read, exception
tables which are used by rdmsr_safe are not yet initialized, leading to
the boot hang.

This is the simple fix which enables the microcode line in /proc/cpuinfo
for K8 and newer (it is not that interesting for older boxes anyway :-)).

Reported-and-bisected-and-tested-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c7e46cb..a72d183 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -474,7 +474,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
+	if (c->x86 >= 0xf)
+		rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-- 
1.7.8.rc0

