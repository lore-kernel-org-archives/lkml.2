Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0G3RSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:18:13 -0400
Received: from kroah.org ([198.145.64.141]:46185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab0G3RRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:00 2010
Message-Id: <20100730171500.496954194@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:13:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [009/165] cifs: dont attempt busy-file rename unless its in same directory
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit ed0e3ace576d297a5c7015401db1060bbf677b94 upstream.

Busy-file renames don't actually work across directories, so we need
to limit this code to renames within the same dir.

This fixes the bug detailed here:

    https://bugzilla.redhat.com/show_bug.cgi?id=591938

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1284,6 +1284,10 @@ cifs_do_rename(int xid, struct dentry *f
 	if (rc == 0 || rc != -ETXTBSY)
 		return rc;
 
+	/* open-file renames don't work across directories */
+	if (to_dentry->d_parent != from_dentry->d_parent)
+		return rc;
+
 	/* open the file to be renamed -- we need DELETE perms */
 	rc = CIFSSMBOpen(xid, pTcon, fromPath, FILE_OPEN, DELETE,
 			 CREATE_NOT_DIR, &srcfid, &oplock, NULL,


