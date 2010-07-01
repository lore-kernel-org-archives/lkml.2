Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab0GAVSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:18:47 -0400
Received: from kroah.org ([198.145.64.141]:33091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764Ab0GAVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:05 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:00 2010
Message-Id: <20100701174300.572758886@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christoph Hellwig <hch@lst.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [166/200] nfsd: nfsd_setattr needs to call commit_metadata
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit b160fdabe93a8a53094f90f02bf4dcb500782aab upstream.

The conversion of write_inode_now calls to commit_metadata in commit
f501912a35c02eadc55ca9396ece55fe36f785d0 missed out the call in nfsd_setattr.

But without this conversion we can't guarantee that a SETATTR request
has actually been commited to disk with XFS, which causes a regression
from 2.6.32 (only for NFSv2, but anyway).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -443,8 +443,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	if (size_change)
 		put_write_access(inode);
 	if (!err)
-		if (EX_ISSYNC(fhp->fh_export))
-			write_inode_now(inode, 1);
+		commit_metadata(fhp);
 out:
 	return err;
 


