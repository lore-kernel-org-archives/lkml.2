Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab2GBLuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:50:14 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60930 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2GBLuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:50:11 -0400
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH] [powerpc] Export memory limit via device tree
To: benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com
Date: Mon, 02 Jul 2012 17:19:00 +0530
Message-ID: <20120702114855.22333.95335.stgit@suzukikp.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12070211-5816-0000-0000-00000367927C
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

This patch exports the memory limit, if present, via chosen/linux,memory-limit
property, so that the vmcore can be limited to the memory limit.

The prom_init seems to export this value in the same node. But doesn't really
appear there.  Also the memory_limit gets adjusted with the processing of
crashkernel= parameter. This patch makes sure we get the actual limit.

The kexec-tools will use the value to limit the 'end' of the memory
regions.

Tested this patch on ppc64 and ppc32(ppc440) with a kexec-tools
patch by Mahesh.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Tested-by: Mahesh J. Salgaonkar <mahesh@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/machine_kexec.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index c957b12..0c9695d 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -207,6 +207,12 @@ static struct property crashk_size_prop = {
 	.value = &crashk_size,
 };
 
+static struct property memory_limit_prop = {
+	.name = "linux,memory-limit",
+	.length = sizeof(phys_addr_t),
+	.value = &memory_limit,
+};
+
 static void __init export_crashk_values(struct device_node *node)
 {
 	struct property *prop;
@@ -226,6 +232,15 @@ static void __init export_crashk_values(struct device_node *node)
 		crashk_size = resource_size(&crashk_res);
 		prom_add_property(node, &crashk_size_prop);
 	}
+
+	/* memory-limit is needed for constructing the crash regions */
+	prop = of_find_property(node, memory_limit_prop.name, NULL);
+	if (prop)
+		prom_remove_property(node, prop);
+
+	if (memory_limit)
+		prom_add_property(node, &memory_limit_prop);
+
 }
 
 static int __init kexec_setup(void)

