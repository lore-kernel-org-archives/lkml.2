Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1KPSVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:21:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60670 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1KPSU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:20:58 -0500
Date: Wed, 16 Nov 2011 10:20:47 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH v2] pstore: pass reason to backend write callback
Message-ID: <20111116182047.GA11479@www.outflux.net>
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

Drop pstore_write() as it has no users, and handling the "reason" here
has no obviously correct value.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/apei/erst.c   |    6 ++++--
 drivers/firmware/efivars.c |    8 +++++---
 fs/pstore/platform.c       |   30 +-----------------------------
 include/linux/pstore.h     |   12 +++++-------
 4 files changed, 15 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 1274080..3616c67 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -933,7 +933,8 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 			   struct timespec *time, struct pstore_info *psi);
-static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
+static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
+		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
@@ -1040,7 +1041,8 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
+static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
+		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8370f72..f67ddfb 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -490,7 +490,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return 0;
 }
 
-static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
@@ -560,7 +561,7 @@ static int efi_pstore_write(enum pstore_type_id type, u64 *id,
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 			    struct pstore_info *psi)
 {
-	efi_pstore_write(type, &id, (unsigned int)id, 0, psi);
+	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
 
 	return 0;
 }
@@ -581,7 +582,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return -1;
 }
 
-static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
 		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	return 0;
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 2bd620f..b22322f 100644
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
@@ -240,33 +240,5 @@ static void pstore_timefunc(unsigned long dummy)
 	mod_timer(&pstore_timer, jiffies + PSTORE_INTERVAL);
 }
 
-/*
- * Call platform driver to write a record to the
- * persistent store.
- */
-int pstore_write(enum pstore_type_id type, char *buf, size_t size)
-{
-	u64		id;
-	int		ret;
-	unsigned long	flags;
-
-	if (!psinfo)
-		return -ENODEV;
-
-	if (size > psinfo->bufsize)
-		return -EFBIG;
-
-	spin_lock_irqsave(&psinfo->buf_lock, flags);
-	memcpy(psinfo->buf, buf, size);
-	ret = psinfo->write(type, &id, 0, size, psinfo);
-	if (ret == 0 && pstore_is_mounted())
-		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
-			      size, CURRENT_TIME, psinfo);
-	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pstore_write);
-
 module_param(backend, charp, 0444);
 MODULE_PARM_DESC(backend, "Pstore backend to use");
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ea56732..b38ddf9 100644
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
@@ -39,7 +42,8 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time, struct pstore_info *psi);
-	int		(*write)(enum pstore_type_id type, u64 *id,
+	int		(*write)(enum pstore_type_id type,
+			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
@@ -48,18 +52,12 @@ struct pstore_info {
 
 #ifdef CONFIG_PSTORE
 extern int pstore_register(struct pstore_info *);
-extern int pstore_write(enum pstore_type_id type, char *buf, size_t size);
 #else
 static inline int
 pstore_register(struct pstore_info *psi)
 {
 	return -ENODEV;
 }
-static inline int
-pstore_write(enum pstore_type_id type, char *buf, size_t size)
-{
-	return -ENODEV;
-}
 #endif
 
 #endif /*_LINUX_PSTORE_H*/
-- 
1.7.0.4

