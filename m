Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587Ab2CBXhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 18:37:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2CBXhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 18:37:42 -0500
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Meyer <thomas@m3y3r.de>, Ian Kent <raven@themaw.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] autofs: fix compilation on hosts without CONFIG_COMPAT
Date: Sat,  3 Mar 2012 00:37:40 +0100
Message-Id: <1330731460-24727-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling 3.3-rc5 on arm, I get the following compilation error:

  fs/autofs4/inode.c: In function 'autofs4_fill_super':
  fs/autofs4/inode.c:228:2: error: implicit declaration of function 'is_compat_task' [-Werror=implicit-function-declaration]

which was introduced by commit a32744d4a. On platforms that don't define
CONFIG_COMPAT, using is_compat_task() is not necessarily defined. So
let's just not use it there.

Signed-off-by: Alexander Graf <agraf@suse.de>

---

Sorry if this was already fixed elsewhere - I couldn't find a patch for it, but
my LKML searching skills are slightly limited :)

diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 85f1fcd..bab4c5a 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -385,7 +385,11 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		sbi->pipefd = pipefd;
 		sbi->pipe = pipe;
 		sbi->catatonic = 0;
+#ifdef CONFIG_COMPAT
 		sbi->compat_daemon = is_compat_task();
+#else
+		sbi->compat_daemon = 0;
+#endif
 	}
 out:
 	mutex_unlock(&sbi->wq_mutex);
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index 06858d9..1fc68e7 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -225,7 +225,11 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
 	set_autofs_type_indirect(&sbi->type);
 	sbi->min_proto = 0;
 	sbi->max_proto = 0;
+#ifdef CONFIG_COMPAT
 	sbi->compat_daemon = is_compat_task();
+#else
+	sbi->compat_daemon = 0;
+#endif
 	mutex_init(&sbi->wq_mutex);
 	mutex_init(&sbi->pipe_mutex);
 	spin_lock_init(&sbi->fs_lock);
