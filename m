Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab0GAWEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:04:13 -0400
Received: from kroah.org ([198.145.64.141]:33748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689Ab0GAVMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:53 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.632225121@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [014/200] nfsd: dont break lease while servicing a COMMIT
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 91885258e8343bb65c08f668d7e6c16563eb4284 upstream.

This is the second attempt to fix the problem whereby a COMMIT call
causes a lease break and triggers a possible deadlock.

The problem is that nfsd attempts to break a lease on a COMMIT call.
This triggers a delegation recall if the lease is held for a delegation.
If the client is the one holding the delegation and it's the same one on
which it's issuing the COMMIT, then it can't return that delegation
until the COMMIT is complete. But, nfsd won't complete the COMMIT until
the delegation is returned. The client and server are essentially
deadlocked until the state is marked bad (due to the client not
responding on the callback channel).

The first patch attempted to deal with this by eliminating the open of
the file altogether and simply had nfsd_commit pass a NULL file pointer
to the vfs_fsync_range. That would conflict with some work in progress
by Christoph Hellwig to clean up the fsync interface, so this patch
takes a different approach.

This declares a new NFSD_MAY_NOT_BREAK_LEASE access flag that indicates
to nfsd_open that it should not break any leases when opening the file,
and has nfsd_commit set that flag on the nfsd_open call.

For now, this patch leaves nfsd_commit opening the file with write
access since I'm not clear on what sort of access would be more
appropriate.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    8 +++++---
 fs/nfsd/vfs.h |    1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -724,7 +724,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	struct inode	*inode;
 	int		flags = O_RDONLY|O_LARGEFILE;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 
 	validate_process_creds();
 
@@ -761,7 +761,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	 * Check to see if there are any leases on this file.
 	 * This may block while leases are broken.
 	 */
-	host_err = break_lease(inode, O_NONBLOCK | ((access & NFSD_MAY_WRITE) ? O_WRONLY : 0));
+	if (!(access & NFSD_MAY_NOT_BREAK_LEASE))
+		host_err = break_lease(inode, O_NONBLOCK | ((access & NFSD_MAY_WRITE) ? O_WRONLY : 0));
 	if (host_err == -EWOULDBLOCK)
 		host_err = -ETIMEDOUT;
 	if (host_err) /* NOMEM or WOULDBLOCK */
@@ -1169,7 +1170,8 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 			goto out;
 	}
 
-	err = nfsd_open(rqstp, fhp, S_IFREG, NFSD_MAY_WRITE, &file);
+	err = nfsd_open(rqstp, fhp, S_IFREG,
+			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &file);
 	if (err)
 		goto out;
 	if (EX_ISSYNC(fhp->fh_export)) {
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -20,6 +20,7 @@
 #define NFSD_MAY_OWNER_OVERRIDE	64
 #define NFSD_MAY_LOCAL_ACCESS	128 /* IRIX doing local access check on device special file*/
 #define NFSD_MAY_BYPASS_GSS_ON_ROOT 256
+#define NFSD_MAY_NOT_BREAK_LEASE 512
 
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)


