Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2AWDkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:40:05 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57941 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2AWDjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:39:39 -0500
X-AuditID: b753bd60-9658fba000007b1b-90-4f1cd67989cd
X-AuditID: b753bd60-9658fba000007b1b-90-4f1cd67989cd
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH 1/3] xfs: consider new reservation for quota check on inode
 reservation
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Date: Mon, 23 Jan 2012 12:45:25 +0900
Message-ID: <20120123034525.3339.79163.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xfs checks quota when reserving disk blocks and inodes. In the block
reservation it checks if the total number of blocks including current
usage and new reservation reach quota. However, in the inode reservation
it checks using the total number of inodes including only current usage
without new reservation. It should include the new one, as well.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 4d00ee6..eb29fe1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -677,11 +677,13 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL && count >= hardlimit) {
+			if (hardlimit > 0ULL &&
+			    hardlimit <= ninos + count) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL && count >= softlimit) {
+			if (softlimit > 0ULL &&
+			    softlimit <= ninos + count) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

