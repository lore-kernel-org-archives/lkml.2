Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2APAiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:38:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2APAh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:37:59 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 4/4] Allow unprivileged chroot when safe
Date: Sun, 15 Jan 2012 16:37:21 -0800
Message-Id: <c4c1a0e710a50e48221aa28d2b60b486ab686369.1326673414.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <cover.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net>
In-Reply-To: <cover.1326673414.git.luto@amacapital.net>
References: <cover.1326673414.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chroot can easily be used to subvert setuid programs.  If no_new_privs,
then setuid programs don't gain any privilege, so allow chroot.

Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
is still required if the caller is already chrooted.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/open.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f711921..80ca7e2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -422,6 +422,8 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	struct fs_struct *fs = current->fs;
+	bool is_chrooted;
 
 	error = user_path_dir(filename, &path);
 	if (error)
@@ -432,13 +434,23 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto dput_and_out;
 
 	error = -EPERM;
-	if (!capable(CAP_SYS_CHROOT))
+	/*
+	 * Chroot is dangerous unless no_new_privs is set.  But we also
+	 * don't want to allow unprivileged users to break out of chroot
+	 * jail with another chroot call, so we require either CAP_SYS_CHROOT
+	 * unless we're not chrooted already and we have no_new_privs.
+	 */
+	is_chrooted = (fs->root.mnt->mnt_mountpoint !=
+		       fs->root.mnt->mnt_parent->mnt_root ||
+		       fs->root.dentry != fs->root.mnt->mnt_root);
+	if (!(current->no_new_privs && !is_chrooted) &&
+	    !capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 	error = security_path_chroot(&path);
 	if (error)
 		goto dput_and_out;
 
-	set_fs_root(current->fs, &path);
+	set_fs_root(fs, &path);
 	error = 0;
 dput_and_out:
 	path_put(&path);
-- 
1.7.7.5

