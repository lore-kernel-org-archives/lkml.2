Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1CBXTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:19:02 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55856 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab1CBXS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:18:59 -0500
Message-ID: <4D6ED045.3090309@kernel.org>
Date: Wed, 02 Mar 2011 15:18:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH for .39] x86, numa: Fix numa_emulation code with node0 without
 RAM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D6ED04D.0030,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On one system that does not have RAM on node0.

when numa_emulation is compiled in, and
1. boot system without numa=fake...
2. or boot system with numa=fake=128 to make emulation fail

will get:

[    0.092026] ------------[ cut here ]------------
[    0.096005] kernel BUG at arch/x86/mm/numa_emulation.c:439!
[    0.096005] invalid opcode: 0000 [#1] SMP 
[    0.096005] last sysfs file: 
[    0.096005] CPU 0 
[    0.096005] Modules linked in:
[    0.096005] 
[    0.096005] Pid: 0, comm: swapper Not tainted 2.6.38-rc6-tip-yh-03869-gcb0491d-dirty #684 Sun Microsystems     Sun Fire X4240/Sun Fire X4240
[    0.096005] RIP: 0010:[<ffffffff81cdc65b>]  [<ffffffff81cdc65b>] numa_add_cpu+0x56/0xcf
[    0.096005] RSP: 0000:ffffffff82437ed8  EFLAGS: 00010246
...
[    0.096005] Call Trace:
[    0.096005]  [<ffffffff81cd7931>] identify_cpu+0x2d7/0x2df
[    0.096005]  [<ffffffff827e54fa>] identify_boot_cpu+0x10/0x30
[    0.096005]  [<ffffffff827e5704>] check_bugs+0x9/0x2d
[    0.096005]  [<ffffffff827dceda>] start_kernel+0x3d7/0x3f1
[    0.096005]  [<ffffffff827dc2cc>] x86_64_start_reservations+0x9c/0xa0
[    0.096005]  [<ffffffff827dc4ad>] x86_64_start_kernel+0x1dd/0x1e8
[    0.096005] Code: 74 06 48 8d 04 90 eb 0f 48 c7 c0 30 d9 00 00 48 03 04 d5 90 0f 60 82 8b 00 83 f8 ff 74 0d 0f a3 05 8b 7e 92 00 19 d2 85 d2 75 02 <0f> 0b 48 98 be 00 01 00 00 48 c7 c7 e0 44 60 82 44 8b 2c 85 e0 
[    0.096005] RIP  [<ffffffff81cdc65b>] numa_add_cpu+0x56/0xcf
[    0.096005]  RSP <ffffffff82437ed8>
[    0.096026] ---[ end trace a7919e7f17c0a725 ]---

need to used early_cpu_to_node directly, because numa_cpu_node() will return node0 that is not onlined.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index aeecea9..75b31dc 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -417,9 +417,7 @@ void __cpuinit numa_add_cpu(int cpu)
 {
 	int physnid, nid;
 
-	nid = numa_cpu_node(cpu);
-	if (nid == NUMA_NO_NODE)
-		nid = early_cpu_to_node(cpu);
+	nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
 
 	physnid = emu_nid_to_phys[nid];
