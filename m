Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab2EEOzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:55:52 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:34811 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2EEOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:55:51 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] kmsg: limit message size
Date: Sat,  5 May 2012 16:56:12 +0200
Message-Id: <1336229772-3488-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no size checks in kmsg_write(), and we try allocating enough
memory to store everything userspace gave us, which may be too much for
kmalloc to allocate.

Furthermore, we can have an integer overflow if len==INT_MAX, in that case
we'll corrupt kernel memory.

This was tested with several userspace programs that write to kmsg, and haven't
found a case where the program attempts to write more than PAGE_SIZE.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/char/mem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index d6e9d08..c90964b 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -815,6 +815,9 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	ssize_t ret = -EFAULT;
 	size_t len = iov_length(iv, count);
 
+	if (len > PAGE_SIZE)
+		return -E2BIG;
+
 	line = kmalloc(len + 1, GFP_KERNEL);
 	if (line == NULL)
 		return -ENOMEM;
-- 
1.7.8.5

