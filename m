Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2A3QSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:18:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55019 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2A3QSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:18:53 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
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
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 4/4] Allow unprivileged chroot when safe
Date: Mon, 30 Jan 2012 08:17:29 -0800
Message-Id: <0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chroot can easily be used to subvert setuid programs.  If no_new_privs,
then setuid programs don't gain any privilege, so allow chroot.

Because chroot is an easy way to break out of chroot jail, CAP_SYS_ADMIN
is still required if the caller is already chrooted.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/open.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 77becc0..2e2887a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -418,10 +418,39 @@ out:
 	return error;
 }
 
+static bool is_chrooted(struct fs_struct *fs)
+{
+	bool ret;
+
+	/*
+	 * This is equivalent to checking whether "/.." is the same
+	 * directory as "/", where the ".." part ignores the current
+	 * root.  This logic is the same as follow_dotdot except that we
+	 * ignore fs->root and we don't need to follow the final
+	 * mountpoint we end up on.
+	 */
+	struct path path = fs->root;
+	path_get(&path);
+	while (true) {
+		if (path.dentry != path.mnt->mnt_root) {
+			ret = true;  /* .. moves up within a vfsmount. */
+			break;
+		}
+
+		if (!follow_up(&path)) {
+			ret = false;  /* We've hit the real root. */
+			break;
+		}
+	}
+	path_put(&path);
+	return ret;
+}
+
 SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	struct fs_struct *fs = current->fs;
 
 	error = user_path_dir(filename, &path);
 	if (error)
@@ -432,13 +461,26 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto dput_and_out;
 
 	error = -EPERM;
-	if (!capable(CAP_SYS_CHROOT))
+	/*
+	 * Chroot is dangerous unless no_new_privs is set, and we also
+	 * don't want to allow unprivileged users to break out of chroot
+	 * jail with another chroot call.
+	 *
+	 * We therefore allow chroot under one of two circumstances:
+	 *  a) no_new_privs (so setuid and similar programs can't be
+	 *     exploited), fs not shared (to avoid bypassing no_new_privs),
+	 *     and not already chrooted (so there's no chroot jail to break
+	 *     out of)
+	 *  b) CAP_SYS_CHROOT
+	 */
+	if (!(current->no_new_privs && fs->users == 1 && !is_chrooted(fs)) &&
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
1.7.7.6

