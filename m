Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2KZKgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:36:13 -0500
Received: from 173-254-64-10.unifiedlayer.com ([173.254.64.10]:41339 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754888Ab2KZKgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:36:10 -0500
Message-ID: <1353926165.2025.41.camel@slavad-ubuntu>
Subject: [PATCH v3 2/5] hfsplus: add on-disk layout declarations related to
 attributes tree
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Hin-Tak Leung <htl10@users.sourceforge.net>
Date: Mon, 26 Nov 2012 14:36:05 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.49.123 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds all necessary on-disk layout declarations related to attributes file.

With the best regards,
Vyacheslav Dubeyko.
---
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH v3 2/5] hfsplus: add on-disk layout declarations related to attributes tree

This patch adds all necessary on-disk layout declarations related to attributes file.

Reported-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/hfsplus/hfsplus_raw.h |   68 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/hfsplus_raw.h b/fs/hfsplus/hfsplus_raw.h
index 921967e..452ede0 100644
--- a/fs/hfsplus/hfsplus_raw.h
+++ b/fs/hfsplus/hfsplus_raw.h
@@ -52,13 +52,23 @@
 typedef __be32 hfsplus_cnid;
 typedef __be16 hfsplus_unichr;
 
+#define HFSPLUS_MAX_STRLEN 255
+#define HFSPLUS_ATTR_MAX_STRLEN 127
+
 /* A "string" as used in filenames, etc. */
 struct hfsplus_unistr {
 	__be16 length;
-	hfsplus_unichr unicode[255];
+	hfsplus_unichr unicode[HFSPLUS_MAX_STRLEN];
 } __packed;
 
-#define HFSPLUS_MAX_STRLEN 255
+/*
+ * A "string" is used in attributes file
+ * for name of extended attribute
+ */
+struct hfsplus_attr_unistr {
+	__be16 length;
+	hfsplus_unichr unicode[HFSPLUS_ATTR_MAX_STRLEN];
+} __packed;
 
 /* POSIX permissions */
 struct hfsplus_perm {
@@ -291,6 +301,8 @@ struct hfsplus_cat_file {
 /* File attribute bits */
 #define HFSPLUS_FILE_LOCKED		0x0001
 #define HFSPLUS_FILE_THREAD_EXISTS	0x0002
+#define HFSPLUS_XATTR_EXISTS		0x0004
+#define HFSPLUS_ACL_EXISTS		0x0008
 
 /* HFS+ catalog thread (part of a cat_entry) */
 struct hfsplus_cat_thread {
@@ -327,11 +339,63 @@ struct hfsplus_ext_key {
 
 #define HFSPLUS_EXT_KEYLEN	sizeof(struct hfsplus_ext_key)
 
+#define HFSPLUS_XATTR_FINDER_INFO_NAME "com.apple.FinderInfo"
+#define HFSPLUS_XATTR_ACL_NAME "com.apple.system.Security"
+
+#define HFSPLUS_ATTR_INLINE_DATA 0x10
+#define HFSPLUS_ATTR_FORK_DATA   0x20
+#define HFSPLUS_ATTR_EXTENTS     0x30
+
+/* HFS+ attributes tree key */
+struct hfsplus_attr_key {
+	__be16 key_len;
+	__be16 pad;
+	hfsplus_cnid cnid;
+	__be32 start_block;
+	struct hfsplus_attr_unistr key_name;
+} __packed;
+
+#define HFSPLUS_ATTR_KEYLEN	sizeof(struct hfsplus_attr_key)
+
+/* HFS+ fork data attribute */
+struct hfsplus_attr_fork_data {
+	__be32 record_type;
+	__be32 reserved;
+	struct hfsplus_fork_raw the_fork;
+} __packed;
+
+/* HFS+ extension attribute */
+struct hfsplus_attr_extents {
+	__be32 record_type;
+	__be32 reserved;
+	struct hfsplus_extent extents;
+} __packed;
+
+#define HFSPLUS_MAX_INLINE_DATA_SIZE 3802
+
+/* HFS+ attribute inline data */
+struct hfsplus_attr_inline_data {
+	__be32 record_type;
+	__be32 reserved1;
+	u8 reserved2[6];
+	__be16 length;
+	u8 raw_bytes[HFSPLUS_MAX_INLINE_DATA_SIZE];
+} __packed;
+
+/* A data record in the attributes tree */
+typedef union {
+	__be32 record_type;
+	struct hfsplus_attr_fork_data fork_data;
+	struct hfsplus_attr_extents extents;
+	struct hfsplus_attr_inline_data inline_data;
+} __packed hfsplus_attr_entry;
+
 /* HFS+ generic BTree key */
 typedef union {
 	__be16 key_len;
 	struct hfsplus_cat_key cat;
 	struct hfsplus_ext_key ext;
+	struct hfsplus_attr_key attr;
 } __packed hfsplus_btree_key;
 
 #endif
-- 
1.7.9.5



