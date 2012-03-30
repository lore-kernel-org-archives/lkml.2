Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2C3PEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:04:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64101 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2C3PEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:04:47 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk
Cc: davej@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
Date: Fri, 30 Mar 2012 13:04:27 -0400
Message-Id: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no size checks in kmsg_write(), and we try allocating enough
memory to store everything userspace gave us, which may be too much for
kmalloc to allocate.

One option would be to limit it to something, but we can't come up with
a number that would make sense.

Instead, just use vmalloc so that nothing would break with large amounts
of data.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/char/mem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..e047783 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -815,7 +815,7 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	ssize_t ret = -EFAULT;
 	size_t len = iov_length(iv, count);
 
-	line = kmalloc(len + 1, GFP_KERNEL);
+	line = vmalloc(len + 1);
 	if (line == NULL)
 		return -ENOMEM;
 
@@ -836,7 +836,7 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	if (ret > len)
 		ret = len;
 out:
-	kfree(line);
+	vfree(line);
 	return ret;
 }
 
-- 
1.7.8.4

