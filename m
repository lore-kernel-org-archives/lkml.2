Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab2AJXW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:22:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933797Ab2AJW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:21 2012
Message-Id: <20120110215021.852694679@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Li Zhong <zhong@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [11/42] powerpc: Fix unpaired probe_hcall_entry and probe_hcall_exit
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

commit e4f387d8db3ba3c2dae4d8bdfe7bb5f4fe1bcb0d upstream.

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
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/hvCall_inst.c |    4 +---
 arch/powerpc/platforms/pseries/lpar.c        |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/powerpc/platforms/pseries/hvCall_inst.c
+++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
@@ -109,7 +109,7 @@ static void probe_hcall_entry(void *igno
 	if (opcode > MAX_HCALL_OPCODE)
 		return;
 
-	h = &get_cpu_var(hcall_stats)[opcode / 4];
+	h = &__get_cpu_var(hcall_stats)[opcode / 4];
 	h->tb_start = mftb();
 	h->purr_start = mfspr(SPRN_PURR);
 }
@@ -126,8 +126,6 @@ static void probe_hcall_exit(void *ignor
 	h->num_calls++;
 	h->tb_total += mftb() - h->tb_start;
 	h->purr_total += mfspr(SPRN_PURR) - h->purr_start;
-
-	put_cpu_var(hcall_stats);
 }
 
 static int __init hcall_inst_init(void)
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -553,6 +553,7 @@ void __trace_hcall_entry(unsigned long o
 		goto out;
 
 	(*depth)++;
+	preempt_disable();
 	trace_hcall_entry(opcode, args);
 	(*depth)--;
 
@@ -575,6 +576,7 @@ void __trace_hcall_exit(long opcode, uns
 
 	(*depth)++;
 	trace_hcall_exit(opcode, retval, retbuf);
+	preempt_enable();
 	(*depth)--;
 
 out:


