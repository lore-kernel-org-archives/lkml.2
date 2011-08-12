Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1HNQHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:07:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1HNQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:32 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.115388308@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [34/90] cifs: cope with negative dentries in cifs_get_root
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 80975d21aae2136ccae1ce914a1602dc1d8b0795 upstream.

The loop around lookup_one_len doesn't handle the case where it might
return a negative dentry, which can cause an oops on the next pass
through the loop. Check for that and break out of the loop with an
error of -ENOENT if there is one.

Fixes the panic reported here:

    https://bugzilla.redhat.com/show_bug.cgi?id=727927

Reported-by: TR Bentley <home@trarbentley.net>
Reported-by: Iain Arnell <iarnell@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -581,6 +581,10 @@ cifs_get_root(struct smb_vol *vol, struc
 		mutex_unlock(&dir->i_mutex);
 		dput(dentry);
 		dentry = child;
+		if (!dentry->d_inode) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOENT);
+		}
 	} while (!IS_ERR(dentry));
 	_FreeXid(xid);
 	kfree(full_path);


