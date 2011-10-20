Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1JTCj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:39:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45852 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1JTCj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:39:26 -0400
MIME-Version: 1.0
Date: Thu, 20 Oct 2011 10:39:24 +0800
Message-ID: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com>
Subject: [PATCH] ACL supports to mqueue
From: Zhou Peng <ailvpeng25@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015174c1962606f9104afb1dd8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c1962606f9104afb1dd8f
Content-Type: text/plain; charset=ISO-8859-1

This patch adds ACL supports to mqueue filesystem.
Based on Linux 3.0.4.

Signed-off-by: Zhou Peng <zhoupeng@nfs.iscas.ac.cn>

diff --git a/fs/Kconfig b/fs/Kconfig
index 19891aa..dbf0aca 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -151,6 +151,14 @@ config TMPFS_XATTR

 	  If unsure, say N.

+config MQUEUE_POSIX_ACL
+       bool "Mqueue POSIX Access Control Lists support"
+       depends on POSIX_MQUEUE
+       select GENERIC_ACL
+       help
+         Mqueue is a file system which is used to suport POSIX msg queue.
+	 Say y to get Access Control Lists support for mqueue file system.
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 14fb6d6..e9d7ea9 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -10,6 +10,9 @@
  *
  * Audit:                   George Wilson           (ltcgcw@us.ibm.com)
  *
+ * ACL:
+ * Copyright (c) 2011       Zhou Peng               (ailvpeng25@gmail.com)
+ *
  * This file is released under the GPL.
  */

@@ -33,6 +36,9 @@
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
+#include <linux/posix_acl.h>
+#include <linux/generic_acl.h>

 #include <net/sock.h>
 #include "util.h"
@@ -76,6 +82,9 @@ struct mqueue_inode_info {
 };

 static const struct inode_operations mqueue_dir_inode_operations;
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static const struct inode_operations mqueue_inode_operations;
+#endif
 static const struct file_operations mqueue_file_operations;
 static const struct super_operations mqueue_super_ops;
 static void remove_notification(struct mqueue_inode_info *info);
@@ -84,6 +93,14 @@ static struct kmem_cache *mqueue_inode_cachep;

 static struct ctl_table_header * mq_sysctl_table;

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static const struct xattr_handler *mqueue_xattr_handlers[] = {
+	&generic_acl_access_handler,
+	&generic_acl_default_handler,
+	NULL
+};
+#endif
+
 static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
 {
 	return container_of(inode, struct mqueue_inode_info, vfs_inode);
@@ -122,12 +139,19 @@ static struct inode *mqueue_get_inode(struct
super_block *sb,
 		inode->i_gid = current_fsgid();
 		inode->i_mtime = inode->i_ctime = inode->i_atime =
 				CURRENT_TIME;
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+		cache_no_acl(inode);
+#endif

 		if (S_ISREG(mode)) {
 			struct mqueue_inode_info *info;
 			struct task_struct *p = current;
 			unsigned long mq_bytes, mq_msg_tblsz;

+#ifdef CONFIG_MQUEUE_POSIX_ACL			
+			inode->i_op = &mqueue_inode_operations;
+#endif
+
 			inode->i_fop = &mqueue_file_operations;
 			inode->i_size = FILENT_SIZE;
 			/* mqueue specific info */
@@ -192,6 +216,11 @@ static int mqueue_fill_super(struct super_block
*sb, void *data, int silent)
 	sb->s_magic = MQUEUE_MAGIC;
 	sb->s_op = &mqueue_super_ops;

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	sb->s_xattr = mqueue_xattr_handlers;
+	sb->s_flags |= MS_POSIXACL;
+#endif
+
 	inode = mqueue_get_inode(sb, ns, S_IFDIR | S_ISVTX | S_IRWXUGO,
 				NULL);
 	if (!inode) {
@@ -322,6 +351,16 @@ static int mqueue_create(struct inode *dir,
struct dentry *dentry,
 		goto out_unlock;
 	}

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	error = generic_acl_init(inode, dir);
+	if (error) {
+		iput(inode);
+		spin_lock(&mq_lock);
+		ipc_ns->mq_queues_count--;
+		goto out_unlock;
+	}
+#endif
+
 	put_ipc_ns(ipc_ns);
 	dir->i_size += DIRENT_SIZE;
 	dir->i_ctime = dir->i_mtime = dir->i_atime = CURRENT_TIME;
@@ -1217,10 +1256,46 @@ out:
 	return ret;
 }

+#ifdef CONFIG_MQUEUE_POSIX_ACL
+static int mqueue_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = simple_setattr(dentry, attr);
+	if (error)
+		return error;
+
+	if (attr->ia_valid & ATTR_MODE)
+		error = generic_acl_chmod(inode);
+
+	return error;
+}
+#endif
+
 static const struct inode_operations mqueue_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.create = mqueue_create,
 	.unlink = mqueue_unlink,
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	.setxattr    = generic_setxattr,
+	.getxattr    = generic_getxattr,
+	.listxattr   = generic_listxattr,
+	.removexattr = generic_removexattr,
+	.check_acl   = generic_check_acl,
+	.setattr     = mqueue_setattr,
+#endif
+};
+
+static const struct inode_operations mqueue_inode_operations = {
+#ifdef CONFIG_MQUEUE_POSIX_ACL
+	.setxattr    = generic_setxattr,
+	.getxattr    = generic_getxattr,
+	.listxattr   = generic_listxattr,
+	.removexattr = generic_removexattr,
+	.check_acl   = generic_check_acl,
+	.setattr     = mqueue_setattr,
+#endif
 };

 static const struct file_operations mqueue_file_operations = {

--
Zhou Peng

--0015174c1962606f9104afb1dd8f
Content-Type: text/x-patch; charset=US-ASCII; name="posix_msg_queue_acl_linux 3.0.4.diff"
Content-Disposition: attachment; 
	filename="posix_msg_queue_acl_linux 3.0.4.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtz550wb0

VGhpcyBwYXRjaCBhZGRzIEFDTCBzdXBwb3J0cyB0byBtcXVldWUgZmlsZXN5c3RlbS4KQmFzZWQg
b24gTGludXggMy4wLjQuCgpTaWduZWQtb2ZmLWJ5OiBaaG91IFBlbmcgPHpob3VwZW5nQG5mcy5p
c2Nhcy5hYy5jbj4KCmRpZmYgLS1naXQgYS9mcy9LY29uZmlnIGIvZnMvS2NvbmZpZwppbmRleCAx
OTg5MWFhLi5kYmYwYWNhIDEwMDY0NAotLS0gYS9mcy9LY29uZmlnCisrKyBiL2ZzL0tjb25maWcK
QEAgLTE1MSw2ICsxNTEsMTQgQEAgY29uZmlnIFRNUEZTX1hBVFRSCiAKIAkgIElmIHVuc3VyZSwg
c2F5IE4uCiAKK2NvbmZpZyBNUVVFVUVfUE9TSVhfQUNMCisgICAgICAgYm9vbCAiTXF1ZXVlIFBP
U0lYIEFjY2VzcyBDb250cm9sIExpc3RzIHN1cHBvcnQiCisgICAgICAgZGVwZW5kcyBvbiBQT1NJ
WF9NUVVFVUUKKyAgICAgICBzZWxlY3QgR0VORVJJQ19BQ0wKKyAgICAgICBoZWxwCisgICAgICAg
ICBNcXVldWUgaXMgYSBmaWxlIHN5c3RlbSB3aGljaCBpcyB1c2VkIHRvIHN1cG9ydCBQT1NJWCBt
c2cgcXVldWUuCisJIFNheSB5IHRvIGdldCBBY2Nlc3MgQ29udHJvbCBMaXN0cyBzdXBwb3J0IGZv
ciBtcXVldWUgZmlsZSBzeXN0ZW0uCisKIGNvbmZpZyBIVUdFVExCRlMKIAlib29sICJIdWdlVExC
IGZpbGUgc3lzdGVtIHN1cHBvcnQiCiAJZGVwZW5kcyBvbiBYODYgfHwgSUE2NCB8fCBTUEFSQzY0
IHx8IChTMzkwICYmIDY0QklUKSB8fCBcCmRpZmYgLS1naXQgYS9pcGMvbXF1ZXVlLmMgYi9pcGMv
bXF1ZXVlLmMKaW5kZXggMTRmYjZkNi4uZTlkN2VhOSAxMDA2NDQKLS0tIGEvaXBjL21xdWV1ZS5j
CisrKyBiL2lwYy9tcXVldWUuYwpAQCAtMTAsNiArMTAsOSBAQAogICoKICAqIEF1ZGl0OiAgICAg
ICAgICAgICAgICAgICBHZW9yZ2UgV2lsc29uICAgICAgICAgICAobHRjZ2N3QHVzLmlibS5jb20p
CiAgKgorICogQUNMOgorICogQ29weXJpZ2h0IChjKSAyMDExICAgICAgIFpob3UgUGVuZyAgICAg
ICAgICAgICAgIChhaWx2cGVuZzI1QGdtYWlsLmNvbSkKKyAqCiAgKiBUaGlzIGZpbGUgaXMgcmVs
ZWFzZWQgdW5kZXIgdGhlIEdQTC4KICAqLwogCkBAIC0zMyw2ICszNiw5IEBACiAjaW5jbHVkZSA8
bGludXgvcGlkLmg+CiAjaW5jbHVkZSA8bGludXgvaXBjX25hbWVzcGFjZS5oPgogI2luY2x1ZGUg
PGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC94YXR0ci5oPgorI2luY2x1ZGUgPGxpbnV4
L3Bvc2l4X2FjbC5oPgorI2luY2x1ZGUgPGxpbnV4L2dlbmVyaWNfYWNsLmg+CiAKICNpbmNsdWRl
IDxuZXQvc29jay5oPgogI2luY2x1ZGUgInV0aWwuaCIKQEAgLTc2LDYgKzgyLDkgQEAgc3RydWN0
IG1xdWV1ZV9pbm9kZV9pbmZvIHsKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3Bl
cmF0aW9ucyBtcXVldWVfZGlyX2lub2RlX29wZXJhdGlvbnM7CisjaWZkZWYgQ09ORklHX01RVUVV
RV9QT1NJWF9BQ0wKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3BlcmF0aW9ucyBtcXVldWVf
aW5vZGVfb3BlcmF0aW9uczsKKyNlbmRpZgogc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJh
dGlvbnMgbXF1ZXVlX2ZpbGVfb3BlcmF0aW9uczsKIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3VwZXJf
b3BlcmF0aW9ucyBtcXVldWVfc3VwZXJfb3BzOwogc3RhdGljIHZvaWQgcmVtb3ZlX25vdGlmaWNh
dGlvbihzdHJ1Y3QgbXF1ZXVlX2lub2RlX2luZm8gKmluZm8pOwpAQCAtODQsNiArOTMsMTQgQEAg
c3RhdGljIHN0cnVjdCBrbWVtX2NhY2hlICptcXVldWVfaW5vZGVfY2FjaGVwOwogCiBzdGF0aWMg
c3RydWN0IGN0bF90YWJsZV9oZWFkZXIgKiBtcV9zeXNjdGxfdGFibGU7CiAKKyNpZmRlZiBDT05G
SUdfTVFVRVVFX1BPU0lYX0FDTAorc3RhdGljIGNvbnN0IHN0cnVjdCB4YXR0cl9oYW5kbGVyICpt
cXVldWVfeGF0dHJfaGFuZGxlcnNbXSA9IHsKKwkmZ2VuZXJpY19hY2xfYWNjZXNzX2hhbmRsZXIs
CisJJmdlbmVyaWNfYWNsX2RlZmF1bHRfaGFuZGxlciwKKwlOVUxMCit9OworI2VuZGlmCisKIHN0
YXRpYyBpbmxpbmUgc3RydWN0IG1xdWV1ZV9pbm9kZV9pbmZvICpNUVVFVUVfSShzdHJ1Y3QgaW5v
ZGUgKmlub2RlKQogewogCXJldHVybiBjb250YWluZXJfb2YoaW5vZGUsIHN0cnVjdCBtcXVldWVf
aW5vZGVfaW5mbywgdmZzX2lub2RlKTsKQEAgLTEyMiwxMiArMTM5LDE5IEBAIHN0YXRpYyBzdHJ1
Y3QgaW5vZGUgKm1xdWV1ZV9nZXRfaW5vZGUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYiwKIAkJaW5v
ZGUtPmlfZ2lkID0gY3VycmVudF9mc2dpZCgpOwogCQlpbm9kZS0+aV9tdGltZSA9IGlub2RlLT5p
X2N0aW1lID0gaW5vZGUtPmlfYXRpbWUgPQogCQkJCUNVUlJFTlRfVElNRTsKKyNpZmRlZiBDT05G
SUdfTVFVRVVFX1BPU0lYX0FDTAorCQljYWNoZV9ub19hY2woaW5vZGUpOworI2VuZGlmCiAKIAkJ
aWYgKFNfSVNSRUcobW9kZSkpIHsKIAkJCXN0cnVjdCBtcXVldWVfaW5vZGVfaW5mbyAqaW5mbzsK
IAkJCXN0cnVjdCB0YXNrX3N0cnVjdCAqcCA9IGN1cnJlbnQ7CiAJCQl1bnNpZ25lZCBsb25nIG1x
X2J5dGVzLCBtcV9tc2dfdGJsc3o7CiAKKyNpZmRlZiBDT05GSUdfTVFVRVVFX1BPU0lYX0FDTAkJ
CQorCQkJaW5vZGUtPmlfb3AgPSAmbXF1ZXVlX2lub2RlX29wZXJhdGlvbnM7CisjZW5kaWYKKwog
CQkJaW5vZGUtPmlfZm9wID0gJm1xdWV1ZV9maWxlX29wZXJhdGlvbnM7CiAJCQlpbm9kZS0+aV9z
aXplID0gRklMRU5UX1NJWkU7CiAJCQkvKiBtcXVldWUgc3BlY2lmaWMgaW5mbyAqLwpAQCAtMTky
LDYgKzIxNiwxMSBAQCBzdGF0aWMgaW50IG1xdWV1ZV9maWxsX3N1cGVyKHN0cnVjdCBzdXBlcl9i
bG9jayAqc2IsIHZvaWQgKmRhdGEsIGludCBzaWxlbnQpCiAJc2ItPnNfbWFnaWMgPSBNUVVFVUVf
TUFHSUM7CiAJc2ItPnNfb3AgPSAmbXF1ZXVlX3N1cGVyX29wczsKIAorI2lmZGVmIENPTkZJR19N
UVVFVUVfUE9TSVhfQUNMCisJc2ItPnNfeGF0dHIgPSBtcXVldWVfeGF0dHJfaGFuZGxlcnM7CisJ
c2ItPnNfZmxhZ3MgfD0gTVNfUE9TSVhBQ0w7CisjZW5kaWYKKwogCWlub2RlID0gbXF1ZXVlX2dl
dF9pbm9kZShzYiwgbnMsIFNfSUZESVIgfCBTX0lTVlRYIHwgU19JUldYVUdPLAogCQkJCU5VTEwp
OwogCWlmICghaW5vZGUpIHsKQEAgLTMyMiw2ICszNTEsMTYgQEAgc3RhdGljIGludCBtcXVldWVf
Y3JlYXRlKHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnksCiAJCWdvdG8g
b3V0X3VubG9jazsKIAl9CiAKKyNpZmRlZiBDT05GSUdfTVFVRVVFX1BPU0lYX0FDTAorCWVycm9y
ID0gZ2VuZXJpY19hY2xfaW5pdChpbm9kZSwgZGlyKTsKKwlpZiAoZXJyb3IpIHsKKwkJaXB1dChp
bm9kZSk7CisJCXNwaW5fbG9jaygmbXFfbG9jayk7CisJCWlwY19ucy0+bXFfcXVldWVzX2NvdW50
LS07CisJCWdvdG8gb3V0X3VubG9jazsKKwl9CisjZW5kaWYKKwogCXB1dF9pcGNfbnMoaXBjX25z
KTsKIAlkaXItPmlfc2l6ZSArPSBESVJFTlRfU0laRTsKIAlkaXItPmlfY3RpbWUgPSBkaXItPmlf
bXRpbWUgPSBkaXItPmlfYXRpbWUgPSBDVVJSRU5UX1RJTUU7CkBAIC0xMjE3LDEwICsxMjU2LDQ2
IEBAIG91dDoKIAlyZXR1cm4gcmV0OwogfQogCisjaWZkZWYgQ09ORklHX01RVUVVRV9QT1NJWF9B
Q0wKK3N0YXRpYyBpbnQgbXF1ZXVlX3NldGF0dHIoc3RydWN0IGRlbnRyeSAqZGVudHJ5LCBzdHJ1
Y3QgaWF0dHIgKmF0dHIpCit7CisJc3RydWN0IGlub2RlICppbm9kZSA9IGRlbnRyeS0+ZF9pbm9k
ZTsKKwlpbnQgZXJyb3I7CisKKwllcnJvciA9IHNpbXBsZV9zZXRhdHRyKGRlbnRyeSwgYXR0cik7
CisJaWYgKGVycm9yKQorCQlyZXR1cm4gZXJyb3I7CisKKwlpZiAoYXR0ci0+aWFfdmFsaWQgJiBB
VFRSX01PREUpCisJCWVycm9yID0gZ2VuZXJpY19hY2xfY2htb2QoaW5vZGUpOworCisJcmV0dXJu
IGVycm9yOworfQorI2VuZGlmCisKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3BlcmF0aW9u
cyBtcXVldWVfZGlyX2lub2RlX29wZXJhdGlvbnMgPSB7CiAJLmxvb2t1cCA9IHNpbXBsZV9sb29r
dXAsCiAJLmNyZWF0ZSA9IG1xdWV1ZV9jcmVhdGUsCiAJLnVubGluayA9IG1xdWV1ZV91bmxpbmss
CisjaWZkZWYgQ09ORklHX01RVUVVRV9QT1NJWF9BQ0wKKwkuc2V0eGF0dHIgICAgPSBnZW5lcmlj
X3NldHhhdHRyLAorCS5nZXR4YXR0ciAgICA9IGdlbmVyaWNfZ2V0eGF0dHIsCisJLmxpc3R4YXR0
ciAgID0gZ2VuZXJpY19saXN0eGF0dHIsCisJLnJlbW92ZXhhdHRyID0gZ2VuZXJpY19yZW1vdmV4
YXR0ciwKKwkuY2hlY2tfYWNsICAgPSBnZW5lcmljX2NoZWNrX2FjbCwKKwkuc2V0YXR0ciAgICAg
PSBtcXVldWVfc2V0YXR0ciwKKyNlbmRpZgorfTsKKworc3RhdGljIGNvbnN0IHN0cnVjdCBpbm9k
ZV9vcGVyYXRpb25zIG1xdWV1ZV9pbm9kZV9vcGVyYXRpb25zID0geworI2lmZGVmIENPTkZJR19N
UVVFVUVfUE9TSVhfQUNMCisJLnNldHhhdHRyICAgID0gZ2VuZXJpY19zZXR4YXR0ciwKKwkuZ2V0
eGF0dHIgICAgPSBnZW5lcmljX2dldHhhdHRyLAorCS5saXN0eGF0dHIgICA9IGdlbmVyaWNfbGlz
dHhhdHRyLAorCS5yZW1vdmV4YXR0ciA9IGdlbmVyaWNfcmVtb3ZleGF0dHIsCisJLmNoZWNrX2Fj
bCAgID0gZ2VuZXJpY19jaGVja19hY2wsCisJLnNldGF0dHIgICAgID0gbXF1ZXVlX3NldGF0dHIs
CisjZW5kaWYKIH07CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIG1xdWV1
ZV9maWxlX29wZXJhdGlvbnMgPSB7Cg==
--0015174c1962606f9104afb1dd8f--
