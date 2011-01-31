Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1AaQ1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:27:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab1AaQ1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:27:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kks25L6+Wli400cuyoCMpyr5q2QQEs0ig78hgmvM0MtYBzPi0NI7mESK6oqPxpfC45
         eK8VrO8CkOEPU7HVtoAqP+E+mgd9IRpGChYe7hjX1FJI4C3RzSnHWCwNQFH1gEMokrLQ
         PuLQ524MtYiPMdX8W9fVTwI617Jr7e/GfAEqs=
MIME-Version: 1.0
In-Reply-To: <1296482354.26427.21.camel@moss-pluto>
References: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com> <1296482354.26427.21.camel@moss-pluto>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 31 Jan 2011 18:27:11 +0200
Message-ID: <AANLkTimt5sxmgUmn-i-WcgMN4d0X00YVMujsA4QgS8nX@mail.gmail.com>
Subject: Re: [PATCH 2/2] RFC: selinux: sysctl: fix selinux labeling broken by
 last patch
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux <selinux@tycho.nsa.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 3:59 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> - You don't need special handling of /proc/PID entries.  Those are
> labeled via the security_task_to_inode -> selinux_task_to_inode hook,
> called from proc_pid_make_inode and the _revalidate functions.


On a clean 2.6.37 I ran:
   ls -Z /proc/1/net/rpc/nfs    >> find.txt
   ls -Z /proc/1/limits         >> find.txt
   ls -Z /proc/1/net/netfilter  >> find.txt

with a printk() for the path computed in selinux_proc_get_sid. These
paths printed were:
  /net/rpc/nfs
  /net/netfilter
  /net/netfilter/nf_log [ and others files in netfilter dir ]


So, while there may be some ->sid initializing in the hooks you
mention, these ones get their sid from selinux_proc_get_sid called
from inode_doinit_with_dentry.

There was nothing for /proc/1/limits because it got filtered by this
check in inode_doinit_with_dentry():
         struct proc_inode *proci = PROC_I(inode);
         if (proci->pde) {
                selinux_proc_get_sid(...)


I do need to get the PID part out to compute a valid path for
selinux_proc_get_sid().

Before Eric's patch the path was computed by walking the struct
proc_dir_entry->parent links. These links stopped before the PID
entry: /proc/PID/net/stuff -> /net/stuff.

Because now we walk the path without /proc/ -> /PID/net/stuff, we will
send a path to selinux_proc_get_sid that will not be mappable to a
valid label so it will default to proc_t.


I know understand why I saw some differences between running 'find
/proc | xargs ls -Z' with and without these patches: Eric's patches
called selinux_proc_get_sid() without this check:
         struct proc_inode *proci = PROC_I(inode);
         if (proci->pde) {


I've updated my patch to take this into consideration. I'll post an
update later with the patches merged and without the "//deleted"
manipulation.


Again, I have next to nothing selinux experience, and probably my test
system is very bad configured to run a relevant selinux test. I've
uploaded here the output and dmesg from running 'find /proc | xargs ls
-Z' on 2.6.37 with and without these two patches:
http://swarm.cs.pub.ro/~lucian/store/v4/

There are now fewer differences than before, but I'd like to point
something out: *without* the patches files in /proc/sys/* get labeled
like this.
-r--r--r-- unknown                          /proc/sys/fs/file-nr
-rw-r--r-- unknown                          /proc/sys/debug/exception-trace
-rw-r--r-- unknown                          /proc/sys/dev/cdrom/autoclose
-rw-r--r-- unknown                          /proc/sys/kernel/sem
-rw-r--r-- unknown
/proc/sys/net/ipv4/conf/all/accept_local

but with the patches:
-r--r--r-- system_u:object_r:sysctl_fs_t:s0 /proc/sys/fs/file-nr
-rw-r--r-- system_u:object_r:sysctl_t:s0    /proc/sys/debug/exception-trace
-rw-r--r-- system_u:object_r:sysctl_dev_t:s0 /proc/sys/dev/cdrom/autoclose
-rw-r--r-- system_u:object_r:sysctl_kernel_t:s0 /proc/sys/kernel/sem
-rw-r--r-- system_u:object_r:sysctl_net_t:s0
/proc/sys/net/ipv4/conf/all/accept_local


There seem to be no labeling mismatches elsewhere. So either sysctl
labeling is broken in 2.6.37 or my test setup is broken.

I'll try to find out if there's an earlier kernel that works on my
setul for sysctl too.

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index b652cb0..b17619d 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -31,7 +31,6 @@ static struct inode *proc_sys_make_inode(struct
super_block *sb,
 	ei->sysctl_entry = table;

 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
 	inode->i_mode = table->mode;
 	if (!table->child) {
 		inode->i_mode |= S_IFREG;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 51615f6..af8be17 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1132,8 +1132,23 @@ static int selinux_proc_get_sid(struct dentry *dentry,
 	path = dentry_path(dentry, buffer, PAGE_SIZE);
 	if (IS_ERR(path))
 		rc = PTR_ERR(path);
-	else
+	else {
+		/* because dentry is not hashed, dentry_path() will
+		 * append "//deleted" to the end of the string. We'll
+		 * remove this as no /proc/ file is named so. */
+		int pathlen = strlen(path);
+		int dellen = strlen("//deleted");
+		if ((pathlen > dellen) && strcmp(path + pathlen - dellen, "//deleted") == 0)
+			path[pathlen-dellen] = '\0';
+
+		/* each process gets a /proc/PID/ entry. Strip off the
+		 * PID part to get a valid selinux labeling. */
+		while (path[1] >= '0' && path[1] <= '9') {
+			path[1] = '/';
+			path++;
+		}
 		rc = security_genfs_sid("proc", path, tclass, sid);
+	}
 	free_page((unsigned long)buffer);
 	return rc;
 }
@@ -1302,7 +1317,8 @@ static int inode_doinit_with_dentry(struct inode
*inode, struct dentry *opt_dent
 		isec->sid = sbsec->sid;

 		if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
-			if (opt_dentry) {
+			struct proc_inode *proci = PROC_I(inode);
+			if (opt_dentry && (proci->pde || proci->sysctl)) {
 				isec->sclass = inode_mode_to_security_class(inode->i_mode);
 				rc = selinux_proc_get_sid(opt_dentry,
 							  isec->sclass,
@@ -1464,9 +1480,6 @@ static int inode_has_perm(const struct cred *cred,

 	validate_creds(cred);

-	if (unlikely(IS_PRIVATE(inode)))
-		return 0;
-
 	sid = cred_sid(cred);
 	isec = inode->i_security;
