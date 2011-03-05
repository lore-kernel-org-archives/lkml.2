Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab1CEAvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 19:51:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:47677 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1CEAvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:51:45 -0500
From: Andrey Vagin <avagin@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@openvz.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: skip zombie in OOM-killer
Date: Sat,  5 Mar 2011 03:51:47 +0300
Message-Id: <1299286307-4386-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we check that task has flag TIF_MEMDIE, we forgot check that
it has mm. A task may be zombie and a parent may wait a memor.

v2: Check that task doesn't have mm one time and skip it immediately

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 mm/oom_kill.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7dcca55..b1ce3ba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -299,6 +299,9 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 	for_each_process(p) {
 		unsigned int points;
 
+		if (!p->mm)
+			continue;
+
 		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
@@ -324,7 +327,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		 * the process of exiting and releasing its resources.
 		 * Otherwise we could get an easy OOM deadlock.
 		 */
-		if (thread_group_empty(p) && (p->flags & PF_EXITING) && p->mm) {
+		if (thread_group_empty(p) && (p->flags & PF_EXITING)) {
 			if (p != current)
 				return ERR_PTR(-1UL);
 
-- 
1.7.1

