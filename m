Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0LFX2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:28:02 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27005 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0LFXZP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC PATCH] Utilize the PCI API in the AGP framework.
Date: Mon,  6 Dec 2010 18:24:12 -0500
Message-Id: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is a set of RFC patches that make it possible for AGP graphic drivers to
work under Xen. The major problem that Linux kernel has when running under Xen
is that the usage of "virt_to_phys(x) >> PAGE_SIZE" to get the DMA address is not
applicable. That is due to the fact that the PFN value is not the real Machine
Frame Number (MFN), hence virt_to_phys(x) >> PAGE_SIZE ends up pointing to a
random physical address. But if you use the PCI API, then the DMA (bus) address
returned is a valid MFN.

This macro (virt_to_phys) is used throughout the AGP backends when either constructing
the GART or when stitching pages in the GART tables and programming the GATT.

One way to fix this is to provide a lookup (similar to how the internal Xen MMU
does it) in the AGP backends to take the PFN (or phys) and find the "real" MFN,
such as this skanky code:

- 		addr_t phys = page_to_phys(mem->pages[i]);
+		if (xen_pv_domain()) {
+			phys_addr_t xen_phys = PFN_PHYS(pfn_to_mfn(
+					page_to_pfn(mem->pages[i])));
+			if (phys != xen_phys) {
+				printk(KERN_ERR "Fixing up GART: (0x%lx->0x%lx)." \
+					" CODE UNTESTED!\n",
+					(unsigned long)phys,
+					(unsigned long)xen_phys);
+				WARN_ON_ONCE(phys != xen_phys);
+				phys = xen_phys;
+			}
+		}
 		tmp = agp_bridge->driver->mask_memory(agp_bridge,
-						      page_to_phys(mem->pages[i]),
+						      phys,
 						      mask_type);

Truly horrible. The other way that I"ve pursued is to pass the responsibility
of providing the DMA address to the callers of the AGP API and using the PCI API
to get the real DMA address. In the past the big user of AGPI API used to be the
XServer, but now that is taken over by the TTM and the DRM API so everything is
nicely contained within the kernel.

This set of patches attached does three major things for the X86 platform:

 1). If graphic driver uses the agp_generic_create_gatt_table to set up the GART
     make the allocation for the GART use the pci_alloc_consistent so that the
     bus address can be programmed to the GATT instead of using virt_to_phys macro.

 2). When using agp_alloc_page(s), a new argument would be added which would have
     an array of dma_addr_t to be populated. Some of the callers of this
     function use the AGP_USER_TYPES type so the the responsibility
     of populating the dma_addr_t falls to the callers (TTM for example).
 
 3). When using the agp_bind_memory, the AGP PCI would use the dma_addr_t that would
     have been populated by the agp_alloc_page(s) (or provided by the caller), to
     program the GATT instead of using the page_to_phys(x) macro.

Basically extending the AGP API to pass the dma_addr around.

There are two extra set of patch series that demonstrate how the TTM and DRM layers
would have to be modified to utilize this. 

Regressions tests have show no failures. I tested it on an ASUS P5PE (AGP), Dell
Optiplex 780 (Q45), Dell T105 (AMD, with Radeon 3450), BIOSTAR-MCP6P-M2 (Nvidia 6150).
But I haven't done any extensive testing on the older platforms yet as I was thinking
to get your guys idea before spending more resources on this.

This patch-set is also availble at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/agp.pci-api

The users of these changes are available in two other branches: devel/drm.pci-api and
devel/ttm.pci-api, which I will post soon too.

 arch/alpha/include/asm/agp.h        |   20 +++++++++--
 arch/ia64/include/asm/agp.h         |   32 +++++++++++++++--
 arch/ia64/include/asm/dma-mapping.h |    2 +
 arch/ia64/include/asm/sn/io.h       |   16 ++++----
 arch/parisc/include/asm/agp.h       |   21 +++++++++--
 arch/powerpc/include/asm/agp.h      |   21 +++++++++--
 arch/sparc/include/asm/agp.h        |   20 +++++++++--
 arch/x86/include/asm/agp.h          |   32 +++++++++++++++--
 drivers/char/agp/agp.h              |    9 +++--
 drivers/char/agp/ali-agp.c          |   20 ++++++-----
 drivers/char/agp/amd-k7-agp.c       |   20 +++++++---
 drivers/char/agp/amd64-agp.c        |    4 +-
 drivers/char/agp/ati-agp.c          |   18 ++++++---
 drivers/char/agp/backend.c          |   17 ++++++---
 drivers/char/agp/generic.c          |   66 ++++++++++++++++++++++-------------
 drivers/char/agp/hp-agp.c           |    3 +-
 drivers/char/agp/i460-agp.c         |    7 ++--
 drivers/char/agp/intel-gtt.c        |   63 ++++++++++++++++++++++++---------
 drivers/char/agp/nvidia-agp.c       |    2 +-
 drivers/char/agp/sgi-agp.c          |   21 +----------
 drivers/char/agp/sworks-agp.c       |   18 ++++++---
 include/linux/agp_backend.h         |    4 ++-
 22 files changed, 303 insertions(+), 133 deletions(-)

