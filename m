Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0I3P2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:28:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:65181 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756668Ab0I3P2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:28:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,259,1283756400"; 
   d="scan'208";a="662711545"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] support to overwrite DMI board info
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 30 Sep 2010 15:39:36 +0100
Message-ID: <20100930143933.7835.55138.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang, Chao <chao.jiang@intel.com>

support to overwrite board vendor/version/name information by editing
/boot/cmdline file. Format example:
	board_vendor="XXX company" board_version=DV3.0


Signed-off-by: Jiang, Chao <chao.jiang@intel.com>
[Added Documentation as requested]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 Documentation/kernel-parameters.txt |   16 +++++++++++++++
 drivers/firmware/dmi_scan.c         |   37 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9139a2d..fb1b606 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -43,6 +43,7 @@ parameter is applicable:
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
+	DMI	Desktop Management Interface is enabled
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
 	EFI	EFI Partitioning (GPT) is enabled
 	EIDE	EIDE/ATAPI support is enabled.
@@ -390,6 +391,21 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
+	board_name=	[DMI]
+			Override reported name in firmware DMI data. Used
+			for testing and for checking board specific
+			workarounds
+
+	board_vendor=	[DMI]
+			Override reported vendor in firmware DMI data. Used
+			for testing and for checking board specific
+			workarounds
+
+	board_version=	[DMI]
+			Override reported version in firmware DMI data. Used
+			for testing and for checking board specific
+			workarounds
+
 	boot_delay=	Milliseconds to delay each printk during boot.
 			Values larger than 10 seconds (10000) are changed to
 			no delay (0).
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b3d22d6..5763618 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -712,3 +712,40 @@ bool dmi_match(enum dmi_field f, const char *str)
 	return !strcmp(info, str);
 }
 EXPORT_SYMBOL_GPL(dmi_match);
+
+static int __init dmi_override(int slot, char *str)
+{
+	size_t len;
+	char *p;
+	if (!str)
+		return -EINVAL;
+	len = strlen(str) + 1;
+	p = dmi_alloc(len);
+	if (p != NULL)
+		strcpy(p, str);
+	else {
+		printk(KERN_ERR "dm_override: cannot allocate %Zu bytes.\n",
+					len);
+		return -ENOMEM;
+	}
+	dmi_ident[slot] = p;
+	return 0;
+}
+
+static int __init override_dmi_board_vendor(char *str)
+{
+	return dmi_override(DMI_BOARD_VENDOR, str);
+}
+early_param("board_vendor", override_dmi_board_vendor);
+
+static int __init override_dmi_board_version(char *str)
+{
+	return dmi_override(DMI_BOARD_VERSION, str);
+}
+early_param("board_version", override_dmi_board_version);
+
+static int __init override_dmi_board_name(char *str)
+{
+	return dmi_override(DMI_BOARD_NAME, str);
+}
+early_param("board_name", override_dmi_board_name);

