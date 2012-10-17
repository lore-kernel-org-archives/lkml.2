Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2JQRCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:02:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41195 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2JQRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:02:35 -0400
Date: Wed, 17 Oct 2012 13:03:21 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: [PATCH 1/3] Make KNC use full 40-bit width of counters
In-Reply-To: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1210171302140.23243@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Early versions of KNC chips have a bug where bits above 32 were 
not properly set.  We worked around this by only using the bottom
32 bits (out of 40 that should be available).

It turns out this workaround breaks overflow handling.

The buggy silicon will in theory never be used in production systems,
so remove this workaround so we get proper overflow support.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>


diff -ur linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c
--- linux-3.7-rc1.orig/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-14 17:41:04.000000000 -0400
+++ linux-3.7-rc1/arch/x86/kernel/cpu/perf_event_knc.c	2012-10-17 11:50:08.688394147 -0400
@@ -226,12 +226,11 @@
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
