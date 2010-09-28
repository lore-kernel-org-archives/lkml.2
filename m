Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248Ab0I1AaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:30:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0I1AaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:30:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jYNc6/mxTqPcCTUZhJRBfbyhvU+iSuNFk6rIxtfVnN3hnRcSr+4GXXxi1oXUE7+fx
	hLYLKbwg9bjRzZCWkDD4A==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH 2/3] sched: drop group_capacity to 1 only if remote group has no running tasks
Date: Mon, 27 Sep 2010 17:29:57 -0700
Message-Id: <1285633798-26886-3-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285633798-26886-1-git-send-email-ncrao@google.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
only if the remote sched group has no running tasks. This addresses the case
where you have two tasks on one socket and the other socket is idle, in which
case you drop the capacity to 1. If the remote group has >=1 running task, then
there is no difference from a cache-sharing perspective.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index de8a6a0..33a7985 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2548,7 +2548,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		 * first, lower the sg capacity to one so that we'll try
 		 * and move all the excess tasks away.
 		 */
-		if (prefer_sibling)
+		if (prefer_sibling && !sgs.sum_nr_running)
 			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
-- 
1.7.1

