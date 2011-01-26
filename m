Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1AZI3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:29:53 -0500
Received: from smtp-out.google.com ([74.125.121.67]:28507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1AZI3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:29:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wFMvimsxzfoW44+4M8mm9Kk1yHtHOpL5TEdxw3c057wLMcsxavOrJV+j4vCdMoYU8
	KHqYlhogxTL5YvUMpQc6g==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Date: Wed, 26 Jan 2011 00:29:15 -0800
Message-Id: <1296030555-3594-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_get_limit() returns a byte limit as a unsigned 64 bit value,
which is converted to a page count by mem_cgroup_out_of_memory().  Prior
to this patch the conversion could overflow on 32 bit platforms
yielding a limit of zero.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..3fcac51 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -538,7 +538,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 	struct task_struct *p;
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
-	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
+	limit = min(mem_cgroup_get_limit(mem) >> PAGE_SHIFT, (u64)ULONG_MAX);
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, limit, mem, NULL);
-- 
1.7.3.1

