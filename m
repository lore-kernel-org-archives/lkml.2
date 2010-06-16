Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab0FPTyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0FPTya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:54:30 -0400
Date: Wed, 16 Jun 2010 15:54:00 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] d_ino considered harmful
Message-ID: <20100616195359.GA24382@shell>
References: <20100616185913.GA15566@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616185913.GA15566@shell>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 02:59:13PM -0400, Valerie Aurora wrote:
> Who needs d_ino anyway?  I am running a kernel with this patch -
> Gnome, a browser, IRC, kernel compile, etc. and everything works.

Gosh, maybe it would help to patch the currently used readdir instead
of just old_readdir() (thanks, Arnd).  And return 1 instead of 0 so ls
doesn't think all files are deleted (thanks, Andreas).

I'm running a kernel with the below patch and everything still works.
Apparently "ls -i" is still using the bogus d_ino performance
improvement mentioned here because it returns all 1's for inode
number.

http://www.mail-archive.com/bug-findutils@gnu.org/msg02531.html

-VAL

commit 5902fd7b7407e059c5cea1bf1ea101a1ff8a6072
Author: Valerie Aurora <vaurora@redhat.com>
Date:   Wed Jun 16 11:05:06 2010 -0700

    VFS: Always return 1 for d_ino
    
    Use of d_ino without the corresponding st_dev is always buggy in the
    presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
    of a mountpoint will be the inode number of the directory under the
    mountpoint, not the mounted directory.  Correct code must call stat(),
    which returns the correct device ID and inode in st_dev and st_ino.
    Since no one should be using d_ino anyway, always return 1 to detect
    bugs.

diff --git a/fs/readdir.c b/fs/readdir.c
index dd3eae1..5ff8f10 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -91,11 +91,8 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
 
 	if (buf->result)
 		return -EINVAL;
-	d_ino = ino;
-	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
-		buf->result = -EOVERFLOW;
-		return -EOVERFLOW;
-	}
+	/* Use of d_ino without st_dev is always buggy. */
+	d_ino = 1;
 	buf->result++;
 	dirent = buf->dirent;
 	if (!access_ok(VERIFY_WRITE, dirent,
@@ -172,11 +169,8 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
-	d_ino = ino;
-	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
-		buf->error = -EOVERFLOW;
-		return -EOVERFLOW;
-	}
+	/* Use of d_ino without st_dev is always buggy. */
+	d_ino = 1;
 	dirent = buf->previous;
 	if (dirent) {
 		if (__put_user(offset, &dirent->d_off))
