Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0JUVnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:43:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab0JUVnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:43:16 -0400
From: Matthew Garrett <mjg@redhat.com>
To: srajiv@linux.vnet.ibm.com
Cc: debora@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] tpm: Autodetect itpm devices
Date: Thu, 21 Oct 2010 17:42:40 -0400
Message-Id: <1287697360-31273-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Lenovos have TPMs that require a quirk to function correctly. This can
be autodetected by checking whether the device has a _HID of INTC0102. This
is an invalid PNPid, and as such is discarded by the pnp layer - however
it's still present in the ACPI code, so we can pull it out that way. This
means that the quirk won't be automatically applied on non-ACPI systems,
but without ACPI we don't have any way to identify the chip anyway so I
don't think that's a great concern.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/tpm/tpm_tis.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 1030f84..c17a305 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/acpi.h>
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
@@ -78,6 +79,26 @@ enum tis_defaults {
 static LIST_HEAD(tis_chips);
 static DEFINE_SPINLOCK(tis_lock);
 
+#ifdef CONFIG_ACPI
+static int is_itpm(struct pnp_dev *dev)
+{
+	struct acpi_device *acpi = pnp_acpi_device(dev);
+	struct acpi_hardware_id *id;
+
+	list_for_each_entry(id, &acpi->pnp.ids, list) {
+		if (!strcmp("INTC0102", id->id))
+			return 1;
+	}
+
+	return 0;
+}
+#else
+static int is_itpm(struct pnp_dev *dev)
+{
+	return 0;
+}
+#endif
+
 static int check_locality(struct tpm_chip *chip, int l)
 {
 	if ((ioread8(chip->vendor.iobase + TPM_ACCESS(l)) &
@@ -472,6 +493,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (is_itpm(to_pnp_dev(dev)))
+		itpm = 1;
+
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 
-- 
1.7.3.1

