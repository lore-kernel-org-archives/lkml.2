Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab0JTBhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:37:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:19948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0JTBhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620617"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 1/9] ACPI, APEI, Add ERST record ID cache
Date: Wed, 20 Oct 2010 09:36:52 +0800
Message-Id: <1287538620-7442-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APEI ERST firmware interface and implementation has no multiple users
in mind. For example, there is four records in storage with ID: 1, 2,
3 and 4, if two ERST readers enumerate the records via
GET_NEXT_RECORD_ID as follow,

reader 1		reader 2
1
			2
3
			4
-1
			-1

where -1 signals there is no more record ID.

Reader 1 has no chance to check record 2 and 4, while reader 2 has no
chance to check record 1 and 3. And any other GET_NEXT_RECORD_ID will
return -1, that is, other readers will has no chance to check any
record even they are not cleared by anyone.

This makes raw GET_NEXT_RECORD_ID not suitable for usage of multiple
users.

To solve the issue, an in memory ERST record ID cache is designed and
implemented. When enumerating record ID, the ID returned by
GET_NEXT_RECORD_ID is added into cache in addition to be returned to
caller. So other readers can check the cache to get all record ID
available.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-apei.c |   40 +++--
 drivers/acpi/apei/erst-dbg.c          |   24 ++-
 drivers/acpi/apei/erst.c              |  241 +++++++++++++++++++++++++++-------
 include/acpi/apei.h                   |    5 
 4 files changed, 246 insertions(+), 64 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -106,24 +106,34 @@ int apei_write_mce(struct mce *m)
 ssize_t apei_read_mce(struct mce *m, u64 *record_id)
 {
 	struct cper_mce_record rcd;
-	ssize_t len;
-
-	len = erst_read_next(&rcd.hdr, sizeof(rcd));
-	if (len <= 0)
-		return len;
-	/* Can not skip other records in storage via ERST unless clear them */
-	else if (len != sizeof(rcd) ||
-		 uuid_le_cmp(rcd.hdr.creator_id, CPER_CREATOR_MCE)) {
-		if (printk_ratelimit())
-			pr_warning(
-			"MCE-APEI: Can not skip the unknown record in ERST");
-		return -EIO;
-	}
+	int rc, pos;
 
+	rc = erst_get_record_id_begin(&pos);
+	if (rc)
+		return rc;
+retry:
+	rc = erst_get_record_id_next(&pos, record_id);
+	if (rc)
+		goto out;
+	/* no more record */
+	if (*record_id == APEI_ERST_INVALID_RECORD_ID)
+		goto out;
+	rc = erst_read(*record_id, &rcd.hdr, sizeof(rcd));
+	/* someone else has cleared the record, try next one */
+	if (rc == -ENOENT)
+		goto retry;
+	else if (rc < 0)
+		goto out;
+	/* try to skip other type records in storage */
+	else if (rc != sizeof(rcd) ||
+		 uuid_le_cmp(rcd.hdr.creator_id, CPER_CREATOR_MCE))
+		goto retry;
 	memcpy(m, &rcd.mce, sizeof(*m));
-	*record_id = rcd.hdr.record_id;
+	rc = sizeof(*m);
+out:
+	erst_get_record_id_end();
 
-	return sizeof(*m);
+	return rc;
 }
 
 /* Check whether there is record in ERST */
--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -43,12 +43,27 @@ static DEFINE_MUTEX(erst_dbg_mutex);
 
 static int erst_dbg_open(struct inode *inode, struct file *file)
 {
+	int rc, *pos;
+
 	if (erst_disable)
 		return -ENODEV;
 
+	pos = (int *)&file->private_data;
+
+	rc = erst_get_record_id_begin(pos);
+	if (rc)
+		return rc;
+
 	return nonseekable_open(inode, file);
 }
 
+static int erst_dbg_release(struct inode *inode, struct file *file)
+{
+	erst_get_record_id_end();
+
+	return 0;
+}
+
 static long erst_dbg_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int rc;
@@ -79,18 +94,20 @@ static long erst_dbg_ioctl(struct file *
 static ssize_t erst_dbg_read(struct file *filp, char __user *ubuf,
 			     size_t usize, loff_t *off)
 {
-	int rc;
+	int rc, *pos;
 	ssize_t len = 0;
 	u64 id;
 
-	if (*off != 0)
+	if (*off)
 		return -EINVAL;
 
 	if (mutex_lock_interruptible(&erst_dbg_mutex) != 0)
 		return -EINTR;
 
+	pos = (int *)&filp->private_data;
+
 retry_next:
-	rc = erst_get_next_record_id(&id);
+	rc = erst_get_record_id_next(pos, &id);
 	if (rc)
 		goto out;
 	/* no more record */
@@ -181,6 +198,7 @@ out:
 static const struct file_operations erst_dbg_ops = {
 	.owner		= THIS_MODULE,
 	.open		= erst_dbg_open,
+	.release	= erst_dbg_release,
 	.read		= erst_dbg_read,
 	.write		= erst_dbg_write,
 	.unlocked_ioctl	= erst_dbg_ioctl,
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -429,6 +429,27 @@ ssize_t erst_get_record_count(void)
 }
 EXPORT_SYMBOL_GPL(erst_get_record_count);
 
+#define ERST_RECORD_ID_CACHE_SIZE_MIN	16
+#define ERST_RECORD_ID_CACHE_SIZE_MAX	1024
+
+struct erst_record_id_entry {
+	u64 id;
+	unsigned int cleared:1;
+};
+
+struct erst_record_id_cache {
+	struct mutex lock;
+	struct erst_record_id_entry *entries;
+	int len;
+	int size;
+	int refcount;
+};
+
+static struct erst_record_id_cache erst_record_id_cache = {
+	.lock = __MUTEX_INITIALIZER(erst_record_id_cache.lock),
+	.refcount = 0,
+};
+
 static int __erst_get_next_record_id(u64 *record_id)
 {
 	struct apei_exec_context ctx;
@@ -443,26 +464,180 @@ static int __erst_get_next_record_id(u64
 	return 0;
 }
 
+int erst_get_record_id_begin(int *pos)
+{
+	int rc;
+
+	if (erst_disable)
+		return -ENODEV;
+
+	rc = mutex_lock_interruptible(&erst_record_id_cache.lock);
+	if (rc)
+		return rc;
+	erst_record_id_cache.refcount++;
+	mutex_unlock(&erst_record_id_cache.lock);
+
+	*pos = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(erst_get_record_id_begin);
+
+/* erst_record_id_cache.lock must be held by caller */
+static int erst_record_id_cache_add_one(void)
+{
+	u64 id, prev_id, first_id;
+	int i, rc;
+	struct erst_record_id_entry *entries;
+	unsigned long flags;
+
+	id = prev_id = first_id = APEI_ERST_INVALID_RECORD_ID;
+retry:
+	spin_lock_irqsave(&erst_lock, flags);
+	rc = __erst_get_next_record_id(&id);
+	spin_unlock_irqrestore(&erst_lock, flags);
+	if (rc == -ENOENT)
+		return 0;
+	if (rc)
+		return rc;
+	if (id == APEI_ERST_INVALID_RECORD_ID)
+		return 0;
+	/* can not skip current ID, or look back to first ID */
+	if (id == prev_id || id == first_id)
+		return 0;
+	if (first_id == APEI_ERST_INVALID_RECORD_ID)
+		first_id = id;
+	prev_id = id;
+
+	entries = erst_record_id_cache.entries;
+	for (i = 0; i < erst_record_id_cache.len; i++) {
+		if (!entries[i].cleared && entries[i].id == id)
+			break;
+	}
+	/* record id already in cache, try next */
+	if (i < erst_record_id_cache.len)
+		goto retry;
+	if (erst_record_id_cache.len >= erst_record_id_cache.size) {
+		int new_size, alloc_size;
+		struct erst_record_id_entry *new_entries;
+
+		new_size = erst_record_id_cache.size * 2;
+		new_size = max_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MIN);
+		new_size = min_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MAX);
+		if (new_size <= erst_record_id_cache.size) {
+			if (printk_ratelimit())
+				pr_warning(FW_WARN ERST_PFX
+					   "too many record ID!\n");
+			return 0;
+		}
+		alloc_size = new_size * sizeof(struct erst_record_id_entry);
+		if (alloc_size < PAGE_SIZE)
+			new_entries = kmalloc(alloc_size, GFP_KERNEL);
+		else
+			new_entries = vmalloc(alloc_size);
+		if (!new_entries)
+			return -ENOMEM;
+		memcpy(new_entries, entries,
+		       erst_record_id_cache.len * sizeof(entries[0]));
+		if (erst_record_id_cache.size < PAGE_SIZE)
+			kfree(entries);
+		else
+			vfree(entries);
+		erst_record_id_cache.entries = entries = new_entries;
+		erst_record_id_cache.size = new_size;
+	}
+	memset(&entries[i], 0, sizeof(entries[i]));
+	entries[i].id = id;
+	erst_record_id_cache.len++;
+
+	return 1;
+}
+
 /*
  * Get the record ID of an existing error record on the persistent
  * storage. If there is no error record on the persistent storage, the
  * returned record_id is APEI_ERST_INVALID_RECORD_ID.
  */
-int erst_get_next_record_id(u64 *record_id)
+int erst_get_record_id_next(int *pos, u64 *record_id)
 {
-	int rc;
-	unsigned long flags;
+	int rc = 0;
+	struct erst_record_id_entry *entries;
 
 	if (erst_disable)
 		return -ENODEV;
 
-	spin_lock_irqsave(&erst_lock, flags);
-	rc = __erst_get_next_record_id(record_id);
-	spin_unlock_irqrestore(&erst_lock, flags);
+	/* must be enclosed by erst_get_record_id_begin/end */
+	BUG_ON(!erst_record_id_cache.refcount);
+	BUG_ON(*pos < 0 || *pos > erst_record_id_cache.len);
+
+	mutex_lock(&erst_record_id_cache.lock);
+	entries = erst_record_id_cache.entries;
+	for (; *pos < erst_record_id_cache.len; (*pos)++)
+		if (!entries[*pos].cleared)
+			break;
+	/* found next record id in cache */
+	if (*pos < erst_record_id_cache.len) {
+		*record_id = entries[*pos].id;
+		(*pos)++;
+		goto out_unlock;
+	}
+
+	/* Try to add one more record ID to cache */
+	rc = erst_record_id_cache_add_one();
+	if (rc < 0)
+		goto out_unlock;
+	/* successfully add one new ID */
+	if (rc == 1) {
+		entries = erst_record_id_cache.entries;
+		*record_id = entries[*pos].id;
+		(*pos)++;
+		rc = 0;
+	} else {
+		*pos = -1;
+		*record_id = APEI_ERST_INVALID_RECORD_ID;
+	}
+out_unlock:
+	mutex_unlock(&erst_record_id_cache.lock);
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(erst_get_next_record_id);
+EXPORT_SYMBOL_GPL(erst_get_record_id_next);
+
+static void __erst_record_id_cache_compact(void)
+{
+	int i, wpos = 0;
+	struct erst_record_id_entry *entries;
+
+	if (!erst_record_id_cache.refcount) {
+		entries = erst_record_id_cache.entries;
+		for (i = 0; i < erst_record_id_cache.len; i++) {
+			if (entries[i].cleared)
+				continue;
+			if (wpos != i)
+				memcpy(&entries[wpos], &entries[i],
+				       sizeof(entries[i]));
+			wpos++;
+		}
+		erst_record_id_cache.len = wpos;
+	}
+}
+
+void erst_get_record_id_end(void)
+{
+	/*
+	 * erst_disable != 0 should be detected by invoker via the
+	 * return value of erst_get_record_id_begin/next, so this
+	 * function should not be called for erst_disable != 0.
+	 */
+	BUG_ON(erst_disable);
+
+	mutex_lock(&erst_record_id_cache.lock);
+	erst_record_id_cache.refcount--;
+	BUG_ON(erst_record_id_cache.refcount < 0);
+	__erst_record_id_cache_compact();
+	mutex_unlock(&erst_record_id_cache.lock);
+}
+EXPORT_SYMBOL_GPL(erst_get_record_id_end);
 
 static int __erst_write_to_storage(u64 offset)
 {
@@ -703,56 +878,34 @@ ssize_t erst_read(u64 record_id, struct
 }
 EXPORT_SYMBOL_GPL(erst_read);
 
-/*
- * If return value > buflen, the buffer size is not big enough,
- * else if return value = 0, there is no more record to read,
- * else if return value < 0, something goes wrong,
- * else everything is OK, and return value is record length
- */
-ssize_t erst_read_next(struct cper_record_header *record, size_t buflen)
-{
-	int rc;
-	ssize_t len;
-	unsigned long flags;
-	u64 record_id;
-
-	if (erst_disable)
-		return -ENODEV;
-
-	spin_lock_irqsave(&erst_lock, flags);
-	rc = __erst_get_next_record_id(&record_id);
-	if (rc) {
-		spin_unlock_irqrestore(&erst_lock, flags);
-		return rc;
-	}
-	/* no more record */
-	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
-		spin_unlock_irqrestore(&erst_lock, flags);
-		return 0;
-	}
-
-	len = __erst_read(record_id, record, buflen);
-	spin_unlock_irqrestore(&erst_lock, flags);
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(erst_read_next);
-
 int erst_clear(u64 record_id)
 {
-	int rc;
+	int rc, i;
 	unsigned long flags;
+	struct erst_record_id_entry *entries;
 
 	if (erst_disable)
 		return -ENODEV;
 
+	rc = mutex_lock_interruptible(&erst_record_id_cache.lock);
+	if (rc)
+		return rc;
 	spin_lock_irqsave(&erst_lock, flags);
 	if (erst_erange.attr & ERST_RANGE_NVRAM)
 		rc = __erst_clear_from_nvram(record_id);
 	else
 		rc = __erst_clear_from_storage(record_id);
 	spin_unlock_irqrestore(&erst_lock, flags);
-
+	if (rc)
+		goto out;
+	entries = erst_record_id_cache.entries;
+	for (i = 0; i < erst_record_id_cache.len; i++) {
+		if (!entries[i].cleared && entries[i].id == record_id)
+			entries[i].cleared = 1;
+	}
+	__erst_record_id_cache_compact();
+out:
+	mutex_unlock(&erst_record_id_cache.lock);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(erst_clear);
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -24,10 +24,11 @@ int apei_hest_parse(apei_hest_func_t fun
 
 int erst_write(const struct cper_record_header *record);
 ssize_t erst_get_record_count(void);
-int erst_get_next_record_id(u64 *record_id);
+int erst_get_record_id_begin(int *pos);
+int erst_get_record_id_next(int *pos, u64 *record_id);
+void erst_get_record_id_end(void);
 ssize_t erst_read(u64 record_id, struct cper_record_header *record,
 		  size_t buflen);
-ssize_t erst_read_next(struct cper_record_header *record, size_t buflen);
 int erst_clear(u64 record_id);
 
 #endif
