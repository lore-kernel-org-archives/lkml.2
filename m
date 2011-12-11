Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1LKU7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:59:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53397 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1LKU7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:59:47 -0500
Date: Sun, 11 Dec 2011 20:59:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH -next] proc: fix task_struct infoleak
Message-ID: <20111211205939.GH2203@ZenIV.linux.org.uk>
References: <20111211182821.GA2853@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111211182821.GA2853@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 10:28:21PM +0400, Vasiliy Kulikov wrote:
> proc_pid_permission() doesn't put task_struct on every /proc/$pid/
> access.  A demo from Hugh Dickins:
> 
> while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  This is a patch against a hidepid patchset from -mm.

Choose saner commit summary, please.  It's not information leak, for pity sake
- it's a plain and simple memory leak...

Speaking of which, I've a couple of memory leaks in mainline procfs and
mqueue; Alexey, are you OK with that sucker going directly to Linus or
would you rather push it yourself?  See the patch below...

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 9a8a2b7..03102d9 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -91,20 +91,18 @@ static struct file_system_type proc_fs_type = {
 
 void __init proc_root_init(void)
 {
-	struct vfsmount *mnt;
 	int err;
 
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
-	mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
-	if (IS_ERR(mnt)) {
+	err = pid_ns_prepare_proc(&init_pid_ns);
+	if (err) {
 		unregister_filesystem(&proc_fs_type);
 		return;
 	}
 
-	init_pid_ns.proc_mnt = mnt;
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	proc_net_init();
@@ -209,5 +207,5 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 
 void pid_ns_release_proc(struct pid_namespace *ns)
 {
-	mntput(ns->proc_mnt);
+	kern_unmount(ns->proc_mnt);
 }
