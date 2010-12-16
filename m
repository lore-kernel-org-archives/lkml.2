Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab0LPUcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:32:21 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60974 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab0LPUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:32:20 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 16 Dec 2010 12:32:42 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] make pipes use event aware wakeups
Message-ID: <alpine.DEB.2.00.1012161228530.25094@davide-lnx1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought this was alreay merged, but this thread brought to my attention 
it wasn't:

https://lkml.org/lkml/2010/12/15/234

This patch sends the events the wakeup refers to, so that epoll, and even 
the new poll code in fs/select.c can avoid wakeups in events are not 
matching the requested set.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.mod/fs/pipe.c
===================================================================
--- linux-2.6.mod.orig/fs/pipe.c	2010-12-15 20:49:48.000000000 -0800
+++ linux-2.6.mod/fs/pipe.c	2010-12-15 20:51:42.000000000 -0800
@@ -441,7 +441,7 @@
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 		}
 		pipe_wait(pipe);
@@ -450,7 +450,7 @@
 
 	/* Signal writers asynchronously that there is more room. */
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
 	if (ret > 0)
@@ -612,7 +612,7 @@
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 			do_wakeup = 0;
 		}
@@ -623,7 +623,7 @@
 out:
 	mutex_unlock(&inode->i_mutex);
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 	if (ret > 0)
@@ -715,7 +715,7 @@
 	if (!pipe->readers && !pipe->writers) {
 		free_pipe_info(inode);
 	} else {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
