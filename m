Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1DSUc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:32:29 -0400
Received: from kroah.org ([198.145.64.141]:47547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1DSUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:43 2011
Message-Id: <20110419201043.824344501@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [06/70] cifs: set ra_pages in backing_dev_info
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 2b6c26a0a62cc0bab0ad487533d5581d7c293fef upstream.

Commit 522440ed made cifs set backing_dev_info on the mapping attached
to new inodes. This change caused a fairly significant read performance
regression, as cifs started doing page-sized reads exclusively.

By virtue of the fact that they're allocated as part of cifs_sb_info by
kzalloc, the ra_pages on cifs BDIs get set to 0, which prevents any
readahead. This forces the normal read codepaths to use readpage instead
of readpages causing a four-fold increase in the number of read calls
with the default rsize.

Fix it by setting ra_pages in the BDI to the same value as that in the
default_backing_dev_info.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=31662

Reported-and-Tested-by: Till <till2.schaefer@uni-dortmund.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -127,6 +127,7 @@ cifs_read_super(struct super_block *sb,
 		kfree(cifs_sb);
 		return rc;
 	}
+	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/* copy mount params to sb for use in submounts */


