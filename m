Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2HULnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:43:18 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33552 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab2HULnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:43:14 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH v2 2/2] [powerpc] Export memory limit via device tree
To: linuxppc-dev@lists.ozlabs.org
Cc: mahesh@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2012 17:12:43 +0530
Message-ID: <20120821114240.29282.44213.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20120821113815.29282.4000.stgit@suzukikp.in.ibm.com>
References: <20120821113815.29282.4000.stgit@suzukikp.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12082111-2674-0000-0000-000005AD466B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc kernel doesn't export the memory limit enforced by 'mem='
kernel parameter. This is required for building the ELF header in
kexec-tools to limit the vmcore to capture only the used memory. On
powerpc the kexec-tools depends on the device-tree for memory related
information, unlike /proc/iomem on the x86.

Without this information, the kexec-tools assumes the entire System
RAM and vmcore creates an unnecessarily larger dump.

This patch exports the memory limit, if present, via
chosen/linux,memory-limit
property, so that the vmcore can be limited to the memory limit.

The prom_init seems to export this value in the same node. But doesn't
really
appear there.  Also the memory_limit gets adjusted with the processing of
crashkernel= parameter. This patch makes sure we get the actual limit.

The kexec-tools will use the value to limit the 'end' of the memory
regions.

Tested this patch on ppc64 and ppc32(ppc440) with a kexec-tools
patch by Mahesh.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Tested-by: Mahesh J. Salgaonkar <mahesh@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/machine_kexec.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index 4074eff..fa9f6c7 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -204,6 +204,12 @@ static struct property crashk_size_prop = {
 	.value = &crashk_size,
 };
 
+static struct property memory_limit_prop = {
+	.name = "linux,memory-limit",
+	.length = sizeof(unsigned long long),
+	.value = &memory_limit,
+};
+
 static void __init export_crashk_values(struct device_node *node)
 {
 	struct property *prop;
@@ -223,6 +229,12 @@ static void __init export_crashk_values(struct device_node *node)
 		crashk_size = resource_size(&crashk_res);
 		prom_add_property(node, &crashk_size_prop);
 	}
+
+	/*
+	 * memory_limit is required by the kexec-tools to limit the
+	 * crash regions to the actual memory used.
+	 */
+	prom_update_property(node, &memory_limit_prop);
 }
 
 static int __init kexec_setup(void)

