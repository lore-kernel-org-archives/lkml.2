Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1AFAak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:40 -0500
Received: from kroah.org ([198.145.64.141]:35886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1AFAai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:38 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.750647318@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Slava Pestov <slavapestov@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [094/152] tracing: Fix panic when lseek() called on "trace" opened for writing
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/trace/trace.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2320,11 +2320,19 @@ tracing_write_stub(struct file *filp, co
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
 


