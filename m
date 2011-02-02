Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1BBAzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:55:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab1BBAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028529"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: slavapestov@google.com, ak@linux.intel.com, rostedt@goodmis.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [88/139] tracing: Fix panic when lseek() called on "trace" opened for writing
Message-Id: <20110202004445.D7DB23E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Slava Pestov <slavapestov@google.com>

commit 364829b1263b44aa60383824e4c1289d83d78ca7 upstream.

The file_ops struct for the "trace" special file defined llseek as seq_lseek().
However, if the file was opened for writing only, seq_open() was not called,
and the seek would dereference a null pointer, file->private_data.

This patch introduces a new wrapper for seq_lseek() which checks if the file
descriptor is opened for reading first. If not, it does nothing.

Signed-off-by: Slava Pestov <slavapestov@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1290640396-24179-1-git-send-email-slavapestov@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/kernel/trace/trace.c
===================================================================
--- linux-2.6.35.y.orig/kernel/trace/trace.c
+++ linux-2.6.35.y/kernel/trace/trace.c
@@ -2382,11 +2382,19 @@ tracing_write_stub(struct file *filp, co
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
 
