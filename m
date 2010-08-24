Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab0HXXX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:23:57 -0400
Received: from kroah.org ([198.145.64.141]:40827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261Ab0HXXBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:17 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:02 2010
Message-Id: <20100824224502.320913513@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tiger Yang <tiger.yang@oracle.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [012/114] ocfs2: do not overwrite error codes in ocfs2_init_acl
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tiger Yang <tiger.yang@oracle.com>

commit 6eda3dd33f8a0ce58ee56a11351758643a698db4 upstream.

Setting the acl while creating a new inode depends on
the error codes of posix_acl_create_masq. This patch fix
a issue of overwriting the error codes of it.

Reported-by: Pawel Zawora <pzawora@gmail.com>
Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/acl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -344,7 +344,7 @@ int ocfs2_init_acl(handle_t *handle,
 {
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct posix_acl *acl = NULL;
-	int ret = 0;
+	int ret = 0, ret2;
 	mode_t mode;
 
 	if (!S_ISLNK(inode->i_mode)) {
@@ -381,7 +381,12 @@ int ocfs2_init_acl(handle_t *handle,
 		mode = inode->i_mode;
 		ret = posix_acl_create_masq(clone, &mode);
 		if (ret >= 0) {
-			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			if (ret2) {
+				mlog_errno(ret2);
+				ret = ret2;
+				goto cleanup;
+			}
 			if (ret > 0) {
 				ret = ocfs2_set_acl(handle, inode,
 						    di_bh, ACL_TYPE_ACCESS,


