Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab1D2Noo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:44:44 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39033 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758724Ab1D2Noj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:44:39 -0400
X-Sasl-enc: w2i0Ep6afRR1mnHkP6u8tLOpmm8F38A9/wS+4PYmEYQR 1304084678
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, zohar@linux.vnet.ibm.com,
        safford@watson.ibm.com, tyhicks@linux.vnet.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        casey@schaufler-ca.com, eparis@redhat.com, sds@tycho.nsa.gov,
        selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk,
        john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 2/4] eCryptfs: introduce per-filesystem credentials
Date: Fri, 29 Apr 2011 15:41:50 +0200
Message-Id: <1304084515-22132-3-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
References: <1304084515-22132-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----9F8F34E9B8D35B62C446B3C4CFAA419A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------9F8F34E9B8D35B62C446B3C4CFAA419A

Each mounted eCryptfs filesystem is associated with a credentials set
obtained by calling the function prepare_kernel_cred(). These prepared
credentials give to eCryptfs root privileges, so that all inodes in the
lower filesystem can be opened even by unprivileged users.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 fs/ecryptfs/Makefile          |    2 +-
 fs/ecryptfs/crypto.c          |    1 +
 fs/ecryptfs/ecryptfs_kernel.h |   21 +----
 fs/ecryptfs/kthread.c         |  197 -----------------------------------------
 fs/ecryptfs/main.c            |   55 +++++++-----
 5 files changed, 36 insertions(+), 240 deletions(-)
 delete mode 100644 fs/ecryptfs/kthread.c

diff --git a/fs/ecryptfs/Makefile b/fs/ecryptfs/Makefile
index 2cc9ee4..aa22276 100644
--- a/fs/ecryptfs/Makefile
+++ b/fs/ecryptfs/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_ECRYPT_FS) += ecryptfs.o
 
-ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o miscdev.o kthread.o debug.o
+ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o miscdev.o debug.o
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index b8d5c80..efb5cbd 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -261,6 +261,7 @@ void ecryptfs_destroy_mount_crypt_stat(
 
 	if (!(mount_crypt_stat->flags & ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED))
 		return;
+	put_cred(mount_crypt_stat->subject_cred);
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	list_for_each_entry_safe(auth_tok, auth_tok_tmp,
 				 &mount_crypt_stat->global_auth_tok_list,
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index e702827..6d9cc17 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -387,6 +387,7 @@ struct ecryptfs_mount_crypt_stat {
 	unsigned char global_default_fn_cipher_name[
 		ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 	char global_default_fnek_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
+	struct cred *subject_cred;
 };
 
 /* superblock private data. */
@@ -610,20 +611,6 @@ extern struct kmem_cache *ecryptfs_key_record_cache;
 extern struct kmem_cache *ecryptfs_key_sig_cache;
 extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
 extern struct kmem_cache *ecryptfs_key_tfm_cache;
-extern struct kmem_cache *ecryptfs_open_req_cache;
-
-struct ecryptfs_open_req {
-#define ECRYPTFS_REQ_PROCESSED 0x00000001
-#define ECRYPTFS_REQ_DROPPED   0x00000002
-#define ECRYPTFS_REQ_ZOMBIE    0x00000004
-	u32 flags;
-	struct file **lower_file;
-	struct dentry *lower_dentry;
-	struct vfsmount *lower_mnt;
-	wait_queue_head_t wait;
-	struct mutex mux;
-	struct list_head kthread_ctl_list;
-};
 
 #define ECRYPTFS_INTERPOSE_FLAG_D_ADD                 0x00000001
 int ecryptfs_interpose(struct dentry *hidden_dentry,
@@ -755,12 +742,6 @@ void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
 int
 ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
 		      struct user_namespace *user_ns, struct pid *pid);
-int ecryptfs_init_kthread(void);
-void ecryptfs_destroy_kthread(void);
-int ecryptfs_privileged_open(struct file **lower_file,
-			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt,
-			     const struct cred *cred);
 int ecryptfs_get_lower_file(struct dentry *ecryptfs_dentry);
 void ecryptfs_put_lower_file(struct inode *inode);
 int
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
deleted file mode 100644
index 69f994a..0000000
--- a/fs/ecryptfs/kthread.c
+++ /dev/null
@@ -1,197 +0,0 @@
-/**
- * eCryptfs: Linux filesystem encryption layer
- *
- * Copyright (C) 2008 International Business Machines Corp.
- *   Author(s): Michael A. Halcrow <mahalcro@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
- * 02111-1307, USA.
- */
-
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-#include <linux/slab.h>
-#include <linux/wait.h>
-#include <linux/mount.h>
-#include "ecryptfs_kernel.h"
-
-struct kmem_cache *ecryptfs_open_req_cache;
-
-static struct ecryptfs_kthread_ctl {
-#define ECRYPTFS_KTHREAD_ZOMBIE 0x00000001
-	u32 flags;
-	struct mutex mux;
-	struct list_head req_list;
-	wait_queue_head_t wait;
-} ecryptfs_kthread_ctl;
-
-static struct task_struct *ecryptfs_kthread;
-
-/**
- * ecryptfs_threadfn
- * @ignored: ignored
- *
- * The eCryptfs kernel thread that has the responsibility of getting
- * the lower file with RW permissions.
- *
- * Returns zero on success; non-zero otherwise
- */
-static int ecryptfs_threadfn(void *ignored)
-{
-	set_freezable();
-	while (1)  {
-		struct ecryptfs_open_req *req;
-
-		wait_event_freezable(
-			ecryptfs_kthread_ctl.wait,
-			(!list_empty(&ecryptfs_kthread_ctl.req_list)
-			 || kthread_should_stop()));
-		mutex_lock(&ecryptfs_kthread_ctl.mux);
-		if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
-			mutex_unlock(&ecryptfs_kthread_ctl.mux);
-			goto out;
-		}
-		while (!list_empty(&ecryptfs_kthread_ctl.req_list)) {
-			req = list_first_entry(&ecryptfs_kthread_ctl.req_list,
-					       struct ecryptfs_open_req,
-					       kthread_ctl_list);
-			mutex_lock(&req->mux);
-			list_del(&req->kthread_ctl_list);
-			if (!(req->flags & ECRYPTFS_REQ_ZOMBIE)) {
-				dget(req->lower_dentry);
-				mntget(req->lower_mnt);
-				(*req->lower_file) = dentry_open(
-					req->lower_dentry, req->lower_mnt,
-					(O_RDWR | O_LARGEFILE), current_cred());
-				req->flags |= ECRYPTFS_REQ_PROCESSED;
-			}
-			wake_up(&req->wait);
-			mutex_unlock(&req->mux);
-		}
-		mutex_unlock(&ecryptfs_kthread_ctl.mux);
-	}
-out:
-	return 0;
-}
-
-int __init ecryptfs_init_kthread(void)
-{
-	int rc = 0;
-
-	mutex_init(&ecryptfs_kthread_ctl.mux);
-	init_waitqueue_head(&ecryptfs_kthread_ctl.wait);
-	INIT_LIST_HEAD(&ecryptfs_kthread_ctl.req_list);
-	ecryptfs_kthread = kthread_run(&ecryptfs_threadfn, NULL,
-				       "ecryptfs-kthread");
-	if (IS_ERR(ecryptfs_kthread)) {
-		rc = PTR_ERR(ecryptfs_kthread);
-		printk(KERN_ERR "%s: Failed to create kernel thread; rc = [%d]"
-		       "\n", __func__, rc);
-	}
-	return rc;
-}
-
-void ecryptfs_destroy_kthread(void)
-{
-	struct ecryptfs_open_req *req;
-
-	mutex_lock(&ecryptfs_kthread_ctl.mux);
-	ecryptfs_kthread_ctl.flags |= ECRYPTFS_KTHREAD_ZOMBIE;
-	list_for_each_entry(req, &ecryptfs_kthread_ctl.req_list,
-			    kthread_ctl_list) {
-		mutex_lock(&req->mux);
-		req->flags |= ECRYPTFS_REQ_ZOMBIE;
-		wake_up(&req->wait);
-		mutex_unlock(&req->mux);
-	}
-	mutex_unlock(&ecryptfs_kthread_ctl.mux);
-	kthread_stop(ecryptfs_kthread);
-	wake_up(&ecryptfs_kthread_ctl.wait);
-}
-
-/**
- * ecryptfs_privileged_open
- * @lower_file: Result of dentry_open by root on lower dentry
- * @lower_dentry: Lower dentry for file to open
- * @lower_mnt: Lower vfsmount for file to open
- *
- * This function gets a r/w file opened againt the lower dentry.
- *
- * Returns zero on success; non-zero otherwise
- */
-int ecryptfs_privileged_open(struct file **lower_file,
-			     struct dentry *lower_dentry,
-			     struct vfsmount *lower_mnt,
-			     const struct cred *cred)
-{
-	struct ecryptfs_open_req *req;
-	int flags = O_LARGEFILE;
-	int rc = 0;
-
-	/* Corresponding dput() and mntput() are done when the
-	 * lower file is fput() when all eCryptfs files for the inode are
-	 * released. */
-	dget(lower_dentry);
-	mntget(lower_mnt);
-	flags |= IS_RDONLY(lower_dentry->d_inode) ? O_RDONLY : O_RDWR;
-	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags, cred);
-	if (!IS_ERR(*lower_file))
-		goto out;
-	if (flags & O_RDONLY) {
-		rc = PTR_ERR((*lower_file));
-		goto out;
-	}
-	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
-	if (!req) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	mutex_init(&req->mux);
-	req->lower_file = lower_file;
-	req->lower_dentry = lower_dentry;
-	req->lower_mnt = lower_mnt;
-	init_waitqueue_head(&req->wait);
-	req->flags = 0;
-	mutex_lock(&ecryptfs_kthread_ctl.mux);
-	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
-		rc = -EIO;
-		mutex_unlock(&ecryptfs_kthread_ctl.mux);
-		printk(KERN_ERR "%s: We are in the middle of shutting down; "
-		       "aborting privileged request to open lower file\n",
-			__func__);
-		goto out_free;
-	}
-	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
-	mutex_unlock(&ecryptfs_kthread_ctl.mux);
-	wake_up(&ecryptfs_kthread_ctl.wait);
-	wait_event(req->wait, (req->flags != 0));
-	mutex_lock(&req->mux);
-	BUG_ON(req->flags == 0);
-	if (req->flags & ECRYPTFS_REQ_DROPPED
-	    || req->flags & ECRYPTFS_REQ_ZOMBIE) {
-		rc = -EIO;
-		printk(KERN_WARNING "%s: Privileged open request dropped\n",
-		       __func__);
-		goto out_unlock;
-	}
-	if (IS_ERR(*req->lower_file))
-		rc = PTR_ERR(*req->lower_file);
-out_unlock:
-	mutex_unlock(&req->mux);
-out_free:
-	kmem_cache_free(ecryptfs_open_req_cache, req);
-out:
-	return rc;
-}
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 89b9338..d53f834 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -119,14 +119,24 @@ void __ecryptfs_printk(const char *fmt, ...)
 static int ecryptfs_init_lower_file(struct dentry *dentry,
 				    struct file **lower_file)
 {
-	const struct cred *cred = current_cred();
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	int rc;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+	int flags = O_LARGEFILE;
+	int rc = 0;
 
-	rc = ecryptfs_privileged_open(lower_file, lower_dentry, lower_mnt,
-				      cred);
-	if (rc) {
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+		dentry->d_sb)->mount_crypt_stat;
+
+	/* Corresponding dput() and mntput() are done when the
+	 * lower file is fput() in the function ecryptfs_put_lower_file(). */
+	dget(lower_dentry);
+	mntget(lower_mnt);
+	flags |= IS_RDONLY(lower_dentry->d_inode) ? O_RDONLY : O_RDWR;
+	(*lower_file) = dentry_open(lower_dentry, lower_mnt, flags,
+				    mount_crypt_stat->subject_cred);
+	if (IS_ERR(*lower_file)) {
+		rc = PTR_ERR(*lower_file);
 		printk(KERN_ERR "Error opening lower file "
 		       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
 		       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
@@ -291,14 +301,25 @@ out:
 	return rc;
 }
 
-static void ecryptfs_init_mount_crypt_stat(
+static int ecryptfs_init_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
+	int rc = 0;
+
 	memset((void *)mount_crypt_stat, 0,
 	       sizeof(struct ecryptfs_mount_crypt_stat));
 	INIT_LIST_HEAD(&mount_crypt_stat->global_auth_tok_list);
 	mutex_init(&mount_crypt_stat->global_auth_tok_list_mutex);
+	mount_crypt_stat->subject_cred = prepare_kernel_cred(NULL);
+	if (IS_ERR(mount_crypt_stat->subject_cred)) {
+		rc = PTR_ERR(mount_crypt_stat->subject_cred);
+		printk(KERN_ERR "%s: Failed to obtain the credentials "
+				"set; rc = [%d]\n", __func__, rc);
+		goto out;
+	}
 	mount_crypt_stat->flags |= ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED;
+out:
+	return rc;
 }
 
 /**
@@ -349,7 +370,11 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
 		rc = -EINVAL;
 		goto out;
 	}
-	ecryptfs_init_mount_crypt_stat(mount_crypt_stat);
+
+	rc = ecryptfs_init_mount_crypt_stat(mount_crypt_stat);
+	if (rc)
+		goto out;
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		if (!*p)
 			continue;
@@ -738,11 +763,6 @@ static struct ecryptfs_cache_info {
 		.name = "ecryptfs_key_tfm_cache",
 		.size = sizeof(struct ecryptfs_key_tfm),
 	},
-	{
-		.cache = &ecryptfs_open_req_cache,
-		.name = "ecryptfs_open_req_cache",
-		.size = sizeof(struct ecryptfs_open_req),
-	},
 };
 
 static void ecryptfs_free_kmem_caches(void)
@@ -860,18 +880,12 @@ static int __init ecryptfs_init(void)
 		printk(KERN_ERR "sysfs registration failed\n");
 		goto out_unregister_filesystem;
 	}
-	rc = ecryptfs_init_kthread();
-	if (rc) {
-		printk(KERN_ERR "%s: kthread initialization failed; "
-		       "rc = [%d]\n", __func__, rc);
-		goto out_do_sysfs_unregistration;
-	}
 	rc = ecryptfs_init_messaging();
 	if (rc) {
 		printk(KERN_ERR "Failure occurred while attempting to "
 				"initialize the communications channel to "
 				"ecryptfsd\n");
-		goto out_destroy_kthread;
+		goto out_do_sysfs_unregistration;
 	}
 	rc = ecryptfs_init_crypto();
 	if (rc) {
@@ -886,8 +900,6 @@ static int __init ecryptfs_init(void)
 	goto out;
 out_release_messaging:
 	ecryptfs_release_messaging();
-out_destroy_kthread:
-	ecryptfs_destroy_kthread();
 out_do_sysfs_unregistration:
 	do_sysfs_unregistration();
 out_unregister_filesystem:
@@ -907,7 +919,6 @@ static void __exit ecryptfs_exit(void)
 		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
 		       "rc = [%d]\n", rc);
 	ecryptfs_release_messaging();
-	ecryptfs_destroy_kthread();
 	do_sysfs_unregistration();
 	unregister_filesystem(&ecryptfs_fs_type);
 	ecryptfs_free_kmem_caches();
-- 
1.7.4.4


------9F8F34E9B8D35B62C446B3C4CFAA419A
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMTA0MjkxMzQyMjNaMCMGCSqG
SIb3DQEJBDEWBBQWJfec8y2Y6oMPh7amLCAxNUXlEDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAkZA1ry7ly+puxVwcc+ZuzOrkm
SeFkQU+TRTp7tbGfGIg2Y4gNzqJMIHs0V7NJvbFUHMA1BUJ9kLULNKdK+N6HUnU2
aEiBiojs6It0ZF/RgieUt/abkB8Bj0C//R8EWSXYPc5Stb+J4gofvbCFWv2FbK1U
ynPIHUqRm1uECn3u7FUWN13qyFGxxRC3vc2Gn2v1qxSfqINBrZn03FcUFrDZW7UI
HLtle/j/ewlUfDYzWffTH7kEAwfLcmSq/86n6YGy33s37+XFh2WOCG2f3cforvu3
iTa0Pccs5XdLcZzJkck9GFUtPC/IPbdKmmJcXbk9WlxZldSXLS/Sz2mZi5Mv

------9F8F34E9B8D35B62C446B3C4CFAA419A--


