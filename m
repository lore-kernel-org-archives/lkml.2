Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2JXKfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:35:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2JXKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:35:46 -0400
Date: Wed, 24 Oct 2012 03:34:23 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-ae5ba47a990a18c869d66916fd72fb334c45cf91@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, lawrence.f.meadows@intel.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, lawrence.f.meadows@intel.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210171302140.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171302140.23243@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Make Intel KNC use full 40-bit width of counters
Git-Commit-ID: ae5ba47a990a18c869d66916fd72fb334c45cf91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:34:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae5ba47a990a18c869d66916fd72fb334c45cf91
Gitweb:     http://git.kernel.org/tip/ae5ba47a990a18c869d66916fd72fb334c45cf91
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Wed, 17 Oct 2012 13:03:21 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 12:00:48 +0200

perf/x86: Make Intel KNC use full 40-bit width of counters

Early versions of Intel KNC chips have a bug where bits above 32
were not properly set.  We worked around this by only using the
bottom 32 bits (out of 40 that should be available).

It turns out this workaround breaks overflow handling.

The buggy silicon will in theory never be used in production
systems, so remove this workaround so we get proper overflow
support.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: eranian@gmail.com
Cc: Meadows Lawrence F <lawrence.f.meadows@intel.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210171302140.23243@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_knc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 7c46bfd..73bcfbd 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -226,12 +226,11 @@ static __initconst struct x86_pmu knc_pmu = {
 	.event_map		= knc_pmu_event_map,
 	.max_events             = ARRAY_SIZE(knc_perfmon_event_map),
 	.apic			= 1,
-	.max_period		= (1ULL << 31) - 1,
+	.max_period		= (1ULL << 39) - 1,
 	.version		= 0,
 	.num_counters		= 2,
-	/* in theory 40 bits, early silicon is buggy though */
-	.cntval_bits		= 32,
-	.cntval_mask		= (1ULL << 32) - 1,
+	.cntval_bits		= 40,
+	.cntval_mask		= (1ULL << 40) - 1,
 	.get_event_constraints	= x86_get_event_constraints,
 	.event_constraints	= knc_event_constraints,
 	.format_attrs		= intel_knc_formats_attr,
