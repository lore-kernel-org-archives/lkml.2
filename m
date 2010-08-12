Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab0HLJph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:45:37 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2922 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310Ab0HLJpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:45:33 -0400
X-IronPort-AV: E=Sophos;i="4.55,357,1278280800"; 
   d="scan'208";a="67527459"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 1/3] cgroup_freezer: Unnecessary test in cgroup_freezing_or_frozen
Date: Thu, 12 Aug 2010 11:45:21 +0200
Message-Id: <1281606323-16245-2-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1281606323-16245-1-git-send-email-tomasz.buchert@inria.fr>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-1-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The root freezer_state is always CGROUP_THAWED so we can remove
the special case from the code. The test itself can be handy
and is extracted to static function.

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 kernel/cgroup_freezer.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index ce71ed5..321e2a0 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -48,20 +48,19 @@ static inline struct freezer *task_freezer(struct task_struct *task)
 			    struct freezer, css);
 }
 
-int cgroup_freezing_or_frozen(struct task_struct *task)
+static inline int __cgroup_freezing_or_frozen(struct task_struct *task)
 {
-	struct freezer *freezer;
-	enum freezer_state state;
+	enum freezer_state state = task_freezer(task)->state;
+	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
+}
 
+int cgroup_freezing_or_frozen(struct task_struct *task)
+{
+	int result;
 	task_lock(task);
-	freezer = task_freezer(task);
-	if (!freezer->css.cgroup->parent)
-		state = CGROUP_THAWED; /* root cgroup can't be frozen */
-	else
-		state = freezer->state;
+	result = __cgroup_freezing_or_frozen(task);
 	task_unlock(task);
-
-	return (state == CGROUP_FREEZING) || (state == CGROUP_FROZEN);
+	return result;
 }
 
 /*
-- 
1.6.3.3

