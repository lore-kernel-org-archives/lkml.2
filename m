Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1JWGeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1JWGeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:05 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062539.626776951@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:43 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <sfrench@us.ibm.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [15/27] CIFS: Fix ERR_PTR dereference in cifs_get_root
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 5b980b01212199833ee8023770fa4cbf1b85e9f4 upstream.

move it to the beginning of the loop.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsfs.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -566,6 +566,12 @@ cifs_get_root(struct smb_vol *vol, struc
 		struct inode *dir = dentry->d_inode;
 		struct dentry *child;
 
+		if (!dir) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+			break;
+		}
+
 		/* skip separators */
 		while (*s == sep)
 			s++;
@@ -581,10 +587,6 @@ cifs_get_root(struct smb_vol *vol, struc
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry = child;
-		if (!dentry->d_inode) {
-			dput(dentry);
-			dentry = ERR_PTR(-ENOENT);
-		}
 	} while (!IS_ERR(dentry));
 	_FreeXid(xid);
 	kfree(full_path);


