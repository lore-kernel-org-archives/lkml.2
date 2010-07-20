Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab0GTSH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:07:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:11105 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0GTSHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,233,1278313200"; 
   d="scan'208";a="302287028"
Subject: [patch] intr-remap: allow disabling source id checking
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org, "Barnes, Jesse" <jesse.barnes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Chris Wright <chrisw@redhat.com>, "Han, Weidong" <weidong.han@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 11:06:49 -0700
Message-Id: <1279649209.2899.2.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@redhat.com>
Subject: intr-remap: allow disabling source id checking

Allow disabling the source id checking while programming the interrupt
remap table entry. Useful for debugging or working around the broken
source id checks on some platforms.

Signed-off-by: Chris Wright <chrisw@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Weidong Han <weidong.han@intel.com>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/pci/intr_remapping.c        |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6a84a19..8c3522e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1028,6 +1028,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			result in a hardware IOTLB flush operation as opposed
 			to batching them for performance.
 
+	intremap=	[X86-64, Intel-IOMMU]
+			Format: { on (default) | off | nosid }
+			on	enable Interrupt Remapping (default)
+			off	disable Interrupt Remapping
+			nosid	disable Source ID checking
+
 	inttest=	[IA64]
 
 	iomem=		Disable strict checking of access to MMIO memory
@@ -1755,6 +1761,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
 			remapping.
+			[Deprecated - use intremap=off]
 
 	nointroute	[IA-64]
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 1315ac6..45478ef 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -21,6 +21,8 @@ static int ir_ioapic_num, ir_hpet_num;
 int intr_remapping_enabled;
 
 static int disable_intremap;
+static int disable_sourceid_checking;
+
 static __init int setup_nointremap(char *str)
 {
 	disable_intremap = 1;
@@ -28,6 +30,22 @@ static __init int setup_nointremap(char *str)
 }
 early_param("nointremap", setup_nointremap);
 
+static __init int setup_intremap(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strncmp(str, "on", 2))
+		disable_intremap = 0;
+	else if (!strncmp(str, "off", 3))
+		disable_intremap = 1;
+	else if (!strncmp(str, "nosid", 5))
+		disable_sourceid_checking = 1;
+
+	return 0;
+}
+early_param("intremap", setup_intremap);
+
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -453,6 +471,8 @@ int free_irte(int irq)
 static void set_irte_sid(struct irte *irte, unsigned int svt,
 			 unsigned int sq, unsigned int sid)
 {
+	if (disable_sourceid_checking)
+		svt = SVT_NO_VERIFY;
 	irte->svt = svt;
 	irte->sq = sq;
 	irte->sid = sid;


