Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab2LRFBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:01:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:38566 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2LRFBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:01:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,305,1355126400"; 
   d="scan'208";a="263484392"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, tglx@linutronix.de,
        mingo@kernel.org
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] x86,apic: Blacklist x2APIC on some platforms
Date: Tue, 18 Dec 2012 12:07:30 -0500
Message-Id: <1355850450-26445-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blacklist x2apic when Nivida graphics enabled on Lenovo ThinkPad T420.
Also set blacklist x2apic for Lenovo ThinkPad W520 and L520.


Thre are 3 bug reports:
https://bugzilla.kernel.org/show_bug.cgi?id=43054
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/776999
https://bugs.launchpad.net/bugs/922037

The patches is based on http://git.kernel.org/?p=linux/kernel/git/yinghai/
linux-yinghai.git;a=patch;h=de38757e964cfee20e6da1977572a2191d7f4aa0

Reviewed-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/apic/apic.c     |   51 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/early-quirks.c  |    9 +++++++
 3 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..88e39e6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -202,5 +202,6 @@ extern struct x86_msi_ops x86_msi;
 extern struct x86_io_apic_ops x86_io_apic_ops;
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
+extern int early_found_nvidia_display_card;
 
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 24deb30..0822fe9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -170,6 +170,54 @@ static __init int setup_nox2apic(char *str)
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
+
+static __init int x2apic_set_blacklist_nvidia(const struct dmi_system_id *d)
+{
+	if (!early_found_nvidia_display_card)
+		return 1;
+
+	setup_nox2apic("");
+	pr_info("x2apic blacklisted when Nivida graphics enabled on %s\n",
+		d->ident);
+	return 0;
+}
+
+static __init int x2apic_set_blacklist(const struct dmi_system_id *d)
+{
+	setup_nox2apic("");
+	pr_info("x2apic blacklisted because of broken SMI on %s\n",
+		d->ident);
+	return 0;
+}
+
+static const struct dmi_system_id x2apic_dmi_table[] = {
+	{
+		.callback = x2apic_set_blacklist_nvidia,
+		.ident = "Lenovo ThinkPad T420",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T420"),
+		},
+	},
+	{
+		.callback = x2apic_set_blacklist,
+		.ident = "Lenovo ThinkPad W520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W520"),
+		},
+	},
+	{
+		.callback = x2apic_set_blacklist,
+		.ident = "Lenovo ThinkPad L520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L520"),
+		},
+	},
+	{}
+};
+
 #endif
 
 unsigned long mp_lapic_addr;
@@ -1542,6 +1590,9 @@ void __init enable_IR_x2apic(void)
 	int ret, x2apic_enabled = 0;
 	int hardware_init_ret;
 
+	if (x2apic_supported())
+		dmi_check_system(x2apic_dmi_table);
+
 	/* Make sure irq_remap_ops are initialized */
 	setup_irq_remapping_ops();
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 7548932..852d7a0 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -19,6 +19,8 @@
 #include <asm/iommu.h>
 #include <asm/gart.h>
 
+int early_found_nvidia_display_card __initdata;
+
 static void __init fix_hypertransport_config(int num, int slot, int func)
 {
 	u32 htcfg;
@@ -192,6 +194,11 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 }
 #endif
 
+static void __init nvidia_x2apic_bugs(int num, int slot, int func)
+{
+	early_found_nvidia_display_card = 1;
+}
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -221,6 +228,8 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
 	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 	  PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+	  PCI_CLASS_DISPLAY_VGA, 0xff00, 0, nvidia_x2apic_bugs},
 	{}
 };
 
-- 
1.7.1

