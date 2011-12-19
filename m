Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1LSCD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:03:26 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39933 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab1LSCDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:03:23 -0500
Message-ID: <1324260184.3006.15.camel@ThinkPad-T61>
Subject: [PATCH powerpc] fix unpaired probe_hcall_entry and probe_hcall_exit
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, anton@samba.org,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Mon, 19 Dec 2011 10:03:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121816-7014-0000-0000-00000046E8B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpaired calling of probe_hcall_entry and probe_hcall_exit might happen
as following, which could cause incorrect preempt count. 

__trace_hcall_entry => trace_hcall_entry -> probe_hcall_entry =>
get_cpu_var => preempt_disable

__trace_hcall_exit => trace_hcall_exit -> probe_hcall_exit =>
put_cpu_var => preempt_enable

where: 
A => B and A -> B means A calls B, but
=> means A will call B through function name, and B will definitely be
called.
-> means A will call B through function pointer, so B might not be
called if the function pointer is not set.

So error happens when only one of probe_hcall_entry and probe_hcall_exit
get called during a hcall.

This patch tries to move the preempt count operations from
probe_hcall_entry and probe_hcall_exit to its callers.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/hvCall_inst.c |    4 +---
 arch/powerpc/platforms/pseries/lpar.c        |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hvCall_inst.c b/arch/powerpc/platforms/pseries/hvCall_inst.c
index f106662..c9311cf 100644
--- a/arch/powerpc/platforms/pseries/hvCall_inst.c
+++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -109,7 +109,7 @@ static void probe_hcall_entry(void *ignored, unsigned long opcode, unsigned long
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &get_cpu_var(hcall_stats)[opcode / 4];
+	h = &__get_cpu_var(hcall_stats)[opcode / 4];
 	h->tb_start = mftb();
 	h->purr_start = mfspr(SPRN_PURR);
 }
@@ -126,8 +126,6 @@ static void probe_hcall_exit(void *ignored, unsigned long opcode, unsigned long
 	h->num_calls++;
 	h->tb_total += mftb() - h->tb_start;
 	h->purr_total += mfspr(SPRN_PURR) - h->purr_start;
-
-	put_cpu_var(hcall_stats);
 }
 
 static int __init hcall_inst_init(void)
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 27a4950..dc36ea6 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -554,6 +554,7 @@ void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 		goto out;
 
 	(*depth)++;
+	preempt_disable();
 	trace_hcall_entry(opcode, args);
 	(*depth)--;
 
@@ -576,6 +577,7 @@ void __trace_hcall_exit(long opcode, unsigned long retval,
 
 	(*depth)++;
 	trace_hcall_exit(opcode, retval, retbuf);
+	preempt_enable();
 	(*depth)--;
 
 out:
-- 
1.7.5.4

