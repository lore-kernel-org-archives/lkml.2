Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2BZPKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 10:10:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2BZPKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 10:10:23 -0500
Date: Sun, 26 Feb 2012 16:10:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] autofs: fix 3.3-rc5 compilation breakage on x86-32
Message-ID: <20120226151015.GA14324@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent commit a32744d4abae24572eff7269bc17895c41bd0085 broke autofs
compilation on x86-32:

fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
fs/autofs4/inode.c:228: error: implicit declaration of function ‘is_compat_task’

This patch fix that by adding #if checks.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/autofs4/autofs_i.h  |    2 ++
 fs/autofs4/dev-ioctl.c |    2 ++
 fs/autofs4/inode.c     |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index eb1cc92..60439c2 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -110,7 +110,9 @@ struct autofs_sb_info {
 	int sub_version;
 	int min_proto;
 	int max_proto;
+#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
 	int compat_daemon;
+#endif
 	unsigned long exp_timeout;
 	unsigned int type;
 	int reghost_enabled;
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 85f1fcd..3ffff72 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -385,7 +385,9 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
+#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
 		sbi->compat_daemon = is_compat_task();
+#endif
 	}
 out:
 	mutex_unlock(&sbi->wq_mutex);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 06858d9..5f3fb68 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -225,7 +225,9 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
+#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
 	sbi->compat_daemon = is_compat_task();
+#endif
 	mutex_init(&sbi->wq_mutex);
 	mutex_init(&sbi->pipe_mutex);
 	spin_lock_init(&sbi->fs_lock);
-- 
1.7.1

