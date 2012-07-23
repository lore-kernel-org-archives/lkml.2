Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2GWBn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54366 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421Ab2GWBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:22 -0400
Message-Id: <20120723010659.181223860@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 051/108] intel_ips: blacklist HP ProBook laptops
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 88ca518b0bb4161e5f20f8a1d9cc477cae294e54 upstream.

intel_ips driver spews the warning message
  "ME failed to update for more than 1s, likely hung"
at each second endlessly on HP ProBook laptops with IronLake.

As this has never worked, better to blacklist the driver for now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/intel_ips.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 0ffdb3c..9af4257 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -72,6 +72,7 @@
 #include <linux/string.h>
 #include <linux/tick.h>
 #include <linux/timer.h>
+#include <linux/dmi.h>
 #include <drm/i915_drm.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -1485,6 +1486,24 @@ static DEFINE_PCI_DEVICE_TABLE(ips_id_table) = {
 
 MODULE_DEVICE_TABLE(pci, ips_id_table);
 
+static int ips_blacklist_callback(const struct dmi_system_id *id)
+{
+	pr_info("Blacklisted intel_ips for %s\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id ips_blacklist[] = {
+	{
+		.callback = ips_blacklist_callback,
+		.ident = "HP ProBook",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook"),
+		},
+	},
+	{ }	/* terminating entry */
+};
+
 static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	u64 platform_info;
@@ -1494,6 +1513,9 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	u16 htshi, trc, trc_required_mask;
 	u8 tse;
 
+	if (dmi_check_system(ips_blacklist))
+		return -ENODEV;
+
 	ips = kzalloc(sizeof(struct ips_driver), GFP_KERNEL);
 	if (!ips)
 		return -ENOMEM;


