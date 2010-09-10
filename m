Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0IJLKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 07:10:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4101 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0IJLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 07:10:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=eE5yzWZcoX+CtM4P68h0AJt/Kv8lsZYHcG4aiLPFyhWvZtu/7N612VS6QTiWx3gAF
	ynP9yvTXXc4BQORh5qsFQ==
Message-ID: <4c8a121b.0e28e30a.4dc9.718d@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 10 Sep 2010 13:09:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, dzickus@redhat.com
Subject: [PATCH] perf_events: fix BTS interrupt handling to avoid being dazed by NMI
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug introduced with commit de725de and the change in the meaning of the
return value of intel_pmu_handle_irq(). With the current code, when you are
using the BTS, you get 'dazed by NMI' each time the BTS buffer fills up.

BTS does interrupt on the PMU vector, thus NMI. You need to take this
into account in the return value of the function.

Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ee05c90..b4d2e1c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -713,18 +713,18 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
 	u64 status;
-	int handled = 0;
+	int handled;
 
 	perf_sample_data_init(&data, 0);
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	intel_pmu_disable_all();
-	intel_pmu_drain_bts_buffer();
+	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
 		intel_pmu_enable_all(0);
-		return 0;
+		return handled;
 	}
 
 	loops = 0;
