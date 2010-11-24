Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0KXXNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:13:24 -0500
Received: from smtp-out.google.com ([74.125.121.35]:2602 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0KXXNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:13:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=ZzY4w5c/A9cBw5qZnpN2tT5oexnPs1+frThXAv1lbI66lrrV08uW7F+UJqRIifJ4y
	fX7e0qnKpEdlNZY9p6Bqw==
From: Slava Pestov <slavapestov@google.com>
To: linux-kernel@vger.kernel.org
Cc: dhsharp@google.com, mrubin@google.com,
        Slava Pestov <slavapestov@google.com>
Subject: [PATCH] ftrace: Fix panic when lseek() called on "trace" opened for writing
Date: Wed, 24 Nov 2010 15:13:16 -0800
Message-Id: <1290640396-24179-1-git-send-email-slavapestov@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file_ops struct for the "trace" special file defined llseek as seq_lseek().
However, if the file was opened for writing only, seq_open() was not called,
and the seek would dereference a null pointer, file->private_data.

This patch introduces a new wrapper for seq_lseek() which checks if the file
descriptor is opened for reading first. If not, it does nothing.

This patch is for Linux 2.6.36.1.

Signed-Off-By: Slava Pestov <slavapestov@google.com>
---

Change-Id: Iaabc50d84fb541c04e3efabd4788cebadbadbb4c
---
 kernel/trace/trace.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9ec59f5..7702f5a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2320,11 +2320,19 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
+static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+{
+	if (file->f_mode & FMODE_READ)
+		return seq_lseek(file, offset, origin);
+	else
+		return 0;
+}
+
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.write		= tracing_write_stub,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_seek,
 	.release	= tracing_release,
 };
 
-- 
1.7.3.1

