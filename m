Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0I1NZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:25:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:39639 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0I1NZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:25:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,247,1283756400"; 
   d="scan'208";a="611179052"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] support to overwrite DMI board info
To: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 28 Sep 2010 13:36:47 +0100
Message-ID: <20100928123639.17046.13090.stgit@localhost.localdomain>
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
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/firmware/dmi_scan.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)


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

