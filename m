Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab1DZVNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:61741 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758550Ab1DZVNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684326737"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: drosenberg@vsecurity.com, ak@linux.intel.com, eugeneteo@kernel.org,
        aelder@sgi.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [8/106] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
Message-Id: <20110426211246.2E1863E1887@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_fsops.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.35.y.orig/fs/xfs/xfs_fsops.c
+++ linux-2.6.35.y/fs/xfs/xfs_fsops.c
@@ -57,6 +57,9 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
+
+	memset(geo, 0, sizeof(*geo));
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;
