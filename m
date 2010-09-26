Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0IZIu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:50:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44849 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0IZIuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:50:54 -0400
Date: Sun, 26 Sep 2010 10:50:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100926085046.GA1314@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/pci_ids.h            # 4c894f4: x86/amd-iommu: Work around S3 BIO

 Thanks,

	Ingo

------------------>
Joerg Roedel (3):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Work around S3 BIOS bug
      x86/amd-iommu: Fix rounding-bug in __unmap_single

Yinghai Lu (2):
      x86, setup: Fix earlyprintk=serial,ttyS0,115200
      x86, setup: Fix earlyprintk=serial,0x3f8,115200


 arch/x86/boot/early_serial_console.c   |   14 ++++++-
 arch/x86/include/asm/amd_iommu_proto.h |    6 +++
 arch/x86/include/asm/amd_iommu_types.h |   12 ++++++
 arch/x86/kernel/amd_iommu.c            |    4 +-
 arch/x86/kernel/amd_iommu_init.c       |   67 +++++++++++++++++++++----------
 include/linux/pci_ids.h                |    3 +
 6 files changed, 82 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/early_serial_console.c b/arch/x86/boot/early_serial_console.c
index 030f4b9..5df2869 100644
--- a/arch/x86/boot/early_serial_console.c
+++ b/arch/x86/boot/early_serial_console.c
@@ -58,7 +58,19 @@ static void parse_earlyprintk(void)
 		if (arg[pos] == ',')
 			pos++;
 
-		if (!strncmp(arg, "ttyS", 4)) {
+		/*
+		 * make sure we have
+		 *	"serial,0x3f8,115200"
+		 *	"serial,ttyS0,115200"
+		 *	"ttyS0,115200"
+		 */
+		if (pos == 7 && !strncmp(arg + pos, "0x", 2)) {
+			port = simple_strtoull(arg + pos, &e, 16);
+			if (port == 0 || arg + pos == e)
+				port = DEFAULT_SERIAL_PORT;
+			else
+				pos = e - arg;
+		} else if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index d2544f1..cb03037 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -38,4 +38,10 @@ static inline void amd_iommu_stats_init(void) { }
 
 #endif /* !CONFIG_AMD_IOMMU_STATS */
 
+static inline bool is_rd890_iommu(struct pci_dev *pdev)
+{
+	return (pdev->vendor == PCI_VENDOR_ID_ATI) &&
+	       (pdev->device == PCI_DEVICE_ID_RD890_IOMMU);
+}
+
 #endif /* _ASM_X86_AMD_IOMMU_PROTO_H  */
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 7014e88..0861618 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -368,6 +368,9 @@ struct amd_iommu {
 	/* capabilities of that IOMMU read from ACPI */
 	u32 cap;
 
+	/* flags read from acpi table */
+	u8 acpi_flags;
+
 	/*
 	 * Capability pointer. There could be more than one IOMMU per PCI
 	 * device function if there are more than one AMD IOMMU capability
@@ -411,6 +414,15 @@ struct amd_iommu {
 
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
+
+	/*
+	 * This array is required to work around a potential BIOS bug.
+	 * The BIOS may miss to restore parts of the PCI configuration
+	 * space when the system resumes from S3. The result is that the
+	 * IOMMU does not execute commands anymore which leads to system
+	 * failure.
+	 */
+	u32 cache_cfg[4];
 };
 
 /*
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa044e1..679b645 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1953,6 +1953,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 			   size_t size,
 			   int dir)
 {
+	dma_addr_t flush_addr;
 	dma_addr_t i, start;
 	unsigned int pages;
 
@@ -1960,6 +1961,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
+	flush_addr = dma_addr;
 	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
@@ -1974,7 +1976,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3cc63e2..5a170cb 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -632,6 +632,13 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 	iommu->last_device = calc_devid(MMIO_GET_BUS(range),
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
+
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_read_config_dword(iommu->dev, 0xf0, &iommu->cache_cfg[0]);
+		pci_read_config_dword(iommu->dev, 0xf4, &iommu->cache_cfg[1]);
+		pci_read_config_dword(iommu->dev, 0xf8, &iommu->cache_cfg[2]);
+		pci_read_config_dword(iommu->dev, 0xfc, &iommu->cache_cfg[3]);
+	}
 }
 
 /*
@@ -649,29 +656,9 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	struct ivhd_entry *e;
 
 	/*
-	 * First set the recommended feature enable bits from ACPI
-	 * into the IOMMU control registers
+	 * First save the recommended feature enable bits from ACPI
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
-		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
-
-	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
-
-	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
-		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
-
-	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
-		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
-		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
-
-	/*
-	 * make IOMMU memory accesses cache coherent
-	 */
-	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+	iommu->acpi_flags = h->flags;
 
 	/*
 	 * Done. Now parse the device entries
@@ -1116,6 +1103,40 @@ static void init_device_table(void)
 	}
 }
 
+static void iommu_init_flags(struct amd_iommu *iommu)
+{
+	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
+		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_PASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
+		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
+
+	iommu->acpi_flags & IVHD_FLAG_ISOC_EN_MASK ?
+		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
+		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
+
+	/*
+	 * make IOMMU memory accesses cache coherent
+	 */
+	iommu_feature_enable(iommu, CONTROL_COHERENT_EN);
+}
+
+static void iommu_apply_quirks(struct amd_iommu *iommu)
+{
+	if (is_rd890_iommu(iommu->dev)) {
+		pci_write_config_dword(iommu->dev, 0xf0, iommu->cache_cfg[0]);
+		pci_write_config_dword(iommu->dev, 0xf4, iommu->cache_cfg[1]);
+		pci_write_config_dword(iommu->dev, 0xf8, iommu->cache_cfg[2]);
+		pci_write_config_dword(iommu->dev, 0xfc, iommu->cache_cfg[3]);
+	}
+}
+
 /*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
@@ -1126,6 +1147,8 @@ static void enable_iommus(void)
 
 	for_each_iommu(iommu) {
 		iommu_disable(iommu);
+		iommu_apply_quirks(iommu);
+		iommu_init_flags(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 10d3330..570fdde 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -393,6 +393,9 @@
 #define PCI_DEVICE_ID_VLSI_82C147	0x0105
 #define PCI_DEVICE_ID_VLSI_VAS96011	0x0702
 
+/* AMD RD890 Chipset */
+#define PCI_DEVICE_ID_RD890_IOMMU	0x5a23
+
 #define PCI_VENDOR_ID_ADL		0x1005
 #define PCI_DEVICE_ID_ADL_2301		0x2301
 
