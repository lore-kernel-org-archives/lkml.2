Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1KRBlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 20:41:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab1KRBlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 20:41:12 -0500
From: Thomas Renninger <trenn@suse.de>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 4/9] ACPI, APEI, Resolve false conflict between ACPI NVS and APEI
Date: Fri, 18 Nov 2011 02:41:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com> <1320719974-3598-5-git-send-email-ying.huang@intel.com>
In-Reply-To: <1320719974-3598-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201111180241.09150.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 08 November 2011 03:39:29 Huang Ying wrote:
> Some firmware will access memory in ACPI NVS region via APEI.  That
> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
> region.  The original resource conflict checking in APEI code will
> check memory/ioport accessed by APEI via general resource management
> mech.  But ACPI NVS region is marked as busy already, so that the
> false resource conflict will prevent APEI ERST/EINJ to work.
> 
> To fix this, this patch excludes ACPI NVS regions when APEI components
> request resources.  So that they will not conflict with ACPI NVS
> regions.

find below an approach which still allows requesting the resources,
similar to Yinghai's patch.
But instead of allowing everybody to access NVS memory, it needs to
be explicitly requested.

Compile tested only.

Also this is a bit hacky, as it reserves the last free bits in the
the generic resource flags for X86 only.

I fear doing it properly needs quite some more efforts.

   Thomas

---
 arch/x86/kernel/e820.c        |   30 ++++++++++++++++++++++--------
 drivers/acpi/apei/apei-base.c |    4 ++--
 include/linux/ioport.h        |    5 +++++
 kernel/resource.c             |    5 ++++-
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 303a0e4..4b1b15f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -958,15 +958,29 @@ void __init e820_reserve_resources(void)
 
 		res->flags = IORESOURCE_MEM;
 
-		/*
-		 * don't register the region that could be conflicted with
-		 * pci device BAR resource and insert them later in
-		 * pcibios_resource_survey()
-		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		switch (e820.map[i].type) {
+		case E820_RESERVED:
+			/*
+			 * don't register the region that could be conflicted
+			 * with pci device BAR resource and insert them later in
+			 * pcibios_resource_survey()
+			 */
+			if (res->start < (1ULL<<20))
+				res->flags |= IORESOURCE_BUSY;
+			res->flags |= IORESOURCE_RESERVED_RAM;
+			break;
+		case E820_ACPI:
+			res->flags |= IORESOURCE_ACPI_RAM;
 			res->flags |= IORESOURCE_BUSY;
-			insert_resource(&iomem_resource, res);
-		}
+			break;
+		case E820_NVS:
+			res->flags |= IORESOURCE_NVS_RAM;
+			res->flags |= IORESOURCE_BUSY;
+			break;
+		default:
+			res->flags |= IORESOURCE_BUSY;
+		}			
+		insert_resource(&iomem_resource, res);
 		res++;
 	}
 
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 6154036..a86aa24 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -456,8 +456,8 @@ int apei_resources_request(struct apei_resources *resources,
 
 	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
-		r = request_mem_region(res->start, res->end - res->start,
-				       desc);
+		r = __request_mem_region(res->start, res->end - res->start,
+					 desc, IORESOURCE_NVS_RAM);
 		if (!r) {
 			pr_err(APEI_PFX
 		"Can not request iomem region <%016llx-%016llx> for GARs.\n",
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 9d57a71..2c1b3db 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -54,6 +54,11 @@ struct resource_list {
 #define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
 #define IORESOURCE_MUXED	0x00400000	/* Resource is software muxed */
 
+/* X86 specific e820 marked memory resources */
+#define IORESOURCE_NVS_RAM      0x01000000
+#define IORESOURCE_ACPI_RAM     0x02000000
+#define IORESOURCE_RESERVED_RAM 0x04000000
+
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
 #define IORESOURCE_UNSET	0x20000000
diff --git a/kernel/resource.c b/kernel/resource.c
index 7640b3a..4397543 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -861,7 +861,10 @@ struct resource * __request_region(struct resource *parent,
 			break;
 		if (conflict != parent) {
 			parent = conflict;
-			if (!(conflict->flags & IORESOURCE_BUSY))
+			if (!(conflict->flags & IORESOURCE_BUSY) ||
+			    /* Even the region is busy, it was explicitly
+			       requested -> allow access */
+			    flags & conflict->flags)
 				continue;
 		}
 		if (conflict->flags & flags & IORESOURCE_MUXED) {
