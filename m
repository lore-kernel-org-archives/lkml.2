Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2FTQjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:39:39 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:38276
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab2FTQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:39:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5XCXU-01-2Y8-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 18:39:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, <zheng.z.yan@intel.com>,
        <tglx@linutronix.de>
CC: <linux-tip-commits@vger.kernel.org>
Subject: [PATCH] perf, x86: Fix section mismatch in uncore_pci_init()
Message-ID: <20120620163927.GI5046@erda.amd.com>
References: <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
 <tip-14371cce03c2fc393997e17f979e76674b7f392a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-14371cce03c2fc393997e17f979e76674b7f392a@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.12 03:56:06, tip-bot for Yan, Zheng wrote:
> Commit-ID:  14371cce03c2fc393997e17f979e76674b7f392a
> Gitweb:     http://git.kernel.org/tip/14371cce03c2fc393997e17f979e76674b7f392a
> Author:     Yan, Zheng <zheng.z.yan@intel.com>
> AuthorDate: Fri, 15 Jun 2012 14:31:36 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 18 Jun 2012 12:13:23 +0200
> 
> perf: Add generic PCI uncore PMU device support
> 
> This patch adds generic support for uncore PMUs presented as
> PCI devices. (These come in addition to the CPU/MSR based
> uncores.)
> 
> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1339741902-8449-8-git-send-email-zheng.z.yan@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |  175 ++++++++++++++++++++++++-
>  arch/x86/kernel/cpu/perf_event_intel_uncore.h |   66 +++++++++
>  2 files changed, 236 insertions(+), 5 deletions(-)

This patch causes a section mismatch, fix below.

-Robert



>From 912df3647e53c7bb1c61fd8fe4366cba1f788755 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 20 Jun 2012 18:31:17 +0200
Subject: [PATCH] perf, x86: Fix section mismatch in uncore_pci_init()

Fixing section mismatch in uncore_pci_init():

 WARNING: vmlinux.o(.init.text+0x9246): Section mismatch in reference from the function uncore_pci_init() to the function .devexit.text:uncore_pci_remove()
 The function __init uncore_pci_init() references
 a function __devexit uncore_pci_remove().
 This is often seen when error handling in the init function
 uses functionality in the exit path.
 The fix is often to remove the __devexit annotation of
 uncore_pci_remove() so it may be used outside an exit section.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 28a8413..6f43f95 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1313,7 +1313,7 @@ static int __devinit uncore_pci_add(struct intel_uncore_type *type,
 	return 0;
 }
 
-static void __devexit uncore_pci_remove(struct pci_dev *pdev)
+static void uncore_pci_remove(struct pci_dev *pdev)
 {
 	struct intel_uncore_box *box = pci_get_drvdata(pdev);
 	struct intel_uncore_pmu *pmu = box->pmu;
-- 
1.7.8.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

