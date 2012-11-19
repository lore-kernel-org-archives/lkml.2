Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2KSPM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:12:57 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60706 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KSPMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:12:55 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:26 -0800
Message-Id: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87lidx8wbo.fsf@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
X-XM-AID: U2FsdGVkX18Tl3fOdood0zcW8to62eby1745BVxRjWI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0040]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 01/16] userns: Ignore suid and sgid on binaries if the uid or gid can not be mapped
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When performing an exec where the binary lives in one user namespace and
the execing process lives in another usre namespace there is the possibility
that the target uids can not be represented.

Instead of failing the exec simply ignore the suid/sgid bits and run
the binary with lower privileges.   We already do this in the case
of MNT_NOSUID so this should be a well tested code path.

As the user and group are not changed this should not introduce any
security issues.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/exec.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0039055..aef0c2f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1266,14 +1266,13 @@ int prepare_binprm(struct linux_binprm *bprm)
 	bprm->cred->egid = current_egid();
 
 	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID) &&
-	    !current->no_new_privs) {
+	    !current->no_new_privs &&
+	    kuid_has_mapping(bprm->cred->user_ns, inode->i_uid) &&
+	    kgid_has_mapping(bprm->cred->user_ns, inode->i_gid)) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
-			if (!kuid_has_mapping(bprm->cred->user_ns, inode->i_uid))
-				return -EPERM;
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
 			bprm->cred->euid = inode->i_uid;
-
 		}
 
 		/* Set-gid? */
@@ -1283,8 +1282,6 @@ int prepare_binprm(struct linux_binprm *bprm)
 		 * executable.
 		 */
 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
-			if (!kgid_has_mapping(bprm->cred->user_ns, inode->i_gid))
-				return -EPERM;
 			bprm->per_clear |= PER_CLEAR_ON_SETID;
 			bprm->cred->egid = inode->i_gid;
 		}
-- 
1.7.5.4

