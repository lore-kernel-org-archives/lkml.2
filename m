Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab0HFQ22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:28:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0HFQ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:28:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix the module init error handling
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 06 Aug 2010 17:26:48 +0100
Message-ID: <20100806162648.11782.17953.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the module init error handling.  There are a bunch of goto labels for
aborting the init procedure at different points and just undoing what needs
undoing - they aren't all in the right places, however.

This can lead to an oops like the following:

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
	IP: [<ffffffff81042a31>] destroy_workqueue+0x17/0xc0
	...
	Modules linked in: kafs(+) dns_resolver rxkad af_rxrpc fscache

	Pid: 2171, comm: insmod Not tainted 2.6.35-cachefs+ #319 DG965RY/
	...
	Process insmod (pid: 2171, threadinfo ffff88003ca6a000, task ffff88003dcc3050)
	...
	Call Trace:
	 [<ffffffffa0055994>] afs_callback_update_kill+0x10/0x12 [kafs]
	 [<ffffffffa007d1c5>] afs_init+0x190/0x1ce [kafs]
	 [<ffffffffa007d035>] ? afs_init+0x0/0x1ce [kafs]
	 [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
	 [<ffffffff8105f7ee>] sys_init_module+0x9c/0x1de
	 [<ffffffff81001eab>] system_call_fastpath+0x16/0x1b

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/main.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 66d54d3..cfd1cbe 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -111,6 +111,8 @@ static int __init afs_init(void)
 
 	/* initialise the callback update process */
 	ret = afs_callback_update_init();
+	if (ret < 0)
+		goto error_callback_update_init;
 
 	/* create the RxRPC transport */
 	ret = afs_open_socket();
@@ -127,15 +129,16 @@ static int __init afs_init(void)
 error_fs:
 	afs_close_socket();
 error_open_socket:
+	afs_callback_update_kill();
+error_callback_update_init:
+	afs_vlocation_purge();
 error_vl_update_init:
+	afs_cell_purge();
 error_cell_init:
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
 error_cache:
 #endif
-	afs_callback_update_kill();
-	afs_vlocation_purge();
-	afs_cell_purge();
 	afs_proc_cleanup();
 	rcu_barrier();
 	printk(KERN_ERR "kAFS: failed to register: %d\n", ret);

