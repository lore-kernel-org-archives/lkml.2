Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777Ab1DYUok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:44:40 -0400
Received: from 1wt.eu ([62.212.114.60]:34326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab1DYUYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:48 -0400
Message-Id: <20110425200238.296486076@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Alex Elder <aelder@sgi.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 122/173] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit c4d0c3b097f7584772316ee4d64a09fe0e4ddfca upstream.

The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
xfs_fs_geometry() with a version number of 3.  This code path does not
fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
the leaking of four bytes of uninitialized stack data to potentially
unprivileged callers.

v2 switches to memset() to avoid future issues if structure members
change, on suggestion of Dave Chinner.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_fsops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -56,6 +56,9 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
+
+	memset(geo, 0, sizeof(*geo));
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;


