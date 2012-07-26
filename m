Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2GZVaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:30:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48389 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2GZVaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:30:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bill Robertson <bill_robertson@debortoli.com.au>,
        Dion Edwards <dion_edwards@debortoli.com.au>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 01/40] cifs: always update the inode cache with the results from a FIND_*
Date: Thu, 26 Jul 2012 14:29:19 -0700
Message-Id: <20120726211411.164006056@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211424.GA7709@kroah.com>
References: <20120726211424.GA7709@kroah.com>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit cd60042cc1392e79410dc8de9e9c1abb38a29e57 upstream.

When we get back a FIND_FIRST/NEXT result, we have some info about the
dentry that we use to instantiate a new inode. We were ignoring and
discarding that info when we had an existing dentry in the cache.

Fix this by updating the inode in place when we find an existing dentry
and the uniqueid is the same.

Reported-and-Tested-by: Andrew Bartlett <abartlet@samba.org>
Reported-by: Bill Robertson <bill_robertson@debortoli.com.au>
Reported-by: Dion Edwards <dion_edwards@debortoli.com.au>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/readdir.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -85,9 +85,12 @@ cifs_readdir_lookup(struct dentry *paren
 
 	dentry = d_lookup(parent, name);
 	if (dentry) {
-		/* FIXME: check for inode number changes? */
-		if (dentry->d_inode != NULL)
+		inode = dentry->d_inode;
+		/* update inode in place if i_ino didn't change */
+		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+			cifs_fattr_to_inode(inode, fattr);
 			return dentry;
+		}
 		d_drop(dentry);
 		dput(dentry);
 	}


