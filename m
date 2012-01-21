Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2AUIKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:10:52 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:55833 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752599Ab2AUIKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:10:50 -0500
Date: Sat, 21 Jan 2012 15:57:58 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: Re:[PATCH 2/3] eCryptfs: Check inode changes in setattr
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        "Cong Wang" <xiyou.wangcong@gmail.com>, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Tyler Hicks" <tyhicks@canonical.com>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
 <527098189.19032@eyou.net>
In-Reply-To: <527098189.19032@eyou.net>
Message-Id: <120121155758aecba8095c7be7e9983b250416d86f0c@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 218.89.84.161
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <785f68466adadc027197bae6ddd6332f>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0L8Axkb009446

Hi Tyler,
  Please consider the following two things,
1. While invoking inode_newsize_ok/inode_change_ok, it just make sure the new file size seen from
eCryptfs will not exceed the whatever kinds of file size limit, what about the new size does not
exceed the limit, plus ecryptfs_lower_header_size will. Therefore the safest way is to check the
new size seen from lower file system, which is ecryptfs_lower_header_size bigger.  
2. The senmatics of sb->s_maxbytes, is the maximum file size allowed by the file system 
repsented by sb. For eCryptfs, it should be lower_sb->s_maxbytes - ecryptfs_lower_header_size, 
rather than equal to lower_sb->s_maxbytes. However, the ecryptfs_lower_header_size is different
file by file, not a file system wide constant. It is, kind of nasty and we cannot trust it. 
Combined with the reason 1, we prefer to execute an extra new size check on lower inode
after inode_change_ok on ecryptfs inode. For ecryptfs_truncate, directly perform new size check
on lower inode. 
  Please check the patch below.

Cheers,
Li Wang

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
               Yunchuan Wen <wenyunchuan@kylinos.com.cn>

---

diff -prNu a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c	2012-01-05 07:55:44.000000000 +0800
+++ b/fs/ecryptfs/inode.c	2012-01-21 15:55:21.000000000 +0800
@@ -841,18 +841,6 @@ static int truncate_upper(struct dentry 
 		size_t num_zeros = (PAGE_CACHE_SIZE
 				    - (ia->ia_size & ~PAGE_CACHE_MASK));
 
-
-		/*
-		 * XXX(truncate) this should really happen at the begginning
-		 * of ->setattr.  But the code is too messy to that as part
-		 * of a larger patch.  ecryptfs is also totally missing out
-		 * on the inode_change_ok check at the beginning of
-		 * ->setattr while would include this.
-		 */
-		rc = inode_newsize_ok(inode, ia->ia_size);
-		if (rc)
-			goto out;
-
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 			truncate_setsize(inode, ia->ia_size);
 			lower_ia->ia_size = ia->ia_size;
@@ -916,8 +904,14 @@ int ecryptfs_truncate(struct dentry *den
 {
 	struct iattr ia = { .ia_valid = ATTR_SIZE, .ia_size = new_length };
 	struct iattr lower_ia = { .ia_valid = 0 };
+	struct ecryptfs_crypt_stat *crypt_stat;
 	int rc;
-
+	
+	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
+	rc = inode_newsize_ok(ecryptfs_inode_to_lower(dentry->d_inode), new_length + ecryptfs_lower_header_size(crypt_stat));
+	if (rc)
+		return rc;
+	
 	rc = truncate_upper(dentry, &ia, &lower_ia);
 	if (!rc && lower_ia.ia_valid & ATTR_SIZE) {
 		struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
@@ -997,6 +991,15 @@ static int ecryptfs_setattr(struct dentr
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
+	
+	rc = inode_change_ok(inode, ia);
+	if (rc)
+		goto out;
+	if (ia->ia_valid & ATTR_SIZE)
+		rc = inode_newsize_ok(lower_inode, ia->ia_size + ecryptfs_lower_header_size(crypt_stat));
+	if (rc)
+		goto out;
+	
 	if (S_ISREG(inode->i_mode)) {
 		rc = filemap_write_and_wait(inode->i_mapping);
 		if (rc)





---------- Origin message ----------
>From£º"Tyler Hicks" <tyhicks@canonical.com>
>To£ºecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
>Subject£º[PATCH 2/3] eCryptfs: Check inode changes in setattr
>Date£º2012-01-21 06:35:06

Most filesystems call inode_change_ok() very early in ->setattr(), but
eCryptfs didn't call it at all. It allowed the lower filesystem to make
the call in its ->setattr() function. Then, eCryptfs would copy the
appropriate inode attributes from the lower inode to the eCryptfs inode.

This patch changes that and actually calls inode_change_ok() on the
eCryptfs inode, fairly early in ecryptfs_setattr(). Ideally, the call
would happen earlier in ecryptfs_setattr(), but there is some possible
inode initialization that must happen first.

Since the call was already being made on the lower inode, the change in
functionality should be minimal, except for the case of a file extending
truncate call. In that case, inode_newsize_ok() was never being
called on the eCryptfs inode. Rather than inode_newsize_ok() catching
errors early on, eCryptfs would encrypt zeroed pages and write them to
the lower filesystem until the lower filesystem's write path caught the
error in generic_write_checks().

In summary this change prevents eCryptfs truncate operations (and the
resulting page encryptions), which would exceed the lower filesystem ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
