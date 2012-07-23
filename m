Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2GWBnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54318 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab2GWBnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:13 -0400
Message-Id: <20120723010700.864063000@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:53 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Bill Robertson <bill_robertson@debortoli.com.au>,
        Dion Edwards <dion_edwards@debortoli.com.au>,
        Steve French <smfrench@gmail.com>
Subject: [ 062/108] cifs: always update the inode cache with the results from a FIND_*
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/readdir.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0a8224d..a4217f0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -86,9 +86,12 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 
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


