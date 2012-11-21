Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2KUSXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:23:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2KUSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:23:12 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] x86, smpboot: allow manual hotplug of CPUs
Date: Wed, 21 Nov 2012 13:22:16 -0500
Message-Id: <1353522136-14944-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far CPU hotplug was ignored for mptable implementations which support it by
having the hotpluggable CPUs marked as disabled during boot.

The current kernel code detects that behaviour and actually deals with it
properly:

	[    0.000000] Intel MultiProcessor Specification v1.4
	[    0.000000] MPTABLE: OEM ID: KVMCPU00
	[    0.000000] MPTABLE: Product ID: 0.1
	[    0.000000] MPTABLE: APIC at: 0xFEE00000
	[    0.000000] Processor #0 (Bootup-CPU)
	[    0.000000] Processor #1
	[    0.000000] Processor #2
	[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
	[    0.000000] Processors: 3
	[    0.000000] smpboot: Allowing 3 CPUs, 1 hotplug CPUs

The problem begins when a user might actually want to online such CPU; there
is no interface for him to tell the kernel that the CPU is now present and
can be used.

Luckily, the kernel provides a generic interface in the form of 'probe' and
'release' sysfs files which are used on different architectures exactly for
that - to probe and release CPUs. On x86 however this was unimplemented
until now.

This patch adds code into the x86 implementation of probe and release to allow
adding and removing CPUs. This allows machines that use mptable to hotplug
CPUs:

	sh-4.2# cd /sys/devices/system/cpu/
	sh-4.2# cat possible present online
	0-3
	0-2
	0-2
	sh-4.2# echo "3 0x14" > probe
	sh-4.2# cat possible present online
	0-3
	0-3
	0-2
	sh-4.2# echo 1 > cpu3/online
	[   29.854133] smpboot: Booting Node 0 Processor 3 APIC 0x3
	[    0.001000] kvm-clock: cpu 3, msr 0:1bd929c1, secondary cpu clock
	[   29.872438] KVM setup async PF for cpu 3
	[   29.872790] kvm-stealtime: cpu 3, msr 1bd8d100
	[   29.873276] microcode: CPU3 sig=0x206a7, pf=0x1, revision=0x1
	sh-4.2# cat possible present online
	0-3
	0-3
	0-3
	sh-4.2# echo 0 > cpu3/online
	[  116.146352] Unregister pv shared memory for cpu 3
	[  116.160000] Cannot set affinity for irq 0
	[  116.163068] smpboot: CPU 3 is now offline
	sh-4.2# cat possible present online
	0-3
	0-3
	0-2
	sh-4.2# echo 3 > release
	sh-4.2# cat possible present online
	0-3
	0-2
	0-2

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/kernel/smpboot.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 732bf5c..78b3197 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -97,8 +97,43 @@ void cpu_hotplug_driver_unlock(void)
 	mutex_unlock(&x86_cpu_hotplug_driver_mutex);
 }
 
-ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
-ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
+ssize_t arch_cpu_probe(const char *buf, size_t count)
+{
+	int cpu, version, r;
+
+	r = sscanf(buf, "%d %x", &cpu, &version);
+	if (r != 2)
+		return -EINVAL;
+
+	if (!cpu_possible(cpu) || cpu_present(cpu))
+		return -EINVAL;
+
+	arch_register_cpu(cpu);
+	generic_processor_info(cpu, version);
+
+	return count;
+}
+
+ssize_t arch_cpu_release(const char *buf, size_t count)
+{
+	int cpu, r;
+
+	r = kstrtoint(buf, 10, &cpu);
+	if (r < 0)
+		return r;
+
+	if (!cpu_present(cpu))
+		return -EINVAL;
+
+	if (cpu_online(cpu))
+		return -EBUSY;
+
+	arch_unregister_cpu(cpu);
+	set_cpu_present(cpu, false);
+
+	return count;
+}
+
 #endif
 
 /* Number of siblings per CPU package */
-- 
1.8.0

