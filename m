Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab1FOPps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:45:48 -0400
Received: from relay1.sgi.com ([192.48.179.29]:38170 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1FOPpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:45:45 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8 v2] x86, UV: smp_processor_id in a preemptable region
Cc: mingo@elte.hu
Message-Id: <E1QWsIy-0008FZ-3Y@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 15 Jun 2011 10:46:56 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Calling smp_processor_id() from within a preemptable region will issue
a warning if DEBUG_PREEMPT is set.

Which cpu is returned by smp_processor_id() is actually arbitrary here, as
every cpu has a per-cpu structure with the needed limit for the tunable. But
the call should be non-preemptable to avoid a warning in a DEBUG_PREEMPT
kernel.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1334,7 +1334,9 @@ static ssize_t tunables_write(struct fil
 
 	instr[count] = '\0';
 
+	preempt_disable(); /* avoid DEBUG_PREEMPT warning */
 	bcp = &per_cpu(bau_control, smp_processor_id());
+	preempt_enable_no_resched();
 
 	ret = parse_tunables_write(bcp, instr, count);
 	if (ret)
