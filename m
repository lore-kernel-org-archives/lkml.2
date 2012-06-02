Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2FBRiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 13:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab2FBRiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 13:38:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] Fix booted_cores calculation in set_cpu_sibling_map()
Date: Sat,  2 Jun 2012 13:37:54 -0400
Message-Id: <1338658674-6550-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

git commit 316ad248307fba13be40f01e92a22b89457c32bc changed
 set_cpu_sibling_map() to a single loop.

On a 2 socket system with 4 nodes, with 8 cores/socket top of tree
now shows

.> cat /proc/cpuinfo | grep cores
cpu cores	: 2
cpu cores	: 4
cpu cores	: 5
cpu cores	: 6
cpu cores	: 7
cpu cores	: 8
cpu cores	: 9
cpu cores	: 10
cpu cores	: 2
cpu cores	: 4
cpu cores	: 5
cpu cores	: 6
cpu cores	: 7
cpu cores	: 8
cpu cores	: 9
cpu cores	: 10
cpu cores	: 15
cpu cores	: 15
cpu cores	: 13
cpu cores	: 11
cpu cores	: 9
cpu cores	: 7
cpu cores	: 5
cpu cores	: 3
cpu cores	: 15
cpu cores	: 15
cpu cores	: 13
cpu cores	: 11
cpu cores	: 9
cpu cores	: 7
cpu cores	: 5
cpu cores	: 3

This is wrong.  The kernel should show

cpu cores	: 8

for each entry.

set_cpu_sibling_map() must be two separate loops, the first which
calculates the cpu's sibling_maps and the second which determines
how many cores have been booted.  The code does a check on
(cpumask_weight(cpu_sibling_mask(cpu)).  The problem is that
the sibling_mask may not be fully populated by the time this
value is checked resulting in incorrect booted_cores values.

I've found this broken and tested the fix on both AMD multi-socket and Intel
multi-socket systems (as well as single socket single node systems).
-----8<-----

The code in set_cpu_sibling_map() checks the value of
cpu_sibling_mask(cpu) before the mask is fully populated.  This results in
an incorrect calculation of each cpu's booted_cores.  Move back to a two
pass mechanism to properly calculate booted_cores.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/smpboot.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f56f96d..019248e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -381,6 +381,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 		if ((i == cpu) || (has_mc && match_llc(c, o)))
 			link_mask(llc_shared, cpu, i);
+	}
+
+	for_each_cpu(i, cpu_sibling_setup_mask) {
+		o = &cpu_data(i);
 
 		if ((i == cpu) || (has_mc && match_mc(c, o))) {
 			link_mask(core, cpu, i);
-- 
1.7.1

