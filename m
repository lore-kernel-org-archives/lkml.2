Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab1I1WsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab1I1WsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:46 2011
Message-Id: <20110928220146.347778981@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Tomczak <marcin.tomczak@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [199/244] [SCSI] isci: change sas phy timeouts from 54us to 59us
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Tomczak <marcin.tomczak@intel.com>

commit 985af6f70dbb8a33b3af8a7c7df508d924650e37 upstream.

Need the following workaround in the driver for interoperability with
the older Intel SSD drives and any other SATA drive that may exhibit the
same behavior. This is a corner case where SCU speed is limited to
either 3G or 1.5G and the drive has a period of DC idle when it switches
speed during SATA speed negotiation. Workaround :change PHYTOV[31:24]
from 0x36 to 0x3B.

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/isci/phy.c       |   13 +++++++++++++
 drivers/scsi/isci/registers.h |   12 ++++++++++++
 2 files changed, 25 insertions(+)

--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -104,6 +104,7 @@ sci_phy_link_layer_initialization(struct
 	u32 parity_count = 0;
 	u32 llctl, link_rate;
 	u32 clksm_value = 0;
+	u32 sp_timeouts = 0;
 
 	iphy->link_layer_registers = reg;
 
@@ -211,6 +212,18 @@ sci_phy_link_layer_initialization(struct
 	llctl |= SCU_SAS_LLCTL_GEN_VAL(MAX_LINK_RATE, link_rate);
 	writel(llctl, &iphy->link_layer_registers->link_layer_control);
 
+	sp_timeouts = readl(&iphy->link_layer_registers->sas_phy_timeouts);
+
+	/* Clear the default 0x36 (54us) RATE_CHANGE timeout value. */
+	sp_timeouts &= ~SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0xFF);
+
+	/* Set RATE_CHANGE timeout value to 0x3B (59us).  This ensures SCU can
+	 * lock with 3Gb drive when SCU max rate is set to 1.5Gb.
+	 */
+	sp_timeouts |= SCU_SAS_PHYTOV_GEN_VAL(RATE_CHANGE, 0x3B);
+
+	writel(sp_timeouts, &iphy->link_layer_registers->sas_phy_timeouts);
+
 	if (is_a2(ihost->pdev)) {
 		/* Program the max ARB time for the PHY to 700us so we inter-operate with
 		 * the PMC expander which shuts down PHYs if the expander PHY generates too
--- a/drivers/scsi/isci/registers.h
+++ b/drivers/scsi/isci/registers.h
@@ -1299,6 +1299,18 @@ struct scu_transport_layer_registers {
 #define SCU_AFE_XCVRCR_OFFSET       0x00DC
 #define SCU_AFE_LUTCR_OFFSET        0x00E0
 
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_SHIFT          (0UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_ALIGN_DETECTION_MASK           (0x000000FFUL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_SHIFT                 (8UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_HOT_PLUG_MASK                  (0x0000FF00UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_SHIFT         (16UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_COMSAS_DETECTION_MASK          (0x00FF0000UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_SHIFT              (24UL)
+#define SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_RATE_CHANGE_MASK               (0xFF000000UL)
+
+#define SCU_SAS_PHYTOV_GEN_VAL(name, value) \
+	SCU_GEN_VALUE(SCU_SAS_PHY_TIMER_TIMEOUT_VALUES_##name, value)
+
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_SHIFT                  (0)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_MASK                   (0x00000003)
 #define SCU_SAS_LINK_LAYER_CONTROL_MAX_LINK_RATE_GEN1                   (0)


