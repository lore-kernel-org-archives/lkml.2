Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab1BYXmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 18:42:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab1BYXmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 18:42:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eI5nLn5DGb/klrZtk1ZJkgbMDDOzrbzuIZ4ifdiX7ReOJYEMq2abOJIW2ZDhUsu65
	3P8f+1eA2R270ZtwaqfiQ==
Subject: [resend PATCH v2 6/5] Fix unaligned memory accesses in dmi-sysfs
To: Greg KH <greg@kroah.com>, Olof Johansson <olofj@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>
From: Mike Waychison <mikew@google.com>
Cc: Jon Mayer <jonmayer@google.com>, Tony Luck <tony.luck@intel.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
        David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
Date: Fri, 25 Feb 2011 15:41:49 -0800
Message-ID: <20110225234149.21809.65320.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMI entries are arranged in memory back to back with no alignment
guarantees. This means that the struct dmi_header passed to callbacks
from dmi_walk() itself isn't byte aligned.  This causes problems on
architectures that expect aligned data, such as IA64.

The dmi-sysfs patchset introduced structure member accesses through this
passed in dmi_header.  Fix this by memcpy()ing the structures to
temporary locations on stack when inspecting/copying them.

Signed-off-by: Mike Waychison <mikew@google.com>
Tested-by: Tony Luck <tony.luck@intel.com>
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
 

