Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0JSPuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:50:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57165 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab0JSPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:50:35 -0400
Message-ID: <4CBDBE39.7080502@kernel.org>
Date: Tue, 19 Oct 2010 17:50:17 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2.6.36-rc7] afs: add afs_wq and use it instead of the system
 workqueue
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 15:50:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() is going away.  afs needs to make sure all the
works it has queued have finished before being unloaded and there can
be arbitrary number of pending works.  Add afs_wq and use it as the
flush domain instead of the system workqueue.

While at it, convert cancel_delayed_work() + flush_scheduled_work() to
cancel_delayed_work_sync() in afs_mntpt_kill_timer().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/afs/cmservice.c |   12 ++++++------
 fs/afs/internal.h  |    1 +
 fs/afs/main.c      |   13 +++++++++++--
 fs/afs/mntpt.c     |   11 +++++------
 fs/afs/rxrpc.c     |    2 +-
 fs/afs/server.c    |   13 +++++++------
 fs/afs/vlocation.c |   14 +++++++-------
 7 files changed, 38 insertions(+), 28 deletions(-)

Index: work/fs/afs/cmservice.c
===================================================================
--- work.orig/fs/afs/cmservice.c
+++ work/fs/afs/cmservice.c
@@ -289,7 +289,7 @@ static int afs_deliver_cb_callback(struc
 	call->server = server;

 	INIT_WORK(&call->work, SRXAFSCB_CallBack);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }

@@ -336,7 +336,7 @@ static int afs_deliver_cb_init_call_back
 	call->server = server;

 	INIT_WORK(&call->work, SRXAFSCB_InitCallBackState);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }

@@ -367,7 +367,7 @@ static int afs_deliver_cb_init_call_back
 	call->server = server;

 	INIT_WORK(&call->work, SRXAFSCB_InitCallBackState);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }

@@ -400,7 +400,7 @@ static int afs_deliver_cb_probe(struct a
 	call->state = AFS_CALL_REPLYING;

 	INIT_WORK(&call->work, SRXAFSCB_Probe);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }

@@ -496,7 +496,7 @@ static int afs_deliver_cb_probe_uuid(str
 	call->state = AFS_CALL_REPLYING;

 	INIT_WORK(&call->work, SRXAFSCB_ProbeUuid);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }

@@ -580,6 +580,6 @@ static int afs_deliver_cb_tell_me_about_
 	call->state = AFS_CALL_REPLYING;

 	INIT_WORK(&call->work, SRXAFSCB_TellMeAboutYourself);
-	schedule_work(&call->work);
+	queue_work(afs_wq, &call->work);
 	return 0;
 }
Index: work/fs/afs/internal.h
===================================================================
--- work.orig/fs/afs/internal.h
+++ work/fs/afs/internal.h
@@ -576,6 +576,7 @@ extern int afs_drop_inode(struct inode *
 /*
  * main.c
  */
+extern struct workqueue_struct *afs_wq;
 extern struct afs_uuid afs_uuid;

 /*
Index: work/fs/afs/main.c
===================================================================
--- work.orig/fs/afs/main.c
+++ work/fs/afs/main.c
@@ -30,6 +30,7 @@ module_param(rootcell, charp, 0);
 MODULE_PARM_DESC(rootcell, "root AFS cell name and VL server IP addr list");

 struct afs_uuid afs_uuid;
+struct workqueue_struct *afs_wq;

 /*
  * get a client UUID
@@ -87,10 +88,16 @@ static int __init afs_init(void)
 	if (ret < 0)
 		return ret;

+	/* create workqueue */
+	ret = -ENOMEM;
+	afs_wq = alloc_workqueue("afs", 0, 0);
+	if (!afs_wq)
+		return ret;
+
 	/* register the /proc stuff */
 	ret = afs_proc_init();
 	if (ret < 0)
-		return ret;
+		goto error_proc;

 #ifdef CONFIG_AFS_FSCACHE
 	/* we want to be able to cache */
@@ -140,6 +147,8 @@ error_cell_init:
 error_cache:
 #endif
 	afs_proc_cleanup();
+error_proc:
+	destroy_workqueue(afs_wq);
 	rcu_barrier();
 	printk(KERN_ERR "kAFS: failed to register: %d\n", ret);
 	return ret;
@@ -163,7 +172,7 @@ static void __exit afs_exit(void)
 	afs_purge_servers();
 	afs_callback_update_kill();
 	afs_vlocation_purge();
-	flush_scheduled_work();
+	destroy_workqueue(afs_wq);
 	afs_cell_purge();
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
Index: work/fs/afs/mntpt.c
===================================================================
--- work.orig/fs/afs/mntpt.c
+++ work/fs/afs/mntpt.c
@@ -267,8 +267,8 @@ static void *afs_mntpt_follow_link(struc
 		path_put(&nd->path);
 		nd->path.mnt = newmnt;
 		nd->path.dentry = dget(newmnt->mnt_root);
-		schedule_delayed_work(&afs_mntpt_expiry_timer,
-				      afs_mntpt_expiry_timeout * HZ);
+		queue_delayed_work(afs_wq, &afs_mntpt_expiry_timer,
+				   afs_mntpt_expiry_timeout * HZ);
 		break;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
@@ -294,8 +294,8 @@ static void afs_mntpt_expiry_timed_out(s

 	if (!list_empty(&afs_vfsmounts)) {
 		mark_mounts_for_expiry(&afs_vfsmounts);
-		schedule_delayed_work(&afs_mntpt_expiry_timer,
-				      afs_mntpt_expiry_timeout * HZ);
+		queue_delayed_work(afs_wq, &afs_mntpt_expiry_timer,
+				   afs_mntpt_expiry_timeout * HZ);
 	}

 	_leave("");
@@ -309,6 +309,5 @@ void afs_mntpt_kill_timer(void)
 	_enter("");

 	ASSERT(list_empty(&afs_vfsmounts));
-	cancel_delayed_work(&afs_mntpt_expiry_timer);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&afs_mntpt_expiry_timer);
 }
Index: work/fs/afs/rxrpc.c
===================================================================
--- work.orig/fs/afs/rxrpc.c
+++ work/fs/afs/rxrpc.c
@@ -410,7 +410,7 @@ static void afs_rx_interceptor(struct so
 	if (!call) {
 		/* its an incoming call for our callback service */
 		skb_queue_tail(&afs_incoming_calls, skb);
-		schedule_work(&afs_collect_incoming_call_work);
+		queue_work(afs_wq, &afs_collect_incoming_call_work);
 	} else {
 		/* route the messages directly to the appropriate call */
 		skb_queue_tail(&call->rx_queue, skb);
Index: work/fs/afs/server.c
===================================================================
--- work.orig/fs/afs/server.c
+++ work/fs/afs/server.c
@@ -238,8 +238,8 @@ void afs_put_server(struct afs_server *s
 	if (atomic_read(&server->usage) == 0) {
 		list_move_tail(&server->grave, &afs_server_graveyard);
 		server->time_of_death = get_seconds();
-		schedule_delayed_work(&afs_server_reaper,
-				      afs_server_timeout * HZ);
+		queue_delayed_work(afs_wq, &afs_server_reaper,
+				   afs_server_timeout * HZ);
 	}
 	spin_unlock(&afs_server_graveyard_lock);
 	_leave(" [dead]");
@@ -285,10 +285,11 @@ static void afs_reap_server(struct work_
 		expiry = server->time_of_death + afs_server_timeout;
 		if (expiry > now) {
 			delay = (expiry - now) * HZ;
-			if (!schedule_delayed_work(&afs_server_reaper, delay)) {
+			if (!queue_delayed_work(afs_wq, &afs_server_reaper,
+						delay)) {
 				cancel_delayed_work(&afs_server_reaper);
-				schedule_delayed_work(&afs_server_reaper,
-						      delay);
+				queue_delayed_work(afs_wq, &afs_server_reaper,
+						   delay);
 			}
 			break;
 		}
@@ -323,5 +324,5 @@ void __exit afs_purge_servers(void)
 {
 	afs_server_timeout = 0;
 	cancel_delayed_work(&afs_server_reaper);
-	schedule_delayed_work(&afs_server_reaper, 0);
+	queue_delayed_work(afs_wq, &afs_server_reaper, 0);
 }
Index: work/fs/afs/vlocation.c
===================================================================
--- work.orig/fs/afs/vlocation.c
+++ work/fs/afs/vlocation.c
@@ -507,8 +507,8 @@ void afs_put_vlocation(struct afs_vlocat
 		_debug("buried");
 		list_move_tail(&vl->grave, &afs_vlocation_graveyard);
 		vl->time_of_death = get_seconds();
-		schedule_delayed_work(&afs_vlocation_reap,
-				      afs_vlocation_timeout * HZ);
+		queue_delayed_work(afs_wq, &afs_vlocation_reap,
+				   afs_vlocation_timeout * HZ);

 		/* suspend updates on this record */
 		if (!list_empty(&vl->update)) {
@@ -561,11 +561,11 @@ static void afs_vlocation_reaper(struct
 		if (expiry > now) {
 			delay = (expiry - now) * HZ;
 			_debug("delay %lu", delay);
-			if (!schedule_delayed_work(&afs_vlocation_reap,
-						   delay)) {
+			if (!queue_delayed_work(afs_wq, &afs_vlocation_reap,
+						delay)) {
 				cancel_delayed_work(&afs_vlocation_reap);
-				schedule_delayed_work(&afs_vlocation_reap,
-						      delay);
+				queue_delayed_work(afs_wq, &afs_vlocation_reap,
+						   delay);
 			}
 			break;
 		}
@@ -620,7 +620,7 @@ void afs_vlocation_purge(void)
 	destroy_workqueue(afs_vlocation_update_worker);

 	cancel_delayed_work(&afs_vlocation_reap);
-	schedule_delayed_work(&afs_vlocation_reap, 0);
+	queue_delayed_work(afs_wq, &afs_vlocation_reap, 0);
 }

 /*
