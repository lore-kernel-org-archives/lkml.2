Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab1FWRiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:35674 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623Ab1FWRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Alex Elder <aelder@sgi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 238/247] xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1
Date: Thu, 23 Jun 2011 13:35:06 -0400
Message-Id: <1308850515-15242-179-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3a3675b7f23f83ca8c67c9c2b6edf707fd28d1ba upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/xfs_fsops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 37a6f62..4e7f02b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
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
-- 
1.7.4.4

