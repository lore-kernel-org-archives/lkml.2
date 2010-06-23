Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0FWVx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 17:53:57 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37334 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884Ab0FWVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 17:53:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, nhorman@tuxdriver.com,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/12] rlimits: selinux, do rlimits changes under task_lock
Date: Wed, 23 Jun 2010 23:52:05 +0200
Message-Id: <1277329933-8139-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
References: <1277329933-8139-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

When doing an exec, selinux updates rlimits in its code of current
process depending on current max. Make sure max or cur doesn't change
in the meantime by grabbing task_lock which do_prlimit needs for
changing limits too.

While at it, use rlimit helper for accessing CPU rlimit a line below.
To have a volatile access too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 security/selinux/hooks.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index afb18a9..2a8a0a9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2333,13 +2333,15 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	rc = avc_has_perm(new_tsec->osid, new_tsec->sid, SECCLASS_PROCESS,
 			  PROCESS__RLIMITINH, NULL);
 	if (rc) {
+		/* protect against do_prlimit() */
+		task_lock(current);
 		for (i = 0; i < RLIM_NLIMITS; i++) {
 			rlim = current->signal->rlim + i;
 			initrlim = init_task.signal->rlim + i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		update_rlimit_cpu(current,
-				current->signal->rlim[RLIMIT_CPU].rlim_cur);
+		task_unlock(current);
+		update_rlimit_cpu(current, rlimit(RLIMIT_CPU));
 	}
 }
 
-- 
1.7.1


