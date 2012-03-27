Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2C0LOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:14:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab2C0LOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:14:43 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH] apparmor: Fix change_onexec when called from a confined task
Date: Tue, 27 Mar 2012 04:14:33 -0700
Message-Id: <1332846873-30208-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix failure in aa_change_onexec api when the request is made from a confined
task.  This failure was caused by two problems

 The AA_MAY_ONEXEC perm was not being mapped correctly for this case.

 The executable name was being checked as second time instead of using the
 requested onexec profile name, which may not be the same as the exec
 profile name. This mistake can not be exploited to grant extra permission
 because of the above flaw where the ONEXEC permission was not being mapped
 so it will not be granted.

BugLink: http://bugs.launchpad.net/bugs/963756

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/domain.c |    3 ++-
 security/apparmor/file.c   |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 7c69599..6327685 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -410,7 +410,8 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
 		 * exec\0change_profile
 		 */
 		state = aa_dfa_null_transition(profile->file.dfa, state);
-		cp = change_profile_perms(profile, cxt->onexec->ns, name,
+		cp = change_profile_perms(profile, cxt->onexec->ns,
+					  cxt->onexec->base.name,
 					  AA_MAY_ONEXEC, state);
 
 		if (!(cp.allow & AA_MAY_ONEXEC))
diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 3022c0f..5d176f2 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -215,6 +215,8 @@ static struct file_perms compute_perms(struct aa_dfa *dfa, unsigned int state,
 	/* change_profile wasn't determined by ownership in old mapping */
 	if (ACCEPT_TABLE(dfa)[state] & 0x80000000)
 		perms.allow |= AA_MAY_CHANGE_PROFILE;
+	if (ACCEPT_TABLE(dfa)[state] & 0x40000000)
+		perms.allow |= AA_MAY_ONEXEC;
 
 	return perms;
 }
-- 
1.7.9.1

