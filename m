Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2BCPSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:18:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2BCPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:18:29 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: [PATCH 2/3] ACPI: Provide config option to control automatic brightness switching
Date: Fri,  3 Feb 2012 10:18:12 -0500
Message-Id: <1328282293-16551-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1328282293-16551-1-git-send-email-mjg@redhat.com>
References: <1328282293-16551-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI backlight driver will optionally automatically respond to ACPI
brightness key events. This is unique amongst backlight drivers and makes
it more difficult for userspace to provide a consistent backlight policy.
Add support for disabling this behaviour by default.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org
Cc: lenb@kernel.org
---
 drivers/acpi/Kconfig |   11 +++++++++++
 drivers/acpi/video.c |    6 +++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5354290..27212e0 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -171,6 +171,17 @@ config ACPI_VIDEO_DISABLE_BIOS_POWER_BRIGHTNESS
 	  Many laptops will automatically change brightness on AC/battery
 	  status changes. Choose Y here to disable this.
 
+config ACPI_VIDEO_BRIGHTNESS_SWITCH_ENABLED
+        bool "Automatically change brightness on ACPI key events"
+	depends on ACPI_VIDEO
+	default y
+	help
+	  If this option is enabled the kernel will change brightness
+	  automatically in response to ACPI video key events. If it is
+	  disabled, the keys will be reported to userspace but no further
+	  action will be taken by the kernel. It is then up to userspace
+	  to respond to the events.
+
 config ACPI_FAN
 	tristate "Fan"
 	select THERMAL
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 4b42938..2b85046 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -69,7 +69,11 @@ MODULE_AUTHOR("Bruno Ducrot");
 MODULE_DESCRIPTION("ACPI Video Driver");
 MODULE_LICENSE("GPL");
 
-static bool brightness_switch_enabled = 1;
+#ifdef CONFIG_ACPI_VIDEO_BRIGHTNESS_SWITCH_ENABLED
+static bool brightness_switch_enabled = true;
+#else
+static bool brightness_switch_enabled;
+#endif
 module_param(brightness_switch_enabled, bool, 0644);
 
 /*
-- 
1.7.7.6

