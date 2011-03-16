Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1CPVXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:23:49 -0400
Received: from kroah.org ([198.145.64.141]:42690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab1CPVML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:12:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/50] firmware: Fix unaligned memory accesses in dmi-sysfs
Date: Wed, 16 Mar 2011 14:11:16 -0700
Message-Id: <1300309888-5028-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

DMI entries are arranged in memory back to back with no alignment
guarantees. This means that the struct dmi_header passed to callbacks
from dmi_walk() itself isn't byte aligned.  This causes problems on
architectures that expect aligned data, such as IA64.

The dmi-sysfs patchset introduced structure member accesses through this
passed in dmi_header.  Fix this by memcpy()ing the structures to
temporary locations on stack when inspecting/copying them.

Signed-off-by: Mike Waychison <mikew@google.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-sysfs.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index a5afd80..eb26d62 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -263,20 +263,16 @@ struct dmi_system_event_log {
 	u8	supported_log_type_descriptos[0];
 } __packed;
 
-static const struct dmi_system_event_log *to_sel(const struct dmi_header *dh)
-{
-	return (const struct dmi_system_event_log *)dh;
-}
-
 #define DMI_SYSFS_SEL_FIELD(_field) \
 static ssize_t dmi_sysfs_sel_##_field(struct dmi_sysfs_entry *entry, \
 				      const struct dmi_header *dh, \
 				      char *buf) \
 { \
-	const struct dmi_system_event_log *sel = to_sel(dh); \
-	if (sizeof(*sel) > dmi_entry_length(dh)) \
+	struct dmi_system_event_log sel; \
+	if (sizeof(sel) > dmi_entry_length(dh)) \
 		return -EIO; \
-	return sprintf(buf, "%u\n", sel->_field); \
+	memcpy(&sel, dh, sizeof(sel)); \
+	return sprintf(buf, "%u\n", sel._field); \
 } \
 static DMI_SYSFS_MAPPED_ATTR(sel, _field)
 
@@ -403,26 +399,28 @@ static ssize_t dmi_sel_raw_read_helper(struct dmi_sysfs_entry *entry,
 				       void *_state)
 {
 	struct dmi_read_state *state = _state;
-	const struct dmi_system_event_log *sel = to_sel(dh);
+	struct dmi_system_event_log sel;
 
-	if (sizeof(*sel) > dmi_entry_length(dh))
+	if (sizeof(sel) > dmi_entry_length(dh))
 		return -EIO;
 
-	switch (sel->access_method) {
+	memcpy(&sel, dh, sizeof(sel));
+
+	switch (sel.access_method) {
 	case DMI_SEL_ACCESS_METHOD_IO8:
 	case DMI_SEL_ACCESS_METHOD_IO2x8:
 	case DMI_SEL_ACCESS_METHOD_IO16:
-		return dmi_sel_raw_read_io(entry, sel, state->buf,
+		return dmi_sel_raw_read_io(entry, &sel, state->buf,
 					   state->pos, state->count);
 	case DMI_SEL_ACCESS_METHOD_PHYS32:
-		return dmi_sel_raw_read_phys32(entry, sel, state->buf,
+		return dmi_sel_raw_read_phys32(entry, &sel, state->buf,
 					       state->pos, state->count);
 	case DMI_SEL_ACCESS_METHOD_GPNV:
 		pr_info("dmi-sysfs: GPNV support missing.\n");
 		return -EIO;
 	default:
 		pr_info("dmi-sysfs: Unknown access method %02x\n",
-			sel->access_method);
+			sel.access_method);
 		return -EIO;
 	}
 }
@@ -595,7 +593,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 	}
 
 	/* Set the key */
-	entry->dh = *dh;
+	memcpy(&entry->dh, dh, sizeof(*dh));
 	entry->instance = instance_counts[dh->type]++;
 	entry->position = position_count++;
 
-- 
1.7.4.1

