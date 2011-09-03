Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1ICF3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 01:29:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:14676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1ICF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 01:28:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="44915374"
From: Chen Gong <gong.chen@linux.intel.com>
To: tony.luck@intel.com, mjg59@srcf.ucam.org
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Subject: [PATCH 1/2] pstore: change the purpose of return value for pstore write operation
Date: Sat,  3 Sep 2011 13:30:16 +0800
Message-Id: <1315027817-5316-2-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.7.7.rc0.70.g82660
In-Reply-To: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
References: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently pstore write interface employs record id as return
value, but it is not enough because it can't tell caller if
the write operation is successful. To get this purpose, change
the return value from record id to new meaning.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/erst.c   |   10 ++++++----
 drivers/firmware/efivars.c |   17 +++++++++--------
 fs/pstore/platform.c       |   11 ++++++-----
 include/linux/pstore.h     |    4 ++--
 4 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 2ca59dc..d498cd7 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -933,7 +933,7 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
 			   struct timespec *time, struct pstore_info *psi);
-static u64 erst_writer(enum pstore_type_id type, unsigned int part,
+static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
@@ -1040,11 +1040,12 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static u64 erst_writer(enum pstore_type_id type, unsigned int part,
+static int erst_writer(enum pstore_type_id type, u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
 					(erst_info.buf - sizeof(*rcd));
+	int ret;
 
 	memset(rcd, 0, sizeof(*rcd));
 	memcpy(rcd->hdr.signature, CPER_SIG_RECORD, CPER_SIG_SIZE);
@@ -1079,9 +1080,10 @@ static u64 erst_writer(enum pstore_type_id type, unsigned int part,
 	}
 	rcd->sec_hdr.section_severity = CPER_SEV_FATAL;
 
-	erst_write(&rcd->hdr);
+	ret = erst_write(&rcd->hdr);
+	*id = rcd->hdr.record_id;
 
-	return rcd->hdr.record_id;
+	return ret;
 }
 
 static int erst_clearer(enum pstore_type_id type, u64 id,
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eb80b54..fe07673 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -490,8 +490,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return 0;
 }
 
-static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
-			    size_t size, struct pstore_info *psi)
+static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
 	char stub_name[DUMP_NAME_LEN];
@@ -499,7 +499,7 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
-	int i;
+	int i, ret = 0;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
@@ -548,18 +548,19 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
 		efivar_unregister(found);
 
 	if (size)
-		efivar_create_sysfs_entry(efivars,
+		ret = efivar_create_sysfs_entry(efivars,
 					  utf16_strsize(efi_name,
 							DUMP_NAME_LEN * 2),
 					  efi_name, &vendor);
 
-	return part;
+	*id = part;
+	return ret;
 };
 
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 			    struct pstore_info *psi)
 {
-	efi_pstore_write(type, id, 0, psi);
+	efi_pstore_write(type, &id, (unsigned int)id, 0, psi);
 
 	return 0;
 }
@@ -580,8 +581,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return -1;
 }
 
-static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
-			    size_t size, struct pstore_info *psi)
+static int efi_pstore_write(enum pstore_type_id type, u64 *id,
+		unsigned int part, size_t size, struct pstore_info *psi)
 {
 	return 0;
 }
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index c5300ec..633c0e5 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -69,7 +69,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	size, total = 0;
 	char		*dst, *why;
 	u64		id;
-	int		hsize;
+	int		hsize, ret;
 	unsigned int	part = 1;
 
 	if (reason < ARRAY_SIZE(reason_str))
@@ -97,9 +97,9 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		memcpy(dst, s1 + s1_start, l1_cpy);
 		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
-		id = psinfo->write(PSTORE_TYPE_DMESG, part,
+		ret = psinfo->write(PSTORE_TYPE_DMESG, &id, part,
 				   hsize + l1_cpy + l2_cpy, psinfo);
-		if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
+		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
 				      psinfo->buf, hsize + l1_cpy + l2_cpy,
 				      CURRENT_TIME, psinfo);
@@ -198,6 +198,7 @@ out:
 int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 {
 	u64	id;
+	int	ret;
 
 	if (!psinfo)
 		return -ENODEV;
@@ -207,8 +208,8 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 
 	mutex_lock(&psinfo->buf_mutex);
 	memcpy(psinfo->buf, buf, size);
-	id = psinfo->write(type, 0, size, psinfo);
-	if (pstore_is_mounted())
+	ret = psinfo->write(type, &id, 0, size, psinfo);
+	if (ret == 0 && pstore_is_mounted())
 		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
 			      size, CURRENT_TIME, psinfo);
 	mutex_unlock(&psinfo->buf_mutex);
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index cc03bbf..976a3db 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -39,8 +39,8 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			struct timespec *time, struct pstore_info *psi);
-	u64		(*write)(enum pstore_type_id type, unsigned int part,
-			size_t size, struct pstore_info *psi);
+	int		(*write)(enum pstore_type_id type, u64 *id,
+			unsigned int part, size_t size, struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
 	void		*data;
-- 
1.7.7.rc0.70.g82660

