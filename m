Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2BVBzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:55:22 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2BVBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.134.228 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/36] cfq: don't register propio policy if !CONFIG_CFQ_GROUP_IOSCHED
Date: Tue, 21 Feb 2012 17:46:30 -0800
Message-Id: <1329875223-5102-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq has been registering zeroed blkio_poilcy_cfq if CFQ_GROUP_IOSCHED
is disabled.  This fortunately doesn't collide with blk-throtl as
BLKIO_POLICY_PROP is zero but is unnecessary and risky.  Just don't
register it if not enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4572952..388fe01 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3878,8 +3878,6 @@ static struct blkio_policy_type blkio_policy_cfq = {
 	},
 	.plid = BLKIO_POLICY_PROP,
 };
-#else
-static struct blkio_policy_type blkio_policy_cfq;
 #endif
 
 static int __init cfq_init(void)
@@ -3910,14 +3908,17 @@ static int __init cfq_init(void)
 		return ret;
 	}
 
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkio_policy_register(&blkio_policy_cfq);
-
+#endif
 	return 0;
 }
 
 static void __exit cfq_exit(void)
 {
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
 	blkio_policy_unregister(&blkio_policy_cfq);
+#endif
 	elv_unregister(&iosched_cfq);
 	kmem_cache_destroy(cfq_pool);
 }
-- 
1.7.7.3

