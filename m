Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031336Ab2I1Tcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:32:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33429 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030925Ab2I1TcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:32:22 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Scott Wood <scottwood@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 2/2] kbuild: introduce cmd_dtc_cpp
Date: Fri, 28 Sep 2012 13:32:11 -0600
Message-Id: <1348860731-20868-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
References: <1348860731-20868-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

cmd_dtc_cpp runs the C pre-processor on the input .dts file before
passing it to dtc for final compilation. This allows used of #define
within the .dts file.

Introduce a new rule for %.dtsp -> %.dtb, which uses cmd_dtc_cpp. A new
file extension is introduced for this purpose, since use of the pre-
processor must be optional; any property or node name that starts with
"#" must be escaped to prevent the pre-processor attempting to interpret
it as a directive. For this reason, skeleton.dtsi-cpp is introduced for
*.dts-cpp to include.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/skeleton.dtsip |   13 +++++++++++++
 scripts/Makefile.lib             |    6 ++++++
 2 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsip

diff --git a/arch/arm/boot/dts/skeleton.dtsip b/arch/arm/boot/dts/skeleton.dtsip
new file mode 100644
index 0000000..8bf6729
--- /dev/null
+++ b/arch/arm/boot/dts/skeleton.dtsip
@@ -0,0 +1,13 @@
+/*
+ * Skeleton device tree; the bare minimum needed to boot; just include and
+ * add a compatible value.  The bootloader will typically populate the memory
+ * node.
+ */
+
+/ {
+	\#address-cells = <1>;
+	\#size-cells = <1>;
+	chosen { };
+	aliases { };
+	memory { device_type = "memory"; reg = <0 0>; };
+};
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 425578e..9dd81c0 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -269,6 +269,12 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
 $(obj)/%.dtb: $(src)/dts/%.dts FORCE
 	$(call if_changed_dep,dtc)
 
+quiet_cmd_dtc_cpp = DTC+CPP $@
+cmd_dtc_cpp = $(CC) -E -Wp,-MD,$(depfile) -xc $< | $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -
+
+$(obj)/%.dtb: $(src)/dts/%.dtsp FORCE
+	$(call if_changed_dep,dtc_cpp)
+
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.7.0.4

