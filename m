Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0LPIWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 03:22:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:44326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0LPIWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 03:22:08 -0500
Date: Thu, 16 Dec 2010 08:21:45 GMT
From: tip-bot for Slava Pestov <slavapestov@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        slavapestov@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        slavapestov@google.com
In-Reply-To: <1290640396-24179-1-git-send-email-slavapestov@google.com>
References: <1290640396-24179-1-git-send-email-slavapestov@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix panic when lseek() called on "trace" opened for writing
Message-ID: <tip-364829b1263b44aa60383824e4c1289d83d78ca7@git.kernel.org>
Git-Commit-ID: 364829b1263b44aa60383824e4c1289d83d78ca7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Dec 2010 08:21:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  364829b1263b44aa60383824e4c1289d83d78ca7
Gitweb:     http://git.kernel.org/tip/364829b1263b44aa60383824e4c1289d83d78ca7
Author:     Slava Pestov <slavapestov@google.com>
AuthorDate: Wed, 24 Nov 2010 15:13:16 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 30 Nov 2010 12:18:17 -0500

tracing: Fix panic when lseek() called on "trace" opened for writing

The file_ops struct for the "trace" special file defined llseek as seq_lseek().
However, if the file was opened for writing only, seq_open() was not called,
and the seek would dereference a null pointer, file->private_data.

This patch introduces a new wrapper for seq_lseek() which checks if the file
descriptor is opened for reading first. If not, it does nothing.

Cc: <stable@kernel.org>
Signed-off-by: Slava Pestov <slavapestov@google.com>
LKML-Reference: <1290640396-24179-1-git-send-email-slavapestov@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ee6a733..21db0de 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2339,11 +2339,19 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
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
 
