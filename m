Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2ASBLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:11:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ASBLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:11:39 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/12] cfq: don't register propio policy if !CONFIG_CFQ_GROUP_IOSCHED
Date: Wed, 18 Jan 2012 17:11:20 -0800
Message-Id: <1326935490-11827-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326935490-11827-1-git-send-email-tj@kernel.org>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cfq has been registering zeroed blkio_poilcy_cfq if CFQ_GROUP_IOSCHED
is disabled.  This fortunately doesn't collide with blk-throtl as
BLKIO_POLICY_PROP is zero but is unnecessary and risky.  Just don't
register it if not enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9f6219f..5a2e670 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3883,8 +3883,6 @@ static struct blkio_policy_type blkio_policy_cfq = {
 	},
 	.plid = BLKIO_POLICY_PROP,
 };
-#else
-static struct blkio_policy_type blkio_policy_cfq;
 #endif
 
 static int __init cfq_init(void)
@@ -3915,14 +3913,17 @@ static int __init cfq_init(void)
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

