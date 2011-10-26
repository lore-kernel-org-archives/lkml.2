Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1JZGH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:07:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32889 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1JZGH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:07:56 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 2/3] Add multi-node boot support
Date: Wed, 26 Oct 2011 14:07:09 +0800
Message-Id: <1319609230-18897-2-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Persvold <sp@numascale.com>

From: Steffen Persvold <sp@numascale.com>

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

