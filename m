Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1LNQE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:04:57 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:60420 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab1LNQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:04:46 -0500
X-AuditID: c1b4fb39-b7b3eae00000252a-78-4ee8c91adca7
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
To: <lucas.demarchi@profusion.mobi>, <borislav.petkov@amd.com>,
        <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>
Subject: [PATCH 3/4] edac: i5100 add fault injection code
Date: Wed, 14 Dec 2011 17:04:29 +0100
Message-ID: <1323878670-26079-4-git-send-email-niklas.soderlund@ericsson.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
References: <1323878670-26079-1-git-send-email-niklas.soderlund@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fault injection based on information datasheet for i5100, see 1. In
addition to the i5100 datasheet some missing information on injection
functions where found through experimentation and the i7300 datasheet,
see 2.

[1] Intel 5100 Memory Controller Hub Chipset
    Doc.Nr: 318378
    http://www.intel.com/content/dam/doc/datasheet/5100-
    memory-controller-hub-chipset-datasheet.pdf

[2] Intel 7300 Chipset MemoryController Hub (MCH)
    Doc.Nr: 318082
    http://www.intel.com/assets/pdf/datasheet/318082.pdf

Signed-off-by: Niklas Söderlund <niklas.soderlund@ericsson.com>
---
 drivers/edac/i5100_edac.c |  110 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 3840674..54392e2 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -63,6 +63,14 @@
 			I5100_FERR_NF_MEM_M1ERR_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
 #define I5100_EMASK_MEM		0xa8	/* MC Error Mask Register */
+#define I5100_MEM0EINJMSK0	0x200	/* Injection Mask0 Register Channel 0 */
+#define I5100_MEM1EINJMSK0	0x208	/* Injection Mask0 Register Channel 1 */
+#define		I5100_MEMXEINJMSK0_EINJEN	(1 << 27)
+#define I5100_MEM0EINJMSK1	0x204	/* Injection Mask1 Register Channel 0 */
+#define I5100_MEM1EINJMSK1	0x206	/* Injection Mask1 Register Channel 1 */
+
+/* Device 19, Function 0 */
+#define I5100_DINJ0 0x9a
 
 /* device 21 and 22, func 0 */
 #define I5100_MTR_0	0x154	/* Memory Technology Registers 0-3 */
@@ -889,6 +897,100 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 	}
 }
 
+/****************************************************************************
+ *                       Error injection routines
+ ****************************************************************************
+ *
+ * The i5100 has independent error injection features per channel.
+ * However, to have a simpler code, we don't allow enabling error injection
+ * on more than one channel.
+ * Also, since a change at an inject parameter will be applied only at enable,
+ * we're disabling error injection on all write calls to the sysfs nodes that
+ * controls
+ */
+
+static int i5100_inject_write(struct mem_ctl_info *mci, u32 mask0, u16 mask1,
+		u8 dinj)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+
+	/* MEM[1:0]EINJMSK0
+	 * 31    - ADDRMATCHEN
+	 * 29:28 - HLINESEL
+	 *         00 Reserved
+	 *         01 Lower half of cache line
+	 *         10 Upper half of cache line
+	 *         11 Both upper and lower parts of cache line
+	 * 27    - EINJEN
+	 * 25:19 - XORMASK1 for deviceptr1
+	 * 9:5   - SEC2RAM or deviceptr2
+	 * 4:0   - FIR2RAM or deviceptr1
+	 */
+
+	/* MEM[1:0]EINJMSK1
+	 * 15:0  - XORMASK2 for deviceptr2
+	 */
+
+	/* Only write to the specified channel. */
+	if (priv->inject_channel == 0) {
+		pci_write_config_dword(priv->mc, I5100_MEM0EINJMSK0, mask0);
+		pci_write_config_word(priv->mc, I5100_MEM0EINJMSK1, mask1);
+	} else {
+		pci_write_config_dword(priv->mc, I5100_MEM1EINJMSK0, mask0);
+		pci_write_config_word(priv->mc, I5100_MEM1EINJMSK1, mask1);
+	}
+
+	/* Error Injection Response Function
+	 * Intel 5100 Memory Controller Hub Chipset (318378) datasheet
+	 * hints about this register but carry no data about them. All
+	 * data regarding device 19 is based on experimentation and the
+	 * Intel 7300 Chipset Memory Controller Hub (318082) datasheet
+	 * which appears to be accurate for the i5100 in this area.
+	 *
+	 * The injection code don't work without settig this register.
+	 *
+	 * Stop condition bits 7:4
+	 * 1010 - Stop after one injection
+	 * 1011 - Never stop injecting faults
+	 *
+	 * Start condition bits 3:0
+	 * 1010 - Never start
+	 * 1011 - Start immediately
+	 */
+	pci_write_config_byte(priv->mc_einj, I5100_DINJ0, dinj);
+
+	return 0;
+}
+
+
+static int i5100_inject_disable(struct mem_ctl_info *mci)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+
+	priv->inject_enable = 0;
+
+	return i5100_inject_write(mci, 0, 0, 0xaa);
+}
+
+static int i5100_inject_enable(struct mem_ctl_info *mci)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+	u32 mask0;
+	u16 mask1;
+
+	priv->inject_enable = 1;
+
+	mask0 = ((priv->inject_hlinesel & 0x3) << 28) |
+		I5100_MEMXEINJMSK0_EINJEN |
+		((priv->inject_eccmask1 & 0xffff) << 10) |
+		((priv->inject_deviceptr2 & 0x1f) << 5) |
+		(priv->inject_deviceptr1 & 0x1f);
+
+	mask1 = priv->inject_eccmask2;
+
+	return i5100_inject_write(mci, mask0, mask1, 0xab);
+}
+
 #define DECLARE_INJECT_PARAM(param, limit_low, limit_high)		\
 static ssize_t i5100_inject_store_##param(				\
 		struct mem_ctl_info *mci,				\
@@ -899,6 +1001,9 @@ static ssize_t i5100_inject_store_##param(				\
 	unsigned long value;						\
 	int rc;								\
 									\
+	if (priv->inject_enable)					\
+		i5100_inject_disable(mci);				\
+									\
 	rc = kstrtoul(data, 10, &value);				\
 	if (rc < 0 || value < limit_low || value > limit_high)		\
 		return -EIO;						\
@@ -941,6 +1046,11 @@ static ssize_t i5100_inject_store_inject_enable(struct mem_ctl_info *mci,
 	if (kstrtoul(data, 10, &value) < 0)
 		return -EIO;
 
+	if (value)
+		i5100_inject_enable(mci);
+	else
+		i5100_inject_disable(mci);
+
 	return count;
 }
 
-- 
1.7.7.3

