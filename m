Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935867Ab1KJEkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:40:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964840Ab1KJDfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:35:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:42 2011
Message-Id: <20111109213142.335908386@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:30:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <smfrench@gmail.com>
Subject: [002/264] CIFS: Fix DFS handling in cifs_get_file_info
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 42274bb22afc3e877ae5abed787b0b09d7dede52 upstream.

We should call cifs_all_info_to_fattr in rc == 0 case only.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -562,7 +562,16 @@ int cifs_get_file_info(struct file *filp
 
 	xid = GetXid();
 	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
-	if (rc == -EOPNOTSUPP || rc == -EINVAL) {
+	switch (rc) {
+	case 0:
+		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
+		break;
+	case -EREMOTE:
+		cifs_create_dfs_fattr(&fattr, inode->i_sb);
+		rc = 0;
+		break;
+	case -EOPNOTSUPP:
+	case -EINVAL:
 		/*
 		 * FIXME: legacy server -- fall back to path-based call?
 		 * for now, just skip revalidating and mark inode for
@@ -570,18 +579,14 @@ int cifs_get_file_info(struct file *filp
 		 */
 		rc = 0;
 		CIFS_I(inode)->time = 0;
+	default:
 		goto cgfi_exit;
-	} else if (rc == -EREMOTE) {
-		cifs_create_dfs_fattr(&fattr, inode->i_sb);
-		rc = 0;
-	} else if (rc)
-		goto cgfi_exit;
+	}
 
 	/*
 	 * don't bother with SFU junk here -- just mark inode as needing
 	 * revalidation.
 	 */
-	cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
 	fattr.cf_uniqueid = CIFS_I(inode)->uniqueid;
 	fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 	cifs_fattr_to_inode(inode, &fattr);


