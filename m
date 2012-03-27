Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2C0OOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:14:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:50451 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2C0OOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:14:03 -0400
Date: Wed, 28 Mar 2012 01:13:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: [GIT] Apparmor bugfix
Message-ID: <alpine.LRH.2.02.1203280112180.22779@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this fix for Apparmor.

The following changes since commit e22057c8599373e5caef0bc42bdb95d2a361ab0d:
  Linus Torvalds (1):
        Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/.../konrad/xen

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

John Johansen (1):
      apparmor: Fix change_onexec when called from a confined task

 security/apparmor/domain.c |    3 ++-
 security/apparmor/file.c   |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

commit 0421ea91ddc7895a5a68d3bc670ed4b8e6448a42
Author: John Johansen <john.johansen@canonical.com>
Date:   Tue Mar 27 04:14:33 2012 -0700

    apparmor: Fix change_onexec when called from a confined task
    
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
    Signed-off-by: James Morris <james.l.morris@oracle.com>

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
