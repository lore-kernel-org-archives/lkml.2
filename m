Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2E3EtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 00:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2E3EtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 00:49:14 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 5/5] pci: Misc pci_reg additions
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com
Date: Tue, 29 May 2012 22:49:00 -0600
Message-ID: <20120530044900.1164.50649.stgit@bling.home>
In-Reply-To: <20120530043142.1164.63415.stgit@bling.home>
References: <20120530043142.1164.63415.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill in many missing definitions and add sizeof fields for many
sections allowing for more extensive config parsing.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/pci_regs.h |  113 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 101 insertions(+), 12 deletions(-)

diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 4b608f5..526d2c4 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -26,6 +26,7 @@
  * Under PCI, each device has 256 bytes of configuration address space,
  * of which the first 64 bytes are standardized as follows:
  */
+#define PCI_STD_HEADER_SIZEOF	64
 #define PCI_VENDOR_ID		0x00	/* 16 bits */
 #define PCI_DEVICE_ID		0x02	/* 16 bits */
 #define PCI_COMMAND		0x04	/* 16 bits */
@@ -209,9 +210,12 @@
 #define  PCI_CAP_ID_SHPC 	0x0C	/* PCI Standard Hot-Plug Controller */
 #define  PCI_CAP_ID_SSVID	0x0D	/* Bridge subsystem vendor/device ID */
 #define  PCI_CAP_ID_AGP3	0x0E	/* AGP Target PCI-PCI bridge */
+#define  PCI_CAP_ID_SECDEV	0x0F	/* Secure Device */
 #define  PCI_CAP_ID_EXP 	0x10	/* PCI Express */
 #define  PCI_CAP_ID_MSIX	0x11	/* MSI-X */
+#define  PCI_CAP_ID_SATA	0x12	/* SATA Data/Index Conf. */
 #define  PCI_CAP_ID_AF		0x13	/* PCI Advanced Features */
+#define  PCI_CAP_ID_MAX		PCI_CAP_ID_AF
 #define PCI_CAP_LIST_NEXT	1	/* Next capability in the list */
 #define PCI_CAP_FLAGS		2	/* Capability defined flags (16 bits) */
 #define PCI_CAP_SIZEOF		4
@@ -276,6 +280,7 @@
 #define  PCI_VPD_ADDR_MASK	0x7fff	/* Address mask */
 #define  PCI_VPD_ADDR_F		0x8000	/* Write 0, 1 indicates completion */
 #define PCI_VPD_DATA		4	/* 32-bits of data returned here */
+#define PCI_CAP_VPD_SIZEOF	8
 
 /* Slot Identification */
 
@@ -297,8 +302,10 @@
 #define PCI_MSI_ADDRESS_HI	8	/* Upper 32 bits (if PCI_MSI_FLAGS_64BIT set) */
 #define PCI_MSI_DATA_32		8	/* 16 bits of data for 32-bit devices */
 #define PCI_MSI_MASK_32		12	/* Mask bits register for 32-bit devices */
+#define PCI_MSI_PENDING_32	16	/* Pending intrs for 32-bit devices */
 #define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
 #define PCI_MSI_MASK_64		16	/* Mask bits register for 64-bit devices */
+#define PCI_MSI_PENDING_64	20	/* Pending intrs for 64-bit devices */
 
 /* MSI-X registers */
 #define PCI_MSIX_FLAGS		2
@@ -308,6 +315,7 @@
 #define PCI_MSIX_TABLE		4
 #define PCI_MSIX_PBA		8
 #define  PCI_MSIX_FLAGS_BIRMASK	(7 << 0)
+#define PCI_CAP_MSIX_SIZEOF	12	/* size of MSIX registers */
 
 /* MSI-X entry's format */
 #define PCI_MSIX_ENTRY_SIZE		16
@@ -338,6 +346,7 @@
 #define  PCI_AF_CTRL_FLR	0x01
 #define PCI_AF_STATUS		5
 #define  PCI_AF_STATUS_TP	0x01
+#define PCI_CAP_AF_SIZEOF	6	/* size of AF registers */
 
 /* PCI-X registers */
 
@@ -374,6 +383,10 @@
 #define  PCI_X_STATUS_SPL_ERR	0x20000000	/* Rcvd Split Completion Error Msg */
 #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
 #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
+#define PCI_X_ECC_CSR		8	/* ECC control and status */
+#define PCI_CAP_PCIX_SIZEOF_V0	8	/* size of registers for Version 0 */
+#define PCI_CAP_PCIX_SIZEOF_V1	24	/* size for Version 1 */
+#define PCI_CAP_PCIX_SIZEOF_V2	PCI_CAP_PCIX_SIZEOF_V1	/* Same for v2 */
 
 /* PCI Bridge Subsystem ID registers */
 
@@ -462,6 +475,7 @@
 #define  PCI_EXP_LNKSTA_DLLLA	0x2000	/* Data Link Layer Link Active */
 #define  PCI_EXP_LNKSTA_LBMS	0x4000	/* Link Bandwidth Management Status */
 #define  PCI_EXP_LNKSTA_LABS	0x8000	/* Link Autonomous Bandwidth Status */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V1	20	/* v1 endpoints end here */
 #define PCI_EXP_SLTCAP		20	/* Slot Capabilities */
 #define  PCI_EXP_SLTCAP_ABP	0x00000001 /* Attention Button Present */
 #define  PCI_EXP_SLTCAP_PCP	0x00000002 /* Power Controller Present */
@@ -521,6 +535,7 @@
 #define  PCI_EXP_OBFF_MSGA_EN	0x2000	/* OBFF enable with Message type A */
 #define  PCI_EXP_OBFF_MSGB_EN	0x4000	/* OBFF enable with Message type B */
 #define  PCI_EXP_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints end here */
 #define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
 #define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
 
@@ -529,23 +544,43 @@
 #define PCI_EXT_CAP_VER(header)		((header >> 16) & 0xf)
 #define PCI_EXT_CAP_NEXT(header)	((header >> 20) & 0xffc)
 
-#define PCI_EXT_CAP_ID_ERR	1
-#define PCI_EXT_CAP_ID_VC	2
-#define PCI_EXT_CAP_ID_DSN	3
-#define PCI_EXT_CAP_ID_PWR	4
-#define PCI_EXT_CAP_ID_VNDR	11
-#define PCI_EXT_CAP_ID_ACS	13
-#define PCI_EXT_CAP_ID_ARI	14
-#define PCI_EXT_CAP_ID_ATS	15
-#define PCI_EXT_CAP_ID_SRIOV	16
-#define PCI_EXT_CAP_ID_PRI	19
-#define PCI_EXT_CAP_ID_LTR	24
-#define PCI_EXT_CAP_ID_PASID	27
+#define PCI_EXT_CAP_ID_ERR	0x01	/* Advanced Error Reporting */
+#define PCI_EXT_CAP_ID_VC	0x02	/* Virtual Channel Capability */
+#define PCI_EXT_CAP_ID_DSN	0x03	/* Device Serial Number */
+#define PCI_EXT_CAP_ID_PWR	0x04	/* Power Budgeting */
+#define PCI_EXT_CAP_ID_RCLD	0x05	/* Root Complex Link Declaration */
+#define PCI_EXT_CAP_ID_RCILC	0x06	/* Root Complex Internal Link Control */
+#define PCI_EXT_CAP_ID_RCEC	0x07	/* Root Complex Event Collector */
+#define PCI_EXT_CAP_ID_MFVC	0x08	/* Multi-Function VC Capability */
+#define PCI_EXT_CAP_ID_VC9	0x09	/* same as _VC */
+#define PCI_EXT_CAP_ID_RCRB	0x0A	/* Root Complex RB? */
+#define PCI_EXT_CAP_ID_VNDR	0x0B	/* Vendor Specific */
+#define PCI_EXT_CAP_ID_CAC	0x0C	/* Config Access - obsolete */
+#define PCI_EXT_CAP_ID_ACS	0x0D	/* Access Control Services */
+#define PCI_EXT_CAP_ID_ARI	0x0E	/* Alternate Routing ID */
+#define PCI_EXT_CAP_ID_ATS	0x0F	/* Address Translation Services */
+#define PCI_EXT_CAP_ID_SRIOV	0x10	/* Single Root I/O Virtualization */
+#define PCI_EXT_CAP_ID_MRIOV	0x11	/* Multi Root I/O Virtualization */
+#define PCI_EXT_CAP_ID_MCAST	0x12	/* Multicast */
+#define PCI_EXT_CAP_ID_PRI	0x13	/* Page Request Interface */
+#define PCI_EXT_CAP_ID_AMD_XXX	0x14	/* reserved for AMD */
+#define PCI_EXT_CAP_ID_REBAR	0x15	/* resizable BAR */
+#define PCI_EXT_CAP_ID_DPA	0x16	/* dynamic power alloc */
+#define PCI_EXT_CAP_ID_TPH	0x17	/* TPH request */
+#define PCI_EXT_CAP_ID_LTR	0x18	/* latency tolerance reporting */
+#define PCI_EXT_CAP_ID_SECPCI	0x19	/* Secondary PCIe */
+#define PCI_EXT_CAP_ID_PMUX	0x1A	/* Protocol Multiplexing */
+#define PCI_EXT_CAP_ID_PASID	0x1B	/* Process Address Space ID */
+#define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_PASID
+
+#define PCI_EXT_CAP_DSN_SIZEOF	12
+#define PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF 40
 
 /* Advanced Error Reporting */
 #define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
 #define  PCI_ERR_UNC_TRAIN	0x00000001	/* Training */
 #define  PCI_ERR_UNC_DLP	0x00000010	/* Data Link Protocol */
+#define  PCI_ERR_UNC_SURPDN	0x00000020	/* Surprise Down */
 #define  PCI_ERR_UNC_POISON_TLP	0x00001000	/* Poisoned TLP */
 #define  PCI_ERR_UNC_FCP	0x00002000	/* Flow Control Protocol */
 #define  PCI_ERR_UNC_COMP_TIME	0x00004000	/* Completion Timeout */
@@ -555,6 +590,11 @@
 #define  PCI_ERR_UNC_MALF_TLP	0x00040000	/* Malformed TLP */
 #define  PCI_ERR_UNC_ECRC	0x00080000	/* ECRC Error Status */
 #define  PCI_ERR_UNC_UNSUP	0x00100000	/* Unsupported Request */
+#define  PCI_ERR_UNC_ACSV	0x00200000	/* ACS Violation */
+#define  PCI_ERR_UNC_INTN	0x00400000	/* internal error */
+#define  PCI_ERR_UNC_MCBTLP	0x00800000	/* MC blocked TLP */
+#define  PCI_ERR_UNC_ATOMEG	0x01000000	/* Atomic egress blocked */
+#define  PCI_ERR_UNC_TLPPRE	0x02000000	/* TLP prefix blocked */
 #define PCI_ERR_UNCOR_MASK	8	/* Uncorrectable Error Mask */
 	/* Same bits as above */
 #define PCI_ERR_UNCOR_SEVER	12	/* Uncorrectable Error Severity */
@@ -565,6 +605,9 @@
 #define  PCI_ERR_COR_BAD_DLLP	0x00000080	/* Bad DLLP Status */
 #define  PCI_ERR_COR_REP_ROLL	0x00000100	/* REPLAY_NUM Rollover */
 #define  PCI_ERR_COR_REP_TIMER	0x00001000	/* Replay Timer Timeout */
+#define  PCI_ERR_COR_ADV_NFAT	0x00002000	/* Advisory Non-Fatal */
+#define  PCI_ERR_COR_INTERNAL	0x00004000	/* Corrected Internal */
+#define  PCI_ERR_COR_LOG_OVER	0x00008000	/* Header Log Overflow */
 #define PCI_ERR_COR_MASK	20	/* Correctable Error Mask */
 	/* Same bits as above */
 #define PCI_ERR_CAP		24	/* Advanced Error Capabilities */
@@ -596,12 +639,18 @@
 
 /* Virtual Channel */
 #define PCI_VC_PORT_REG1	4
+#define  PCI_VC_REG1_EVCC	0x7	/* extended vc count */
 #define PCI_VC_PORT_REG2	8
+#define  PCI_VC_REG2_32_PHASE	0x2
+#define  PCI_VC_REG2_64_PHASE	0x4
+#define  PCI_VC_REG2_128_PHASE	0x8
 #define PCI_VC_PORT_CTRL	12
 #define PCI_VC_PORT_STATUS	14
 #define PCI_VC_RES_CAP		16
 #define PCI_VC_RES_CTRL		20
 #define PCI_VC_RES_STATUS	26
+#define PCI_CAP_VC_BASE_SIZEOF		0x10
+#define PCI_CAP_VC_PER_VC_SIZEOF	0x0C
 
 /* Power Budgeting */
 #define PCI_PWR_DSR		4	/* Data Select Register */
@@ -614,6 +663,7 @@
 #define  PCI_PWR_DATA_RAIL(x)	(((x) >> 18) & 7)   /* Power Rail */
 #define PCI_PWR_CAP		12	/* Capability */
 #define  PCI_PWR_CAP_BUDGET(x)	((x) & 1)	/* Included in system budget */
+#define PCI_EXT_CAP_PWR_SIZEOF	16
 
 /*
  * Hypertransport sub capability types
@@ -646,6 +696,8 @@
 #define HT_CAPTYPE_ERROR_RETRY	0xC0	/* Retry on error configuration */
 #define HT_CAPTYPE_GEN3		0xD0	/* Generation 3 hypertransport configuration */
 #define HT_CAPTYPE_PM		0xE0	/* Hypertransport powermanagement configuration */
+#define HT_CAP_SIZEOF_LONG	28	/* slave & primary */
+#define HT_CAP_SIZEOF_SHORT	24	/* host & secondary */
 
 /* Alternative Routing-ID Interpretation */
 #define PCI_ARI_CAP		0x04	/* ARI Capability Register */
@@ -656,6 +708,7 @@
 #define  PCI_ARI_CTRL_MFVC	0x0001	/* MFVC Function Groups Enable */
 #define  PCI_ARI_CTRL_ACS	0x0002	/* ACS Function Groups Enable */
 #define  PCI_ARI_CTRL_FG(x)	(((x) >> 4) & 7) /* Function Group */
+#define PCI_EXT_CAP_ARI_SIZEOF	8
 
 /* Address Translation Service */
 #define PCI_ATS_CAP		0x04	/* ATS Capability Register */
@@ -665,6 +718,7 @@
 #define  PCI_ATS_CTRL_ENABLE	0x8000	/* ATS Enable */
 #define  PCI_ATS_CTRL_STU(x)	((x) & 0x1f)	/* Smallest Translation Unit */
 #define  PCI_ATS_MIN_STU	12	/* shift of minimum STU block */
+#define PCI_EXT_CAP_ATS_SIZEOF	8
 
 /* Page Request Interface */
 #define PCI_PRI_CTRL		0x04	/* PRI control register */
@@ -676,6 +730,7 @@
 #define  PCI_PRI_STATUS_STOPPED	0x100	/* PRI Stopped */
 #define PCI_PRI_MAX_REQ		0x08	/* PRI max reqs supported */
 #define PCI_PRI_ALLOC_REQ	0x0c	/* PRI max reqs allowed */
+#define PCI_EXT_CAP_PRI_SIZEOF	16
 
 /* PASID capability */
 #define PCI_PASID_CAP		0x04    /* PASID feature register */
@@ -685,6 +740,7 @@
 #define  PCI_PASID_CTRL_ENABLE	0x01	/* Enable bit */
 #define  PCI_PASID_CTRL_EXEC	0x02	/* Exec permissions Enable */
 #define  PCI_PASID_CTRL_PRIV	0x04	/* Priviledge Mode Enable */
+#define PCI_EXT_CAP_PASID_SIZEOF	8
 
 /* Single Root I/O Virtualization */
 #define PCI_SRIOV_CAP		0x04	/* SR-IOV Capabilities */
@@ -716,12 +772,14 @@
 #define  PCI_SRIOV_VFM_MI	0x1	/* Dormant.MigrateIn */
 #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
 #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
+#define PCI_EXT_CAP_SRIOV_SIZEOF 64
 
 #define PCI_LTR_MAX_SNOOP_LAT	0x4
 #define PCI_LTR_MAX_NOSNOOP_LAT	0x6
 #define  PCI_LTR_VALUE_MASK	0x000003ff
 #define  PCI_LTR_SCALE_MASK	0x00001c00
 #define  PCI_LTR_SCALE_SHIFT	10
+#define PCI_EXT_CAP_LTR_SIZEOF	8
 
 /* Access Control Service */
 #define PCI_ACS_CAP		0x04	/* ACS Capability Register */
@@ -732,7 +790,38 @@
 #define  PCI_ACS_UF		0x10	/* Upstream Forwarding */
 #define  PCI_ACS_EC		0x20	/* P2P Egress Control */
 #define  PCI_ACS_DT		0x40	/* Direct Translated P2P */
+#define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
+#define PCI_VSEC_HDR		4	/* extended cap - vendor specific */
+#define  PCI_VSEC_HDR_LEN_SHIFT	20	/* shift for length field */
+
+/* sata capability */
+#define PCI_SATA_REGS		4	/* SATA REGs specifier */
+#define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
+#define  PCI_SATA_REGS_INLINE	0xF	/* REGS in config space */
+#define PCI_SATA_SIZEOF_SHORT	8
+#define PCI_SATA_SIZEOF_LONG	16
+
+/* resizable BARs */
+#define PCI_REBAR_CTRL		8	/* control register */
+#define  PCI_REBAR_CTRL_NBAR_MASK	(7 << 5)	/* mask for # bars */
+#define  PCI_REBAR_CTRL_NBAR_SHIFT	5	/* shift for # bars */
+
+/* dynamic power allocation */
+#define PCI_DPA_CAP		4	/* capability register */
+#define  PCI_DPA_CAP_SUBSTATE_MASK	0x1F	/* # substates - 1 */
+#define PCI_DPA_BASE_SIZEOF	16	/* size with 0 substates */
+
+/* TPH Requester */
+#define PCI_TPH_CAP		4	/* capability register */
+#define  PCI_TPH_CAP_LOC_MASK	0x600	/* location mask */
+#define   PCI_TPH_LOC_NONE	0x000	/* no location */
+#define   PCI_TPH_LOC_CAP	0x200	/* in capability */
+#define   PCI_TPH_LOC_MSIX	0x400	/* in MSI-X */
+#define PCI_TPH_CAP_ST_MASK	0x07FF0000	/* st table mask */
+#define PCI_TPH_CAP_ST_SHIFT	16	/* st table shift */
+#define PCI_TPH_BASE_SIZEOF	12	/* size with no st table */
+
 #endif /* LINUX_PCI_REGS_H */

