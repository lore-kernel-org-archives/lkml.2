Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab0JQOm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:42:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61194 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab0JQOlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E4zgiEcUsWFFJZFrgjUdkzItDKUoFz2WQ89ObahBn1td1YlqE2indPn3HKq+nmMo+X
         sLOOUWVOa2o90jzw3AOxOsm1CGc5A83GPebNRve3kgPHa8pwzuM12hxvae+2wRWLoSn4
         7VD236UrKUGvCWlYg71msI60OlNSFfhChcScY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
        Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] char: ppdev: fix information leak to userland
Date: Sun, 17 Oct 2010 18:41:28 +0400
Message-Id: <1287326489-8071-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure par_timeout is copied to userland with some padding fields unitialized.
Field tv_usec has type __kernel_suseconds_t, it differs from tv_sec's type on
some architectures.  It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/char/ppdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 723152d..f176dba 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -613,6 +613,7 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case PPGETTIME:
 		to_jiffies = pp->pdev->timeout;
+		memset(&par_timeout, 0, sizeof(par_timeout));
 		par_timeout.tv_sec = to_jiffies / HZ;
 		par_timeout.tv_usec = (to_jiffies % (long)HZ) * (1000000/HZ);
 		if (copy_to_user (argp, &par_timeout, sizeof(struct timeval)))
-- 
1.7.0.4

