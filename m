Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0H1RKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 13:10:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53582 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0H1RKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 13:10:46 -0400
Message-ID: <4C794310.1020801@canonical.com>
Date: Sat, 28 Aug 2010 10:10:40 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36
 changes
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com> <1282959209-5431-3-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1282959209-5431-3-git-send-email-john.johansen@canonical.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2010 06:33 PM, John Johansen wrote:
> 2.6.36 introduced the abilitiy to specify the task that is having its
> rlimits set.  Update mediation to ensure that confined tasks can only
> set their own group_leader as expected by current policy.
> 
> Add TODO note about extending policy to support setting other tasks
> rlimits.
> 
the change to security/apparmor/include/resource.h is missing from the
previous patch.

find the corrected patch below

---

>From f09ade4027dc55b3c41f0dffa587789c43395610 Mon Sep 17 00:00:00 2001
From: John Johansen <john.johansen@canonical.com>
Date: Wed, 25 Aug 2010 16:13:07 -0700
Subject: [PATCH] AppArmor: Fix security_task_setrlimit logic for 2.6.36 changes

2.6.36 introduced the abilitiy to specify the task that is having its
rlimits set.  Update mediation to ensure that confined tasks can only
set their own group_leader as expected by current policy.

Add TODO note about extending policy to support setting other tasks
rlimits.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/resource.h |    4 ++--
 security/apparmor/lsm.c              |    2 +-
 security/apparmor/resource.c         |   20 ++++++++++++--------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/security/apparmor/include/resource.h b/security/apparmor/include/resource.h
index 3c88be9..02baec7 100644
--- a/security/apparmor/include/resource.h
+++ b/security/apparmor/include/resource.h
@@ -33,8 +33,8 @@ struct aa_rlimit {
 };
 
 int aa_map_resource(int resource);
-int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
-		      struct rlimit *new_rlim);
+int aa_task_setrlimit(struct aa_profile *profile, struct task_struct *,
+		      unsigned int resource, struct rlimit *new_rlim);
 
 void __aa_transition_rlimits(struct aa_profile *old, struct aa_profile *new);
 
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
