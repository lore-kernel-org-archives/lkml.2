Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967243Ab0GSX7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:59:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64463 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967202Ab0GSX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:59:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/49] x86, numa: fix boot without RAM on node0 again
Date: Mon, 19 Jul 2010 16:56:10 -0700
Message-Id: <1279583818-14249-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C44E6A7.0244,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

|commit e534c7c5f8d6e9fc46f57fab067c7e48d8ceb172
|Author: Lee Schermerhorn <lee.schermerhorn@hp.com>
|Date:   Wed May 26 14:44:58 2010 -0700
|
|    numa: x86_64: use generic percpu var numa_node_id() implementation
|
|    x86 arch specific changes to use generic numa_node_id() based on generic
|    percpu variable infrastructure.  Back out x86's custom version of
|    numa_node_id()

broke numa system that doesn't have ram on node0 when MEMORY_HOTPLUG is enabled.

because cpu_up() will call cpu_to_node() before per_cpu(numa_node) is setup for
APs.

When Node0 doesn't have RAM, on x86, cpus already round it to nearest node with
RAM in x86_cpu_to_node_map. and per_cpu(numa_node) is not set up until in c_init for APs.

when later cpu_up() calling cpu_to_node() will get 0 again, and make it online
even there is no RAM on node0. so later all APs can not booted up, and later
will have panic.

[    1.611101] On node 0 totalpages: 0
.........
[    2.608558] On node 0 totalpages: 0
[    2.612065] Brought up 1 CPUs
[    2.615199] Total of 1 processors activated (3990.31 BogoMIPS).
...
   93.225341] calling  loop_init+0x0/0x1a4 @ 1
[   93.229314] PERCPU: allocation failed, size=80 align=8, failed to populate
[   93.246539] Pid: 1, comm: swapper Tainted: G        W   2.6.35-rc4-tip-yh-04371-gd64e6c4-dirty #354
[   93.264621] Call Trace:
[   93.266533]  [<ffffffff81125e43>] pcpu_alloc+0x83a/0x8e7
[   93.270710]  [<ffffffff81125f15>] __alloc_percpu+0x10/0x12
[   93.285849]  [<ffffffff8140786c>] alloc_disk_node+0x94/0x16d
[   93.291811]  [<ffffffff81407956>] alloc_disk+0x11/0x13
[   93.306157]  [<ffffffff81503e51>] loop_alloc+0xa7/0x180
[   93.310538]  [<ffffffff8277ef48>] loop_init+0x9b/0x1a4
[   93.324909]  [<ffffffff8277eead>] ? loop_init+0x0/0x1a4
[   93.329650]  [<ffffffff810001f2>] do_one_initcall+0x57/0x136
[   93.345197]  [<ffffffff827486d0>] kernel_init+0x184/0x20e
[   93.348146]  [<ffffffff81034954>] kernel_thread_helper+0x4/0x10
[   93.365194]  [<ffffffff81c7cc3c>] ? restore_args+0x0/0x30
[   93.369305]  [<ffffffff8274854c>] ? kernel_init+0x0/0x20e
[   93.386011]  [<ffffffff81034950>] ? kernel_thread_helper+0x0/0x10
[   93.392047] loop: out of memory
...

Try to assign per_cpu(numa_node) early

Signed-off-by: Yinghai <yinghai@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index de3b63a..b03959c 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -238,6 +238,15 @@ void __init setup_per_cpu_areas(void)
 #ifdef CONFIG_NUMA
 		per_cpu(x86_cpu_to_node_map, cpu) =
 			early_per_cpu_map(x86_cpu_to_node_map, cpu);
+		/*
+		 * make sure boot cpu numa_node is right, when boot cpu is on
+		 *  the node that doesn't have mem installed
+		 * also cpu_up() will call cpu_to_node() for APs when
+		 *  MEMORY_HOTPLUG is defined, before per_cpu(numa_node) is set
+		 *  up later with c_init aka intel_init/amd_init
+		 * So set them all (boot cpu and all APs)
+		 */
+		set_cpu_numa_node(cpu, early_cpu_to_node(cpu));
 #endif
 #endif
 		/*
@@ -257,14 +266,6 @@ void __init setup_per_cpu_areas(void)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
-	/*
-	 * make sure boot cpu numa_node is right, when boot cpu is on the
-	 * node that doesn't have mem installed
-	 */
-	set_cpu_numa_node(boot_cpu_id, early_cpu_to_node(boot_cpu_id));
-#endif
-
 	/* Setup node to cpumask map */
 	setup_node_to_cpumask_map();
 
-- 
1.6.4.2

