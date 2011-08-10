Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1HJRlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:41:14 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:10284
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585Ab1HJRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:41:11 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:160.36.179.112;KIP:(null);UIP:(null);IPVD:NLI;H:kedge2.utk.tennessee.edu;RD:kedge2.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 10 Aug 2011 13:40:31 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: <will.deacon@arm.com>, sam wang <linux.swang@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: [patch] perf: ARMv7 wrong "branches" generalized instruction 
Message-ID: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Sam Wang reported to me that my perf_event validation tests were failing 
with branches on ARM Cortex A9.

It turns out the branches event used (ARMV7_PERFCTR_PC_WRITE) only seems
to count taken branches.

ARMV7_PERFCTR_PC_IMM_BRANCH seems to do a better job of counting both 
taken and not-taken.  So I've attached a patch to change the definition
for Cotex A9.

This might be needed for Cortex A8 but I don't have a machine to test on 
(yet).

I'm assuming this is a proper fix.  The "generalized" events aren't 
defined very well so there's always some wiggle room about what they mean.

Patch tested on a Pandaboard.

The test code looks like this.  There should be 500,000*3 branches.  But
the second branch (the not taken "bge test_jmp2") is not counted with 
PC_WRITE.

        asm(    "\teor r3,r3,r3\n"
                "\tldr r3,=500000\n"
                "test_loop:\n"
                "\tB test_jmp\n"
                "\tnop\n"
                "test_jmp:\n"
                "\teor r2,r2,r2\n"
                "\tcmp r2,#1\n"
                "\tbge test_jmp2\n"     
                "\tnop\n"
                "\tadd r2,r2,#1\n"
                "test_jmp2:\n"
                "\tsub r3,r3,#1\n"
                "\tcmp r3,#1\n"
                "\tbgt test_loop\n"
                : /* no output registers */
                : /* no inputs           */
                : "cc", "r2", "r3" /* clobbered */
        );


Vince
vweaver1@eecs.utk.edu

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 4c85183..4d11bd5 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -323,7 +323,7 @@ static const unsigned armv7_a9_perf_map[PERF_COUNT_HW_MAX] = {
 					ARMV7_PERFCTR_INST_OUT_OF_RENAME_STAGE,
 	[PERF_COUNT_HW_CACHE_REFERENCES]    = ARMV7_PERFCTR_COHERENT_LINE_HIT,
 	[PERF_COUNT_HW_CACHE_MISSES]	    = ARMV7_PERFCTR_COHERENT_LINE_MISS,
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = ARMV7_PERFCTR_PC_WRITE,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = ARMV7_PERFCTR_PC_IMM_BRANCH,
 	[PERF_COUNT_HW_BRANCH_MISSES]	    = ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
 	[PERF_COUNT_HW_BUS_CYCLES]	    = ARMV7_PERFCTR_CLOCK_CYCLES,
 };

