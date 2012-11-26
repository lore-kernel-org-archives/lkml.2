Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2KZKg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:36:27 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:53993 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754921Ab2KZKgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:36:23 -0500
Message-ID: <1353926178.2025.42.camel@slavad-ubuntu>
Subject: [PATCH v3 3/5] hfsplus: add functionality of manipulating by
 records in attributes tree
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 14:36:18 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.49.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds functionality of manipulating by records in attributes tree.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 3/5] hfsplus: add functionality of manipulating by records in attributes tree

This patch adds functionality of manipulating by records in attributes tree.

Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/attributes.c |  399 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 399 insertions(+)
 create mode 100644 fs/hfsplus/attributes.c

diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
new file mode 100644
index 0000000..8d691f1
--- /dev/null
+++ b/fs/hfsplus/attributes.c
@@ -0,0 +1,399 @@
+/*
+ * linux/fs/hfsplus/attributes.c
+ *
+ * Vyacheslav Dubeyko <slava@dubeyko.com>
+ *
+ * Handling of records in attributes tree
+ */
+
+#include "hfsplus_fs.h"
+#include "hfsplus_raw.h"
+
+static struct kmem_cache *hfsplus_attr_tree_cachep;
+
+int hfsplus_create_attr_tree_cache(void)
+{
+	if (hfsplus_attr_tree_cachep)
+		return -EEXIST;
+
+	hfsplus_attr_tree_cachep =
+		kmem_cache_create("hfsplus_attr_cache",
+			sizeof(hfsplus_attr_entry), 0,
+			SLAB_HWCACHE_ALIGN, NULL);
+	if (!hfsplus_attr_tree_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void hfsplus_destroy_attr_tree_cache(void)
+{
+	kmem_cache_destroy(hfsplus_attr_tree_cachep);
+}
+
+int hfsplus_attr_bin_cmp_key(const hfsplus_btree_key *k1,
+				const hfsplus_btree_key *k2)
+{
+	__be32 k1_cnid, k2_cnid;
+
+	k1_cnid = k1->attr.cnid;
+	k2_cnid = k2->attr.cnid;
+	if (k1_cnid != k2_cnid)
+		return be32_to_cpu(k1_cnid) < be32_to_cpu(k2_cnid) ? -1 : 1;
+
+	return hfsplus_strcmp(
+			(const struct hfsplus_unistr *)&k1->attr.key_name,
+			(const struct hfsplus_unistr *)&k2->attr.key_name);
+}
+
+int hfsplus_attr_build_key(struct super_block *sb, hfsplus_btree_key *key,
+			u32 cnid, const char *name)
+{
+	int len;
+
+	memset(key, 0, sizeof(struct hfsplus_attr_key));
+	key->attr.cnid = cpu_to_be32(cnid);
+	if (name) {
+		len = strlen(name);
+		if (len > HFSPLUS_ATTR_MAX_STRLEN) {
+			printk(KERN_ERR "hfs: invalid xattr name's length\n");
+			return -EINVAL;
+		}
+		hfsplus_asc2uni(sb,
+				(struct hfsplus_unistr *)&key->attr.key_name,
+				HFSPLUS_ATTR_MAX_STRLEN, name, len);
+		len = be16_to_cpu(key->attr.key_name.length);
+	} else {
+		key->attr.key_name.length = 0;
+		len = 0;
+	}
+
+	/* The length of the key, as stored in key_len field, does not include
+	 * the size of the key_len field itself.
+	 * So, offsetof(hfsplus_attr_key, key_name) is a trick because
+	 * it takes into consideration key_len field (__be16) of
+	 * hfsplus_attr_key structure instead of length field (__be16) of
+	 * hfsplus_attr_unistr structure.
+	 */
+	key->key_len =
+		cpu_to_be16(offsetof(struct hfsplus_attr_key, key_name) +
+				2 * len);
+
+	return 0;
+}
+
+void hfsplus_attr_build_key_uni(hfsplus_btree_key *key,
+					u32 cnid,
+					struct hfsplus_attr_unistr *name)
+{
+	int ustrlen;
+
+	memset(key, 0, sizeof(struct hfsplus_attr_key));
+	ustrlen = be16_to_cpu(name->length);
+	key->attr.cnid = cpu_to_be32(cnid);
+	key->attr.key_name.length = cpu_to_be16(ustrlen);
+	ustrlen *= 2;
+	memcpy(key->attr.key_name.unicode, name->unicode, ustrlen);
+
+	/* The length of the key, as stored in key_len field, does not include
+	 * the size of the key_len field itself.
+	 * So, offsetof(hfsplus_attr_key, key_name) is a trick because
+	 * it takes into consideration key_len field (__be16) of
+	 * hfsplus_attr_key structure instead of length field (__be16) of
+	 * hfsplus_attr_unistr structure.
+	 */
+	key->key_len =
+		cpu_to_be16(offsetof(struct hfsplus_attr_key, key_name) +
+				ustrlen);
+}
+
+hfsplus_attr_entry *hfsplus_alloc_attr_entry(void)
+{
+	return kmem_cache_alloc(hfsplus_attr_tree_cachep, GFP_KERNEL);
+}
+
+void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry)
+{
+	if (entry)
+		kmem_cache_free(hfsplus_attr_tree_cachep, entry);
+}
+
+#define HFSPLUS_INVALID_ATTR_RECORD -1
+
+static int hfsplus_attr_build_record(hfsplus_attr_entry *entry, int record_type,
+				u32 cnid, const void *value, size_t size)
+{
+	if (record_type == HFSPLUS_ATTR_FORK_DATA) {
+		/*
+		 * Mac OS X supports only inline data attributes.
+		 * Do nothing
+		 */
+		memset(entry, 0, sizeof(*entry));
+		return sizeof(struct hfsplus_attr_fork_data);
+	} else if (record_type == HFSPLUS_ATTR_EXTENTS) {
+		/*
+		 * Mac OS X supports only inline data attributes.
+		 * Do nothing.
+		 */
+		memset(entry, 0, sizeof(*entry));
+		return sizeof(struct hfsplus_attr_extents);
+	} else if (record_type == HFSPLUS_ATTR_INLINE_DATA) {
+		u16 len;
+
+		memset(entry, 0, sizeof(struct hfsplus_attr_inline_data));
+		entry->inline_data.record_type = cpu_to_be32(record_type);
+		if (size <= HFSPLUS_MAX_INLINE_DATA_SIZE)
+			len = size;
+		else
+			return HFSPLUS_INVALID_ATTR_RECORD;
+		entry->inline_data.length = cpu_to_be16(len);
+		memcpy(entry->inline_data.raw_bytes, value, len);
+		/*
+		 * Align len on two-byte boundary.
+		 * It needs to add pad byte if we have odd len.
+		 */
+		len = round_up(len, 2);
+		return offsetof(struct hfsplus_attr_inline_data, raw_bytes) +
+					len;
+	} else /* invalid input */
+		memset(entry, 0, sizeof(*entry));
+
+	return HFSPLUS_INVALID_ATTR_RECORD;
+}
+
+int hfsplus_find_attr(struct super_block *sb, u32 cnid,
+			const char *name, struct hfs_find_data *fd)
+{
+	int err = 0;
+
+	dprint(DBG_ATTR_MOD, "find_attr: %s,%d\n", name ? name : NULL, cnid);
+
+	if (!HFSPLUS_SB(sb)->attr_tree) {
+		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		return -EINVAL;
+	}
+
+	if (name) {
+		err = hfsplus_attr_build_key(sb, fd->search_key, cnid, name);
+		if (err)
+			goto failed_find_attr;
+		err = hfs_brec_find(fd, hfs_find_rec_by_key);
+		if (err)
+			goto failed_find_attr;
+	} else {
+		err = hfsplus_attr_build_key(sb, fd->search_key, cnid, NULL);
+		if (err)
+			goto failed_find_attr;
+		err = hfs_brec_find(fd, hfs_find_1st_rec_by_cnid);
+		if (err)
+			goto failed_find_attr;
+	}
+
+failed_find_attr:
+	return err;
+}
+
+int hfsplus_attr_exists(struct inode *inode, const char *name)
+{
+	int err = 0;
+	struct super_block *sb = inode->i_sb;
+	struct hfs_find_data fd;
+
+	if (!HFSPLUS_SB(sb)->attr_tree)
+		return 0;
+
+	err = hfs_find_init(HFSPLUS_SB(sb)->attr_tree, &fd);
+	if (err)
+		return 0;
+
+	err = hfsplus_find_attr(sb, inode->i_ino, name, &fd);
+	if (err)
+		goto attr_not_found;
+
+	hfs_find_exit(&fd);
+	return 1;
+
+attr_not_found:
+	hfs_find_exit(&fd);
+	return 0;
+}
+
+int hfsplus_create_attr(struct inode *inode,
+				const char *name,
+				const void *value, size_t size)
+{
+	struct super_block *sb = inode->i_sb;
+	struct hfs_find_data fd;
+	hfsplus_attr_entry *entry_ptr;
+	int entry_size;
+	int err;
+
+	dprint(DBG_ATTR_MOD, "create_attr: %s,%ld\n",
+		name ? name : NULL, inode->i_ino);
+
+	if (!HFSPLUS_SB(sb)->attr_tree) {
+		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		return -EINVAL;
+	}
+
+	entry_ptr = hfsplus_alloc_attr_entry();
+	if (!entry_ptr)
+		return -ENOMEM;
+
+	err = hfs_find_init(HFSPLUS_SB(sb)->attr_tree, &fd);
+	if (err)
+		goto failed_init_create_attr;
+
+	if (name) {
+		err = hfsplus_attr_build_key(sb, fd.search_key,
+						inode->i_ino, name);
+		if (err)
+			goto failed_create_attr;
+	} else {
+		err = -EINVAL;
+		goto failed_create_attr;
+	}
+
+	/* Mac OS X supports only inline data attributes. */
+	entry_size = hfsplus_attr_build_record(entry_ptr,
+					HFSPLUS_ATTR_INLINE_DATA,
+					inode->i_ino,
+					value, size);
+	if (entry_size == HFSPLUS_INVALID_ATTR_RECORD) {
+		err = -EINVAL;
+		goto failed_create_attr;
+	}
+
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
+	if (err != -ENOENT) {
+		if (!err)
+			err = -EEXIST;
+		goto failed_create_attr;
+	}
+
+	err = hfs_brec_insert(&fd, entry_ptr, entry_size);
+	if (err)
+		goto failed_create_attr;
+
+	hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ATTR_DIRTY);
+
+failed_create_attr:
+	hfs_find_exit(&fd);
+
+failed_init_create_attr:
+	hfsplus_destroy_attr_entry(entry_ptr);
+	return err;
+}
+
+static int __hfsplus_delete_attr(struct inode *inode, u32 cnid,
+					struct hfs_find_data *fd)
+{
+	int err = 0;
+	__be32 found_cnid, record_type;
+
+	hfs_bnode_read(fd->bnode, &found_cnid,
+			fd->keyoffset +
+			offsetof(struct hfsplus_attr_key, cnid),
+			sizeof(__be32));
+	if (cnid != be32_to_cpu(found_cnid))
+		return -ENOENT;
+
+	hfs_bnode_read(fd->bnode, &record_type,
+			fd->entryoffset, sizeof(record_type));
+
+	switch (be32_to_cpu(record_type)) {
+	case HFSPLUS_ATTR_INLINE_DATA:
+		/* All is OK. Do nothing. */
+		break;
+	case HFSPLUS_ATTR_FORK_DATA:
+	case HFSPLUS_ATTR_EXTENTS:
+		printk(KERN_ERR "hfs: only inline data xattr are supported\n");
+		return -EOPNOTSUPP;
+	default:
+		printk(KERN_ERR "hfs: invalid extended attribute record\n");
+		return -ENOENT;
+	}
+
+	err = hfs_brec_remove(fd);
+	if (err)
+		return err;
+
+	hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ATTR_DIRTY);
+	return err;
+}
+
+int hfsplus_delete_attr(struct inode *inode, const char *name)
+{
+	int err = 0;
+	struct super_block *sb = inode->i_sb;
+	struct hfs_find_data fd;
+
+	dprint(DBG_ATTR_MOD, "delete_attr: %s,%ld\n",
+		name ? name : NULL, inode->i_ino);
+
+	if (!HFSPLUS_SB(sb)->attr_tree) {
+		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		return -EINVAL;
+	}
+
+	err = hfs_find_init(HFSPLUS_SB(sb)->attr_tree, &fd);
+	if (err)
+		return err;
+
+	if (name) {
+		err = hfsplus_attr_build_key(sb, fd.search_key,
+						inode->i_ino, name);
+		if (err)
+			goto out;
+	} else {
+		printk(KERN_ERR "hfs: invalid extended attribute name\n");
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = hfs_brec_find(&fd, hfs_find_rec_by_key);
+	if (err)
+		goto out;
+
+	err = __hfsplus_delete_attr(inode, inode->i_ino, &fd);
+	if (err)
+		goto out;
+
+out:
+	hfs_find_exit(&fd);
+	return err;
+}
+
+int hfsplus_delete_all_attrs(struct inode *dir, u32 cnid)
+{
+	int err = 0;
+	struct hfs_find_data fd;
+
+	dprint(DBG_ATTR_MOD, "delete_all_attrs: %d\n", cnid);
+
+	if (!HFSPLUS_SB(dir->i_sb)->attr_tree) {
+		printk(KERN_ERR "hfs: attributes file doesn't exist\n");
+		return -EINVAL;
+	}
+
+	err = hfs_find_init(HFSPLUS_SB(dir->i_sb)->attr_tree, &fd);
+	if (err)
+		return err;
+
+	for (;;) {
+		err = hfsplus_find_attr(dir->i_sb, cnid, NULL, &fd);
+		if (err) {
+			if (err != -ENOENT)
+				printk(KERN_ERR "hfs: xattr search failed.\n");
+			goto end_delete_all;
+		}
+
+		err = __hfsplus_delete_attr(dir, cnid, &fd);
+		if (err)
+			goto end_delete_all;
+	}
+
+end_delete_all:
+	hfs_find_exit(&fd);
+	return err;
+}
-- 
1.7.9.5



