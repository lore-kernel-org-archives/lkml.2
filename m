Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0IFRKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:10:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47603 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab0IFRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:10:24 -0400
Message-ID: <4C85207C.8040003@canonical.com>
Date: Mon, 06 Sep 2010 10:10:20 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36
 changes
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com> <1282959209-5431-3-git-send-email-john.johansen@canonical.com> <4C794310.1020801@canonical.com> <4C795242.80402@gmail.com> <4C797315.7030204@canonical.com> <4C797627.6080708@gmail.com> <4C7BE205.40202@canonical.com> <4C7C238D.2070505@gmail.com>
In-Reply-To: <4C7C238D.2070505@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 02:33 PM, Jiri Slaby wrote:
> On 08/30/2010 06:53 PM, John Johansen wrote:
>> /* TODO: extend resource control to handle other (non current) processes.
>>  * AppArmor rules currently have the implicit assumption that the task
>>  * is setting the resource of the current process
>>  */
> 
> Makes sense(TM) now.
> 
This is the patch updated with the only comment changed to what was
discussed with Jiri above.

thanks again
john

---
AppArmor: Fix security_task_setrlimit logic for 2.6.36 changes

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
index 4a368f1..a4136c1 100644
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
+	/* TODO: extend resource control to handle other (non current)
+	 * processes.  AppArmor rules currently have the implicit assumption
+	 * that the task is setting the resource of the current process
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
