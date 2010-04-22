Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0DVBXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:23:13 -0400
Received: from mail.openrapids.net ([64.15.138.104]:36381 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754790Ab0DVBXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:23:12 -0400
Date: Wed, 21 Apr 2010 21:23:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       davem@davemloft.net
Subject: [PATCH] rcu fix rcu head init on stack in rcutree_plugin.h
Message-ID: <20100422012309.GB32400@Krystal>
References: <20100417124837.536020244@efficios.com> <20100418004849.GD2876@linux.vnet.ibm.com> <20100421173145.GA6966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421173145.GA6966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:20:52 up 89 days,  3:58,  9 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Paul]
[...]
And testing got me the following debugobjects splat
[...]
ODEBUG: object is on stack, but not annotated
------------[ cut here ]------------
Badness at lib/debugobjects.c:294
NIP: c0000000002c76f0 LR: c0000000002c76ec CTR: c00000000041ecd8
REGS: c0000001de71b280 TRAP: 0700   Tainted: G        W   (2.6.34-rc3-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000424  XER: 0000000f
TASK = c0000001de7dca00[3695] 'arping' THREAD: c0000001de718000 CPU: 1
GPR00: c0000000002c76ec c0000001de71b500 c00000000096c048 0000000000000034 
GPR04: 0000000000000001 c000000000063918 0000000000000000 0000000000000002 
GPR08: 0000000000000003 0000000000000000 c000000000086f68 c0000001de7dca00 
GPR12: 000000000000256d c0000000074e4200 0000000000000000 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 00000000201b8f60 
GPR20: 00000000201b8f70 00000000201b8f48 0000000000000000 c0000000008766b8 
GPR24: c0000001de71b800 0000000000000001 c0000000008ad400 c000000001247478 
GPR28: c0000000e6abb8c0 c0000000e6abb8c0 c000000000904570 c000000001247470 
NIP [c0000000002c76f0] .__debug_object_init+0x314/0x40c
LR [c0000000002c76ec] .__debug_object_init+0x310/0x40c
Call Trace:
[c0000001de71b500] [c0000000002c76ec] .__debug_object_init+0x310/0x40c (unreliable)
[c0000001de71b5d0] [c00000000007d990] .rcuhead_fixup_activate+0x40/0xdc
[c0000001de71b660] [c0000000002c6a7c] .debug_object_fixup+0x4c/0x74
[c0000001de71b6f0] [c0000000000c5e54] .__call_rcu+0x3c/0x1d4
[c0000001de71b790] [c0000000000c6050] .synchronize_rcu+0x4c/0x6c
[c0000001de71b870] [c0000000004be218] .synchronize_net+0x10/0x24
[c0000001de71b8e0] [c0000000005498c8] .packet_release+0x1d4/0x274
[c0000001de71b990] [c0000000004ac1f0] .sock_release+0x54/0x124
[c0000001de71ba20] [c0000000004ac9e4] .sock_close+0x34/0x4c
[c0000001de71baa0] [c00000000012469c] .__fput+0x174/0x264
[c0000001de71bb40] [c000000000120c54] .filp_close+0xb0/0xd8
[c0000001de71bbd0] [c000000000065e70] .put_files_struct+0x1a8/0x314
[c0000001de71bc70] [c000000000067e04] .do_exit+0x234/0x6f0
[c0000001de71bd30] [c000000000068354] .do_group_exit+0x94/0xc8
[c0000001de71bdc0] [c00000000006839c] .SyS_exit_group+0x14/0x28
[c0000001de71be30] [c000000000008554] syscall_exit+0x0/0x40
Instruction dump:
7f80b000 419e0030 2fa00000 e93e8140 380b0001 90090000 419e000c e87e8148 
48000008 e87e8150 4bd9cb89 60000000 <0fe00000> 801c0010 2f800003 419e0024 

[Mathieu]

Here is the fix.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux.trees.git/kernel/rcutree_plugin.h
===================================================================
--- linux.trees.git.orig/kernel/rcutree_plugin.h	2010-04-21 21:15:45.000000000 -0400
+++ linux.trees.git/kernel/rcutree_plugin.h	2010-04-21 21:16:57.000000000 -0400
@@ -515,11 +515,13 @@ void synchronize_rcu(void)
 	if (!rcu_scheduler_active)
 		return;
 
+	init_rcu_head_on_stack(&rcu.head);
 	init_completion(&rcu.completion);
 	/* Will wake me after RCU finished. */
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	/* Wait for it. */
 	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
