Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab1C3VG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:4889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933337Ab1C3VGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734574"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: eparis@redhat.com, ak@linux.intel.com, jmorris@namei.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [75/275] SELinux: do not compute transition labels on mountpoint labeled filesystems
Message-Id: <20110330210512.A41013E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Reviewed-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/selinux/hooks.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/security/selinux/hooks.c
===================================================================
--- linux-2.6.35.y.orig/security/selinux/hooks.c	2011-03-29 22:51:40.067697937 -0700
+++ linux-2.6.35.y/security/selinux/hooks.c	2011-03-29 23:54:51.592682299 -0700
@@ -2573,7 +2573,10 @@
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
