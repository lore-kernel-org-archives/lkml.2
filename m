Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031247Ab2ERXZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:25:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946422Ab2ERXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:34 -0400
Message-Id: <20120518211603.017215535@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>
Subject: [ 39/54] init: dont try mounting device as nfs root unless type fully matches
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit 377485f6244af255b04d662cf19cddbbc4ae4310 upstream.

Currently, we'll try mounting any device who's major device number is
UNNAMED_MAJOR as NFS root.  This would happen for non-NFS devices as
well (such as 9p devices) but it wouldn't cause any issues since
mounting the device as NFS would fail quickly and the code proceeded to
doing the proper mount:

       [  101.522716] VFS: Unable to mount root fs via NFS, trying floppy.
       [  101.534499] VFS: Mounted root (9p filesystem) on device 0:18.

Commit 6829a048102a ("NFS: Retry mounting NFSROOT") introduced retries
when mounting NFS root, which means that now we don't immediately fail
and instead it takes an additional 90+ seconds until we stop retrying,
which has revealed the issue this patch fixes.

This meant that it would take an additional 90 seconds to boot when
we're not using a device type which gets detected in order before NFS.

This patch modifies the NFS type check to require device type to be
'Root_NFS' instead of requiring the device to have an UNNAMED_MAJOR
major.  This makes boot process cleaner since we now won't go through
the NFS mounting code at all when the device isn't an NFS root
("/dev/nfs").

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -432,7 +432,7 @@ void __init change_floppy(char *fmt, ...
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
-	if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
+	if (ROOT_DEV == Root_NFS) {
 		if (mount_nfs_root())
 			return;
 


