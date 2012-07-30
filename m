Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2G3Gut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:50:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49007 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab2G3Gus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:50:48 -0400
Date: Mon, 30 Jul 2012 07:50:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [Bisected] commit 71574865 (vfs: do_last(): common slow lookup)
 breaks CUPS printing
Message-ID: <20120730065046.GC6481@ZenIV.linux.org.uk>
References: <20120728104316.GA248@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120728104316.GA248@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 12:43:16PM +0200, Markus Trippelsdorf wrote:
> Printing with CUPS is broken on the current git tree. Whenever I print a page
> the job just sits in the CUPS queue showing "processing". But it never reaches
> the printer.  (My CUPS version is 1.5.2. Filesystem is xfs.)
> 
> I've bisected this issue to:
> 
> commit 7157486541bffc0dfec912e21ae639b029dae3d3
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Tue Jun 5 15:10:14 2012 +0200
> 
>     vfs: do_last(): common slow lookup
>     
>     Make the slow lookup part of O_CREAT and non-O_CREAT opens common.
>     
>     This allows atomic_open to be hooked into the slow lookup part.
>     
>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Hmm...  Looking at that commit, we seem to have one change introduced by it.  Namely,
behaviour of open(path, O_EXCL) (note that O_EXCL without O_CREAT is an undefined
by POSIX and makes no damn sense anyway).

Could you try the patch below, just to make sure that I'm not misreading the
situation?  If that's really happening that way, it should spew a warning,
restore the old behaviour by removing that stray O_EXCL and, if it comes
from open(2)/openat(2), print the syscall arguments.

We'll need to restore the original behaviour anyway, undefined or no undefined,
but if we really catch CUPS doing that, we ought to report that as a bug to
whatever bugtracking system CUPS uses; at the very least, it's a portability
headache waiting to happen.

diff --git a/fs/open.c b/fs/open.c
index 8d2c897..20a3ceb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -893,6 +893,9 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		op->intent |= LOOKUP_CREATE;
 		if (flags & O_EXCL)
 			op->intent |= LOOKUP_EXCL;
+	} else {
+		WARN_ON(flags & O_EXCL);
+		op->open_flag &= ~O_EXCL;
 	}
 
 	if (flags & O_DIRECTORY)
@@ -943,6 +946,10 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
+		if ((flags & O_EXCL) && !(flags & O_CREAT)) {
+			printk(KERN_ERR "WTF: open(\"%s\", %d)", filename, flags);
+		}
+				
 		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
 			struct file *f = do_filp_open(dfd, tmp, &op, lookup);
