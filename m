Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2BTRTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:19:10 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34782 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682Ab2BTRTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:19:07 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZPC0I-02-1O0-02
X-M-MSG: 
Date: Mon, 20 Feb 2012 18:17:05 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86: Remove wrong error message in x86_default_fixup_cpu_id
Message-ID: <20120220171705.GA17069@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's only called from amd.c:srat_detect_node(). The introduced
condition for calling the fixup code is true for all AMD multi-node
processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
nodes on one socket. And thus there are cores having different
numa-node-id but with equal phys_proc_id. For example on such a system
we now get

[    0.228109] Booting Node   0, Processors  #1
[    0.232337] smpboot cpu 1: start_ip = 83000
[    0.252088]  #2
[    0.253746] smpboot cpu 2: start_ip = 83000
[    0.272086]  #3
[    0.276018] smpboot cpu 3: start_ip = 83000
[    0.296088]  #4
[    0.297745] smpboot cpu 4: start_ip = 83000
[    0.316088]  #5
[    0.320021] smpboot cpu 5: start_ip = 83000
[    0.340113]  Ok.
[    0.342324] Booting Node   1, Processors  #6
[    0.344344] smpboot cpu 6: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0
[    0.372110]  #7
[    0.373771] smpboot cpu 7: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0
[    0.396104]  #8
[    0.397764] smpboot cpu 8: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0
[    0.420109]  #9
[    0.421773] smpboot cpu 9: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0
[    0.444113]  #10
[    0.445865] smpboot cpu 10: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0
[    0.468111]  #11
[    0.472030] smpboot cpu 11: start_ip = 83000
[    0.016000] NUMA core number 1 differs from configured core number 0

These NUMA core numbering error messages are plain wrong.

The confusing/misleading error message was introduced with commit
64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
override to fix up NUMA core numbering) and should be removed.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/common.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

BTW, I wonder why the fixup code isn't called from the Intel path.  At
least the mentioned patch suggests that something more generic was
introduced here.

And I am curious why there is this specific condition to decide
whether a call to x86_cpuinit.fixup_cpu_id is required.


Regards,
Andreas


diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..2ef7685 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1163,7 +1163,6 @@ static void dbg_restore_debug_regs(void)
  */
 void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
-	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
 }
 
 /*
-- 
1.7.8.4



