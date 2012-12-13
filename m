Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab2LMOOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933335Ab2LMOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 221/241] [media] fimc-lite: Don't use mutex_lock_interruptible() in device release()
Date: Thu, 13 Dec 2012 11:59:46 -0200
Message-Id: <1355407206-17100-222-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit ddc43d6dc7df0849fe41b91460fa76145cf87b67 upstream.

Use uninterruptible mutex_lock in the release() file op to make
sure all resources are properly freed when a process is being
terminated. Returning -ERESTARTSYS has no effect for a terminating
process and this may cause driver resources not to be released.
This patch is required for stable kernels v3.5+.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[ herton: adjust file name to patch ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/media/video/s5p-fimc/fimc-lite.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 74ff310..9132f61 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -487,8 +487,7 @@ static int fimc_lite_close(struct file *file)
 	struct fimc_lite *fimc = video_drvdata(file);
 	int ret;
 
-	if (mutex_lock_interruptible(&fimc->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&fimc->lock);
 
 	if (--fimc->ref_count == 0 && fimc->out_path == FIMC_IO_DMA) {
 		clear_bit(ST_FLITE_IN_USE, &fimc->state);
-- 
1.7.9.5

