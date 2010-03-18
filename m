Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab0CRXiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:38:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37434 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0CRXio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:38:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 19 Mar 2010 00:38:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] firewire: core: fix Model_ID in modalias
To: linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
       linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <55a4f86e1003171631i323fe5f8w55206efe7d9a5ed6@mail.gmail.com>
Message-ID: <tkrat.7c2a7540520277a5@s5r6.in-berlin.de>
References: <55a4f86e1003171546m11f7a502u648622d1d61793d6@mail.gmail.com> 
 <tkrat.be9aaf962b6d63b3@s5r6.in-berlin.de>
 <55a4f86e1003171631i323fe5f8w55206efe7d9a5ed6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-2
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modalias string of devices that represent units on a FireWire node
did not show Module_ID entries within unit directories.  This was
because firewire-core searched only the root directory of the
configuration ROM for a Model_ID entry.

We now search first the root directory, then the unit directory.  IOW
honor a unit directory's Model_ID if present, otherwise fall back to the
root directory's model ID (if present).

Furthermore, apply the same change to Vendor_ID.  This had the same
issue but it was less apparent because most devices provide Vendor_ID
only in the root directory.

And finally, also use this strategy for the remaining two IDs in the
modalias, Specifier_ID and Version.  It does not actually make sense to
look for them elsewhere than in the unit directory because they are
mandatory there.  However, a uniform search order simplifies the
implementation and has no adverse affect in practice.

Side notes:
  - The older counterpart of this, nodemgr.c of ieee1394, looked for
    Vendor_ID first in the root directory, then in the unit directory,
    and for Model_ID only in the unit directory.
  - There is a single mainline driver which requires Vendor_ID and
    Model_ID --- the firedtv driver.  This one worked because FireDTVs
    provide Vendor_ID in the root directory and Model_ID identically in
    root directory and unit directory.
  - Apart from firedtv, there are currently no drivers known to me
    (including userspace drivers) that look at the Vendor_ID or Model_ID
    of the modalias.

Reported-by: Maciej ¯enczykowski <zenczykowski@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   40 ++++++++++++---------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -180,44 +180,32 @@ static int fw_unit_match(struct device *
 	return 0;
 }
 
-static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
+static void get_modalias_ids(const u32 *directory, int *id)
 {
-	struct fw_device *device = fw_parent_device(unit);
 	struct fw_csr_iterator ci;
-
 	int key, value;
-	int vendor = 0;
-	int model = 0;
-	int specifier_id = 0;
-	int version = 0;
 
-	fw_csr_iterator_init(&ci, &device->config_rom[5]);
+	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
 		switch (key) {
-		case CSR_VENDOR:
-			vendor = value;
-			break;
-		case CSR_MODEL:
-			model = value;
-			break;
+		case CSR_VENDOR:	id[0] = value; break;
+		case CSR_MODEL:		id[1] = value; break;
+		case CSR_SPECIFIER_ID:	id[2] = value; break;
+		case CSR_VERSION:	id[3] = value; break;
 		}
 	}
+}
 
-	fw_csr_iterator_init(&ci, unit->directory);
-	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		switch (key) {
-		case CSR_SPECIFIER_ID:
-			specifier_id = value;
-			break;
-		case CSR_VERSION:
-			version = value;
-			break;
-		}
-	}
+static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
+{
+	int id[] = {0, 0, 0, 0};
+
+	get_modalias_ids(&fw_parent_device(unit)->config_rom[5], id);
+	get_modalias_ids(unit->directory, id);
 
 	return snprintf(buffer, buffer_size,
 			"ieee1394:ven%08Xmo%08Xsp%08Xver%08X",
-			vendor, model, specifier_id, version);
+			id[0], id[1], id[2], id[3]);
 }
 
 static int fw_unit_uevent(struct device *dev, struct kobj_uevent_env *env)

-- 
Stefan Richter
-=====-==-=- --== =--==
http://arcgraph.de/sr/

