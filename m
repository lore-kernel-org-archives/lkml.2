Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1CUXSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:53 -0400
Received: from kroah.org ([198.145.64.141]:52746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385Ab1CUXSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.805892584@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Kinsbursky <skinsbursky@openvz.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [59/78] RPC: killing RPC tasks races fixed
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 8e26de238fd794c8ea56a5c98bf67c40cfeb051d upstream.

RPC task RPC_TASK_QUEUED bit is set must be checked before trying to wake up
task rpc_killall_tasks() because task->tk_waitqueue can not be set (equal to
NULL).
Also, as Trond Myklebust mentioned, such approach (instead of checking
tk_waitqueue to NULL) allows us to "optimise away the call to
rpc_wake_up_queued_task() altogether for those
tasks that aren't queued".

Here is an example of dereferencing of tk_waitqueue equal to NULL:

CPU 0               	CPU 1				CPU 2
--------------------	---------------------	--------------------------
nfs4_run_open_task
rpc_run_task
rpc_execute
rpc_set_active
rpc_make_runnable
(waiting)
			rpc_async_schedule
			nfs4_open_prepare
			nfs_wait_on_sequence
						nfs_umount_begin
						rpc_killall_tasks
						rpc_wake_up_task
						rpc_wake_up_queued_task
						spin_lock(tk_waitqueue == NULL)
						BUG()
			rpc_sleep_on
			spin_lock(&q->lock)
			__rpc_sleep_on
			task->tk_waitqueue = q

Signed-off-by: Stanislav Kinsbursky <skinsbursky@openvz.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/clnt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -436,7 +436,9 @@ void rpc_killall_tasks(struct rpc_clnt *
 		if (!(rovr->tk_flags & RPC_TASK_KILLED)) {
 			rovr->tk_flags |= RPC_TASK_KILLED;
 			rpc_exit(rovr, -EIO);
-			rpc_wake_up_queued_task(rovr->tk_waitqueue, rovr);
+			if (RPC_IS_QUEUED(rovr))
+				rpc_wake_up_queued_task(rovr->tk_waitqueue,
+							rovr);
 		}
 	}
 	spin_unlock(&clnt->cl_lock);


