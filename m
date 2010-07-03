Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0GCWDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:03:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0GCWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:02:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7/8] soundcore_open: Reduce the area BKL coverage
Date: Sun,  4 Jul 2010 00:02:31 +0200
Message-Id: <1278194552-24943-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278194552-24943-1-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Z1xvTmQqFqhbI3wd3NzF7LNri3nsTV6eYFmXSY2DnL/
 VVFYmq+XkjV5X9A5fquBXHHn82pPzd5paFbG9szEi8FtBv7vcH
 U4z412YaVg8NJrUBF5zqDA7YPN60fC5CopHJ3KxsvPltOuXCOY
 p/wOde8jGn8tpQ49cDTGK2U3x4Ct9v80n+zmwdCNLCXs7VsAQ+
 ImCHVhpkF7Qzn/txFbUPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur@redhat.com>

Most of this function is protected by the sound_loader_lock.
We can push down the BKL to this call out err = file->f_op->open(inode,file);

In order to build the sound core without the BKL, we
will need to push the lock_kernel() call into the ~20
device drivers that register their file operations.

Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/sound_core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 7c2d677..c8627fc 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct file *file)
 	struct sound_unit *s;
 	const struct file_operations *new_fops = NULL;
 
-	lock_kernel ();
-
 	chain=unit&0x0F;
 	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
 	{
@@ -630,18 +628,23 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		const struct file_operations *old_fops = file->f_op;
 		file->f_op = new_fops;
 		spin_unlock(&sound_loader_lock);
-		if(file->f_op->open)
+
+		if (file->f_op->open) {
+			/* TODO: push down BKL into indivial open functions */
+			lock_kernel();
 			err = file->f_op->open(inode,file);
+			unlock_kernel();
+		}
+
 		if (err) {
 			fops_put(file->f_op);
 			file->f_op = fops_get(old_fops);
 		}
+
 		fops_put(old_fops);
-		unlock_kernel();
 		return err;
 	}
 	spin_unlock(&sound_loader_lock);
-	unlock_kernel();
 	return -ENODEV;
 }
 
-- 
1.7.1

