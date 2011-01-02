Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1ABHtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:49:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:35910 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1ABHXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Alex Elder <aelder@sgi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 143/260] xfs: prevent reading uninitialized stack memory
Date: Sun,  2 Jan 2011 02:17:19 -0500
Message-Id: <1293952756-15010-144-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:46.0697 (UTC) FILETIME=[DA9AC190:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit a122eb2fdfd78b58c6dd992d6f4b1aaef667eef9 upstream.

The XFS_IOC_FSGETXATTR ioctl allows unprivileged users to read 12
bytes of uninitialized stack memory, because the fsxattr struct
declared on the stack in xfs_ioc_fsgetxattr() does not alter (or zero)
the 12-byte fsx_pad member before copying it back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 7b26cc2..3da1da7 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -791,6 +791,8 @@ xfs_ioc_fsgetxattr(
 {
 	struct fsxattr		fa;
 
+	memset(&fa, 0, sizeof(struct fsxattr));
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	fa.fsx_xflags = xfs_ip2xflags(ip);
 	fa.fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-- 
1.7.3.3

