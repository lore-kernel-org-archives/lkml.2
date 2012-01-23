Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2AWX17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:27:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:40464 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2AWX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:27:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98946502"
From: "Luck, Tony" <tony.luck@intel.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Myron Stowe <mstowe@redhat.com>
Subject: [PATCH] Use acpi_os_map_memory() instead of ioremap() in einj driver
Date: Mon, 23 Jan 2012 15:27:56 -0800
Message-Id: <4f1decfc19324ca832@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap() has become more picky and is now spitting out console messages like:

 ioremap error for 0xbddbd000-0xbddbe000, requested 0x10, got 0x0

when loading the einj driver.  What we are trying to so here is map
a couple of data structures that the EINJ table points to. Perhaps
acpi_os_map_memory() is a better tool for this?
Most importantly it works, but as a side benefit it maps the structures
into kernel virtual space so we can access them with normal C memory
dereferences, so instead of using:
	writel(param1, &v5param->apicid);
we can use the more natural:
	v5param->apicid = param1;

Signed-off-by: Tony Luck <tony.luck@intel.com>

---
 drivers/acpi/apei/einj.c |   82 +++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

The unmap paths are ugly - suggestions for improvement welcome.

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index c89b0e5..dc3e63b 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -141,21 +141,6 @@ static DEFINE_MUTEX(einj_mutex);
 
 static void *einj_param;
 
-#ifndef readq
-static inline __u64 readq(volatile void __iomem *addr)
-{
-	return ((__u64)readl(addr+4) << 32) + readl(addr);
-}
-#endif
-
-#ifndef writeq
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-#endif
-
 static void einj_exec_ctx_init(struct apei_exec_context *ctx)
 {
 	apei_exec_ctx_init(ctx, einj_ins_type, ARRAY_SIZE(einj_ins_type),
@@ -204,22 +189,21 @@ static int einj_timedout(u64 *t)
 static void check_vendor_extension(u64 paddr,
 				   struct set_error_type_with_address *v5param)
 {
-	int	offset = readl(&v5param->vendor_extension);
+	int	offset = v5param->vendor_extension;
 	struct	vendor_error_type_extension *v;
 	u32	sbdf;
 
 	if (!offset)
 		return;
-	v = ioremap(paddr + offset, sizeof(*v));
+	v = acpi_os_map_memory(paddr + offset, sizeof(*v));
 	if (!v)
 		return;
-	sbdf = readl(&v->pcie_sbdf);
+	sbdf = v->pcie_sbdf;
 	sprintf(vendor_dev, "%x:%x:%x.%x vendor_id=%x device_id=%x rev_id=%x\n",
 		sbdf >> 24, (sbdf >> 16) & 0xff,
 		(sbdf >> 11) & 0x1f, (sbdf >> 8) & 0x7,
-		 readw(&v->vendor_id), readw(&v->device_id),
-		readb(&v->rev_id));
-	iounmap(v);
+		 v->vendor_id, v->device_id, v->rev_id);
+	acpi_os_unmap_memory(v, sizeof(*v));
 }
 
 static void *einj_get_parameter_address(void)
@@ -247,7 +231,7 @@ static void *einj_get_parameter_address(void)
 	if (paddrv5) {
 		struct set_error_type_with_address *v5param;
 
-		v5param = ioremap(paddrv5, sizeof(*v5param));
+		v5param = acpi_os_map_memory(paddrv5, sizeof(*v5param));
 		if (v5param) {
 			acpi5 = 1;
 			check_vendor_extension(paddrv5, v5param);
@@ -257,11 +241,11 @@ static void *einj_get_parameter_address(void)
 	if (paddrv4) {
 		struct einj_parameter *v4param;
 
-		v4param = ioremap(paddrv4, sizeof(*v4param));
+		v4param = acpi_os_map_memory(paddrv4, sizeof(*v4param));
 		if (!v4param)
 			return NULL;
-		if (readq(&v4param->reserved1) || readq(&v4param->reserved2)) {
-			iounmap(v4param);
+		if (v4param->reserved1 || v4param->reserved2) {
+			acpi_os_unmap_memory(v4param, sizeof(*v4param));
 			return NULL;
 		}
 		return v4param;
@@ -440,41 +424,41 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 	if (acpi5) {
 		struct set_error_type_with_address *v5param = einj_param;
 
-		writel(type, &v5param->type);
+		v5param->type = type;
 		if (type & 0x80000000) {
 			switch (vendor_flags) {
 			case SETWA_FLAGS_APICID:
-				writel(param1, &v5param->apicid);
+				v5param->apicid = param1;
 				break;
 			case SETWA_FLAGS_MEM:
-				writeq(param1, &v5param->memory_address);
-				writeq(param2, &v5param->memory_address_range);
+				v5param->memory_address = param1;
+				v5param->memory_address_range = param2;
 				break;
 			case SETWA_FLAGS_PCIE_SBDF:
-				writel(param1, &v5param->pcie_sbdf);
+				v5param->pcie_sbdf = param1;
 				break;
 			}
-			writel(vendor_flags, &v5param->flags);
+			v5param->flags = vendor_flags;
 		} else {
 			switch (type) {
 			case ACPI_EINJ_PROCESSOR_CORRECTABLE:
 			case ACPI_EINJ_PROCESSOR_UNCORRECTABLE:
 			case ACPI_EINJ_PROCESSOR_FATAL:
-				writel(param1, &v5param->apicid);
-				writel(SETWA_FLAGS_APICID, &v5param->flags);
+				v5param->apicid = param1;
+				v5param->flags = SETWA_FLAGS_APICID;
 				break;
 			case ACPI_EINJ_MEMORY_CORRECTABLE:
 			case ACPI_EINJ_MEMORY_UNCORRECTABLE:
 			case ACPI_EINJ_MEMORY_FATAL:
-				writeq(param1, &v5param->memory_address);
-				writeq(param2, &v5param->memory_address_range);
-				writel(SETWA_FLAGS_MEM, &v5param->flags);
+				v5param->memory_address = param1;
+				v5param->memory_address_range = param2;
+				v5param->flags = SETWA_FLAGS_MEM;
 				break;
 			case ACPI_EINJ_PCIX_CORRECTABLE:
 			case ACPI_EINJ_PCIX_UNCORRECTABLE:
 			case ACPI_EINJ_PCIX_FATAL:
-				writel(param1, &v5param->pcie_sbdf);
-				writel(SETWA_FLAGS_PCIE_SBDF, &v5param->flags);
+				v5param->pcie_sbdf = param1;
+				v5param->flags = SETWA_FLAGS_PCIE_SBDF;
 				break;
 			}
 		}
@@ -484,8 +468,8 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 			return rc;
 		if (einj_param) {
 			struct einj_parameter *v4param = einj_param;
-			writeq(param1, &v4param->param1);
-			writeq(param2, &v4param->param2);
+			v4param->param1 = param1;
+			v4param->param2 = param2;
 		}
 	}
 	rc = apei_exec_run(&ctx, ACPI_EINJ_EXECUTE_OPERATION);
@@ -736,8 +720,13 @@ static int __init einj_init(void)
 	return 0;
 
 err_unmap:
-	if (einj_param)
-		iounmap(einj_param);
+	if (einj_param) {
+		acpi_size size = (acpi5) ?
+			sizeof (struct set_error_type_with_address) :
+			sizeof (struct einj_parameter);
+
+		acpi_os_unmap_memory(einj_param, size);
+	}
 	apei_exec_post_unmap_gars(&ctx);
 err_release:
 	apei_resources_release(&einj_resources);
@@ -753,8 +742,13 @@ static void __exit einj_exit(void)
 {
 	struct apei_exec_context ctx;
 
-	if (einj_param)
-		iounmap(einj_param);
+	if (einj_param) {
+		acpi_size size = (acpi5) ?
+			sizeof (struct set_error_type_with_address) :
+			sizeof (struct einj_parameter);
+
+		acpi_os_unmap_memory(einj_param, size);
+	}
 	einj_exec_ctx_init(&ctx);
 	apei_exec_post_unmap_gars(&ctx);
 	apei_resources_release(&einj_resources);
