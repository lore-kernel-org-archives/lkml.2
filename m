Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1ECTxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:04 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27513 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1ECTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:01 -0400
Subject: [PATCH 02/16] cciss: do a better job of detecting controller reset
	failure
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:00 -0500
Message-ID: <20110503195300.5154.73166.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Detect failure of controller reset by noticing if the 32 bytes of
"driver version" we store on the hardware in the config table
fail to get zeroed out.  Previously we noticed if the controller
did not transition to "simple mode", but this did not detect reset
failure if the controller was already in simple mode prior to
the reset attempt (e.g. due to module parameter hpsa_simple_mode=1).

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |   82 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/block/cciss_cmd.h |    1 +
 2 files changed, 73 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9bf1398..ed6aa83 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -194,6 +194,8 @@ static int __devinit cciss_find_cfg_addrs(struct pci_dev *pdev,
 static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar);
 static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag);
+static __devinit int write_driver_ver_to_cfgtable(
+	CfgTable_struct __iomem *cfgtable);
 
 /* performant mode helper functions */
 static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
@@ -4078,6 +4080,9 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
+	rc = write_driver_ver_to_cfgtable(h->cfgtable);
+	if (rc)
+		return rc;
 	/* Find performant mode table. */
 	trans_offset = readl(&h->cfgtable->TransMethodOffset);
 	h->transtable = remap_pci_mem(pci_resource_start(h->pdev,
@@ -4428,6 +4433,60 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 	return 0;
 }
 
+static __devinit void init_driver_version(char *driver_version, int len)
+{
+	memset(driver_version, 0, len);
+	strncpy(driver_version, "cciss " DRIVER_NAME, len - 1);
+}
+
+static __devinit int write_driver_ver_to_cfgtable(
+	CfgTable_struct __iomem *cfgtable)
+{
+	char *driver_version;
+	int i, size = sizeof(cfgtable->driver_version);
+
+	driver_version = kmalloc(size, GFP_KERNEL);
+	if (!driver_version)
+		return -ENOMEM;
+
+	init_driver_version(driver_version, size);
+	for (i = 0; i < size; i++)
+		writeb(driver_version[i], &cfgtable->driver_version[i]);
+	kfree(driver_version);
+	return 0;
+}
+
+static __devinit void read_driver_ver_from_cfgtable(
+	CfgTable_struct __iomem *cfgtable, unsigned char *driver_ver)
+{
+	int i;
+
+	for (i = 0; i < sizeof(cfgtable->driver_version); i++)
+		driver_ver[i] = readb(&cfgtable->driver_version[i]);
+}
+
+static __devinit int controller_reset_failed(
+	CfgTable_struct __iomem *cfgtable)
+{
+
+	char *driver_ver, *old_driver_ver;
+	int rc, size = sizeof(cfgtable->driver_version);
+
+	old_driver_ver = kmalloc(2 * size, GFP_KERNEL);
+	if (!old_driver_ver)
+		return -ENOMEM;
+	driver_ver = old_driver_ver + size;
+
+	/* After a reset, the 32 bytes of "driver version" in the cfgtable
+	 * should have been changed, otherwise we know the reset failed.
+	 */
+	init_driver_version(old_driver_ver, size);
+	read_driver_ver_from_cfgtable(cfgtable, driver_ver);
+	rc = !memcmp(driver_ver, old_driver_ver, size);
+	kfree(old_driver_ver);
+	return rc;
+}
+
 /* This does a hard reset of the controller using PCI power management
  * states or using the doorbell register. */
 static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
@@ -4437,7 +4496,7 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	u64 cfg_base_addr_index;
 	void __iomem *vaddr;
 	unsigned long paddr;
-	u32 misc_fw_support, active_transport;
+	u32 misc_fw_support;
 	int rc;
 	CfgTable_struct __iomem *cfgtable;
 	bool use_doorbell;
@@ -4497,6 +4556,9 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 		rc = -ENOMEM;
 		goto unmap_vaddr;
 	}
+	rc = write_driver_ver_to_cfgtable(cfgtable);
+	if (rc)
+		goto unmap_vaddr;
 
 	/* If reset via doorbell register is supported, use that. */
 	misc_fw_support = readl(&cfgtable->misc_fw_support);
@@ -4535,21 +4597,21 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 			"failed waiting for board to become ready\n");
 		goto unmap_cfgtable;
 	}
-	dev_info(&pdev->dev, "board ready.\n");
 
-	/* Controller should be in simple mode at this point.  If it's not,
-	 * It means we're on one of those controllers which doesn't support
-	 * the doorbell reset method and on which the PCI power management reset
-	 * method doesn't work (P800, for example.)
-	 * In those cases, don't try to proceed, as it generally doesn't work.
-	 */
-	active_transport = readl(&cfgtable->TransportActive);
-	if (active_transport & PERFORMANT_MODE) {
+	rc = controller_reset_failed(vaddr);
+	if (rc < 0)
+		goto unmap_cfgtable;
+	if (rc) {
 		dev_warn(&pdev->dev, "Unable to successfully reset controller,"
 			" Ignoring controller.\n");
 		rc = -ENODEV;
+		goto unmap_cfgtable;
+	} else {
+		dev_info(&pdev->dev, "board ready.\n");
 	}
 
+	dev_info(&pdev->dev, "board ready.\n");
+
 unmap_cfgtable:
 	iounmap(cfgtable);
 
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index cd441be..a2e68d2 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -235,6 +235,7 @@ typedef struct _CfgTable_struct {
   u8		   reserved[0x78 - 0x58];
   u32		   misc_fw_support; /* offset 0x78 */
 #define MISC_FW_DOORBELL_RESET (0x02)
+	u8	   driver_version[32];
 } CfgTable_struct;
 
 struct TransTable_struct {

