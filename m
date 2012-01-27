Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2A0AjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:39:01 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33565 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab2A0Aih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:38:37 -0500
From: Kees Cook <kees@ubuntu.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Johansen <john.johansen@canonical.com>,
        Kees Cook <kees@outflux.net>
Subject: [PATCH 2/4] AppArmor: add initial "features" directory to securityfs
Date: Thu, 26 Jan 2012 16:29:21 -0800
Message-Id: <1327624163-21576-3-git-send-email-kees@ubuntu.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees@outflux.net>

This adds the "features" subdirectory to the AppArmor securityfs
to display boolean features flags and the known capability mask.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
 security/apparmor/apparmorfs.c         |   52 ++++++++++++++++++++++++++++++++
 security/apparmor/include/apparmorfs.h |   14 ++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 1e22bb3..36efe64 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -18,6 +18,7 @@
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
 #include <linux/namei.h>
+#include <linux/capability.h>
 
 #include "include/apparmor.h"
 #include "include/apparmorfs.h"
@@ -142,12 +143,63 @@ static const struct file_operations aa_fs_profile_remove = {
 	.llseek = default_llseek,
 };
 
+static int aa_fs_seq_show(struct seq_file *seq, void *v)
+{
+	struct aa_fs_entry *fs_file = seq->private;
+
+	if (!fs_file)
+		return 0;
+
+	switch (fs_file->v_type) {
+	case AA_FS_TYPE_BOOLEAN:
+		seq_printf(seq, "%s\n", fs_file->v.boolean ? "yes" : "no");
+		break;
+	case AA_FS_TYPE_U64:
+		seq_printf(seq, "%#08lx\n", fs_file->v.u64);
+		break;
+	default:
+		/* Ignore unpritable entry types. */
+		break;
+	}
+
+	return 0;
+}
+
+static int aa_fs_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, aa_fs_seq_show, inode->i_private);
+}
+
+const struct file_operations aa_fs_seq_file_ops = {
+	.owner		= THIS_MODULE,
+	.open		= aa_fs_seq_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /** Base file system setup **/
 
+static struct aa_fs_entry aa_fs_entry_domain[] = {
+	AA_FS_FILE_BOOLEAN("change_hat",	1),
+	AA_FS_FILE_BOOLEAN("change_hatv",	1),
+	AA_FS_FILE_BOOLEAN("change_onexec",	1),
+	AA_FS_FILE_BOOLEAN("change_profile",	1),
+	{ }
+};
+
+static struct aa_fs_entry aa_fs_entry_features[] = {
+	AA_FS_DIR("domain",			aa_fs_entry_domain),
+	AA_FS_FILE_BOOLEAN("namespaces",	1),
+	AA_FS_FILE_U64("capability",		VFS_CAP_FLAGS_MASK),
+	{ }
+};
+
 static struct aa_fs_entry aa_fs_entry_apparmor[] = {
 	AA_FS_FILE_FOPS(".load", 0640, &aa_fs_profile_load),
 	AA_FS_FILE_FOPS(".replace", 0640, &aa_fs_profile_replace),
 	AA_FS_FILE_FOPS(".remove", 0640, &aa_fs_profile_remove),
+	AA_FS_DIR("features", aa_fs_entry_features),
 	{ }
 };
 
diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
index 4fdf02f..16e6545 100644
--- a/security/apparmor/include/apparmorfs.h
+++ b/security/apparmor/include/apparmorfs.h
@@ -16,6 +16,8 @@
 #define __AA_APPARMORFS_H
 
 enum aa_fs_type {
+	AA_FS_TYPE_BOOLEAN,
+	AA_FS_TYPE_U64,
 	AA_FS_TYPE_FOPS,
 	AA_FS_TYPE_DIR,
 };
@@ -28,11 +30,23 @@ struct aa_fs_entry {
 	umode_t mode;
 	enum aa_fs_type v_type;
 	union {
+		bool boolean;
+		unsigned long u64;
 		struct aa_fs_entry *files;
 	} v;
 	const struct file_operations *file_ops;
 };
 
+extern const struct file_operations aa_fs_seq_file_ops;
+
+#define AA_FS_FILE_BOOLEAN(_name, _value) \
+	{ .name = (_name), .mode = 0444, \
+	  .v_type = AA_FS_TYPE_BOOLEAN, .v.boolean = (_value), \
+	  .file_ops = &aa_fs_seq_file_ops }
+#define AA_FS_FILE_U64(_name, _value) \
+	{ .name = (_name), .mode = 0444, \
+	  .v_type = AA_FS_TYPE_U64, .v.u64 = (_value), \
+	  .file_ops = &aa_fs_seq_file_ops }
 #define AA_FS_FILE_FOPS(_name, _mode, _fops) \
 	{ .name = (_name), .v_type = AA_FS_TYPE_FOPS, \
 	  .mode = (_mode), .file_ops = (_fops) }
-- 
1.7.0.4

