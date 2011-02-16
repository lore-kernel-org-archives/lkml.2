Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab1BPA5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:57:03 -0500
Received: from kroah.org ([198.145.64.141]:46196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933427Ab1BPAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:14 2011
Message-Id: <20110216002114.404264840@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [patch 154/176] tpm: Autodetect itpm devices
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 upstream.

Some Lenovos have TPMs that require a quirk to function correctly. This can
be autodetected by checking whether the device has a _HID of INTC0102. This
is an invalid PNPid, and as such is discarded by the pnp layer - however
it's still present in the ACPI code, so we can pull it out that way. This
means that the quirk won't be automatically applied on non-ACPI systems,
but without ACPI we don't have any way to identify the chip anyway so I
don't think that's a great concern.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Tested-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

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
@@ -474,6 +495,9 @@ static int tpm_tis_init(struct device *d
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (is_itpm(to_pnp_dev(dev)))
+		itpm = 1;
+
 	if (itpm)
 		dev_info(dev, "Intel iTPM workaround enabled\n");
 


