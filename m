Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab0GVV36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:29:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab0GVV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:29:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [PATCH 1/5] cfq-iosched: Do not idle on service tree if slice_idle=0
Date: Thu, 22 Jul 2010 17:29:28 -0400
Message-Id: <1279834172-4227-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o do not idle either on cfq queue or service tree if slice_idle=0. User does
  not want any queue or service tree idling. Currently even if slice_idle=0,
  we were idling on service tree.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7982b83..c5ec2eb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1838,6 +1838,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(!service_tree);
 	BUG_ON(!service_tree->count);
 
+	if (!cfqd->cfq_slice_idle)
+		return false;
+
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
 		return false;
@@ -1878,7 +1881,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
+	if (!cfq_should_idle(cfqd, cfqq))
 		return;
 
 	/*
-- 
1.7.1.1

