Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1LVPPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:15:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:10697 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1LVPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:15:49 -0500
X-SpamScore: -7
X-BigFish: VPS-7(zz98dK4015Lzz1202hzz8275bh8275dhz2dh668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWM2E5-01-05C-02
X-M-MSG: 
Date: Thu, 22 Dec 2011 16:15:40 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        <stable@kernel.org>
Subject: [PATCH] oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue
Message-ID: <20111222151540.GB16765@erda.amd.com>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.11 14:46:12, Robert Richter wrote:
> please pull this one fix for 3.2.

Ingo, yet another fix. Please apply to tip/perf/urgent.

Thanks,

-Robert



>From a5ea1e51bb66c6081d081cd88d787f248e07d6af Mon Sep 17 00:00:00 2001
From: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
Date: Thu, 22 Dec 2011 15:36:56 +0200
Subject: [PATCH] oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue

This change fixes a linking problem, which happens if oprofile is selected to
be compiled as built-in:

  `oprofile_arch_exit' referenced in section `.init.text' of
  arch/arm/oprofile/built-in.o: defined in discarded section
  `.exit.text' of arch/arm/oprofile/built-in.o

The problem is appeared after commit 87121ca504, which introduced
oprofile_arch_exit() calls from __init function. Note that the aforementioned
commit has been backported to stable branches, and the problem is known to be
reproduced at least with 3.0.13 and 3.1.5 kernels.

Cc: stable@kernel.org # 3.0+
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@nokia.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/arm/oprofile/common.c |    2 +-
 arch/sh/oprofile/common.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index c074e66..4e0a371 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -116,7 +116,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 }
diff --git a/arch/sh/oprofile/common.c b/arch/sh/oprofile/common.c
index b4c2d2b..e4dd5d5 100644
--- a/arch/sh/oprofile/common.c
+++ b/arch/sh/oprofile/common.c
@@ -49,7 +49,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	return oprofile_perf_init(ops);
 }
 
-void __exit oprofile_arch_exit(void)
+void oprofile_arch_exit(void)
 {
 	oprofile_perf_exit();
 	kfree(sh_pmu_op_name);
@@ -60,5 +60,5 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ops->backtrace = sh_backtrace;
 	return -ENODEV;
 }
-void __exit oprofile_arch_exit(void) {}
+void oprofile_arch_exit(void) {}
 #endif /* CONFIG_HW_PERF_EVENTS */
-- 
1.7.8



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

