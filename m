Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IMO6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:58:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0IMO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:58:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=H2WHKpnxvRBSItgSV0ujKeGVMsMr4rZYd3vQPCIcIquLmA7huXchdYJTafHqFtF4p
	wKQCrEVoplsOl/Rb5nCQQ==
Message-ID: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 13 Sep 2010 16:55:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, markus.t.metzger@intel.com
Subject: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
requesting contiguous physical memory. There is no such restriction on
DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
no contiguous physical memory is available. BTS is requesting 64KB,
thus it can cause issues. PEBS is currently only requesting one page.
Both PEBS and BTS are static buffers allocated for each CPU at the
first user. When the last user exists, the buffers are released.

All buffers are only accessed on the CPU they are attached to.
kzalloc() does not take into account NUMA, thus all allocations
are taking place on the NUMA node where the perf_event_open() is
made.

This patch switches allocation to vmalloc_node() to use non-contiguous
physical memory and to allocate on the NUMA node corresponding to each
CPU. We switched DS and PEBS although they do not cause problems today,
to, at least, make the allocation on the correct NUMA node. In the future,
the PEBS buffer size may increase. DS may also grow bigger than a page.
This patch eliminates the memory allocation imbalance.

vmalloc_node() returns page-aligned addresses which do conform with the
restriction on PEBS buffer as documented by Intel in Vol3a section 16.9.4.2.

Signed-off-by: Stephane Eranian <eranian@google.com>
--

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 4977f9c..94293cd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -94,9 +94,9 @@ static void release_ds_buffers(void)
 
 		per_cpu(cpu_hw_events, cpu).ds = NULL;
 
-		kfree((void *)(unsigned long)ds->pebs_buffer_base);
-		kfree((void *)(unsigned long)ds->bts_buffer_base);
-		kfree(ds);
+		vfree((void *)(unsigned long)ds->pebs_buffer_base);
+		vfree((void *)(unsigned long)ds->bts_buffer_base);
+		vfree(ds);
 	}
 
 	put_online_cpus();
@@ -115,18 +115,32 @@ static int reserve_ds_buffers(void)
 		struct debug_store *ds;
 		void *buffer;
 		int max, thresh;
-
+		int node = cpu_to_node(cpu);
+
+		/*
+		 * Neither DS, BTS, nor PEBS need contiguous physical
+		 * pages.  See Intel Vol3a Section 16.9.4.2.
+		 *
+		 * Furthermore, they are all mostly accessed on
+		 * their respective CPU.
+		 * Therefore, we can use vmalloc_node()
+		 */
 		err = -ENOMEM;
-		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+		ds = vmalloc_node(sizeof(*ds), node);
 		if (unlikely(!ds))
 			break;
+
+		memset(ds, 0, sizeof(*ds));
+
 		per_cpu(cpu_hw_events, cpu).ds = ds;
 
 		if (x86_pmu.bts) {
-			buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+			buffer = vmalloc_node(BTS_BUFFER_SIZE, node);
 			if (unlikely(!buffer))
 				break;
 
+			memset(buffer, 0, BTS_BUFFER_SIZE);
+
 			max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
 			thresh = max / 16;
 
@@ -139,10 +153,12 @@ static int reserve_ds_buffers(void)
 		}
 
 		if (x86_pmu.pebs) {
-			buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+			buffer = vmalloc_node(PEBS_BUFFER_SIZE, node);
 			if (unlikely(!buffer))
 				break;
 
+			memset(buffer, 0, PEBS_BUFFER_SIZE);
+
 			max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
 
 			ds->pebs_buffer_base = (u64)(unsigned long)buffer;
