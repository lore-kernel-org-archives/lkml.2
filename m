Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0D0JTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:19:21 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37758 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab0D0JTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=f40kcw9H2NQ/CSnpFitjYnckQkxF8Tdaf34sMELRApckT0TJMG5Qe+zl5YaGdREAps
         +ZFpoZEj71nbo9guoYm4dkdk+JlcDcMG4ZWiA48fkIWsG7ovZstpMuQN3UN9edVcfgTy
         P4wDvkfXU3ZFKChcDAfkNPZ4yww2vsojDKbrY=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/10] bkl: Fix-up compile problems as a result of the bkl-pushdown.
Date: Tue, 27 Apr 2010 11:18:18 +0200
Message-Id: <1272359898-32020-11-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix-up compile problems as a result of the bkl-pushdown.
In particular,  the v4l2_ioctl should call an unlocked_ioctl

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/media/video/v4l2-dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 3606694..8fbfa61 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -222,12 +222,12 @@ static long v4l2_ioctl(struct file *filp,
 	struct video_device *vdev = video_devdata(filp);
 	int ret;
 
-	if (!vdev->fops->ioctl)
+	if (!vdev->fops->unlocked_ioctl)
 		return -ENOTTY;
 	/* Allow ioctl to continue even if the device was unregistered.
 	   Things like dequeueing buffers might still be useful. */
 	lock_kernel();
-	ret = vdev->fops->ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
+	ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
-- 
1.6.6.1

