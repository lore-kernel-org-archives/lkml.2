Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2BCPSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:18:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab2BCPS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:18:28 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, linux-pci@vger.kernel.org,
        jbarnes@virtuousgeek.org
Subject: [PATCH 3/3] pcie: Add support for setting default ASPM policy
Date: Fri,  3 Feb 2012 10:18:13 -0500
Message-Id: <1328282293-16551-3-git-send-email-mjg@redhat.com>
In-Reply-To: <1328282293-16551-1-git-send-email-mjg@redhat.com>
References: <1328282293-16551-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distributions may wish to provide different defaults for PCIE ASPM
depending on their target audience. Provide a configuration option for
choosing the default policy.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org
---
 drivers/pci/pcie/Kconfig |   25 +++++++++++++++++++++++++
 drivers/pci/pcie/aspm.c  |    8 ++++++++
 2 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 72962cc..6c8bc58 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -55,6 +55,31 @@ config PCIEASPM_DEBUG
 	  This enables PCI Express ASPM debug support. It will add per-device
 	  interface to control ASPM.
 
+choice
+	prompt "Default ASPM policy"
+	default PCIEASPM_DEFAULT
+	depends on PCIEASPM
+
+config PCIEASPM_DEFAULT
+        bool "BIOS default"
+	depends on PCIEASPM
+	help
+	  Use the BIOS defaults for PCI Express ASPM.
+
+config PCIEASPM_POWERSAVE
+        bool "Powersave"
+	depends on PCIEASPM
+	help
+	  Enable PCI Express ASPM L0s and L1 where possible, even if the
+	  BIOS did not.
+
+config PCIEASPM_PERFORMANCE
+        bool "Performance"
+	depends on PCIEASPM
+	help
+	  Disable PCI Express ASPM L0s and L1, even if the BIOS enabled them.
+endchoice
+
 config PCIE_PME
 	def_bool y
 	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1cfbf22..a0de5e1 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -76,7 +76,15 @@ static LIST_HEAD(link_list);
 #define POLICY_DEFAULT 0	/* BIOS default setting */
 #define POLICY_PERFORMANCE 1	/* high performance */
 #define POLICY_POWERSAVE 2	/* high power saving */
+
+#ifdef CONFIG_PCIEASPM_PERFORMANCE
+static int aspm_policy = POLICY_PERFORMANCE;
+#elif defined CONFIG_PCIEASPM_POWERSAVE
+static int aspm_policy = POLICY_POWERSAVE;
+#else
 static int aspm_policy;
+#endif
+
 static const char *policy_str[] = {
 	[POLICY_DEFAULT] = "default",
 	[POLICY_PERFORMANCE] = "performance",
-- 
1.7.7.6

