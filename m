Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3AIVUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:20:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:42678 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252Ab3AIUjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 050/123] NFS: Fix access to suid/sgid executables
Date: Wed,  9 Jan 2013 12:34:49 -0800
Message-Id: <20130109201504.973261871@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit f8d9a897d4384b77f13781ea813156568f68b83e upstream.

nfs_open_permission_mask() should only check MAY_EXEC for files that
are opened with __FMODE_EXEC.

Also fix NFSv4 access-in-open path in a similar way -- openflags must be
used because fmode will not always have FMODE_EXEC set.

This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=49101

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dir.c      |   16 ++++++++++------
 fs/nfs/nfs4proc.c |   18 +++++++++++-------
 2 files changed, 21 insertions(+), 13 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2148,12 +2148,16 @@ static int nfs_open_permission_mask(int
 {
 	int mask = 0;
 
-	if ((openflags & O_ACCMODE) != O_WRONLY)
-		mask |= MAY_READ;
-	if ((openflags & O_ACCMODE) != O_RDONLY)
-		mask |= MAY_WRITE;
-	if (openflags & __FMODE_EXEC)
-		mask |= MAY_EXEC;
+	if (openflags & __FMODE_EXEC) {
+		/* ONLY check exec rights */
+		mask = MAY_EXEC;
+	} else {
+		if ((openflags & O_ACCMODE) != O_WRONLY)
+			mask |= MAY_READ;
+		if ((openflags & O_ACCMODE) != O_RDONLY)
+			mask |= MAY_WRITE;
+	}
+
 	return mask;
 }
 
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1721,7 +1721,8 @@ static int _nfs4_recover_proc_open(struc
 
 static int nfs4_opendata_access(struct rpc_cred *cred,
 				struct nfs4_opendata *opendata,
-				struct nfs4_state *state, fmode_t fmode)
+				struct nfs4_state *state, fmode_t fmode,
+				int openflags)
 {
 	struct nfs_access_entry cache;
 	u32 mask;
@@ -1733,11 +1734,14 @@ static int nfs4_opendata_access(struct r
 
 	mask = 0;
 	/* don't check MAY_WRITE - a newly created file may not have
-	 * write mode bits, but POSIX allows the creating process to write */
-	if (fmode & FMODE_READ)
-		mask |= MAY_READ;
-	if (fmode & FMODE_EXEC)
-		mask |= MAY_EXEC;
+	 * write mode bits, but POSIX allows the creating process to write.
+	 * use openflags to check for exec, because fmode won't
+	 * always have FMODE_EXEC set when file open for exec. */
+	if (openflags & __FMODE_EXEC) {
+		/* ONLY check for exec rights */
+		mask = MAY_EXEC;
+	} else if (fmode & FMODE_READ)
+		mask = MAY_READ;
 
 	cache.cred = cred;
 	cache.jiffies = jiffies;
@@ -2009,7 +2013,7 @@ static int _nfs4_do_open(struct inode *d
 	if (server->caps & NFS_CAP_POSIX_LOCK)
 		set_bit(NFS_STATE_POSIX_LOCKS, &state->flags);
 
-	status = nfs4_opendata_access(cred, opendata, state, fmode);
+	status = nfs4_opendata_access(cred, opendata, state, fmode, flags);
 	if (status != 0)
 		goto err_opendata_put;
 


