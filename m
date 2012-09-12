Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2ILFdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:33:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39015 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2ILFdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:33:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50501E97.2020200@jp.fujitsu.com>
Date: Wed, 12 Sep 2012 14:33:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: hot-added cpu is not asiggned to the correct node
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I hot-added CPUs and memories simultaneously using container driver,
all the hot-added CPUs were mistakenly assigned to node0.

Accoding to my DSDT, hot-added CPUs and memorys have PXM#1. So in my system,
these devices should be assigned to node1 as follows:

--- Expected result
ls /sys/devices/system/node/node1/:
cpu16 cpu17 cpu18 cpu19 cpu20 cpu21 cpu22 cpu23 cpu24 cpu25 cpu26 cpu27
cpu28 cpu29 cpu30 cpu31 cpulist ... memory512 memory513 - 767 meminfo ...

=> hot-added CPUs and memorys are assigned to same node.
---

But in actuality, the CPUs were assigned to node0 and the memorys were assigned
to node1 as follows:

--- Actual result
ls /sys/devices/system/node/node0/:
cpu0 cpu1 cpu2 cpu3 cpu4 cpu5 cpu6 cpu7 cpu8 cpu9 cpu10 cpu11 cpu12 cpu13
cpu14 cpu15 cpu16 cpu17 cpu18 cpu19 cpu20 cpu21 cpu22 cpu23 cpu24 cpu25 cpu26
cpu27 cpu28 cpu29 cpu30 cpu31 cpulist ... memory1 memory2 - 255 meminfo ...

ls /sys/devices/system/node/node1/:
cpulist memory512 memory513 - 767 meminfo ...

=> hot-added CPUs are assinged to node0 and hot-added memorys are assigned to
   node1. CPUs and memorys has same PXM#. But assigned node is different.
---

In my investigation, "acpi_map_cpu2node()" causes the problem.

---
#arch/x86/kernel/acpi/boot.c"
static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
   int nid;

   nid = acpi_get_node(handle);
   if (nid == -1 || !node_online(nid))
           return;
   set_apicid_to_node(physid, nid);
   numa_set_node(cpu, nid);
 #endif
 }
---

In my DSDT, CPUs were written ahead of memories, so CPUs were hot-added
before memories. Thus the system has memory-less-node temporarily .
In this case, "node_online()" fails. So the CPU is assigned to node 0.

When I wrote memories ahead of CPUs in DSDT, the CPUs were assigned to the
correct node. In current Linux, the CPUs were assigned to the correct node
or not depends on the order of hot-added resources in DSDT.

ACPI specification doesn't define the order of hot-added resources. So I think
the kernel should properly handle any DSDT conformable to its specification.

I'm thinking a solution about the problem, but I don't have any good idea...
Does anyone has opinion how we should treat it?

