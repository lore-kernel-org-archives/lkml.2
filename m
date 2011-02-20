Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1BTHIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 02:08:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1BTHIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 02:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Tr11zw8cMycVXE4xER33pJkePSXQqYbjqoabx+Mf4L0wNKFGpgaS9VsSkqZkBKdFG3
         8NQuQ2xIve+p05eBMA0427c8s4FGYqx0tTE5fP4FdxNc+fTwjzKOZVKGmDOpwqLPn1K9
         1BJUxPMwtg3McgHCxU/Hz5/TFjsjlL9k908z4=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH 2/5] sched: hide cfs_rq of autogroup if autogroup is disabled
Date: Sun, 20 Feb 2011 15:08:13 +0800
Message-Id: <1298185696-4403-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When autogroup is disabled, sched_debug will show
all of the cfs_rq of autogroup by name "cfs_rq[0]:"
Actually that doesn't make sense and not necessary
to be showed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/sched_debug.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index eb6cb8e..121e2a2 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -169,6 +169,12 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	struct sched_entity *last;
 	unsigned long flags;
 
+#ifdef CONFIG_SCHED_AUTOGROUP
+	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
+
+	if (task_group_is_autogroup(cfs_rq->tg) && !enabled)
+		return;
+#endif
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, task_group_path(cfs_rq->tg));
 #else
-- 
1.7.1

