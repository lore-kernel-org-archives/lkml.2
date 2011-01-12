Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1ALS2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:28:31 -0500
Received: from mx2.netapp.com ([216.240.18.37]:59069 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1ALS20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:28:26 -0500
X-IronPort-AV: E=Sophos;i="4.60,313,1291622400"; 
   d="scan'208";a="504615199"
Subject: Re: Regression, bisected: NFS O_EXCL breakage in 2.6.37 client.
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20110112161054.GA3431@elliptictech.com>
References: <20110112161054.GA3431@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Wed, 12 Jan 2011 13:28:09 -0500
Message-ID: <1294856889.2971.43.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 12 Jan 2011 18:28:10.0557 (UTC) FILETIME=[7735D6D0:01CBB286]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 11:10 -0500, Nick Bowler wrote: 
> With 2.6.37 (client), opens on NFS with O_CREAT | O_EXCL are
> occasionally succeeding when the file already exists, apparently
> depending on the state of the filesystem cache.  The issue was observed
> because mplayer would randomly overwrite its config file...
> 
> Using the test program (./nfsbreak) included in this mail, I can
> reproduce it as follows (/home/nbowler is the NFS mount point).  No
> interesting kernel messages appear on either the client or server
> machines during the test:
> 
>   % mkdir /home/nbowler/nfsexcl
>   % ./nfsbreak
>   nfsbreak: File opened <<< This is OK
>   % ./nfsbreak
>   nfsbreak: File exists
>   % ./nfsbreak
>   nfsbreak: File exists
>   % su -c 'echo 2 > /proc/sys/vm/drop_caches'
>   % ./nfsbreak
>   nfsbreak: File opened <<< Uhoh!
>   % ./nfsbreak
>   nfsbreak: File exists
> 
> Here's the nfsbreak C source:
> 
>   #include <stdio.h>
>   #include <stdlib.h>
>   #include <fcntl.h>
> 
>   int main(void)
>   {
>     int fd;
> 
>     /* /home/nbowler is the NFS mount point */
>     fd = open("/home/nbowler/nfsexcl/nfsexcl", O_WRONLY|O_CREAT|O_EXCL);
>     if (fd == -1) {
>       perror("nfsbreak");
>       return EXIT_FAILURE;
>     }
> 
>     puts("nfsbreak: File opened");
>     return 0;
>   }
> 
> This is a regression from 2.6.36; bisection implicates the following,
> which unfortunately does not revert cleanly.

Confirmed. The breakage does not affect NFSv4, but is limited to NFSv3.
The following patch should therefore suffice to fix it.

Cheers
  Trond

8<--------------------------------------------------------------------- 
>From 1ec00b0d759586211447fec763f6c633759e4b3e Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 12 Jan 2011 13:19:59 -0500
Subject: [PATCH] NFS: Fix NFSv3 exclusive open semantics

Commit c0204fd2b8fe047b18b67e07e1bf2a03691240cd (NFS: Clean up
nfs4_proc_create()) broke NFSv3 exclusive open by removing the code
that passes the O_EXCL flag down to nfs3_proc_create(). This patch
reverts that offending hunk from the original commit.

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@kernel.org    [2.6.37]
---
 fs/nfs/dir.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index abe4f0c..f9d6a37 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1583,6 +1583,7 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 {
 	struct iattr attr;
 	int error;
+	int open_flags = 0;
 
 	dfprintk(VFS, "NFS: create(%s/%ld), %s\n",
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
@@ -1590,7 +1591,10 @@ static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, 0, NULL);
+	if ((nd->flags & LOOKUP_CREATE) != 0)
+		open_flags = nd->intent.open.flags;
+
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, NULL);
 	if (error != 0)
 		goto out_err;
 	return 0;
-- 
1.7.3.4



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

