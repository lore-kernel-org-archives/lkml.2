Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2I1M0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:26:32 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:44660
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012Ab2I1MYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd799hd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-01-LKT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/16] iommu/amd: Keep track of HPET and IOAPIC device ids
Date: Fri, 28 Sep 2012 14:23:51 +0200
Message-ID: <1348835046-3262-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IVRS ACPI table provides information about the IOAPICs
and the HPETs available in the system and which PCI device
ID they use in transactions. Save that information for later
usage in interrupt remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |    3 ++
 drivers/iommu/amd_iommu_init.c  |   65 +++++++++++++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_types.h |   34 ++++++++++++++++++++
 3 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b64502d..6f51483 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -72,6 +72,9 @@ static DEFINE_SPINLOCK(iommu_pd_list_lock);
 static LIST_HEAD(dev_data_list);
 static DEFINE_SPINLOCK(dev_data_list_lock);
 
+LIST_HEAD(ioapic_map);
+LIST_HEAD(hpet_map);
+
 /*
  * Domain for untranslated devices - only allocated
  * if iommu=pt passed on kernel cmd line.
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18a89b7..a9f3948 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -55,6 +55,7 @@
 #define IVHD_DEV_ALIAS_RANGE            0x43
 #define IVHD_DEV_EXT_SELECT             0x46
 #define IVHD_DEV_EXT_SELECT_RANGE       0x47
+#define IVHD_DEV_SPECIAL		0x48
 
 #define IVHD_FLAG_HT_TUN_EN_MASK        0x01
 #define IVHD_FLAG_PASSPW_EN_MASK        0x02
@@ -690,6 +691,31 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
 	set_iommu_for_device(iommu, devid);
 }
 
+static int add_special_device(u8 type, u8 id, u16 devid)
+{
+	struct devid_map *entry;
+	struct list_head *list;
+
+	if (type != 1 && type != 2)
+		return -EINVAL;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->id    = id;
+	entry->devid = devid;
+
+	if (type == 1)
+		list = &ioapic_map;
+	else
+		list = &hpet_map;
+
+	list_add_tail(&entry->list, list);
+
+	return 0;
+}
+
 /*
  * Reads the device exclusion range from ACPI and initialize IOMMU with
  * it
@@ -717,7 +743,7 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
  * Takes a pointer to an AMD IOMMU entry in the ACPI table and
  * initializes the hardware and our data structures with it.
  */
-static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
+static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 					struct ivhd_header *h)
 {
 	u8 *p = (u8 *)h;
@@ -867,12 +893,43 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 							flags, ext_flags);
 			}
 			break;
+		case IVHD_DEV_SPECIAL: {
+			u8 handle, type;
+			const char *var;
+			u16 devid;
+			int ret;
+
+			handle = e->ext & 0xff;
+			devid  = (e->ext >>  8) & 0xffff;
+			type   = (e->ext >> 24) & 0xff;
+
+			if (type == 1)
+				var = "IOAPIC";
+			else if (type == 2)
+				var = "HPET";
+			else
+				var = "UNKNOWN";
+
+			DUMP_printk("  DEV_SPECIAL(%s[%d])\t\tdevid: %02x:%02x.%x\n",
+				    var, (int)handle,
+				    PCI_BUS(devid),
+				    PCI_SLOT(devid),
+				    PCI_FUNC(devid));
+
+			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
+			ret = add_special_device(type, handle, devid);
+			if (ret)
+				return ret;
+			break;
+		}
 		default:
 			break;
 		}
 
 		p += ivhd_entry_length(p);
 	}
+
+	return 0;
 }
 
 /* Initializes the device->iommu mapping for the driver */
@@ -912,6 +969,8 @@ static void __init free_iommu_all(void)
  */
 static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 {
+	int ret;
+
 	spin_lock_init(&iommu->lock);
 
 	/* Add IOMMU to internal data structures */
@@ -947,7 +1006,9 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
 
 	iommu->int_enabled = false;
 
-	init_iommu_from_acpi(iommu, h);
+	ret = init_iommu_from_acpi(iommu, h);
+	if (ret)
+		return ret;
 	init_iommu_devices(iommu);
 
 	return 0;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index d0dab86..4495b78 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -565,6 +565,16 @@ struct amd_iommu {
 	u32 stored_l2[0x83];
 };
 
+struct devid_map {
+	struct list_head list;
+	u8 id;
+	u16 devid;
+};
+
+/* Map HPET and IOAPIC ids to the devid used by the IOMMU */
+extern struct list_head ioapic_map;
+extern struct list_head hpet_map;
+
 /*
  * List with all IOMMUs in the system. This list is not locked because it is
  * only written and read at driver initialization or suspend time
@@ -678,6 +688,30 @@ static inline u16 calc_devid(u8 bus, u8 devfn)
 	return (((u16)bus) << 8) | devfn;
 }
 
+static inline int get_ioapic_devid(int id)
+{
+	struct devid_map *entry;
+
+	list_for_each_entry(entry, &ioapic_map, list) {
+		if (entry->id == id)
+			return entry->devid;
+	}
+
+	return -EINVAL;
+}
+
+static inline int get_hpet_devid(int id)
+{
+	struct devid_map *entry;
+
+	list_for_each_entry(entry, &hpet_map, list) {
+		if (entry->id == id)
+			return entry->devid;
+	}
+
+	return -EINVAL;
+}
+
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 struct __iommu_counter {
-- 
1.7.9.5


