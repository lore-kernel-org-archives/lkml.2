Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2FTSVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab2FTSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:45 -0400
Message-Id: <20120620173022.432073059@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hans de Bruin <jmdebruin@xmsnet.nl>,
        Joerg Platte <jplatte@naasa.net>, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 17/61] rpc_pipefs: allow rpc_purge_list to take a NULL waitq pointer
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 92123e068efa310b09e9943ac1cfd10ff6b6d2e4 upstream.

In the event that we don't have a dentry for a rpc_pipefs pipe, we still
need to allow the queue_timeout job to clean out the queue. There's just
no waitq to wake up in that event.

Reported-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Reported-by: Joerg Platte <jplatte@naasa.net>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/rpc_pipe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -71,7 +71,9 @@ static void rpc_purge_list(wait_queue_he
 		msg->errno = err;
 		destroy_msg(msg);
 	} while (!list_empty(head));
-	wake_up(waitq);
+
+	if (waitq)
+		wake_up(waitq);
 }
 
 static void
@@ -91,11 +93,9 @@ rpc_timeout_upcall_queue(struct work_str
 	}
 	dentry = dget(pipe->dentry);
 	spin_unlock(&pipe->lock);
-	if (dentry) {
-		rpc_purge_list(&RPC_I(dentry->d_inode)->waitq,
-			       &free_list, destroy_msg, -ETIMEDOUT);
-		dput(dentry);
-	}
+	rpc_purge_list(dentry ? &RPC_I(dentry->d_inode)->waitq : NULL,
+			&free_list, destroy_msg, -ETIMEDOUT);
+	dput(dentry);
 }
 
 ssize_t rpc_pipe_generic_upcall(struct file *filp, struct rpc_pipe_msg *msg,


