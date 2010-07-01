Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab0GAUtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:49:23 -0400
Received: from kroah.org ([198.145.64.141]:47067 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189Ab0GAUtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:21 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:27 2010
Message-Id: <20100701173426.938120712@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 001/164] Fix racy use of anon_inode_getfd() in perf_event.c
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit ea635c64e007061f6468ece5cc9cc62d41d4ecf2 upstream.

once anon_inode_getfd() is called, you can't expect *anything* about
struct file that descriptor points to - another thread might be doing
whatever it likes with descriptor table at that point.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4712,8 +4712,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
 	struct file *group_file = NULL;
+	int event_fd;
 	int fput_needed = 0;
-	int fput_needed2 = 0;
 	int err;
 
 	/* for future expandability... */
@@ -4734,12 +4734,18 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
+	event_fd = get_unused_fd_flags(O_RDWR);
+	if (event_fd < 0)
+		return event_fd;
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
 	ctx = find_get_context(pid, cpu);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
+	if (IS_ERR(ctx)) {
+		err = PTR_ERR(ctx);
+		goto err_fd;
+	}
 
 	/*
 	 * Look up the group leader (we will attach this event to it):
@@ -4779,13 +4785,11 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (IS_ERR(event))
 		goto err_put_context;
 
-	err = anon_inode_getfd("[perf_event]", &perf_fops, event, O_RDWR);
-	if (err < 0)
-		goto err_free_put_context;
-
-	event_file = fget_light(err, &fput_needed2);
-	if (!event_file)
+	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event, O_RDWR);
+	if (IS_ERR(event_file)) {
+		err = PTR_ERR(event_file);
 		goto err_free_put_context;
+	}
 
 	if (flags & PERF_FLAG_FD_OUTPUT) {
 		err = perf_event_set_output(event, group_fd);
@@ -4806,19 +4810,19 @@ SYSCALL_DEFINE5(perf_event_open,
 	list_add_tail(&event->owner_entry, &current->perf_event_list);
 	mutex_unlock(&current->perf_event_mutex);
 
-err_fput_free_put_context:
-	fput_light(event_file, fput_needed2);
+	fput_light(group_file, fput_needed);
+	fd_install(event_fd, event_file);
+	return event_fd;
 
+err_fput_free_put_context:
+	fput(event_file);
 err_free_put_context:
-	if (err < 0)
-		free_event(event);
-
+	free_event(event);
 err_put_context:
-	if (err < 0)
-		put_ctx(ctx);
-
 	fput_light(group_file, fput_needed);
-
+	put_ctx(ctx);
+err_fd:
+	put_unused_fd(event_fd);
 	return err;
 }
 


