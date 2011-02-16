Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab1BPAvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:51:45 -0500
Received: from kroah.org ([198.145.64.141]:46191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab1BPAvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:51:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:14 2011
Message-Id: <20110216002114.301380804@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>
Subject: [patch 153/176] SELinux: do not compute transition labels on mountpoint labeled filesystems
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2529,7 +2529,10 @@ static int selinux_inode_init_security(s
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


