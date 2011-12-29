Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1L2VFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 16:05:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38854 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1L2VFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:05:00 -0500
Date: Thu, 29 Dec 2011 22:02:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20111229210252.GA22102@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      perf/x86: Fix raw_spin_unlock_irqrestore() usage

Vladimir Zapolskiy (1):
      oprofile, arm/sh: Fix oprofile_arch_exit() linkage issue


 arch/arm/oprofile/common.c             |    2 +-
 arch/sh/oprofile/common.c              |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8d601b1..121f1be 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1169,7 +1169,7 @@ again:
 		 */
 		c = &unconstrained;
 	} else if (intel_try_alt_er(event, orig_idx)) {
-		raw_spin_unlock(&era->lock);
+		raw_spin_unlock_irqrestore(&era->lock, flags);
 		goto again;
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
