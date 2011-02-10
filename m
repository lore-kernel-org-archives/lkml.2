Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1BJOZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:25:12 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:63274 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab1BJOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:25:10 -0500
Subject: [PATCH] xfs: prevent leaking uninitialized stack memory in
 FSGEOMETRY_V1
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: aelder@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 09:25:04 -0500
Message-ID: <1297347904.13370.9.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
xfs_fs_geometry() with a version number of 3.  This code path does not
fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
the leaking of four bytes of uninitialized stack data to potentially
unprivileged callers.  Since all other members are filled in all code
paths and there are no padding bytes in this structure, it's safe to
avoid an expensive memset() in favor of just clearing this one field.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 fs/xfs/xfs_fsops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cec89dd..17c4785 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -102,6 +102,7 @@ xfs_fs_geometry(
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
 		geo->dirblocksize = mp->m_dirblksize;
+		geo->logsunit = 0;
 	}
 	if (new_version >= 4) {
 		geo->flags |=


