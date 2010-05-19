Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0ESRZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:25:19 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53492 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0ESRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ZUuYeJUDZ7TH/boqogMYjnoe2267pgF1vtEpEUqXZ8esJAtDA1sHLlSqBsjM6x11+r
         xVWyF8O50HlH6opqtlVOf67UvTdLZkH/92cq9g0nEkQHyAPqw0JobDjpJb60qX3hGUCy
         byU5+XMkjrhzpU7lMY2Tl6Kmpq8x/9SD6GpEQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>,
       Uml <user-mode-linux-devel@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/8] uml: Pushdown the bkl from harddog_kern ioctl
Date: Wed, 19 May 2010 19:24:13 +0200
Message-Id: <1274289855-10001-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushdown the bkl to harddog_ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Uml <user-mode-linux-devel@lists.sourceforge.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/um/drivers/harddog_kern.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index d332503..cfcac1f 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -124,8 +124,8 @@ static ssize_t harddog_write(struct file *file, const char __user *data, size_t
 	return 0;
 }
 
-static int harddog_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static int harddog_ioctl_unlocked(struct file *file,
+				  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp= (void __user *)arg;
 	static struct watchdog_info ident = {
@@ -148,10 +148,22 @@ static int harddog_ioctl(struct inode *inode, struct file *file,
 	}
 }
 
+static long harddog_ioctl(struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = harddog_ioctl_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations harddog_fops = {
 	.owner		= THIS_MODULE,
 	.write		= harddog_write,
-	.ioctl		= harddog_ioctl,
+	.unlocked_ioctl	= harddog_ioctl,
 	.open		= harddog_open,
 	.release	= harddog_release,
 };
-- 
1.6.2.3

