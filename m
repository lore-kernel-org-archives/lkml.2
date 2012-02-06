Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2BFMpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:45:04 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33199 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab2BFMpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:45:01 -0500
X-AuditID: b753bd60-96e5dba00000359c-3b-4f2fcb4b1804
X-AuditID: b753bd60-96e5dba00000359c-3b-4f2fcb4b1804
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v2 2/3] xfs: make inode quota check more general
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Date: Mon, 06 Feb 2012 21:50:30 +0900
Message-ID: <20120206125030.12624.95365.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
References: <20120206124951.12624.88233.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs checks quota when reserving disk blocks and inodes. In the block
reservation, it checks if the total number of blocks including current
usage and new reservation exceed quota. In the inode reservation,
it checks using the total number of inodes including only current usage
without new reservation. However, this inode quota check works well
since the caller of xfs_trans_dquot() always sets the argument of the
number of new inode reservation to 1 or 0 and inode is reserved one by
one in current xfs.

To make it more general, this patch changes it to the same way as the
block quota check.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 8525553..c4ba366 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -677,11 +677,13 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL && count >= hardlimit) {
+			if (hardlimit > 0ULL &&
+			    hardlimit < ninos + count) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL && count >= softlimit) {
+			if (softlimit > 0ULL &&
+			    softlimit < ninos + count) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

