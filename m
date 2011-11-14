Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab1KNX3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:29:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43216 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab1KNX3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:29:14 -0500
Date: Mon, 14 Nov 2011 15:29:12 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] pstore: pass reason to backend write callback
Message-ID: <20111114232912.GA14717@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows a backend to filter on the dmesg reason as well as the pstore
reason. When ramoops is switched to pstore, this is needed since it has
no interest in storing non-crash dmesg details.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/apei/erst.c   |    6 ++++--
 drivers/firmware/efivars.c |    8 +++++---
 fs/pstore/platform.c       |    9 +++++----
 include/linux/pstore.h     |   12 +++++++++---
 4 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index b8b97d6..76d0f84 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -934,7 +934,8 @@ static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 			   struct timespec *time, char **buf,
 			   struct pstore_info *psi);
-static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
+static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
+		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
@@ -1051,7 +1052,8 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
+static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
+		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a54a6b9..0a53a05 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -495,7 +495,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return 0;
 }
 
-static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
@@ -565,7 +566,7 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 			    struct pstore_info *psi)
 {
-	efi_pstore_write(type, &id, (unsigned int)id, 0, psi);
+	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
 
 	return 0;
 }
@@ -586,7 +587,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return -1;
 }
 
-static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	return 0;
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index c09cbb4..2454dbe 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -122,7 +122,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		memcpy(dst, s1 + s1_start, l1_cpy);
 		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
-		ret = psinfo->write(PSTORE_TYPE_DMESG, &id, part,
+		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
 				   hsize + l1_cpy + l2_cpy, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
@@ -244,7 +244,8 @@ static void pstore_timefunc(unsigned long dummy)
  * Call platform driver to write a record to the
  * persistent store.
  */
-int pstore_write(enum pstore_type_id type, char *buf, size_t size)
+int pstore_write(enum pstore_type_id type, enum kmsg_dump_reason reason,
+		 char *buf, size_t size)
 {
 	u64		id;
 	int		ret;
@@ -258,10 +259,10 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 
 	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	memcpy(psinfo->buf, buf, size);
-	ret = psinfo->write(type, &id, 0, size, psinfo);
+	ret = psinfo->write(type, reason, &id, 0, size, psinfo);
 	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 	if (ret == 0 && pstore_is_mounted())
-		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, buf,
+		pstore_mkfile(type, psinfo->name, id, buf,
 			      size, CURRENT_TIME, psinfo);
 
 	return 0;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 781cf43..dabf5eb 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -22,6 +22,9 @@
 #ifndef _LINUX_PSTORE_H
 #define _LINUX_PSTORE_H
 
+#include <linux/time.h>
+#include <linux/kmsg_dump.h>
+
 /* types */
 enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
@@ -40,7 +43,8 @@ struct pstore_info {
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time, char **buf,
 			struct pstore_info *psi);
-	int		(*write)(enum pstore_type_id type, u64 *id,
+	int		(*write)(enum pstore_type_id type,
+			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
@@ -49,7 +53,8 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
-extern int pstore_write(enum pstore_type_id type, char *buf, size_t size);
+extern int pstore_write(enum pstore_type_id type, enum kmsg_dump_reason reason,
+			char *buf, size_t size);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
@@ -57,7 +62,8 @@ pstore_register(struct pstore_info *psi)
 	return -ENODEV;
 }
 static inline int
-pstore_write(enum pstore_type_id type, char *buf, size_t size)
+pstore_write(enum pstore_type_id type, enum kmsg_dump_reason reason,
+	     char *buf, size_t size)
 {
 	return -ENODEV;
 }
-- 
1.7.0.4

