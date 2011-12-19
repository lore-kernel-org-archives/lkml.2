Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1LSEH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:07:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54072 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1LSEHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:07:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
	<m14nwxkxyg.fsf@fess.ebiederm.org>
	<m1zkepjjb8.fsf_-_@fess.ebiederm.org>
	<m1ty4xjj9r.fsf_-_@fess.ebiederm.org>
Date: Sun, 18 Dec 2011 20:09:31 -0800
In-Reply-To: <m1ty4xjj9r.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Sun, 18 Dec 2011 20:08:16 -0800")
Message-ID: <m1obv5jj7o.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VRttT0esrmc4whmb9glkdA7MzRUIp3po=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: **
Subject: [PATCH 4/4] sysfs: Kill nlink counting.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tracking the number of subdirectories requires an extra field that increases
the size of sysfs_dirent.  nlinks are not particularly interesting for sysfs
and the nlink counts are wrong when network namespaces are involved so stop
counting them, and always return nlink == 1.  Userspace already knows that
directories with nlink == 1 have an nlink count they can't use to count
subdirectories.

This reduces the size of sysfs_dirent by 8 bytes on 64bit platforms.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |    6 ------
 fs/sysfs/inode.c |    3 ---
 fs/sysfs/sysfs.h |    1 -
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0589c9a..ea64d01 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -91,9 +91,6 @@ static int sysfs_link_sibling(struct sysfs_dirent *sd)
 	struct rb_node **node = &sd->s_parent->s_dir.children.rb_node;
 	struct rb_node *parent = NULL;
 
-	if (sysfs_type(sd) == SYSFS_DIR)
-		sd->s_parent->s_dir.subdirs++;
-
 	while (*node) {
 		struct sysfs_dirent *pos;
 		int result;
@@ -126,9 +123,6 @@ static int sysfs_link_sibling(struct sysfs_dirent *sd)
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
-	if (sysfs_type(sd) == SYSFS_DIR)
-		sd->s_parent->s_dir.subdirs--;
-
 	rb_erase(&sd->s_rb, &sd->s_parent->s_dir.children);
 }
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index c81b22f..c7be716 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -216,9 +216,6 @@ static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
 					    iattrs->ia_secdata,
 					    iattrs->ia_secdata_len);
 	}
-
-	if (sysfs_type(sd) == SYSFS_DIR)
-		set_nlink(inode, sd->s_dir.subdirs + 2);
 }
 
 int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3f23061..2adb052 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -19,7 +19,6 @@ struct sysfs_open_dirent;
 struct sysfs_elem_dir {
 	struct kobject		*kobj;
 
-	unsigned long		subdirs;
 	/* children rbtree starts here and goes through sd->s_rb */
 	struct rb_root		children;
 };
-- 
1.7.2.5

