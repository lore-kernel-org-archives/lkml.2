Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2C1XrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:47:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab2C1XrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:47:21 -0400
Date: Wed, 28 Mar 2012 16:47:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120328164720.d1aea752.akpm@linux-foundation.org>
In-Reply-To: <20120328043951.GA32741@dastard>
References: <20120313182220.GA11500@redhat.com>
	<20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
	<20120328043951.GA32741@dastard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 15:39:51 +1100
Dave Chinner <david@fromorbit.com> wrote:

> > Well, the unusual thing was that I was fuzzing system calls for a few hours.
> > 
> > My fuzzing tool was able to trigger these very easily after an hour or two
> > of uptime and memory had fragmented a little, so yeah, quite trivial.
> 
> We've recently been seeing reports of xfsdump trigging a similar
> allocation failures in the XFS attr code when we are doing hundreds
> of thousands of attribute lookups to back them up.
> 
> ad650f5 xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
> 
> I think that falling back to vmalloc here is much better solution
> than failing to retreive the attribute - it will work no matter how
> fragmented memory gets. That means we don't get incomplete
> backups occurring after days or months of uptime and successful
> backups...

Yup.  How does the below look?

This patch needs more Davids.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/xattr.c:listxattr(): fall back to vmalloc() if kmalloc() failed

This allocation can be as large as 64k.  As David points out, "falling
back to vmalloc here is much better solution than failing to retreive the
attribute - it will work no matter how fragmented memory gets.  That means
we don't get incomplete backups occurring after days or months of uptime
and successful backups".

Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-listxattr-fall-back-to-vmalloc-if-kmalloc-failed
+++ a/fs/xattr.c
@@ -492,13 +492,18 @@ listxattr(struct dentry *d, char __user 
 {
 	ssize_t error;
 	char *klist = NULL;
+	char *vlist = NULL;	/* If non-NULL, we used vmalloc() */
 
 	if (size) {
 		if (size > XATTR_LIST_MAX)
 			size = XATTR_LIST_MAX;
 		klist = kmalloc(size, __GFP_NOWARN | GFP_KERNEL);
-		if (!klist)
-			return -ENOMEM;
+		if (!klist) {
+			vlist = vmalloc(size);
+			if (!vlist)
+				return -ENOMEM;
+			klist = vlist;
+		}
 	}
 
 	error = vfs_listxattr(d, klist, size);
@@ -510,7 +515,10 @@ listxattr(struct dentry *d, char __user 
 		   than XATTR_LIST_MAX bytes. Not possible. */
 		error = -E2BIG;
 	}
-	kfree(klist);
+	if (vlist)
+		vfree(vlist);
+	else
+		kfree(klist);
 	return error;
 }
 
_

