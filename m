Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1GIE7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:59:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34325 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1GIE67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:58:59 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] libfs: fix simple_attr_write on 32bit machine
Date: Sat,  9 Jul 2011 14:00:26 +0900
Message-Id: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assume that /sys/kernel/debug/dummy64 is debugfs file created by
debugfs_create_x64().

	# cd /sys/kernel/debug
	# echo 0x1234567812345678 > dummy64
	# cat dummy64
	0x0000000012345678

	# echo 0x80000000 > dummy64
	# cat dummy64
	0xffffffff80000000

The value more than INT_MAX cannot be written to the debugfs file
created by debugfs_create_u64 or debugfs_create_x64 on 32bit machine.
Because simple_attr_write() uses simple_strtol() for the conversion.

To fix this, use simple_strtoll() instead.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/libfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index c88eab5..275ca474 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -822,7 +822,7 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	val = simple_strtol(attr->set_buf, NULL, 0);
+	val = simple_strtoll(attr->set_buf, NULL, 0);
 	ret = attr->set(attr->data, val);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
-- 
1.7.4.4

