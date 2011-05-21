Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1EUADy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:03:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab1EUACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: dpshah@google.com, namhyung@gmail.com, vgoyal@redhat.com
Subject: [PATCH 1/3] cfq-iosched: Fix a memory leak of per cpu stats for root group
Date: Fri, 20 May 2011 20:02:45 -0400
Message-Id: <1305936167-8932-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocated per cpu stats struct for root group but did not free it.
Fix it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d646b27..0316f6e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3940,6 +3940,11 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	 */
 	if (wait)
 		synchronize_rcu();
+
+#ifdef CONFIG_CFQ_GROUP_IOSCHED
+	/* Free up per cpu stats for root group */
+	free_percpu(cfqd->root_group.blkg.stats_cpu);
+#endif
 	kfree(cfqd);
 }
 
-- 
1.7.4.4

