Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2GRAFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:05:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab2GRAEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Matthew Garrett <mjg@redhat.com>
Subject: [ 12/37] intel_ips: blacklist HP ProBook laptops
Date: Tue, 17 Jul 2012 17:02:49 -0700
Message-Id: <20120717232432.349797357@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 88ca518b0bb4161e5f20f8a1d9cc477cae294e54 upstream.

intel_ips driver spews the warning message
  "ME failed to update for more than 1s, likely hung"
at each second endlessly on HP ProBook laptops with IronLake.

As this has never worked, better to blacklist the driver for now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel_ips.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

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
@@ -1485,6 +1486,24 @@ static DEFINE_PCI_DEVICE_TABLE(ips_id_ta
 
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
@@ -1494,6 +1513,9 @@ static int ips_probe(struct pci_dev *dev
 	u16 htshi, trc, trc_required_mask;
 	u8 tse;
 
+	if (dmi_check_system(ips_blacklist))
+		return -ENODEV;
+
 	ips = kzalloc(sizeof(struct ips_driver), GFP_KERNEL);
 	if (!ips)
 		return -ENOMEM;


