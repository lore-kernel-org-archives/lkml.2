Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1GRUbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1GRUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:31:09 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/9] pstore: Extend API
Date: Mon, 18 Jul 2011 16:30:25 -0400
Message-Id: <1311021033-7483-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1311021033-7483-1-git-send-email-mjg@redhat.com>
References: <1311021033-7483-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some pstore implementations may not have a static context, so extend the
API to pass the pstore_info struct to all calls and allow for a context
pointer.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/apei/erst.c |   18 +++++++++++++-----
 fs/pstore/inode.c        |   10 +++++-----
 fs/pstore/internal.h     |    2 +-
 fs/pstore/platform.c     |   13 +++++++------
 include/linux/pstore.h   |    8 +++++---
 5 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index c8ba9da..8aac55e 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -932,8 +932,10 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
-		       struct timespec *time);
-static u64 erst_writer(enum pstore_type_id type, size_t size);
+			   struct timespec *time, struct pstore_info *psi);
+static u64 erst_writer(enum pstore_type_id type, size_t size,
+		       struct pstore_info *psi);
+static int erst_clearer(u64 id, struct pstore_info *psi);
 
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
@@ -942,7 +944,7 @@ static struct pstore_info erst_info = {
 	.close		= erst_close_pstore,
 	.read		= erst_reader,
 	.write		= erst_writer,
-	.erase		= erst_clear
+	.erase		= erst_clearer
 };
 
 #define CPER_CREATOR_PSTORE						\
@@ -983,7 +985,7 @@ static int erst_close_pstore(struct pstore_info *psi)
 }
 
 static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
-		       struct timespec *time)
+			   struct timespec *time, struct pstore_info *psi)
 {
 	int rc;
 	ssize_t len = 0;
@@ -1037,7 +1039,8 @@ out:
 	return (rc < 0) ? rc : (len - sizeof(*rcd));
 }
 
-static u64 erst_writer(enum pstore_type_id type, size_t size)
+static u64 erst_writer(enum pstore_type_id type, size_t size,
+		       struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
 					(erst_info.buf - sizeof(*rcd));
@@ -1080,6 +1083,11 @@ static u64 erst_writer(enum pstore_type_id type, size_t size)
 	return rcd->hdr.record_id;
 }
 
+static int erst_clearer(u64 id, struct pstore_info *psi)
+{
+	return erst_clear(id);
+}
+
 static int __init erst_init(void)
 {
 	int rc = 0;
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 977ed27..b19884a 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -40,7 +40,7 @@
 
 struct pstore_private {
 	u64	id;
-	int	(*erase)(u64);
+	struct pstore_info *psi;
 	ssize_t	size;
 	char	data[];
 };
@@ -73,7 +73,7 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct pstore_private *p = dentry->d_inode->i_private;
 
-	p->erase(p->id);
+	p->psi->erase(p->id, p->psi);
 
 	return simple_unlink(dir, dentry);
 }
@@ -175,8 +175,8 @@ int pstore_is_mounted(void)
  * Set the mtime & ctime to the date that this record was originally stored.
  */
 int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
-			      char *data, size_t size,
-			      struct timespec time, int (*erase)(u64))
+		  char *data, size_t size, struct timespec time,
+		  struct pstore_info *psi)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
@@ -193,7 +193,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	if (!private)
 		goto fail_alloc;
 	private->id = id;
-	private->erase = erase;
+	private->psi = psi;
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 8c9f23e..611c1b3 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -2,5 +2,5 @@ extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(void);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
 			      char *data, size_t size,
-			      struct timespec time, int (*erase)(u64));
+			      struct timespec time, struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index f2c3ff2..221c04e 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -94,11 +94,12 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		memcpy(dst, s1 + s1_start, l1_cpy);
 		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
-		id = psinfo->write(PSTORE_TYPE_DMESG, hsize + l1_cpy + l2_cpy);
+		id = psinfo->write(PSTORE_TYPE_DMESG, hsize + l1_cpy + l2_cpy,
+				   psinfo);
 		if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
 				      psinfo->buf, hsize + l1_cpy + l2_cpy,
-				      CURRENT_TIME, psinfo->erase);
+				      CURRENT_TIME, psinfo);
 		l1 -= l1_cpy;
 		l2 -= l2_cpy;
 		total += l1_cpy + l2_cpy;
@@ -166,9 +167,9 @@ void pstore_get_records(void)
 	if (rc)
 		goto out;
 
-	while ((size = psi->read(&id, &type, &time)) > 0) {
+	while ((size = psi->read(&id, &type, &time, psi)) > 0) {
 		if (pstore_mkfile(type, psi->name, id, psi->buf, (size_t)size,
-				  time, psi->erase))
+				  time, psi))
 			failed++;
 	}
 	psi->close(psi);
@@ -196,10 +197,10 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
 
 	mutex_lock(&psinfo->buf_mutex);
 	memcpy(psinfo->buf, buf, size);
-	id = psinfo->write(type, size);
+	id = psinfo->write(type, size, psinfo);
 	if (pstore_is_mounted())
 		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
-			      size, CURRENT_TIME, psinfo->erase);
+			      size, CURRENT_TIME, psinfo);
 	mutex_unlock(&psinfo->buf_mutex);
 
 	return 0;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 2455ef2..b2f1d97 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -38,9 +38,11 @@ struct pstore_info {
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
-			struct timespec *time);
-	u64		(*write)(enum pstore_type_id type, size_t size);
-	int		(*erase)(u64 id);
+			struct timespec *time, struct pstore_info *psi);
+	u64		(*write)(enum pstore_type_id type, size_t size,
+			struct pstore_info *psi);
+	int		(*erase)(u64 id, struct pstore_info *psi);
+	void		*data;
 };
 
 #ifdef CONFIG_PSTORE
-- 
1.7.6

