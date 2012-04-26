Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2DZG0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:26:49 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:40171 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab2DZG0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:26:47 -0400
From: Michael Tokarev <mjt@tls.msk.ru>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org, autofs@vger.kernel.org
Subject: [PATCH] unbreak automount daemon after fixing autofs5 ABI
Date: Thu, 26 Apr 2012 10:26:34 +0400
Message-Id: <1335421594-10499-1-git-send-email-mjt@msgid.tls.msk.ru>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 499f286dc02cde6b668e2d757dfe100cb0c43445, comitted
in Feb-2012, fixed a kernel<=>user interface which was
broken for mixed 32/64 user/kernel environment since its
introduction in 2006 by commit 5c0a32fc2cd0.  The problem
with this fix is that it broke userspace which were adopted
to the initial bug a year after its introduction, in
autofs-5.0.1.  So patch 499f286dc02cde6b broke a working
userspace.  This has been done because another user of
this interface emerged, systemd, which had the same prob
as old automount (<5.0.1) had.  So the end result was a
breakage of an old, widely used -- by all current and
previous distribution -- software (autofs5) in order to
unbreak a new not yet widely adopted software (systemd).

The real fix for this issue, in my opinion, is to adopt
the same fix in systemd as has been done in autofs5, and/or
to have a new interface without a bug wich both userspace
implementations will use.

Alternative is to find a way on the kernel side to see
which variant of userspace we're dealing with, by seeing
how many bytes for the structure in question the userspace
requests in read operation.  But since autofs uses regular
pipe code to read the data from kernel, and the said pipe
is opened in userspace before connecting it with the autofs
module, reads are not seen by autofs module directly, they're
seen by the pipe code.

So for now, below is a minimal quick fix which should sort
current mess.

Change 499f286dc02cde6b tries to fix the original interface
bug for 32bit userspace running on 64bit kernel.  But the
issue is that autofs5 already has a workaround for it, so
the end result is that the two (kernel & user) disagree
again.  "Fix" this by applying the in-kernel fix only if
the process is not named "automount" -- which is how autofs5
daemon is named.

This change should be applied to all 3.x stable series too,
since it breaks existing userspace for these kernels.

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Cc: Ian Kent <raven@themaw.net>
Cc: Thomas Meyer <thomas@m3y3r.de>
Cc: stable@kernel.org
Cc: autofs@vger.kernel.org
---
 fs/autofs4/dev-ioctl.c |    3 ++-
 fs/autofs4/inode.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 9dacb85..d5a4cb6 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -385,7 +385,8 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
-		sbi->compat_daemon = is_compat_task();
+		sbi->compat_daemon =
+			is_compat_task() && strcmp(current->comm, "automount");
 	}
 out:
 	mutex_unlock(&sbi->wq_mutex);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index d8dc002..b59f6a0 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -225,7 +225,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
-	sbi->compat_daemon = is_compat_task();
+	sbi->compat_daemon =
+		is_compat_task() && strcmp(current->comm, "automount");
 	mutex_init(&sbi->wq_mutex);
 	mutex_init(&sbi->pipe_mutex);
 	spin_lock_init(&sbi->fs_lock);
-- 
1.7.10

