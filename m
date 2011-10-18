Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1JRIXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:23:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1JRIXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:23:09 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>
Cc: Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 2/3] Add multi-node boot support
Date: Tue, 18 Oct 2011 16:22:35 +0800
Message-Id: <1318926156-25504-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix booting multi-node systems with Numascale's NumaChip.

v2:
 - [Daniel] rediffed and validated against 3.1-rc10

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/kernel/cpu/amd.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b13ed39..4b551f5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -7,6 +7,7 @@
 #include <asm/apic.h>
 #include <asm/cpu.h>
 #include <asm/pci-direct.h>
+#include <asm/numachip/numachip.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -350,6 +351,12 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	node = numa_cpu_node(cpu);
 	if (node == NUMA_NO_NODE)
 		node = per_cpu(cpu_llc_id, cpu);
+	else if (is_numachip_system()) {
+		/* fix for multi-node systems: set phys_proc_id and cpu_llc_id
+		   to node number from ACPI SRAT table */
+		c->phys_proc_id = node;
+		per_cpu(cpu_llc_id, cpu) = node;
+	}
 
 	if (!node_online(node)) {
 		/*
-- 
1.7.5.4

