Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DTWC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:44614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab1DTWC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:02:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,247,1301900400"; 
   d="scan'208";a="681710034"
From: Andi Kleen <andi@firstfloor.org>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability walk.
Date: Wed, 20 Apr 2011 15:00:44 -0700
Message-Id: <1303336844-31074-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

smk_access_entry does a RCU list walk for a list shared with other
threads. It relies on the caller doing rcu_read_lock().
One caller forgot to do to this, which could lead to races
on preemptible kernels.

Move the rcu_read_lock() into smk_access_entry instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 security/smack/smack_access.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 7b0d3b3..43b20f3 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -92,6 +92,7 @@ int smk_access_entry(char *subject_label, char *object_label,
 	int may = -ENOENT;
 	struct smack_rule *srp;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(srp, rule_list, list) {
 		if (srp->smk_subject == subject_label ||
 		    strcmp(srp->smk_subject, subject_label) == 0) {
@@ -102,6 +103,7 @@ int smk_access_entry(char *subject_label, char *object_label,
 			}
 		}
 	}
+	rcu_read_unlock();
 
 	return may;
 }
@@ -184,9 +186,7 @@ int smk_access_flags(char *subject_label, char *object_label, int request,
 	 * good. A negative response from smk_access_entry()
 	 * indicates there is no entry for this pair.
 	 */
-	rcu_read_lock();
 	may = smk_access_entry(subject_label, object_label, &smack_rule_list);
-	rcu_read_unlock();
 
 	if (may > 0 && (request & may) == request)
 		goto out_audit;
-- 
1.7.4.2

