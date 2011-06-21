Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1FUMWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:22:50 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754888Ab1FUMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:43 -0400
Message-Id: <20110621122242.086384966@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:26 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 1/8 v5] x86, UV: smp_processor_id in a preemptable region
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_smpcpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a call by tunables_write() to smp_processor_id() within a preemptable
region.
Call get_cpu()/put_cpu() around the region where the returned cpu
number is actually used, which makes it non-preemptable.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

A DEBUG_PREEMPT warning is prevented.
UV does not support cpu hotplug yet, but this is a step toward that ability.

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
 

