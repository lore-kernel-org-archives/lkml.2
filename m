Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab1KJFLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:11:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934710Ab1KJD0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212710.072285585@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [095/262] nfsd4: fix open downgrade, again
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 3d02fa29dec920c597dd7b7db608a4bc71f088ce upstream.

Yet another open-management regression:

	- nfs4_file_downgrade() doesn't remove the BOTH access bit on
	  downgrade, so the server's idea of the stateid's access gets
	  out of sync with the client's.  If we want to keep an O_RDWR
	  open in this case, we should do that in the file_put_access
	  logic rather than here.
	- We forgot to convert v4 access to an open mode here.

This logic has proven too hard to get right.  In the future we may
consider:
	- reexamining the lock/openowner relationship (locks probably
	  don't really need to take their own references here).
	- adding open upgrade/downgrade support to the vfs.
	- removing the atomic operations.  They're redundant as long as
	  this is all under some other lock.

Also, maybe some kind of additional static checking would help catch
O_/NFS4_SHARE_ACCESS confusion.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4state.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -188,8 +188,15 @@ static void nfs4_file_put_fd(struct nfs4
 static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 {
 	if (atomic_dec_and_test(&fp->fi_access[oflag])) {
-		nfs4_file_put_fd(fp, O_RDWR);
 		nfs4_file_put_fd(fp, oflag);
+		/*
+		 * It's also safe to get rid of the RDWR open *if*
+		 * we no longer have need of the other kind of access
+		 * or if we already have the other kind of open:
+		 */
+		if (fp->fi_fds[1-oflag]
+			|| atomic_read(&fp->fi_access[1 - oflag]) == 0)
+			nfs4_file_put_fd(fp, O_RDWR);
 	}
 }
 
@@ -3381,8 +3388,9 @@ static inline void nfs4_file_downgrade(s
 	int i;
 
 	for (i = 1; i < 4; i++) {
-		if (test_bit(i, &stp->st_access_bmap) && !(i & to_access)) {
-			nfs4_file_put_access(stp->st_file, i);
+		if (test_bit(i, &stp->st_access_bmap)
+					&& ((i & to_access) != i)) {
+			nfs4_file_put_access(stp->st_file, nfs4_access_to_omode(i));
 			__clear_bit(i, &stp->st_access_bmap);
 		}
 	}


