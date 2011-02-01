Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1BAQmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:42:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40981 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1BAQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rMJLCiUqu0HHYsiEghahpWNgnRMCq32Ny11SrMS37PIdNtECKHOJOQUHSuWFZDNsc8
         9IqJZpK6d0mhxnNKoLIgJSNLNXxMtxPRk0aZ7hCdwBOFM3PjXPl6tB6nU1Uw152u4atP
         sga/4rfRuez5mQVu1TMH3EAtLBt9MWunA6Y2g=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 1/2] security/selinux: fix /proc/sys/ labeling
Date: Tue,  1 Feb 2011 18:42:22 +0200
Message-Id: <1296578542-5902-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
In-Reply-To: <1296578246.12605.22.camel@moss-pluto>
References: <1296578246.12605.22.camel@moss-pluto>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes an old (2007) selinux regression: filesystem labeling for
/proc/sys returned
     -r--r--r-- unknown                          /proc/sys/fs/file-nr
instead of
     -r--r--r-- system_u:object_r:sysctl_fs_t:s0 /proc/sys/fs/file-nr

Events that lead to breaking of /proc/sys/ selinux labeling:

1) sysctl was reimplemented to route all calls through /proc/sys/

    commit 77b14db502cb85a031fe8fde6c85d52f3e0acb63
    [PATCH] sysctl: reimplement the sysctl proc support

2) proc_dir_entry was removed from ctl_table:

    commit 3fbfa98112fc3962c416452a0baf2214381030e6
    [PATCH] sysctl: remove the proc_dir_entry member for the sysctl tables

3) selinux still walked the proc_dir_entry tree to apply
   labeling. Because ctl_tables don't have a proc_dir_entry, we did
   not label /proc/sys/ inodes any more. To achieve this the /proc/sys/
   inodes were marked private and private inodes were ignored by
   selinux.

    commit bbaca6c2e7ef0f663bc31be4dad7cf530f6c4962
    [PATCH] selinux: enhance selinux to always ignore private inodes

    commit 86a71dbd3e81e8870d0f0e56b87875f57e58222b
    [PATCH] sysctl: hide the sysctl proc inodes from selinux

Access control checks have been done by means of a special sysctl hook
that was called for read/write accesses to any /proc/sys/ entry.

We don't have to do this because, instead of walking the
proc_dir_entry tree we can walk the dentry tree (as done in this
patch). With this patch:
* we don't mark /proc/sys/ inodes as private
* we don't need the sysclt security hook
* we walk the dentry tree to find the path to the inode.

We have to strip the PID in /proc/PID/ entries that have a
proc_dir_entry because selinux does not know how to label paths like
'/1/net/rpc/nfsd.fh' (and defaults to 'proc_t' labeling). Selinux does
know of '/net/rpc/nfsd.fh' (and applies the 'sysctl_rpc_t' label).

PID stripping from the path was done implicitly in the previous code
because the proc_dir_entry tree had the root in '/net' in the example
from above. The dentry tree has the root in '/1'.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c    |    1 -
 security/selinux/hooks.c |  120 +++++++---------------------------------------
 2 files changed, 18 insertions(+), 103 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 09a1f92..fb707e0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -32,7 +32,6 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
 	ei->sysctl_entry = table;
 
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	inode->i_mode = table->mode;
 	if (!table->child) {
 		inode->i_mode |= S_IFREG;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e276eb4..5231b95 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -43,7 +43,6 @@
 #include <linux/fdtable.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
-#include <linux/proc_fs.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/tty.h>
@@ -70,7 +69,6 @@
 #include <net/ipv6.h>
 #include <linux/hugetlb.h>
 #include <linux/personality.h>
-#include <linux/sysctl.h>
 #include <linux/audit.h>
 #include <linux/string.h>
 #include <linux/selinux.h>
@@ -1120,39 +1118,35 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 }
 
 #ifdef CONFIG_PROC_FS
-static int selinux_proc_get_sid(struct proc_dir_entry *de,
+static int selinux_proc_get_sid(struct dentry *dentry,
 				u16 tclass,
 				u32 *sid)
 {
-	int buflen, rc;
-	char *buffer, *path, *end;
+	int rc;
+	char *buffer, *path;
 
 	buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-	buflen = PAGE_SIZE;
-	end = buffer+buflen;
-	*--end = '\0';
-	buflen--;
-	path = end-1;
-	*path = '/';
-	while (de && de != de->parent) {
-		buflen -= de->namelen + 1;
-		if (buflen < 0)
-			break;
-		end -= de->namelen;
-		memcpy(end, de->name, de->namelen);
-		*--end = '/';
-		path = end;
-		de = de->parent;
+	path = dentry_path_raw(dentry, buffer, PAGE_SIZE);
+	if (IS_ERR(path))
+		rc = PTR_ERR(path);
+	else {
+		/* each process gets a /proc/PID/ entry. Strip off the
+		 * PID part to get a valid selinux labeling.
+		 * e.g. /proc/1/net/rpc/nfs -> /net/rpc/nfs */
+		while (path[1] >= '0' && path[1] <= '9') {
+			path[1] = '/';
+			path++;
+		}
+		rc = security_genfs_sid("proc", path, tclass, sid);
 	}
-	rc = security_genfs_sid("proc", path, tclass, sid);
 	free_page((unsigned long)buffer);
 	return rc;
 }
 #else
-static int selinux_proc_get_sid(struct proc_dir_entry *de,
+static int selinux_proc_get_sid(struct dentry *dentry,
 				u16 tclass,
 				u32 *sid)
 {
@@ -1316,10 +1310,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		isec->sid = sbsec->sid;
 
 		if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
-			struct proc_inode *proci = PROC_I(inode);
-			if (proci->pde) {
+			if (opt_dentry) {
 				isec->sclass = inode_mode_to_security_class(inode->i_mode);
-				rc = selinux_proc_get_sid(proci->pde,
+				rc = selinux_proc_get_sid(opt_dentry,
 							  isec->sclass,
 							  &sid);
 				if (rc)
@@ -1862,82 +1855,6 @@ static int selinux_capable(struct task_struct *tsk, const struct cred *cred,
 	return task_has_capability(tsk, cred, cap, audit);
 }
 
-static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
-{
-	int buflen, rc;
-	char *buffer, *path, *end;
-
-	rc = -ENOMEM;
-	buffer = (char *)__get_free_page(GFP_KERNEL);
-	if (!buffer)
-		goto out;
-
-	buflen = PAGE_SIZE;
-	end = buffer+buflen;
-	*--end = '\0';
-	buflen--;
-	path = end-1;
-	*path = '/';
-	while (table) {
-		const char *name = table->procname;
-		size_t namelen = strlen(name);
-		buflen -= namelen + 1;
-		if (buflen < 0)
-			goto out_free;
-		end -= namelen;
-		memcpy(end, name, namelen);
-		*--end = '/';
-		path = end;
-		table = table->parent;
-	}
-	buflen -= 4;
-	if (buflen < 0)
-		goto out_free;
-	end -= 4;
-	memcpy(end, "/sys", 4);
-	path = end;
-	rc = security_genfs_sid("proc", path, tclass, sid);
-out_free:
-	free_page((unsigned long)buffer);
-out:
-	return rc;
-}
-
-static int selinux_sysctl(ctl_table *table, int op)
-{
-	int error = 0;
-	u32 av;
-	u32 tsid, sid;
-	int rc;
-
-	sid = current_sid();
-
-	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
-				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
-	if (rc) {
-		/* Default to the well-defined sysctl SID. */
-		tsid = SECINITSID_SYSCTL;
-	}
-
-	/* The op values are "defined" in sysctl.c, thereby creating
-	 * a bad coupling between this module and sysctl.c */
-	if (op == 001) {
-		error = avc_has_perm(sid, tsid,
-				     SECCLASS_DIR, DIR__SEARCH, NULL);
-	} else {
-		av = 0;
-		if (op & 004)
-			av |= FILE__READ;
-		if (op & 002)
-			av |= FILE__WRITE;
-		if (av)
-			error = avc_has_perm(sid, tsid,
-					     SECCLASS_FILE, av, NULL);
-	}
-
-	return error;
-}
-
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -5398,7 +5315,6 @@ static struct security_operations selinux_ops = {
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
-	.sysctl =			selinux_sysctl,
 	.capable =			selinux_capable,
 	.quotactl =			selinux_quotactl,
 	.quota_on =			selinux_quota_on,
-- 
1.7.4.rc1.7.g2cf08.dirty

