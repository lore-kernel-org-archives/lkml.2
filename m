Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0H1Bdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 21:33:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46614 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0H1Bdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 21:33:41 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36 changes
Date: Fri, 27 Aug 2010 18:33:27 -0700
Message-Id: <1282959209-5431-3-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36 introduced the abilitiy to specify the task that is having its
rlimits set.  Update mediation to ensure that confined tasks can only
set their own group_leader as expected by current policy.

Add TODO note about extending policy to support setting other tasks
rlimits.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c      |    2 +-
 security/apparmor/resource.c |   20 ++++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index f73e2c2..cf1de44 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -614,7 +614,7 @@ static int apparmor_task_setrlimit(struct task_struct *task,
 	int error = 0;
 
 	if (!unconfined(profile))
-		error = aa_task_setrlimit(profile, resource, new_rlim);
+		error = aa_task_setrlimit(profile, task, resource, new_rlim);
 
 	return error;
 }
diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
index 4a368f1..5bc46e5 100644
--- a/security/apparmor/resource.c
+++ b/security/apparmor/resource.c
@@ -72,6 +72,7 @@ int aa_map_resource(int resource)
 /**
  * aa_task_setrlimit - test permission to set an rlimit
  * @profile - profile confining the task  (NOT NULL)
+ * @task - task the resource is being set on
  * @resource - the resource being set
  * @new_rlim - the new resource limit  (NOT NULL)
  *
@@ -79,18 +80,21 @@ int aa_map_resource(int resource)
  *
  * Returns: 0 or error code if setting resource failed
  */
-int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
-		      struct rlimit *new_rlim)
+int aa_task_setrlimit(struct aa_profile *profile, struct task_struct *task,
+		      unsigned int resource, struct rlimit *new_rlim)
 {
 	int error = 0;
 
-	if (profile->rlimits.mask & (1 << resource) &&
-	    new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max)
-
-		error = audit_resource(profile, resource, new_rlim->rlim_max,
-			-EACCES);
+	/* TODO: extend resource control to handle non group leader tasks.
+	 * AppArmor rules currently have the implicit assumption that
+	 * the task having its resource set is the group leader.
+	 */
+	if ((task != current->group_leader) ||
+	    (profile->rlimits.mask & (1 << resource) &&
+	     new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max))
+		error = -EACCES;
 
-	return error;
+	return audit_resource(profile, resource, new_rlim->rlim_max, error);
 }
 
 /**
-- 
1.7.0.4

