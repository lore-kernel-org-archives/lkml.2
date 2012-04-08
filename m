Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab2DHFSl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:18:41 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44082 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944Ab2DHFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:26 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:22 -0700
Message-Id: <1333862139-31737-26-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19qtZPQLDWyr2YJGcOj+GtTTqwqgU4Lg2w=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 26/43] userns: Convert in_group_p and in_egroup_p to use kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/cred.h |    4 ++--
 kernel/groups.c      |   14 ++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index fac0579..917dc5a 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -73,8 +73,8 @@ extern int groups_search(const struct group_info *, kgid_t);
 #define GROUP_AT(gi, i) \
 	((gi)->blocks[(i) / NGROUPS_PER_BLOCK][(i) % NGROUPS_PER_BLOCK])
 
-extern int in_group_p(gid_t);
-extern int in_egroup_p(gid_t);
+extern int in_group_p(kgid_t);
+extern int in_egroup_p(kgid_t);
 
 /*
  * The common credentials for a thread group
diff --git a/kernel/groups.c b/kernel/groups.c
index 84156f2..6b2588d 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -256,27 +256,25 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 /*
  * Check whether we're fsgid/egid or in the supplemental group..
  */
-int in_group_p(gid_t grp)
+int in_group_p(kgid_t grp)
 {
 	const struct cred *cred = current_cred();
 	int retval = 1;
 
-	if (grp != cred->fsgid)
-		retval = groups_search(cred->group_info,
-				       make_kgid(cred->user_ns, grp));
+	if (!gid_eq(grp, cred->fsgid))
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
 EXPORT_SYMBOL(in_group_p);
 
-int in_egroup_p(gid_t grp)
+int in_egroup_p(kgid_t grp)
 {
 	const struct cred *cred = current_cred();
 	int retval = 1;
 
-	if (grp != cred->egid)
-		retval = groups_search(cred->group_info,
-				       make_kgid(cred->user_ns, grp));
+	if (!gid_eq(grp, cred->egid))
+		retval = groups_search(cred->group_info, grp);
 	return retval;
 }
 
-- 
1.7.2.5

