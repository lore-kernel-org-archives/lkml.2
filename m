Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab2HGDJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:09:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2HGDJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:09:06 -0400
Date: Mon, 6 Aug 2012 20:08:53 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-5b556332c3ab19e6375836d35ca658776e9ba0f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com, borislav.petkov@amd.com
In-Reply-To: <1344272439-29080-3-git-send-email-bp@amd64.org>
References: <1344272439-29080-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, cpu: Push TLB detection CPUID check down
Git-Commit-ID: 5b556332c3ab19e6375836d35ca658776e9ba0f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 06 Aug 2012 20:08:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b556332c3ab19e6375836d35ca658776e9ba0f6
Gitweb:     http://git.kernel.org/tip/5b556332c3ab19e6375836d35ca658776e9ba0f6
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 6 Aug 2012 19:00:37 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 6 Aug 2012 19:18:29 -0700

x86, cpu: Push TLB detection CPUID check down

Push the max CPUID leaf check into the ->detect_tlb function and remove
general test case from the generic path.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344272439-29080-3-git-send-email-bp@amd64.org
Acked-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |    3 +--
 arch/x86/kernel/cpu/intel.c  |    4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d239977..080f4a7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -940,8 +940,7 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	if (boot_cpu_data.cpuid_level >= 2)
-		cpu_detect_tlb(&boot_cpu_data);
+	cpu_detect_tlb(&boot_cpu_data);
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 0a4ce29..198e019 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -648,6 +648,10 @@ static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 	int i, j, n;
 	unsigned int regs[4];
 	unsigned char *desc = (unsigned char *)regs;
+
+	if (c->cpuid_level < 2)
+		return;
+
 	/* Number of times to iterate */
 	n = cpuid_eax(2) & 0xFF;
 
