Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab1DMQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:09:27 -0400
Received: from kroah.org ([198.145.64.141]:54265 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757741Ab1DMPzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:44 2011
Message-Id: <20110413155144.895499184@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:50:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>, Alex Elder <aelder@sgi.com>
Subject: [18/74] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


