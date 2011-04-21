Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1DUUEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab1DUUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:21 -0400
Date: Thu, 21 Apr 2011 13:04:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Borisov <ext-roman.borisov@nokia.com>
Cc: viro@zeniv.linux.org.uk, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] fs: bound mount propagation fix
Message-Id: <20110421130412.ea953cbc.akpm@linux-foundation.org>
In-Reply-To: <a5c94bcf545fe78cc600402a5234a6bbc1dece97.1303304011.git.ext-roman.borisov@nokia.com>
References: <20110419140400.23367a16.akpm@linux-foundation.org>
	<a5c94bcf545fe78cc600402a5234a6bbc1dece97.1303304011.git.ext-roman.borisov@nokia.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011 16:37:28 +0400
Roman Borisov <ext-roman.borisov@nokia.com> wrote:

> MS_SILENT flag cleaning up added to flags_to_propagation_type function.
> It was reported that bound mount propagation doesn't work in busybox as by
> default busybox mount applet sets the MS_SILENT flag for any mount operation.
> Moreover recently added flags_to_propagation_type function doesn't allow to
> do such operations as --make-[r]private --make-[r]shared etc. when MS_SILENT
> is on.
> The idea to clean MS_SILENT flag belongs to Denys Vlasenko <vda.linux@googlemail.com>
> 

This is not an adequate changelog, IMO.  It has almost no description
of the errant user-visible kernel behaviour and almost no description
of what was wrong with the kernel code - ie, why the kernel was doing
the wrong thing.

I've pieced together a fix for the first problem but then got lazy. 
Please can someone provide an analysis of what was causing this bug?

And has this v3 patch been tested with Denys's reproducer?


From: Roman Borisov <ext-roman.borisov@nokia.com>

This issue was discovered by users of busybox.  Apparently, mount is
called with and without MS_SILENT, and this affects mount() behaviour. 
But MS_SILENT is only supposed to affect kernel logging verbosity.

The following script was run in an empty test directory:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1
mount -vv --make-rshared mount.shared1
mount -vv --bind         mount.shared2 mount.shared2
mount -vv --make-rshared mount.shared2
mount -vv --bind mount.shared2 mount.shared1
mount -vv --bind mount.dir     mount.shared2
ls -R mount.dir mount.shared1 mount.shared2
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


mount -vv was used to show the mount() call arguments and result.
Output shows that flag argument has 0x00008000 = MS_SILENT bit:

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0
mount.dir:
a
b

mount.shared1:

mount.shared2:
a
b


After adding --loud option to remove MS_SILENT bit from just one mount cmd:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1 2>&1
mount -vv --make-rshared mount.shared1               2>&1
mount -vv --bind         mount.shared2 mount.shared2 2>&1
mount -vv --loud --make-rshared mount.shared2               2>&1  # <-HERE
mount -vv --bind mount.shared2 mount.shared1         2>&1
mount -vv --bind mount.dir     mount.shared2         2>&1
ls -R mount.dir mount.shared1 mount.shared2      2>&1
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


The result is different now - look closely at mount.shared1 directory listing.
Now it does show files 'a' and 'b':

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x00104000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0

mount.dir:
a
b

mount.shared1:
a
b

mount.shared2:
a
b


Moreover, the recently added flags_to_propagation_type() function doesn't
allow us to do such operations as --make-[r]private --make-[r]shared etc. 
when MS_SILENT is on.  The idea or clearing the MS_SILENT flag came from
to Denys Vlasenko.

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
Reported-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~fs-bound-mount-propagation-fix fs/namespace.c
--- a/fs/namespace.c~fs-bound-mount-propagation-fix
+++ a/fs/namespace.c
@@ -1695,7 +1695,7 @@ static int graft_tree(struct vfsmount *m
 
 static int flags_to_propagation_type(int flags)
 {
-	int type = flags & ~MS_REC;
+	int type = flags & ~(MS_REC | MS_SILENT);
 
 	/* Fail if any non-propagation flags are set */
 	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
_

