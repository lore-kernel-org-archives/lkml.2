Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1BFXpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:53 -0500
Received: from 1wt.eu ([62.212.114.60]:60293 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab1BFXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:51 -0500
Message-Id: <20110206232253.378726212@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Slava Pestov <slavapestov@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 20/23] tracing: Fix panic when lseek() called on "trace" opened for writing
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Slava Pestov <slavapestov@google.com>

commit 364829b1263b44aa60383824e4c1289d83d78ca7 upstream.

The file_ops struct for the "trace" special file defined llseek as seq_lseek().
However, if the file was opened for writing only, seq_open() was not called,
and the seek would dereference a null pointer, file->private_data.

This patch introduces a new wrapper for seq_lseek() which checks if the file
descriptor is opened for reading first. If not, it does nothing.

Signed-off-by: Slava Pestov <slavapestov@google.com>
LKML-Reference: <1290640396-24179-1-git-send-email-slavapestov@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[wt: applied to tracing_lt_fops too /wt]
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 kernel/trace/trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/kernel/trace/trace.c
===================================================================
--- longterm-2.6.27.orig/kernel/trace/trace.c	2011-01-23 10:52:37.000000000 +0100
+++ longterm-2.6.27/kernel/trace/trace.c	2011-01-29 11:42:07.287067215 +0100
@@ -2041,17 +2041,25 @@
 	return ret;
 }
 
+static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+{
+	if (file->f_mode & FMODE_READ)
+		return seq_lseek(file, offset, origin);
+	else
+		return 0;
+}
+
 static struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_release,
 };
 
 static struct file_operations tracing_lt_fops = {
 	.open		= tracing_lt_open,
 	.read		= seq_read,
-	.llseek		= seq_lseek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_release,
 };
 


