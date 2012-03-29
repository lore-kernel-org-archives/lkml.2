Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2C2BGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:06:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab2C2BGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:06:36 -0400
Date: Wed, 28 Mar 2012 18:10:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-Id: <20120328181023.274401d1.akpm@linux-foundation.org>
In-Reply-To: <20120329005442.GB16008@redhat.com>
References: <20120313182220.GA11500@redhat.com>
	<20120327155149.d41a235b.akpm@linux-foundation.org>
	<20120328001550.GA3077@redhat.com>
	<20120328043951.GA32741@dastard>
	<20120328164720.d1aea752.akpm@linux-foundation.org>
	<20120329005442.GB16008@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 20:54:42 -0400 Dave Jones <davej@redhat.com> wrote:

> On Wed, Mar 28, 2012 at 04:47:20PM -0700, Andrew Morton wrote:
>  > On Wed, 28 Mar 2012 15:39:51 +1100
>  > Dave Chinner <david@fromorbit.com> wrote:
>  > 
>  > > > Well, the unusual thing was that I was fuzzing system calls for a few hours.
>  > > > 
>  > > > My fuzzing tool was able to trigger these very easily after an hour or two
>  > > > of uptime and memory had fragmented a little, so yeah, quite trivial.
>  > > 
>  > > We've recently been seeing reports of xfsdump trigging a similar
>  > > allocation failures in the XFS attr code when we are doing hundreds
>  > > of thousands of attribute lookups to back them up.
>  > > 
>  > > ad650f5 xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
>  > > 
>  > > I think that falling back to vmalloc here is much better solution
>  > > than failing to retreive the attribute - it will work no matter how
>  > > fragmented memory gets. That means we don't get incomplete
>  > > backups occurring after days or months of uptime and successful
>  > > backups...
>  > 
>  > Yup.  How does the below look?
> 
> Don't see anything immediately wrong with it.
> Any thoughts on what to do about the similar problem in setxattr ? (memdup_user)
> 

I can't think of anything clever.

The dumb approach:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/xattr.c:setxattr(): improve handling of allocation failures

This allocation can be as large as 64k.

- Add __GFP_NOWARN so that a falied kmalloc() is silent

- Fall back to vmalloc() if the kmalloc() failed

Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff -puN fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures fs/xattr.c
--- a/fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures
+++ a/fs/xattr.c
@@ -320,6 +320,7 @@ setxattr(struct dentry *d, const char __
 {
 	int error;
 	void *kvalue = NULL;
+	void *vvalue = NULL;	/* If non-NULL, we used vmalloc() */
 	char kname[XATTR_NAME_MAX + 1];
 
 	if (flags & ~(XATTR_CREATE|XATTR_REPLACE))
@@ -334,13 +335,25 @@ setxattr(struct dentry *d, const char __
 	if (size) {
 		if (size > XATTR_SIZE_MAX)
 			return -E2BIG;
-		kvalue = memdup_user(value, size);
-		if (IS_ERR(kvalue))
-			return PTR_ERR(kvalue);
+		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!kvalue) {
+			vvalue = vmalloc(size);
+			if (!vvalue)
+				return -ENOMEM;
+			kvalue = vvalue;
+		}
+		if (copy_from_user(kvalue, value, size)) {
+			error = -EFAULT;
+			goto out;
+		}
 	}
 
 	error = vfs_setxattr(d, kname, kvalue, size, flags);
-	kfree(kvalue);
+out:
+	if (vvalue)
+		vfree(vvalue);
+	else
+		kfree(kvalue);
 	return error;
 }
 
_

