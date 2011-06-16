Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab1FPMRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:17:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab1FPMO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:14:59 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8 v3] x86, UV: smp_processor_id in a preemptable region
Cc: mingo@elte.hu
Message-Id: <E1QXBUZ-0004g0-RG@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 16 Jun 2011 07:16:11 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Calling smp_processor_id() from within a preemptable region will issue
a warning if DEBUG_PREEMPT is set.

The calls to get_cpu()/put_cpu() bound the region where the return cpu
number is actually used and make it non-preemptable.  A DEBUG_PREEMPT
warning is prevented.
UV does not support cpu hotplug yet, but this is a step toward that ability.

Diffed against 3.0.0-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1334,9 +1334,10 @@ static ssize_t tunables_write(struct fil
 
 	instr[count] = '\0';
 
-	bcp = &per_cpu(bau_control, smp_processor_id());
-
+	cpu = get_cpu();
+	bcp = &per_cpu(bau_control, cpu);
 	ret = parse_tunables_write(bcp, instr, count);
+	put_cpu();
 	if (ret)
 		return ret;
 
