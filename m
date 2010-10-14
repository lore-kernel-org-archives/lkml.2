Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0JNPnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 11:43:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47241 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0JNPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 11:43:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RESEND PATCH] support to overwrite DMI board info
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 14 Oct 2010 15:50:07 +0100
Message-ID: <20101014144931.14214.66371.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Documented was added, resubmitted - no response so resending)

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
index e287b97..c62b57f 100644
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

