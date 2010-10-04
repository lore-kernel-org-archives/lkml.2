Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab0JDUZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:25:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:39718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab0JDUZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:25:43 -0400
Date: Mon, 4 Oct 2010 20:25:25 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930123235.GB20545@loge.amd.com>
References: <20100930123235.GB20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
Message-ID: <tip-3fdbf004c1706480a7c7fac3c9d836fa6df20d7d@git.kernel.org>
Git-Commit-ID: 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:25:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
Gitweb:     http://git.kernel.org/tip/3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:32:35 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:31 -0700

x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs

Instead of adapting the CPU family check in amd_special_default_mtrr()
for each new CPU family assume that all new AMD CPUs support the
necessary bits in SYS_CFG MSR.

Tom2Enabled is architectural (defined in APM Vol.2).
Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
In pre K8-NPT BKDG this bit is reserved (read as zero).

W/o this adaption Linux would unnecessarily complain about bad MTRR
settings on every new AMD CPU family, e.g.

[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4863MB of RAM.

Cc: stable@kernel.org # .32.x, .35.x
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930123235.GB20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index c5f59d0..ac140c7 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
