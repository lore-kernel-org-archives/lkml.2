Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601Ab0GTUgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:36:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681Ab0GTUfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] fscache: drop references to slow-work
Date: Tue, 20 Jul 2010 22:34:58 +0200
Message-Id: <1279658102-20069-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279658102-20069-1-git-send-email-tj@kernel.org>
References: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache no longer uses slow-work.  Drop references to it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Howells <dhowells@redhat.com>
---
 fs/fscache/Kconfig            |    1 -
 fs/fscache/main.c             |    7 -------
 include/linux/fscache-cache.h |    1 -
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index cc94bb9..3f6dfa9 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -1,7 +1,6 @@
 
 config FSCACHE
 	tristate "General filesystem local caching manager"
-	select SLOW_WORK
 	help
 	  This option enables a generic filesystem caching manager that can be
 	  used by various network and other filesystems to cache data locally.
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 44d13dd..500936d 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -106,10 +106,6 @@ static int __init fscache_init(void)
 	unsigned int cpu;
 	int ret;
 
-	ret = slow_work_register_user(THIS_MODULE);
-	if (ret < 0)
-		goto error_slow_work;
-
 	fscache_object_max_active =
 		clamp_val(nr_cpus,
 			  fscache_object_max_active, WQ_UNBOUND_MAX_ACTIVE);
@@ -176,8 +172,6 @@ error_proc:
 error_op_wq:
 	destroy_workqueue(fscache_object_wq);
 error_object_wq:
-	slow_work_unregister_user(THIS_MODULE);
-error_slow_work:
 	return ret;
 }
 
@@ -196,7 +190,6 @@ static void __exit fscache_exit(void)
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_op_wq);
 	destroy_workqueue(fscache_object_wq);
-	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
 
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 17ed9c1..b8581c0 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -20,7 +20,6 @@
 
 #include <linux/fscache.h>
 #include <linux/sched.h>
-#include <linux/slow-work.h>
 #include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
-- 
1.6.4.2

