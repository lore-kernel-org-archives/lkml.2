Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2G3IOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2G3IOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:14:18 -0400
From: Tomas Racek <tracek@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        xfs@oss.sgi.com (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
Date: Mon, 30 Jul 2012 10:13:44 +0200
Message-Id: <1343636024-20123-1-git-send-email-tracek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If range.start argument was between ULLONG_MAX - BBSIZE and ULLONG_MAX,
BTOBB macro resulted in overflow which caused start to be set to 0.
Now, invalid argument error is returned instead.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..0ef7dd4 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,6 +179,10 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+
+	if (range.start > ULLONG_MAX - BBSIZE)
+		return -XFS_ERROR(EINVAL);
+
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
-- 
1.7.7.6

