Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2DRWDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:03:32 -0400
Received: from mx2.netapp.com ([216.240.18.37]:46874 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab2DRWDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:03:30 -0400
X-IronPort-AV: E=Sophos;i="4.75,443,1330934400"; 
   d="scan'208";a="641900220"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] NFSv4: open(O_TRUNC) hangs
Thread-Topic: [REGRESSION] NFSv4: open(O_TRUNC) hangs
Thread-Index: AQHNE9m4fNNbFQoJxUan0YtsOl2zeJahq80A
Date: Wed, 18 Apr 2012 22:03:26 +0000
Message-ID: <1334786606.12880.14.camel@lade.trondhjem.org>
References: <87d37osrx2.fsf@tucsk.pomaz.szeredi.hu>
	 <1333647115.4573.3.camel@lade.trondhjem.org>
	 <8762ddb3ge.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <8762ddb3ge.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F909DB7722EF6B459D546C7F80000CC3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3IM3bdE022401

Hi Miklos

On Fri, 2012-04-06 at 11:43 +0200, Miklos Szeredi wrote:
> "Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:
> 
> > The following client patch fixes the regression for me.
> 
> It fixes the hang, but it still doesn't work 100% correctly.  Try the
> following test program.
> 
> BTW, do you run any fs test suits?  All these were caught with one I use
> to quick test fuse (it's in the fuse git tree(*) under the "test"
> directory).  But I guess others like LTP would catch these as well.

Thanks! I'll look into that. Bryan has been helping me to set up a test
rig for the NFS client, but for now we don't have much coverage of basic
POSIX tests.

> Thanks,
> Miklos
> 
> (*)  git://fuse.git.sourceforge.net/gitroot/fuse/fuse
> ---
> 
> #include <stdio.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <errno.h>
> 
> int main(int argc, char *argv[])
> {
> 	int res;
> 	char *name = argv[1];
> 
> 	unlink(name);
> 	close(creat(name, 0400));
> 	res = open(name, O_RDONLY | O_TRUNC);
> 	if (res != -1 && errno != EPERM)
> 		fprintf(stderr, "should have failed!\n");

Shouldn't that be EACCES? As far as I know, POSIX doesn't list EPERM as
an allowed return value for open().

> 
> 	return 0;
> }

I'm trying to find out what the correct behaviour should be. Clearly we
should not be hanging, and so we definitely do need a fix. However
according to POSIX, the behaviour of open(O_RDONLY|O_TRUNC) is
undefined. I'm therefore thinking that returning EACCES should be
acceptable in the case where the server returns NFS4ERR_OPENMODE to our
open stateid (which is the case for the Linux server).

Something like the following will 'break' your previous test, in that it
returns EACCES to the open(O_RDONLY|O_TRUNC) instead of truncating the
file. However as I said, that appears to be POSIX-compliant.

Cheers
  Trond
8<-----------------------------------------------------------------------
>From f3efde63559c33a906dc325b192ecdb6c590c0f6 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 18 Apr 2012 16:29:11 -0400
Subject: [PATCH] NFSv4: Fix open(O_TRUNC) and ftruncate() error handling

If the file wasn't opened for writing, then truncate and ftruncate
need to report the appropriate errors.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
---
 fs/nfs/dir.c      |    4 ++--
 fs/nfs/nfs4proc.c |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 4aaf031..8789210 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1429,7 +1429,7 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 	}
 
 	open_flags = nd->intent.open.flags;
-	attr.ia_valid = 0;
+	attr.ia_valid = ATTR_OPEN;
 
 	ctx = create_nfs_open_context(dentry, open_flags);
 	res = ERR_CAST(ctx);
@@ -1536,7 +1536,7 @@ static int nfs_open_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (IS_ERR(ctx))
 		goto out;
 
-	attr.ia_valid = 0;
+	attr.ia_valid = ATTR_OPEN;
 	if (openflags & O_TRUNC) {
 		attr.ia_valid |= ATTR_SIZE;
 		attr.ia_size = 0;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index ba837d9..f875cf3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1954,10 +1954,19 @@ static int nfs4_do_setattr(struct inode *inode, struct rpc_cred *cred,
 	};
 	int err;
 	do {
-		err = nfs4_handle_exception(server,
-				_nfs4_do_setattr(inode, cred, fattr, sattr, state),
-				&exception);
+		err = _nfs4_do_setattr(inode, cred, fattr, sattr, state);
+		switch (err) {
+		case -NFS4ERR_OPENMODE:
+			if (state && !(state->state & FMODE_WRITE)) {
+				err = -EBADF;
+				if (sattr->ia_valid & ATTR_OPEN)
+					err = -EACCES;
+				goto out;
+			}
+		}
+		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
+out:
 	return err;
 }
 
-- 
1.7.7.6


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
