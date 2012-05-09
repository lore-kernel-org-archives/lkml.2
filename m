Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2EIOi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:38:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759792Ab2EIOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:38:26 -0400
Date: Wed, 9 May 2012 07:38:12 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-fc5fb2b5e1874e5894e2ac503bfb744220db89a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-12-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-12-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86-ibs:
  Catch spurious interrupts after stopping IBS
Git-Commit-ID: fc5fb2b5e1874e5894e2ac503bfb744220db89a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:38:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc5fb2b5e1874e5894e2ac503bfb744220db89a1
Gitweb:     http://git.kernel.org/tip/fc5fb2b5e1874e5894e2ac503bfb744220db89a1
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:16 +0200

perf/x86-ibs: Catch spurious interrupts after stopping IBS

After disabling IBS there could be still incomming NMIs with samples
that even have the valid bit cleared. Mark all this NMIs as handled to
avoid spurious interrupt messages.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-12-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index b14e711..5a9f95b 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -473,11 +473,13 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	u64 *buf, *config, period;
 
 	if (!test_bit(IBS_STARTED, pcpu->state)) {
-		/* Catch spurious interrupts after stopping IBS: */
-		if (!test_and_clear_bit(IBS_STOPPING, pcpu->state))
-			return 0;
-		rdmsrl(perf_ibs->msr, *ibs_data.regs);
-		return (*ibs_data.regs & perf_ibs->valid_mask) ? 1 : 0;
+		/*
+		 * Catch spurious interrupts after stopping IBS: After
+		 * disabling IBS there could be still incomming NMIs
+		 * with samples that even have the valid bit cleared.
+		 * Mark all this NMIs as handled.
+		 */
+		return test_and_clear_bit(IBS_STOPPING, pcpu->state) ? 1 : 0;
 	}
 
 	msr = hwc->config_base;
