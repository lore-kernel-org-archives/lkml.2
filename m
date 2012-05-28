Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2E1DkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:40:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52079 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab2E1D3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:41 -0400
Message-Id: <20120528031213.364018747@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>
Subject: [ 076/117] init: dont try mounting device as nfs root unless type fully
 matches
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 0e93f92..42b0707 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -472,7 +472,7 @@ void __init change_floppy(char *fmt, ...)
 void __init mount_root(void)
 {
 #ifdef CONFIG_ROOT_NFS
-	if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
+	if (ROOT_DEV == Root_NFS) {
 		if (mount_nfs_root())
 			return;
 


