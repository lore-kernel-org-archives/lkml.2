Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1CBXQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:16:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53437 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab1CBXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:16:07 -0500
Message-ID: <4D6ECF72.5010308@kernel.org>
Date: Wed, 02 Mar 2011 15:14:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH for.38] x86, numa: Fix numa_emulation code with node0 without
 RAM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D6ECF85.00DC,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On one system that does not have RAM on node0.

when numa_emulation is compiled in, and
1. boot system without numa=fake...
2. or boot system with numa=fake=128 to make emulation fail

will get:

[    0.076025] ------------[ cut here ]------------
[    0.080004] kernel BUG at arch/x86/mm/numa_64.c:788!
[    0.080004] invalid opcode: 0000 [#1] SMP 
[    0.080004] last sysfs file: 
[    0.080004] CPU 0 
[    0.080004] Modules linked in:
[    0.080004] 
[    0.080004] Pid: 0, comm: swapper Not tainted 2.6.38-rc6-yh-00212-g3e1f235 #1 Sun Microsystems     Sun Fire X4240/Sun Fire X4240
[    0.080004] RIP: 0010:[<ffffffff81cd1d8c>]  [<ffffffff81cd1d8c>] numa_add_cpu+0x8a/0x156
...
[    0.080004] Call Trace:
[    0.080004]  [<ffffffff81ccd1cd>] identify_cpu+0x2d7/0x2df
[    0.080004]  [<ffffffff827e13e9>] identify_boot_cpu+0x10/0x30
[    0.080004]  [<ffffffff827e15f3>] check_bugs+0x9/0x2d
[    0.080004]  [<ffffffff827d9bcb>] start_kernel+0x3bf/0x3d9
[    0.080004]  [<ffffffff827d92a6>] x86_64_start_reservations+0xb6/0xba
[    0.080004]  [<ffffffff827d93a1>] x86_64_start_kernel+0xf7/0xfe
[    0.080004] Code: 74 06 48 8d 04 90 eb 0f 48 c7 c0 10 d9 00 00 48 03 04 d5 50 e1 5f 82 8b 00 83 f8 ff 74 0d 0f a3 05 7a f9 92 00 19 d2 85 d2 75 02 <0f> 0b 48 98 31 db 48 8b 04 c5 d0 ec 5f 82 48 8b 90 90 af 00 00 

need to used early_cpu_to_node directly, because cpu_to_apicid and apicid_to_node
 will return node0 that is not onlined.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa_64.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -780,11 +780,7 @@ void __cpuinit numa_add_cpu(int cpu)
 	int physnid;
 	int nid = NUMA_NO_NODE;
 
-	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
-	if (apicid != BAD_APICID)
-		nid = apicid_to_node[apicid];
-	if (nid == NUMA_NO_NODE)
-		nid = early_cpu_to_node(cpu);
+	nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
 
 	/*
