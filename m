Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab3AIUmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:42:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:44061 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934029Ab3AIUld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 123/123] cifs: dont compare uniqueids in cifs_prime_dcache unless server inode numbers are in use
Date: Wed,  9 Jan 2013 12:36:02 -0800
Message-Id: <20130109201514.053104148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 2f2591a34db6c9361faa316c91a6e320cb4e6aee upstream.

Oliver reported that commit cd60042c caused his cifs mounts to
continually thrash through new inodes on readdir. His servers are not
sending inode numbers (or he's not using them), and the new test in
that function doesn't account for that sort of setup correctly.

If we're not using server inode numbers, then assume that the inode
attached to the dentry hasn't changed. Go ahead and update the
attributes in place, but keep the same inode number.

Reported-and-Tested-by: Oliver MÃ¶ssinger <Oliver.Moessinger@ichaus.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -78,6 +78,7 @@ cifs_prime_dcache(struct dentry *parent,
 	struct dentry *dentry, *alias;
 	struct inode *inode;
 	struct super_block *sb = parent->d_inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
 	cFYI(1, "%s: for %s", __func__, name->name);
 
@@ -91,10 +92,20 @@ cifs_prime_dcache(struct dentry *parent,
 		int err;
 
 		inode = dentry->d_inode;
-		/* update inode in place if i_ino didn't change */
-		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
-			cifs_fattr_to_inode(inode, fattr);
-			goto out;
+		if (inode) {
+			/*
+			 * If we're generating inode numbers, then we don't
+			 * want to clobber the existing one with the one that
+			 * the readdir code created.
+			 */
+			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM))
+				fattr->cf_uniqueid = CIFS_I(inode)->uniqueid;
+
+			/* update inode in place if i_ino didn't change */
+			if (CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+				cifs_fattr_to_inode(inode, fattr);
+				goto out;
+			}
 		}
 		err = d_invalidate(dentry);
 		dput(dentry);


