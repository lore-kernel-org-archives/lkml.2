Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2CINYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:24:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2CINX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:23:59 -0500
Date: Fri, 9 Mar 2012 05:23:35 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-88c9a65e13f393fd60d8b9e9c659a34f9e39967d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328826068-11713-7-git-send-email-eranian@google.com>
References: <1328826068-11713-7-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf/x86:
  Disable LBR support for older Intel Atom processors
Git-Commit-ID: 88c9a65e13f393fd60d8b9e9c659a34f9e39967d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:23:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88c9a65e13f393fd60d8b9e9c659a34f9e39967d
Gitweb:     http://git.kernel.org/tip/88c9a65e13f393fd60d8b9e9c659a34f9e39967d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 9 Feb 2012 23:20:56 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Mar 2012 14:55:41 +0100

perf/x86: Disable LBR support for older Intel Atom processors

The patch adds a restriction for Intel Atom LBR support. Only
steppings 10 (PineView) and more recent are supported. Older models
do not have a functional LBR. Their LBR does not freeze on PMU
interrupt which makes LBR unusable in the context of perf_events.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328826068-11713-7-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index e54a063..07f0ff8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -315,6 +315,16 @@ void intel_pmu_lbr_init_snb(void)
 /* atom */
 void intel_pmu_lbr_init_atom(void)
 {
+	/*
+	 * only models starting at stepping 10 seems
+	 * to have an operational LBR which can freeze
+	 * on PMU interrupt
+	 */
+	if (boot_cpu_data.x86_mask < 10) {
+		pr_cont("LBR disabled due to erratum");
+		return;
+	}
+
 	x86_pmu.lbr_nr	   = 8;
 	x86_pmu.lbr_tos    = MSR_LBR_TOS;
 	x86_pmu.lbr_from   = MSR_LBR_CORE_FROM;
