Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1BNNpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:45:35 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:51547 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab1BNNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:45:34 -0500
Subject: [PATCH v2] xfs: prevent leaking uninitialized stack memory in
 FSGEOMETRY_V1
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Dave Chinner <david@fromorbit.com>, aelder@sgi.com,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, security@kernel.org
In-Reply-To: <20110214114629.GA13052@dastard>
References: <1297347904.13370.9.camel@dan>  <20110214114629.GA13052@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 08:45:28 -0500
Message-ID: <1297691128.1857.4.camel@dan>
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
unprivileged callers.

v2 switches to memset() to avoid future issues if structure members
change, on suggestion of Dave Chinner.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
---
 fs/xfs/xfs_fsops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index cec89dd..85668ef 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -53,6 +53,9 @@ xfs_fs_geometry(
 	xfs_fsop_geom_t		*geo,
 	int			new_version)
 {
+
+	memset(geo, 0, sizeof(*geo));
+
 	geo->blocksize = mp->m_sb.sb_blocksize;
 	geo->rtextsize = mp->m_sb.sb_rextsize;
 	geo->agblocks = mp->m_sb.sb_agblocks;


