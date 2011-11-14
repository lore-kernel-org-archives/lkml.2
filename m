Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1KNXMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:12:53 -0500
Received: from smtp.outflux.net ([198.145.64.163]:35810 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab1KNXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:12:49 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] erst: pass back allocated buffer for pstore
Date: Mon, 14 Nov 2011 15:12:37 -0800
Message-Id: <1321312358-11234-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321312358-11234-1-git-send-email-keescook@chromium.org>
References: <1321312358-11234-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pstore cannot hold the buf_lock while it populates the VFS, the backend
needs to do it instead, and provide an allocated buffer with the contents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/apei/erst.c |   21 ++++++++++++++++-----
 1 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 1274080..b8b97d6 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -932,7 +932,8 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
-			   struct timespec *time, struct pstore_info *psi);
+			   struct timespec *time, char **buf,
+			   struct pstore_info *psi);
 static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
@@ -986,17 +987,20 @@ static int erst_close_pstore(struct pstore_info *psi)
 }
 
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
-			   struct timespec *time, struct pstore_info *psi)
+			   struct timespec *time, char **buf,
+			   struct pstore_info *psi)
 {
 	int rc;
 	ssize_t len = 0;
 	u64 record_id;
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
 					(erst_info.buf - sizeof(*rcd));
+	unsigned long flags;
 
 	if (erst_disable)
 		return -ENODEV;
 
+	spin_lock_irqsave(&erst_info.buf_lock, flags);
 skip:
 	rc = erst_get_record_id_next(&reader_pos, &record_id);
 	if (rc)
@@ -1004,7 +1008,7 @@ skip:
 
 	/* no more record */
 	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
-		rc = -1;
+		rc = -EINVAL;
 		goto out;
 	}
 
@@ -1013,13 +1017,19 @@ skip:
 	/* The record may be cleared by others, try read next record */
 	if (len == -ENOENT)
 		goto skip;
-	else if (len < 0) {
-		rc = -1;
+	else if (len < sizeof(*rcd)) {
+		rc = -EIO;
 		goto out;
 	}
 	if (uuid_le_cmp(rcd->hdr.creator_id, CPER_CREATOR_PSTORE) != 0)
 		goto skip;
 
+	*buf = kmalloc(len, GFP_KERNEL);
+	if (*buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	memcpy(*buf, erst_info.buf, len - sizeof(*rcd));
 	*id = record_id;
 	if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			CPER_SECTION_TYPE_DMESG) == 0)
@@ -1037,6 +1047,7 @@ skip:
 	time->tv_nsec = 0;
 
 out:
+	spin_unlock_irqrestore(&erst_info.buf_lock, flags);
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-- 
1.7.0.4

