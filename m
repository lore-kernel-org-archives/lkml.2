Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0CRXjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:39:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37439 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0CRXjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:39:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 19 Mar 2010 00:39:07 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] firewire: core: align driver match with modalias
To: linux1394-devel@lists.sourceforge.net
cc: =?iso-8859-2?Q?Maciej_=AFenczykowski?= <zenczykowski@gmail.com>,
       linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7c2a7540520277a5@s5r6.in-berlin.de>
Message-ID: <tkrat.483401c1864e06a8@s5r6.in-berlin.de>
References: <55a4f86e1003171546m11f7a502u648622d1d61793d6@mail.gmail.com> 
 <tkrat.be9aaf962b6d63b3@s5r6.in-berlin.de>
 <55a4f86e1003171631i323fe5f8w55206efe7d9a5ed6@mail.gmail.com>
 <tkrat.7c2a7540520277a5@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver match strategy was:
  - Match vendor/model/specifier/version of the unit directory.
  - If that was a miss, match vendor from the root directory and
    model/specifier/version of the unit directory.

This was inconsistent whith how the modalias string was constructed
until recently:
  - Take vendor/model from root directory and specifier/version from
    unit directory.
It was also inconsistent with how it is done now:
  - Take vendor/model/specifier/version from the root directory,
    override them with vendor/model/specifier/version from the unit
    directory.

Fix this inconsistency be sharing the ROM scanner function between
modalias printer function and driver match function.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   87 ++++++++++++++-------------------
 1 file changed, 38 insertions(+), 49 deletions(-)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -127,81 +127,70 @@ int fw_csr_string(const u32 *directory, 
 }
 EXPORT_SYMBOL(fw_csr_string);
 
-static bool is_fw_unit(struct device *dev);
-
-static int match_unit_directory(const u32 *directory, u32 match_flags,
-				const struct ieee1394_device_id *id)
+static void get_ids(const u32 *directory, int *id)
 {
 	struct fw_csr_iterator ci;
-	int key, value, match;
+	int key, value;
 
-	match = 0;
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		if (key == CSR_VENDOR && value == id->vendor_id)
-			match |= IEEE1394_MATCH_VENDOR_ID;
-		if (key == CSR_MODEL && value == id->model_id)
-			match |= IEEE1394_MATCH_MODEL_ID;
-		if (key == CSR_SPECIFIER_ID && value == id->specifier_id)
-			match |= IEEE1394_MATCH_SPECIFIER_ID;
-		if (key == CSR_VERSION && value == id->version)
-			match |= IEEE1394_MATCH_VERSION;
+		switch (key) {
+		case CSR_VENDOR:	id[0] = value; break;
+		case CSR_MODEL:		id[1] = value; break;
+		case CSR_SPECIFIER_ID:	id[2] = value; break;
+		case CSR_VERSION:	id[3] = value; break;
+		}
 	}
+}
 
-	return (match & match_flags) == match_flags;
+static void get_modalias_ids(struct fw_unit *unit, int *id)
+{
+	get_ids(&fw_parent_device(unit)->config_rom[5], id);
+	get_ids(unit->directory, id);
+}
+
+static bool match_ids(const struct ieee1394_device_id *id_table, int *id)
+{
+	int match = 0;
+
+	if (id[0] == id_table->vendor_id)
+		match |= IEEE1394_MATCH_VENDOR_ID;
+	if (id[1] == id_table->model_id)
+		match |= IEEE1394_MATCH_MODEL_ID;
+	if (id[2] == id_table->specifier_id)
+		match |= IEEE1394_MATCH_SPECIFIER_ID;
+	if (id[3] == id_table->version)
+		match |= IEEE1394_MATCH_VERSION;
+
+	return (match & id_table->match_flags) == id_table->match_flags;
 }
 
+static bool is_fw_unit(struct device *dev);
+
 static int fw_unit_match(struct device *dev, struct device_driver *drv)
 {
-	struct fw_unit *unit = fw_unit(dev);
-	struct fw_device *device;
-	const struct ieee1394_device_id *id;
+	const struct ieee1394_device_id *id_table =
+			container_of(drv, struct fw_driver, driver)->id_table;
+	int id[] = {0, 0, 0, 0};
 
 	/* We only allow binding to fw_units. */
 	if (!is_fw_unit(dev))
 		return 0;
 
-	device = fw_parent_device(unit);
-	id = container_of(drv, struct fw_driver, driver)->id_table;
+	get_modalias_ids(fw_unit(dev), id);
 
-	for (; id->match_flags != 0; id++) {
-		if (match_unit_directory(unit->directory, id->match_flags, id))
+	for (; id_table->match_flags != 0; id_table++)
+		if (match_ids(id_table, id))
 			return 1;
 
-		/* Also check vendor ID in the root directory. */
-		if ((id->match_flags & IEEE1394_MATCH_VENDOR_ID) &&
-		    match_unit_directory(&device->config_rom[5],
-				IEEE1394_MATCH_VENDOR_ID, id) &&
-		    match_unit_directory(unit->directory, id->match_flags
-				& ~IEEE1394_MATCH_VENDOR_ID, id))
-			return 1;
-	}
-
 	return 0;
 }
 
-static void get_modalias_ids(const u32 *directory, int *id)
-{
-	struct fw_csr_iterator ci;
-	int key, value;
-
-	fw_csr_iterator_init(&ci, directory);
-	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		switch (key) {
-		case CSR_VENDOR:	id[0] = value; break;
-		case CSR_MODEL:		id[1] = value; break;
-		case CSR_SPECIFIER_ID:	id[2] = value; break;
-		case CSR_VERSION:	id[3] = value; break;
-		}
-	}
-}
-
 static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
 {
 	int id[] = {0, 0, 0, 0};
 
-	get_modalias_ids(&fw_parent_device(unit)->config_rom[5], id);
-	get_modalias_ids(unit->directory, id);
+	get_modalias_ids(unit, id);
 
 	return snprintf(buffer, buffer_size,
 			"ieee1394:ven%08Xmo%08Xsp%08Xver%08X",

-- 
Stefan Richter
-=====-==-=- --== =--==
http://arcgraph.de/sr/

