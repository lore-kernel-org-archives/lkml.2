Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1DYUZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:20 -0400
Received: from 1wt.eu ([62.212.114.60]:34514 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1DYUZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:14 -0400
Message-Id: <20110425200239.989268371@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Alex Elder <aelder@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 161/173] xfs: zero proper structure size for geometry calls
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Elder <aelder@sgi.com>

commit af24ee9ea8d532e16883251a6684dfa1be8eec29 upstream.

Commit 493f3358cb289ccf716c5a14fa5bb52ab75943e5 added this call to
xfs_fs_geometry() in order to avoid passing kernel stack data back
to user space:

+       memset(geo, 0, sizeof(*geo));

Unfortunately, one of the callers of that function passes the
address of a smaller data type, cast to fit the type that
xfs_fs_geometry() requires.  As a result, this can happen:

Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
in: f87aca93

Pid: 262, comm: xfs_fsr Not tainted 2.6.38-rc6-493f3358cb2+ #1
Call Trace:

[<c12991ac>] ? panic+0x50/0x150
[<c102ed71>] ? __stack_chk_fail+0x10/0x18
[<f87aca93>] ? xfs_ioc_fsgeometry_v1+0x56/0x5d [xfs]

Fix this by fixing that one caller to pass the right type and then
copy out the subset it is interested in.

Note: This patch is an alternative to one originally proposed by
Eric Sandeen.

Reported-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Signed-off-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Tested-by: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_ioctl.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -697,14 +697,19 @@ xfs_ioc_fsgeometry_v1(
 	xfs_mount_t		*mp,
 	void			__user *arg)
 {
-	xfs_fsop_geom_v1_t	fsgeo;
+	xfs_fsop_geom_t         fsgeo;
 	int			error;
 
-	error = xfs_fs_geometry(mp, (xfs_fsop_geom_t *)&fsgeo, 3);
+	error = xfs_fs_geometry(mp, &fsgeo, 3);
 	if (error)
 		return -error;
 
-	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
+	/*
+	 * Caller should have passed an argument of type
+	 * xfs_fsop_geom_v1_t.  This is a proper subset of the
+	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
+	 */
+	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
 		return -XFS_ERROR(EFAULT);
 	return 0;
 }


