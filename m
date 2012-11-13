Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2KMQiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:38:55 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:47093 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2KMQix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:38:53 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH v5 5/7] efi_pstore: Add a sequence counter to a variable name
Thread-Topic: [PATCH v5 5/7] efi_pstore: Add a sequence counter to a
 variable name
Thread-Index: Ac3BvUajXdkeH4MvREyovl+fjbmC5w==
Date: Tue, 13 Nov 2012 16:38:37 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C15D3@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-13_07:2012-11-13,2012-11-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1211130141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Issue]

Currently, a variable name, which identifies each entry, consists of type, id and ctime.
But if multiple events happens in a short time, a second/third event may fail to log because
efi_pstore can't distinguish each event with current variable name.

[Solution]

A reasonable way to identify all events precisely is introducing a sequence counter to
the variable name.

The sequence counter has already supported in a pstore layer with "oopscount".
So, this patch adds it to a variable name.
Also, it is passed to read/erase callbacks of platform drivers in accordance with
the modification of the variable name.

  <before applying this patch>
 a variable name of first event: dump-type0-1-12345678
 a variable name of second event: dump-type0-1-12345678

  type:0
  id:1
  ctime:12345678

 If multiple events happen in a short time, efi_pstore can't distinguish them because
 variable names are same among them.

  <after applying this patch>

 it can be distinguishable by adding a sequence counter as follows.

 a variable name of first event: dump-type0-1-1-12345678
 a variable name of Second event: dump-type0-1-2-12345678

  type:0
  id:1
  sequence counter: 1(first event), 2(second event)
  ctime:12345678

In case of a write callback executed in pstore_console_write(), "0" is added to
an argument of the write callback because it just logs all kernel messages and
doesn't need to care about multiple events.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Mike Waychison <mikew@google.com>
---
 drivers/acpi/apei/erst.c   |   12 ++++++------
 drivers/firmware/efivars.c |   18 +++++++++++-------
 fs/pstore/inode.c          |    8 +++++---
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   13 +++++++------
 fs/pstore/ram.c            |    7 +++----
 include/linux/pstore.h     |    8 +++++---
 7 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 0bd6ae4..6d894bf 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -931,13 +931,13 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 
 static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
-static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
+static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
 			   struct pstore_info *psi);
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part,
+		       u64 *id, unsigned int part, int count,
 		       size_t size, struct pstore_info *psi);
-static int erst_clearer(enum pstore_type_id type, u64 id,
+static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 			struct timespec time, struct pstore_info *psi);
 
 static struct pstore_info erst_info = {
@@ -987,7 +987,7 @@ static int erst_close_pstore(struct pstore_info *psi)
 	return 0;
 }
 
-static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
+static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 			   struct timespec *time, char **buf,
 			   struct pstore_info *psi)
 {
@@ -1055,7 +1055,7 @@ out:
 }
 
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
-		       u64 *id, unsigned int part,
+		       u64 *id, unsigned int part, int count,
 		       size_t size, struct pstore_info *psi)
 {
 	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
@@ -1101,7 +1101,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 	return ret;
 }
 
-static int erst_clearer(enum pstore_type_id type, u64 id,
+static int erst_clearer(enum pstore_type_id type, u64 id, int count,
 			struct timespec time, struct pstore_info *psi)
 {
 	return erst_clear(id);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 6cbeea7..dc69802 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -658,13 +658,14 @@ static int efi_pstore_close(struct pstore_info *psi)
 }
 
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       struct timespec *timespec,
+			       int *count, struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	char name[DUMP_NAME_LEN];
 	int i;
+	int cnt;
 	unsigned int part, size;
 	unsigned long time;
 
@@ -674,8 +675,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			for (i = 0; i < DUMP_NAME_LEN; i++) {
 				name[i] = efivars->walk_entry->var.VariableName[i];
 			}
-			if (sscanf(name, "dump-type%u-%u-%lu", type, &part, &time) == 3) {
+			if (sscanf(name, "dump-type%u-%u-%d-%lu",
+				   type, &part, &cnt, &time) == 4) {
 				*id = part;
+				*count = cnt;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
 				get_var_data_locked(efivars, &efivars->walk_entry->var);
@@ -698,7 +701,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 
 static int efi_pstore_write(enum pstore_type_id type,
 		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, size_t size, struct pstore_info *psi)
+		unsigned int part, int count, size_t size,
+		struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
@@ -725,7 +729,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 		return -ENOSPC;
 	}
 
-	sprintf(name, "dump-type%u-%u-%lu", type, part,
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
 		get_seconds());
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
@@ -746,7 +750,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 	return ret;
 };
 
-static int efi_pstore_erase(enum pstore_type_id type, u64 id,
+static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 			    struct timespec time, struct pstore_info *psi)
 {
 	char name[DUMP_NAME_LEN];
@@ -756,7 +760,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 	struct efivar_entry *entry, *found = NULL;
 	int i;
 
-	sprintf(name, "dump-type%u-%u-%lu", type, (unsigned int)id,
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
 		time.tv_sec);
 
 	spin_lock(&efivars->lock);
@@ -807,7 +811,7 @@ static int efi_pstore_close(struct pstore_info *psi)
 	return 0;
 }
 
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
 			       struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
 {
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 4300af6..ed1d8c7 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -49,6 +49,7 @@ struct pstore_private {
 	struct pstore_info *psi;
 	enum pstore_type_id type;
 	u64	id;
+	int	count;
 	ssize_t	size;
 	char	data[];
 };
@@ -175,8 +176,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	struct pstore_private *p = dentry->d_inode->i_private;
 
 	if (p->psi->erase)
-		p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime,
-			      p->psi);
+		p->psi->erase(p->type, p->id, p->count,
+			      dentry->d_inode->i_ctime, p->psi);
 
 	return simple_unlink(dir, dentry);
 }
@@ -271,7 +272,7 @@ int pstore_is_mounted(void)
  * Load it up with "size" bytes of data from "buf".
  * Set the mtime & ctime to the date that this record was originally stored.
  */
-int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
+int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 		  char *data, size_t size, struct timespec time,
 		  struct pstore_info *psi)
 {
@@ -307,6 +308,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 		goto fail_alloc;
 	private->type = type;
 	private->id = id;
+	private->count = count;
 	private->psi = psi;
 
 	switch (type) {
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 4847f58..937d820 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -50,7 +50,7 @@ extern struct pstore_info *psinfo;
 extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
 extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
-			      char *data, size_t size,
+			      int count, char *data, size_t size,
 			      struct timespec time, struct pstore_info *psi);
 extern int	pstore_is_mounted(void);
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index a40da07..e518f43 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -136,7 +136,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			break;
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				    hsize + len, psinfo);
+				    oopscount, hsize + len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
 
@@ -172,7 +172,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
 		memcpy(psinfo->buf, s, c);
-		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, c, psinfo);
+		psinfo->write(PSTORE_TYPE_CONSOLE, 0, NULL, 0, 0, c, psinfo);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
@@ -196,7 +196,7 @@ static void pstore_register_console(void) {}
 
 static int pstore_write_compat(enum pstore_type_id type,
 			       enum kmsg_dump_reason reason,
-			       u64 *id, unsigned int part,
+			       u64 *id, unsigned int part, int count,
 			       size_t size, struct pstore_info *psi)
 {
 	return psi->write_buf(type, reason, id, part, psinfo->buf, size, psi);
@@ -266,6 +266,7 @@ void pstore_get_records(int quiet)
 	char			*buf = NULL;
 	ssize_t			size;
 	u64			id;
+	int			count;
 	enum pstore_type_id	type;
 	struct timespec		time;
 	int			failed = 0, rc;
@@ -277,9 +278,9 @@ void pstore_get_records(int quiet)
 	if (psi->open && psi->open(psi))
 		goto out;
 
-	while ((size = psi->read(&id, &type, &time, &buf, psi)) > 0) {
-		rc = pstore_mkfile(type, psi->name, id, buf, (size_t)size,
-				  time, psi);
+	while ((size = psi->read(&id, &type, &count, &time, &buf, psi)) > 0) {
+		rc = pstore_mkfile(type, psi->name, id, count, buf,
+				  (size_t)size, time, psi);
 		kfree(buf);
 		buf = NULL;
 		if (rc && (rc != -EEXIST || !quiet))
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 749693f..2bfa36e 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -132,9 +132,8 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
 }
 
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
-				   struct timespec *time,
-				   char **buf,
-				   struct pstore_info *psi)
+				   int *count, struct timespec *time,
+				   char **buf, struct pstore_info *psi)
 {
 	ssize_t size;
 	struct ramoops_context *cxt = psi->data;
@@ -236,7 +235,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 	return 0;
 }
 
-static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
+static int ramoops_pstore_erase(enum pstore_type_id type, u64 id, int count,
 				struct timespec time, struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index f6e9336..1788909 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -50,17 +50,19 @@ struct pstore_info {
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
-			struct timespec *time, char **buf,
+			int *count, struct timespec *time, char **buf,
 			struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, size_t size, struct pstore_info *psi);
+			unsigned int part, int count, size_t size,
+			struct pstore_info *psi);
 	int		(*write_buf)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, const char *buf, size_t size,
 			struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
-			struct timespec time, struct pstore_info *psi);
+			int count, struct timespec time,
+			struct pstore_info *psi);
 	void		*data;
 };
 
-- 
1.7.1

