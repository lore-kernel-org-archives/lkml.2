Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab1FWRfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:35:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:34109 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab1FWRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Paris <eparis@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 069/247] SELinux: do not compute transition labels on mountpoint labeled filesystems
Date: Thu, 23 Jun 2011 13:32:17 -0400
Message-Id: <1308850515-15242-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 415103f9932d45f7927f4b17e3a9a13834cdb9a1 upstream.

selinux_inode_init_security computes transitions sids even for filesystems
that use mount point labeling.  It shouldn't do that.  It should just use
the mount point label always and no matter what.

This causes 2 problems.  1) it makes file creation slower than it needs to be
since we calculate the transition sid and 2) it allows files to be created
with a different label than the mount point!

# id -Z
staff_u:sysadm_r:sysadm_t:s0-s0:c0.c1023
# sesearch --type --class file --source sysadm_t --target tmp_t
Found 1 semantic te rules:
   type_transition sysadm_t tmp_t : file user_tmp_t;

# mount -o loop,context="system_u:object_r:tmp_t:s0"  /tmp/fs /mnt/tmp

# ls -lZ /mnt/tmp
drwx------. root root system_u:object_r:tmp_t:s0       lost+found
# touch /mnt/tmp/file1
# ls -lZ /mnt/tmp
-rw-r--r--. root root staff_u:object_r:user_tmp_t:s0   file1
drwx------. root root system_u:object_r:tmp_t:s0       lost+found

Whoops, we have a mount point labeled filesystem tmp_t with a user_tmp_t
labeled file!

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 security/selinux/hooks.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5feecb4..0b459c8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2595,7 +2595,10 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	sid = tsec->sid;
 	newsid = tsec->create_sid;
 
-	if (!newsid || !(sbsec->flags & SE_SBLABELSUPP)) {
+	if ((sbsec->flags & SE_SBINITIALIZED) &&
+	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT))
+		newsid = sbsec->mntpoint_sid;
+	else if (!newsid || !(sbsec->flags & SE_SBLABELSUPP)) {
 		rc = security_transition_sid(sid, dsec->sid,
 					     inode_mode_to_security_class(inode->i_mode),
 					     &newsid);
-- 
1.7.4.4

