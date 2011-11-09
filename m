Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715Ab1KJD0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1KJD0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212709.969022394@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [094/262] nfsd4: permit read opens of executable-only files
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit a043226bc140a2c1dde162246d68a67e5043e6b2 upstream.

A client that wants to execute a file must be able to read it.  Read
opens over nfs are therefore implicitly allowed for executable files
even when those files are not readable.

NFSv2/v3 get this right by using a passed-in NFSD_MAY_OWNER_OVERRIDE on
read requests, but NFSv4 has gotten this wrong ever since
dc730e173785e29b297aa605786c94adaffe2544 "nfsd4: fix owner-override on
open", when we realized that the file owner shouldn't override
permissions on non-reclaim NFSv4 opens.

So we can't use NFSD_MAY_OWNER_OVERRIDE to tell nfsd_permission to allow
reads of executable files.

So, do the same thing we do whenever we encounter another weird NFS
permission nit: define yet another NFSD_MAY_* flag.

The industry's future standardization on 128-bit processors will be
motivated primarily by the need for integers with enough bits for all
the NFSD_MAY_* flags.

Reported-by: Leonardo Borda <leonardoborda@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4proc.c |    2 ++
 fs/nfsd/vfs.c      |    3 ++-
 fs/nfsd/vfs.h      |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -156,6 +156,8 @@ do_open_permission(struct svc_rqst *rqst
 		!(open->op_share_access & NFS4_SHARE_ACCESS_WRITE))
 		return nfserr_inval;
 
+	accmode |= NFSD_MAY_READ_IF_EXEC;
+
 	if (open->op_share_access & NFS4_SHARE_ACCESS_READ)
 		accmode |= NFSD_MAY_READ;
 	if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2114,7 +2114,8 @@ nfsd_permission(struct svc_rqst *rqstp,
 
 	/* Allow read access to binaries even when mode 111 */
 	if (err == -EACCES && S_ISREG(inode->i_mode) &&
-	    acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE))
+	     (acc == (NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE) ||
+	      acc == (NFSD_MAY_READ | NFSD_MAY_READ_IF_EXEC)))
 		err = inode_permission(inode, MAY_EXEC);
 
 	return err? nfserrno(err) : 0;
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -25,6 +25,7 @@
 #define NFSD_MAY_BYPASS_GSS_ON_ROOT 256
 #define NFSD_MAY_NOT_BREAK_LEASE 512
 #define NFSD_MAY_BYPASS_GSS	1024
+#define NFSD_MAY_READ_IF_EXEC	2048
 
 #define NFSD_MAY_CREATE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE)
 #define NFSD_MAY_REMOVE		(NFSD_MAY_EXEC|NFSD_MAY_WRITE|NFSD_MAY_TRUNC)


