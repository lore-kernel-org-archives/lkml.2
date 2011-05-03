Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1ECUBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:01:13 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38850 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1ECUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:01:11 -0400
Subject: [PATCH 11/16] cciss: use new doorbell-bit-5 reset method
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:46 -0500
Message-ID: <20110503195346.5154.2503.stgit@beardog.cce.hp.com>
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

The bit-2-doorbell reset method seemed to cause (survivable) NMIs
on some systems and (unsurvivable) IOCK NMIs on some G7 servers.
Firmware guys implemented a new doorbell method to alleviate these
problems triggered by bit 5 of the doorbell register.  We want to
use it if it's available.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |   25 ++++++++++++++-----------
 drivers/block/cciss_cmd.h |    2 ++
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b9f8658..df58c59 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4384,7 +4384,7 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 #define cciss_noop(p) cciss_message(p, 3, 0)
 
 static int cciss_controller_hard_reset(struct pci_dev *pdev,
-	void * __iomem vaddr, bool use_doorbell)
+	void * __iomem vaddr, u32 use_doorbell)
 {
 	u16 pmcsr;
 	int pos;
@@ -4395,7 +4395,7 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		 * other way using the doorbell register.
 		 */
 		dev_info(&pdev->dev, "using doorbell to reset controller\n");
-		writel(DOORBELL_CTLR_RESET, vaddr + SA5_DOORBELL);
+		writel(use_doorbell, vaddr + SA5_DOORBELL);
 		msleep(1000);
 	} else { /* Try to do it the PCI power state way */
 
@@ -4499,7 +4499,7 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	u32 misc_fw_support;
 	int rc;
 	CfgTable_struct __iomem *cfgtable;
-	bool use_doorbell;
+	u32 use_doorbell;
 	u32 board_id;
 	u16 command_register;
 
@@ -4560,15 +4560,18 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	if (rc)
 		goto unmap_vaddr;
 
-	/* If reset via doorbell register is supported, use that. */
-	misc_fw_support = readl(&cfgtable->misc_fw_support);
-	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
-
-	/* The doorbell reset seems to cause lockups on some Smart
-	 * Arrays (e.g. P410, P410i, maybe others).  Until this is
-	 * fixed or at least isolated, avoid the doorbell reset.
+	/* If reset via doorbell register is supported, use that.
+	 * There are two such methods.  Favor the newest method.
 	 */
-	use_doorbell = 0;
+	misc_fw_support = readl(&cfgtable->misc_fw_support);
+	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET2;
+	if (use_doorbell) {
+		use_doorbell = DOORBELL_CTLR_RESET2;
+	} else {
+		use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
+		if (use_doorbell)
+			use_doorbell = DOORBELL_CTLR_RESET;
+	}
 
 	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 3b20c31..d9be6b4 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -53,6 +53,7 @@
 #define CFGTBL_ChangeReq        0x00000001l
 #define CFGTBL_AccCmds          0x00000001l
 #define DOORBELL_CTLR_RESET     0x00000004l
+#define DOORBELL_CTLR_RESET2    0x00000020l
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
@@ -243,6 +244,7 @@ typedef struct _CfgTable_struct {
   u8		   reserved[0x78 - 0x58];
   u32		   misc_fw_support; /* offset 0x78 */
 #define MISC_FW_DOORBELL_RESET (0x02)
+#define MISC_FW_DOORBELL_RESET2 (0x10)
 	u8	   driver_version[32];
 } CfgTable_struct;
 

